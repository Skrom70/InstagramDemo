//
//  UnsplashPhotoItem.swift
//  InstagramDemo
//
//  Created by Viacheslav Tolstopianteko on 15.11.2022.
//

import Foundation

protocol UnsplashPhotoItemMapping {
	static func tryMapToItem(json: UnsplashPhoto) -> UnsplashPhotoItem?
}

struct UnsplashPhotoItem {
	let imageUrl: URL
	let description: String
	let likes: Int
	let autor: Autor
	
	struct Autor {
		let name: String
		let avatarUrl: URL
	}
}


extension UnsplashPhotoItem: UnsplashPhotoItemMapping {
	static func tryMapToItem(json: UnsplashPhoto) -> UnsplashPhotoItem? {
		guard let imageUrl = URL(string: (json.urls?.regular ?? json.urls?.full ?? json.urls?.raw) ?? ""),
			  let description = json.photoDescription ?? Optional(""), let likes = json.likes,
			  let autorName = json.user?.username, let avatarUrl = URL(string: (json.user?.profileImage?.medium ?? json.user?.profileImage?.large) ?? "") else { return nil }
		
		let item = UnsplashPhotoItem(imageUrl: imageUrl, description: description, likes: likes,
									autor: Autor(name: autorName, avatarUrl: avatarUrl))
		
		return item
	}
}
