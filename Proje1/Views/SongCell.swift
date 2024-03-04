//
//  SongCell.swift
//  Proje1
//
//  
//

import UIKit

class SongCell: UITableViewCell {
    
    @IBOutlet weak var songImageView: UIImageView!
    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    
    private var imageData = Data()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        songImageView.layer.cornerRadius = songImageView.frame.size.width / 2
    }
    
    func setcell(imageUrl : String , artistName : String , songName : String , date : String){
        
        songLabel.text = songName
        artistNameLabel.text = artistName
        
        DispatchQueue.global().async {
            self.imageData = try! Data(contentsOf: URL(string: imageUrl)!)
            DispatchQueue.main.async {
                self.songImageView.image = UIImage(data: self.imageData)
            }
        }
    }
}
