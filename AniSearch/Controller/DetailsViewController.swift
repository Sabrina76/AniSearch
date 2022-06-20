//
//  DetailsViewController.swift
//  AniSearch
//
//  Created by Sabrina Chen on 5/5/22.
//

import UIKit
import Parse
import AudioToolbox

class DetailsViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    
    var titlelabel = ""
    var englishTitle = ""
    var ratingLabel = ""
    var genreLabel = ""
    var scoreLabel = ""
    var episodeLabel = ""
    var synopsislabel = ""
    var imageURL = ""
    var id = -1
    
    var anime: AnimeModel!
    var ep_found = false
    var sc_found = false
    var ep: Int = 0
    var sc: Float = 0.0
    let red = UserDefaults.standard.float(forKey: "Background_R")
    let blue = UserDefaults.standard.float(forKey: "Background_B")
    let green = UserDefaults.standard.float(forKey: "Background_G")
    
    var favorite = false
    var favorited:Bool = false
    
    var soundURL: NSURL?
    var soundID:SystemSoundID = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setColor()
        loadInfo()
        animateWelcomeLabel()
        let filePath = Bundle.main.path(forResource: "Sound", ofType: "mp3")
        soundURL = NSURL(fileURLWithPath: filePath!)
    }
    func setColor(){
        self.view.backgroundColor = UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1)
        contentView.backgroundColor = UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1)
    }
    func loadInfo(){
        if (anime != nil) {
            if anime.episodes != nil{
                ep = anime.episodes!
                episodeLabel = String(ep)
            }
            else{
                episodeLabel = "N/A"
            }
            if anime.score != nil{
                sc = anime.score!
                scoreLabel = String(sc)
            }
            else{
                scoreLabel = "N/A"
            }
            id = anime.mal_id
            titlelabel = anime.title
            englishTitle = anime.title_english ?? anime.title
            ratingLabel = anime.rating ?? "N/A"
            synopsislabel = anime.synopsis ?? "N/A"
            var genre = ""
            var count = 1
            for g in anime.genres{
                if count == 1{
                    genre = g.name!
                    count += 1
                }
                else{
                    genre = genre + ", " + g.name!
                }
            }
            genreLabel = genre
            imageURL = anime.images.jpg.image_url
        }
        
        let synopsis = NSMutableAttributedString(string: "Synopsis:",
                                                                  attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17),
                                                                               NSAttributedString.Key.foregroundColor: UIColor.black]);

        synopsis.append(NSMutableAttributedString(string: "\n\n" + (synopsislabel),
                                                                   attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17),
                                                                                NSAttributedString.Key.foregroundColor: UIColor.black]));
        synopsisLabel.attributedText = synopsis
        infoLabel.text =
        "English Title: \n\(englishTitle) \n\n" +
        "Rating: \n\(ratingLabel)\n\n" +
        "Genre: \n\(genreLabel)\n\n" +
        "Score: \n\(scoreLabel)\n\n" +
        "Episode: \n\(episodeLabel)"
        imageView.loadFrom(URLAddress: imageURL)
        titleLabel.text = titlelabel
        let query = PFQuery(className: "Liked")
        query.whereKey("user", equalTo:PFUser.current() as Any)
        query.whereKey("mal_id", equalTo:id as Int)
        query.findObjectsInBackground{(anime, error) in
            if (anime != nil){
                if(anime?.isEmpty == false) {
                    print("Found")
                    self.favorite = true;
                    self.setFavorited(self.favorite)
                }
            }
        }
    }
    
    func setFavorited(_ isFavorited:Bool){
        favorited = isFavorited
        if(favorited){
            favoriteButton.setImage(UIImage(systemName:"star.fill"), for: UIControl.State.normal)
        }
        else {
            favoriteButton.setImage(UIImage(systemName:"star"), for: UIControl.State.normal)
        }
    }
    
    @IBAction func favoritePressed(_ sender: Any) {
        AudioServicesCreateSystemSoundID(soundURL!, &soundID)
        AudioServicesPlaySystemSound(soundID)
        let toBeLiked = !favorited
        if(toBeLiked){
            let like = PFObject(className: "Liked")
            like["user"] = PFUser.current()!
            like["mal_id"] = id as Int
            like["title"] = titlelabel
            like["english"] = englishTitle
            like["rating"] = ratingLabel
            like["genre"] = genreLabel
            like["score"] = scoreLabel
            like["ep"] = episodeLabel
            like["Synopsis"] = synopsislabel
            like["image"] = imageURL
            like.saveInBackground{(success, error) in
                if success {
                    self.setFavorited(true)
                    print("saved")
                }
                else{
                    print("\(String(describing: error))")
                }
            }
        }
        else{
            let query = PFQuery(className: "Liked")
            query.whereKey("user", equalTo:PFUser.current() as Any)
            query.whereKey("mal_id", equalTo:self.id as Any)
            query.findObjectsInBackground { (objects: [PFObject]?, error) in
                if error == nil{
                    self.setFavorited(false)
                    PFObject.deleteAll(inBackground: objects)
                    print("deleted")
                }
            }
        }
    }
    
    //Amimate Labels
    @objc func animateWelcomeLabel() {
        UIView.animate(withDuration: 1.5, animations: {
            self.imageView.frame.origin.x = 100
            self.infoLabel.frame.origin.x = 100
            self.synopsisLabel.frame.origin.x = 100
            self.favoriteButton.frame.origin.x = 100
        })
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
