//
//  Constants.swift
//  Rutin
//
//  Created by H on 04/07/2019.
//  Copyright © 2019 H. All rights reserved.
//

import Foundation

enum Config {
    static let baseURL = NSURL(string: "http://www.example.org/")!
    static let splineReticulatorName = "foobar"
}

enum Font {
    static let baseFont = "SF-Pro-Display-"
    static let regular = baseFont + "Regular"
    static let bold = baseFont + "Bold"
    static let black = baseFont + "Black"
    static let boldItalic = baseFont + "BoldItalic"
    static let italic = baseFont + "RegularItalic"
}

enum Color {
    static let primary = "#42B4D0".hexToUIColor()
    static let secondary = "#54626B".hexToUIColor()
    
    static let black = "#000000".hexToUIColor()
    static let white = "#ffffff".hexToUIColor()
    static let gray = "#DCDCDC".hexToUIColor()
    
    enum label {
        static let primary = "#51626F".hexToUIColor()
        static let secondary = "#A8B0B8".hexToUIColor()
        static let tertiary = "#BBBBBB".hexToUIColor()
    }
}
