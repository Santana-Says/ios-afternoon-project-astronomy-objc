//
//  Photo.swift
//  Astrnomy-C
//
//  Created by Jeffrey Santana on 10/14/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import Foundation

class Photo: NSObject {
    var id: Int?
    var sol: Int?
    var camera: Camera?
    var earthDate: Date?
    
    @objc var imageURL: NSURL?

    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(abbreviation: "GMT")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
	
	@objc init(dictionary: Dictionary<String, Any>) {
		
		if let id = dictionary["id"] as? Int {
			self.id = id
		}
		if let sol = dictionary["isold"] as? Int {
			self.sol = sol
		}
		if let dateString = dictionary["earthDate"] as? String, let date = dateFormatter.date(from: dateString) {
			self.earthDate = date
		}
		if let urlString = dictionary["imageSrc"] as? String, let url = URL(string: urlString) {
			self.imageURL = url as NSURL
		}
	}
}
