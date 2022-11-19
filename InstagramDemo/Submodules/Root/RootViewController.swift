//
//  RootViewController.swift
//  InstagramDemo
//
//  Created by Viacheslav Tolstopianteko on 15.11.2022.
//

import Foundation
import UIKit

class RootViewController: UINavigationController {
	override func viewDidLoad() {
		super.viewDidLoad()
		start()
	}
	
	func start() {
		let feedViewModel = FeedViewModel()
		let unsplashPhotosNetworkHandler = UnsplashPhotoNetworkHandler()
		let feedViewController = FeedViewController()
		
		feedViewModel.unsplashPhotosNetworkHandler = unsplashPhotosNetworkHandler
		feedViewController.viewModel = feedViewModel
		
		self.pushViewController(feedViewController, animated: false)
	}
}
