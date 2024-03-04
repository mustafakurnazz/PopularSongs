//
//  DetailsViewController.swift
//  Proje1
//
// 
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var songImageView: UIImageView!
    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var selectedCell = SongModel(artistName: "", name: "", id: "", songImageUrl: "",releaseDate: "")
    private var imageData = Data()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        songLabel.text = selectedCell.name
        artistNameLabel.text = selectedCell.artistName
        dateLabel.text = selectedCell.releaseDate
        
        DispatchQueue.global().async {
            self.imageData = try! Data(contentsOf: URL(string: self.selectedCell.songImageUrl)!)
            DispatchQueue.main.async {
                self.songImageView.image = UIImage(data: self.imageData)
            }
        }
    }
}
