//
//  AnimeList.swift
//  AniSearch
//
//  Created by Sabrina Chen on 4/22/22.
//

import Foundation

struct Random: Codable{
    let data: AnimeModel
}

struct AnimeList: Codable {
    let pagination: PageCount
    let data: [AnimeModel]
}
struct PageCount: Codable{
    let last_visible_page: Int
    let has_next_page: Bool
}
struct AnimeModel: Codable {
    let mal_id: Int
    let images: imageType
    let title: String
    let title_english: String?
    let episodes: Int?
    let rating: String?
    let score: Float?
    let rank: Int?
    let popularity: Int?
    let synopsis: String?
    let genres: [GenreType]
}

struct imageType: Codable{
    let jpg: imageSize
}
struct imageSize: Codable{
    let image_url: String
}
struct GenreType: Codable{
    let name: String?
}

