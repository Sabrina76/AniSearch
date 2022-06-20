//
//  SettingsViewController.swift
//  AniSearch
//
//  Created by Sabrina Chen on 4/23/22.
//

import UIKit

protocol FromSettings: AnyObject {
    func reloadDefault(_ reload: Bool, _ endpoint: String)
//    func colorChange(_ colorRelod:Bool, _ red: Float, _ blue: Float, _ green: Float)
}

class SettingsViewController: UIViewController {

    var anime = "/seasons/now"
    var filter = ""
    var fromHome = false;
    
    
    @IBOutlet weak var defaultControl: UISegmentedControl!
    @IBOutlet weak var defaultControlLabel: UILabel!
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    
    let nowRed = UserDefaults.standard.float(forKey: "Background_R")
    let nowBlue = UserDefaults.standard.float(forKey: "Background_B")
    let nowGreen = UserDefaults.standard.float(forKey: "Background_G")
    
    weak var delegate: FromSettings?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        redSlider.value = nowRed * 255
        blueSlider.value = nowBlue * 255
        greenSlider.value = nowGreen * 255
        self.view.backgroundColor = UIColor(red:CGFloat(redSlider.value)/255, green:CGFloat(greenSlider.value)/255, blue:CGFloat(blueSlider.value)/255, alpha: 1)
        if (UserDefaults.standard.string(forKey: "HomeDefault") == "/top/anime"){
            defaultControl.selectedSegmentIndex = 1
            anime = "/top/anime"
        }
        if (UserDefaults.standard.string(forKey: "HomeDefault") == "/random/anime"){
            defaultControl.selectedSegmentIndex = 2
            anime = "/random/anime"
        }
        if (fromHome) {
            defaultControlLabel.isHidden = false;
            defaultControl.isHidden = false;
        }
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func changeDefault(_ sender: Any) {
        switch defaultControl.selectedSegmentIndex{
        case 0:
            anime = "/seasons/now"
        case 1:
            anime = "/top/anime"
        case 2:
            anime = "/random/anime"
        default:
            break
        }
    }
    @IBAction func sliderAction(_ sender: Any) {
        self.view.backgroundColor = UIColor(red:CGFloat(redSlider.value)/255, green:CGFloat(greenSlider.value)/255, blue:CGFloat(blueSlider.value)/255, alpha: 1)
    }
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveChanges(_ sender: Any) {
        let now = UserDefaults.standard.string(forKey: "HomeDefault")
        UserDefaults.standard.set(anime, forKey: "HomeDefault")
        
        UserDefaults.standard.set(redSlider.value/255, forKey: "Background_R")
        UserDefaults.standard.set(blueSlider.value/255, forKey: "Background_B")
        UserDefaults.standard.set(greenSlider.value/255, forKey: "Background_G")
        UserDefaults.standard.set(filter, forKey: "Filters")
        
        if now != anime{
            self.delegate?.reloadDefault(true, anime)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
