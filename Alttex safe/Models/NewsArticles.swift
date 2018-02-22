//
//  NewsArticles.swift
//  Alttex safe
//
//  Created by Vlad Kovryzhenko on 2/7/18.
//  Copyright © 2018 Vlad Kovryzhenko. All rights reserved.
//

import Foundation
import ObjectMapper

class Articles: Mappable {
    
    var title: String?
    var description: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: Int32?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        title <- map["title"]
        description <- map["description"]
        url <- map["url"]
        urlToImage <- map["urlToImage"]
        publishedAt <- map["publishedAt"]
    }
    
    
}
