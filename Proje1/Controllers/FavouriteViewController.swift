//
//  FavouriteViewController.swift
//  Proje1
//
//  
//

import UIKit

class FavouriteViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var favouriteSongArray = [SongModel]()
    let object = ViewController()
    private var chosenSong = SongModel(artistName: "", name: "", id: "", songImageUrl: "",releaseDate: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        if let data = object.defaults.data(forKey: "fav") {
            do {
                let decoder = JSONDecoder()
                
                let notes = try decoder.decode([SongModel].self, from: data)
                favouriteSongArray = notes
            } catch {
                print("Kod çözülemedi \(error)")
            }
        }
        
        tableView.register(UINib(nibName: "SongCell", bundle: nil), forCellReuseIdentifier: "SongCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favouriteSongArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath) as! SongCell
        let favouriteItem = favouriteSongArray[indexPath.row]
        cell.setcell(imageUrl: favouriteItem.songImageUrl, artistName: favouriteItem.artistName, songName: favouriteItem.name, date: favouriteItem.releaseDate)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenSong = favouriteSongArray[indexPath.row]
        performSegue(withIdentifier: "favouriteToDetailsVC", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "favouriteToDetailsVC" {
            let destinationVC = segue.destination as! DetailsViewController
            destinationVC.selectedCell = chosenSong
        }
    }
}
