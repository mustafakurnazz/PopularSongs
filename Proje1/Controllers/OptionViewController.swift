//
//  OptionViewController.swift
//  Proje1
//
//  Created by Furkan Kurnaz on 13.01.2024.
//

import UIKit

class OptionViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    private var listCount = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func crateListButtonClicked(_ sender: UIButton) {
        if let count = Int(textField.text!){
            if count > 100 {
                alertController(title: "Error !!!", message: "Listenin boyutu 100'den fazla olamaz.")
            } else{
                listCount = textField.text!
            }
        }
        else{
            self.alertController(title: "Error !!!", message: "Lütfen sayısal bir değer giriniz.")
        }
        performSegue(withIdentifier: "toListVC", sender: nil)
    }
    
    func alertController(title : String , message : String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let closeButton = UIAlertAction(title: "CLOSE", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(closeButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toListVC" {
            let destinationVC = segue.destination as! ViewController
            destinationVC.listCount = listCount
        }
    }
}
