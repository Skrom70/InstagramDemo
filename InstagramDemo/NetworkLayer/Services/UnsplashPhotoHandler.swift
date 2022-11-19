//
//  OpenWeatherHandler.swift
//  WeatherApp
//
//  Created by Viacheslav Tolstopianteko on 13.11.2022.
//

import Foundation
import RxSwift
import Moya

protocol UnsplashPhotoNetworkHandling {
	func loadUnsplashPhotos(page: Int) -> Single<UnspashPhotosJSON>
}

final class UnsplashPhotoNetworkHandler: UnsplashPhotoNetworkHandling {
	
	private let provider = MoyaProvider<UnsplashPhotosRequest>()
	private let decoder = JSONDecoding.decodeWithDate()
	
	func loadUnsplashPhotos(page: Int) -> Single<UnspashPhotosJSON> {
		let perPage = 5
		let from = UnsplashPhotosRequest(api: .list(page: page, perPage: perPage))
		
		return provider.rx
			.request(from)
			.filterSuccessfulStatusCodes()
			.map(UnspashPhotosJSON.self, using: decoder)
	}
}
