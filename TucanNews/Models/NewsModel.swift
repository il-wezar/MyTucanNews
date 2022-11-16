//
//  NewsModel.swift
//  TucanNews
//
//  Created by Illia Wezarino on 13.09.2022.
//

import UIKit

struct NewsResponseObject: Codable {
  
    var news: [NewsObject]
  
}

struct NewsObject: Codable {
  
  let title: String
  let date: String
  let teaser: String
  let image: String
  let text: String
  
}
