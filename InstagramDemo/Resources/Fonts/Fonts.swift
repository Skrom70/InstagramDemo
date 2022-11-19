//
//  Fonts.swift
//  InstagramDemo
//
//  Created by Viacheslav Tolstopianteko on 19.11.2022.
//

import Foundation
import UIKit

enum Fonts {
	static func Siry(size: CGFloat) -> UIFont? { UIFont(name: "Siry", size: size) }
	
	static func SFProText(size: CGFloat, weight: FontsWeight) -> UIFont? { return UIFont(name: "SFProText-\( weight.rawValue)", size: size) }
}

enum FontsWeight: String {
	case Black, Bold, Heavy, Light, Medium, Regular, Semibold
}


