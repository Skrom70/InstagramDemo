//
//  BaseProtocol.swift
//  NewsDemo
//
//  Created by Viacheslav Tolstopianteko on 09.11.2022.
//

import PKHUD
import RxCocoa
import RxSwift
import UIKit

protocol BaseViewProtocol: AnyObject {
	func startAnimating()
	func stopAnimating()
	var isAnimating: Binder<Bool> { get }
}

extension BaseViewProtocol {
	func startAnimating() {
		HUD.show(.progress)
	}
	
	func stopAnimating() {
		HUD.hide()
	}
	
	var isAnimating: Binder<Bool> {
		return Binder(self) { activityIndicator, active in
			if active {
				activityIndicator.startAnimating()
			} else {
				activityIndicator.stopAnimating()
			}
		}
	}
}
