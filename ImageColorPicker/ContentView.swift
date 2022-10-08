//
//  ContentView.swift
//  ImageColorPicker
//
//  Created by Abdullah Kardas on 3.10.2022.
//

import SwiftUI
import UIKit
import PhotoLibraryPermission
import CameraPermission
import PermissionsKit
import AlertToast
import Photos
import PhotosUI



struct ContentView: View {
    
    @State private var shouldPresentImagePicker = false
    @State private var shouldPresentActionScheet = false
    @State private var shouldPresentCamera = false
    @State var colorArray:[UIColor] = []
    @State var showAlert:Bool = false
    @State var alertMessage:String = ""
    @State var showActionSheet: Bool = false
    @State var myImage = UIImage(named: "exampleimage")
    
    let columns:[GridItem] = [GridItem(.flexible(), spacing: nil, alignment: .center),GridItem(.flexible(), spacing: nil, alignment: .center),GridItem(.flexible(), spacing: nil, alignment: .center)]
    var body: some View {
        ZStack {
            Color.blue.opacity(0.3).ignoresSafeArea()
            VStack {
                Image(uiImage: myImage!)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(16)
                    .frame(maxWidth: .infinity).frame(height: 250).padding(.horizontal,8)
                
                
                Spacer()
                
                Text("Choose Photo").font(.headline.bold()).foregroundColor(.white).padding(.vertical,15).background {
                    Capsule(style: .circular).fill(.blue).frame(width: 180)
                }.onTapWithBounce {shouldPresentActionScheet = true}.padding(.vertical,8)
              
                Spacer()
                
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(columns: columns) {
                        ForEach(colorArray,id: \.self) { color in
                            RoundedRectangle(cornerRadius: 8).frame(maxWidth: .infinity).frame(height: 45).padding(.horizontal,4)
                                .foregroundColor(Color(uiColor: color))
                                .overlay(alignment: .center) {
                                    HStack {
                                        
                                        Image(systemName: "rectangle.portrait.on.rectangle.portrait")
                                        Text(color.hexString)
                                    }.font(.caption).foregroundColor(.white)
                                }.onTapWithBounce {
                                    UIPasteboard.general.string = color.hexString
                                    alertMessage = "Color Copied!"
                                    showAlert.toggle()
                                }
                          
                        }
                
                    }
                }
                
                Spacer()
                   
            }
            .onAppear {
                var configuration = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
                configuration.selectionLimit = 1
                guard let colors = myImage?.dominantColors() else {return}
                for color in colors {
                    colorArray.append(color)
                }
            }
            .onChange(of: myImage, perform: { uıımage in
                
                print("onchange")
                guard let colors = uıımage?.dominantColors() else {return}
                colorArray.removeAll()
                for color in colors {
                    colorArray.append(color)
                }
            })
            .toast(isPresenting: $showAlert) {
                AlertToast(displayMode: .hud, type: .systemImage("rectangle.portrait.on.rectangle.portrait", .blue), title: alertMessage)
            }
            .fullScreenCover(isPresented: $shouldPresentImagePicker) {
                SUImagePickerView(sourceType: shouldPresentCamera ? .camera : .photoLibrary, image: $myImage, isPresented: $shouldPresentImagePicker)
            }
            .confirmationDialog("Select Image",isPresented: $shouldPresentActionScheet, titleVisibility: .visible, actions: {
                Button("Camera", role: .none) {
                    if Permission.camera.status == .authorized {
                        shouldPresentImagePicker = true
                        shouldPresentCamera = true
                    }else if Permission.camera.status == .denied{
                        alertMessage = "App needs to access your Camera"
                        showAlert.toggle()
                    }else if Permission.camera.status == .notDetermined{
                        Permission.camera.request {
                            let result = Permission.camera.status
                            if result == .authorized {
                                shouldPresentImagePicker = true
                                shouldPresentCamera = true
                            }
                        }
                    }
                   
                }

                Button("Photos", role: .none) {
                    
                    if Permission.photoLibrary.status == .authorized {
                        shouldPresentImagePicker = true
                        shouldPresentCamera = false
                    }else if Permission.photoLibrary.status == .denied{
                        alertMessage = "App needs to access your Galery"
                        showAlert.toggle()
                    }else if Permission.photoLibrary.status == .notDetermined{
                        Permission.photoLibrary.request {
                            let result = Permission.photoLibrary.status
                            if result == .authorized {
                                shouldPresentImagePicker = true
                                shouldPresentCamera = false
                            }
                        }
                    }
                 
                }

            },message: {
                Text("Select your image from photos or take a new photo from camera")
        })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
