//
//  Modifiers.swift
//  ImageColorPicker
//
//  Created by Abdullah Kardas on 3.10.2022.
//

import Foundation
import SwiftUI

struct bounce:ViewModifier {
    let onClick:() -> Void
    func body(content: Content) -> some View {
        Button {
           
            onClick()
        } label: {
            content
        }.buttonStyle(BounceStyle())
    }
}
struct BounceStyle: ButtonStyle {
    
    func makeBody(configuration: Self.Configuration) -> some View {
  
       return configuration.label
            .scaleEffect(configuration.isPressed ? CGFloat(0.85) : 1.0)
            .animation(.default, value: configuration.isPressed)
    }
}
