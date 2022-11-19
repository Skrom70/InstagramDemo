//
//  JSONDecoding.swift
//  InstagramDemo
//
//  Created by Viacheslav Tolstopianteko on 15.11.2022.
//

import Foundation


enum JSONDecoding {
	static func decodeWithDate(format: String = DateFormat.primary) -> JSONDecoder {
		let jsonDecoder = JSONDecoder()
		let dateFormater = DateFormatter()
		dateFormater.dateFormat = format
		jsonDecoder.dateDecodingStrategy = .formatted(dateFormater)
		return jsonDecoder
	}
}
