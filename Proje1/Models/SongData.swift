//
//  SongData.swift
//  Proje1
//
//  
//

import Foundation

struct SongData : Decodable{
    let feed : Feed
}

struct Feed : Decodable{
    let results : [Results]
}

struct Results : Decodable{
    let artistName : String
    let name : String
    let id : String
    let artworkUrl100 : String
    let releaseDate : String
}
