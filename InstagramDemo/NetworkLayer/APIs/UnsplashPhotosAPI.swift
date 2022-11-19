//
//  CurrentWeatherAPI.swift
//  WeatherApp
//
//  Created by Viacheslav Tolstopianteko on 13.11.2022.
//

import Foundation
import Moya

struct UnsplashPhotosRequest {
	let api: UnsplashPhotosAPI
	
	static let clientId = "r9iPw1oIYXUuPLO9ALYYaOSQaarCH27xtUZpE86P9Ak"
}


enum UnsplashPhotosAPI {
	case list(page: Int, perPage: Int, orderBy: OrderBy = .latest)
	
	enum OrderBy: String {
		case latest, oldest, popular
	}
}

extension UnsplashPhotosRequest: TargetType {
	var baseURL: URL {
		switch self.api {
			case .list:
				return URL(string: "https://api.unsplash.com/")!
		}
	}
	
	var path: String {
		switch self.api {
			case .list:
				return "photos"
		}
	}
	
	var method: Moya.Method {
		return .get
	}
	
	var sampleData: Data {
		return Data()
	}
	
	var task: Task {
		switch self.api {
			case let .list(page, perPage, orderBy):
				return .requestParameters(parameters: ["client_id" : UnsplashPhotosRequest.clientId,
													   "page": page,
													   "per_page": perPage,
													   "order_by": orderBy.rawValue],
										  encoding: URLEncoding.default)
		}
	
	}
	
	var headers: [String : String]? {
		return ["Content-Type": "application/json"]
	}
}
