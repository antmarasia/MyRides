//
//  AppConfiguration.swift
//  MyRides
//
//  Created by Anthony Marasia on 1/18/24.
//

import UIKit

class AppConfiguration {
    static let current = AppConfiguration()
    
    let theme: Theme
    
    private init() {
        theme = Theme()
    }
}

class Theme {
    let defaultFontSize: CGFloat
    let smallerFontSize: CGFloat
    let defaultColor: UIColor
    let greyColor: UIColor
    let lightBlueColor: UIColor
    
    init(defaultFontSize: CGFloat = 12,
         smallerFontSize: CGFloat = 8,
         defaultColor: UIColor = UIColor.defaultColor,
         greyColor: UIColor = .lightGray,
         lightBlueColor: UIColor = UIColor.lightBlueColor) {
        self.defaultFontSize = defaultFontSize
        self.smallerFontSize = smallerFontSize
        self.defaultColor = defaultColor
        self.greyColor = greyColor
        self.lightBlueColor = lightBlueColor
    }
}
