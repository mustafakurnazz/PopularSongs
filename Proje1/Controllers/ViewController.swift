//
//  ViewController.swift
//  Proje1
//
//
//

import UIKit

class ViewController: UIViewController, UISearchControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var songArray = [SongModel]()
    private var filterArray = [SongModel]()
    private var favouriteSong = [SongModel]()
    private var songManeger = SongManager()
    private var chosenCell = SongModel(artistName: "", name: "", id: "", songImageUrl: "",releaseDate: "")
    
    private let searchController = UISearchController()
    private var text = ""
    public var defaults = UserDefaults.standard
    public var listCount = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupController()
    }
    
    private func setupController(){
        
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        
        if let data = defaults.data(forKey: "fav") {
            do {
                let decoder = JSONDecoder()
                
                let notes = try decoder.decode([SongModel].self, from: data)
                favouriteSong = notes
            } catch {
                print("Kod çözülemedi \(error)")
            }
        }
        
        songManeger.delegate = self
        songManeger.performRequest(count: listCount)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SongCell", bundle: nil), forCellReuseIdentifier: "SongCell")
    }
    
    @IBAction func favouriteButtonClicked(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "toFavouriteVC", sender: nil)
    }
}

extension ViewController : SongManegerDelegate{
    func didUpdateSongs(songs: [SongModel]) {
        songArray = songs
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension ViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !filterArray.isEmpty{
            return filterArray.count
        } else if text != "" && filterArray.isEmpty {
            return 0
        } else {
            return songArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath) as! SongCell
        
        if !filterArray.isEmpty{
            let filterItem = filterArray[indexPath.row]
            cell.setcell(imageUrl: filterItem.songImageUrl, artistName: filterItem.artistName, songName: filterItem.name, date: filterItem.releaseDate)
        } else {
            let songItem = songArray[indexPath.row]
            cell.setcell(imageUrl: songItem.songImageUrl, artistName: songItem.artistName, songName: songItem.name, date: songItem.releaseDate)
        }
        
        if !filterArray.isEmpty {
            cell.accessoryType = favouriteSong.contains(where: {$0.id == self.filterArray[indexPath.row].id}) ? .checkmark : .none
        } else {
            cell.accessoryType = favouriteSong.contains(where: {$0.id == self.songArray[indexPath.row].id}) ? .checkmark : .none
        }
        
        return cell
    }
}

extension ViewController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if !filterArray.isEmpty{
            chosenCell = filterArray[indexPath.row]
        } else {
            chosenCell = songArray[indexPath.row]
        }
        
        text = ""
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        var actionTitle = ""
        
        if !filterArray.isEmpty{
            actionTitle = favouriteSong.contains(where: {$0.id == self.filterArray[indexPath.row].id}) ? "UnFavourite" : "Favourite"
        } else {
            actionTitle = favouriteSong.contains(where: {$0.id == self.songArray[indexPath.row].id}) ? "UnFavourite" : "Favourite"
        }
        
        let addFavouriteAction = UIContextualAction(style: .normal, title: actionTitle) { action, view, completionHandler in
            
            if !self.filterArray.isEmpty && !self.favouriteSong.contains(where: {$0.id == self.filterArray[indexPath.row].id}){
                self.favouriteSong.append(self.filterArray[indexPath.row])
                completionHandler(true)
            } else if !self.filterArray.isEmpty{
                if let index = self.favouriteSong.firstIndex(where: {$0.id == self.filterArray[indexPath.row].id}){
                    self.favouriteSong.remove(at: index)
                }
                completionHandler(true)
            } else if !self.favouriteSong.contains(where: {$0.id == self.songArray[indexPath.row].id}) {
                self.favouriteSong.append(self.songArray[indexPath.row])
                completionHandler(true)
            } else {
                if let index = self.favouriteSong.firstIndex(where: {$0.id == self.songArray[indexPath.row].id}){
                    self.favouriteSong.remove(at: index)
                    completionHandler(true)
                }
            }
            
            do{
                let encoder = JSONEncoder()
                let data = try encoder.encode(self.favouriteSong)
                self.defaults.set(data, forKey: "fav")
                print(data)
            } catch {
                print(error.localizedDescription)
            }
            
            tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
        }
        addFavouriteAction.backgroundColor = UIColor.green
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [addFavouriteAction])
        return swipeConfiguration
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC"{
            let destinationVC = segue.destination as! DetailsViewController
            destinationVC.selectedCell = chosenCell
        } else {
            let destinationVC = segue.destination as! FavouriteViewController
            destinationVC.favouriteSongArray = favouriteSong
        }
    }
}

extension ViewController : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterArray.removeAll()
        for index in 0 ... songArray.count - 1{
            if songArray[index].artistName.contains(searchText) || songArray[index].name.contains(searchText){
                filterArray.append(songArray[index])
            }
        }
        text = searchText
        tableView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.placeholder = "Search"
        filterArray.removeAll()
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        text = ""
    }
}
