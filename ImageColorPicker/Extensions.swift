//
//  Extensions.swift
//  ImageColorPicker
//
//  Created by Abdullah Kardas on 3.10.2022.
//

import Foundation
import UIKit
import SwiftUI

extension UIColor {
    var hexString: String {
        guard let components = self.cgColor.components else { return "" }

        let red = Float(components[0])
        let green = Float(components[1])
        let blue = Float(components[2])
        return String(format: "#%02lX%02lX%02lX", lroundf(red * 255), lroundf(green * 255), lroundf(blue * 255))
    }
}

extension View {
    func onTapWithBounce(onClick:@escaping () -> Void) -> some View {
        modifier(bounce(onClick: onClick))
    }
}




