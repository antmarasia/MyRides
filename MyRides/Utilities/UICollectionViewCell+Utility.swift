//
//  UICollectionViewCell+Utility.swift
//  MyRides
//
//  Created by Anthony Marasia on 1/17/24.
//

import UIKit

protocol Reusable {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String {
        String(describing: Self.self)
    }
}

extension UICollectionReusableView: Reusable { }
