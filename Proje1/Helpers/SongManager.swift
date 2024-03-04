//
//  SongManeger.swift
//  Proje1
//
// 
//

import Foundation

protocol SongManegerDelegate{
    func didUpdateSongs(songs : [SongModel])
}

class SongManager {
    
    var delegate : SongManegerDelegate?
    
    func performRequest(count : String){
        
        let urlString = "https://rss.applemarketingtools.com/api/v2/tr/music/most-played/\(count)/songs.json"
        
        if let url = URL(string: urlString){
            let sesion = URLSession(configuration: .default)
            
            let task = sesion.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error!.localizedDescription)
                }
                if let safeData = data{
                    if let songs = self.parseJson(data: safeData){
                        self.delegate?.didUpdateSongs(songs: songs)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJson(data : Data) -> [SongModel]?{
        let decoder = JSONDecoder()
        var songArray = [SongModel]()
        
        do{
            let decodedData = try decoder.decode(SongData.self, from: data)
            for i in ( 0 ... decodedData.feed.results.count - 1 ){
                let artistName = decodedData.feed.results[i].artistName
                let name = decodedData.feed.results[i].name
                let id = decodedData.feed.results[i].id
                let songImageUrl = decodedData.feed.results[i].artworkUrl100
                let date = decodedData.feed.results[i].releaseDate
                
                let song = SongModel(artistName: artistName, name: name, id: id, songImageUrl: songImageUrl,releaseDate: date)
                songArray.append(song)
            }
            return songArray
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
