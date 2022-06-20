//
//  WatchViewController.swift
//  AniSearch
//
//  Created by Sabrina Chen on 5/4/22.
//

import UIKit
import Parse

class WatchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var anime: AnimeModel!
    var liked = [PFObject]()
    var animes = [AnimeModel]()
    var count = 0
    @IBOutlet var collectionView: UICollectionView!
    
    let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
//         Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        spinner.startAnimating()
        collectionView.backgroundView = spinner
        let color = UIColor(red: CGFloat(UserDefaults.standard.float(forKey: "Background_R")), green:CGFloat(UserDefaults.standard.float(forKey:"Background_G")), blue:CGFloat(UserDefaults.standard.float(forKey: "Background_B")), alpha: 1)
        collectionView.backgroundColor = color
        getLiked()
        collectionView.reloadData()
    }
    
    func getLiked() {
        let query = PFQuery(className: "Liked")
        query.whereKey("user", equalTo:PFUser.current() as Any)
        query.findObjectsInBackground{(anime, error) in
            if (error == nil){
                self.liked = anime!
                self.collectionView.reloadData()
                self.spinner.stopAnimating()
            }
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return liked.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CollectionCell
        let anime = liked[indexPath.item]
        let url = anime["image"] as! String
        cell.posterView.loadFrom(URLAddress: url)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width/2, height: view.frame.size.width/2*1.5)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetails"{
            let cell = sender as! UICollectionViewCell
            let indexPath = collectionView.indexPath(for: cell)!
            let selected = liked[indexPath.item]
            //Pass the selected anime to the details view controller
            
            let detailsViewController = segue.destination as! DetailsViewController
            detailsViewController.id = selected["mal_id"] as! Int
            detailsViewController.titlelabel = selected["title"] as! String
            detailsViewController.englishTitle = selected["english"] as! String
            detailsViewController.ratingLabel = selected["rating"] as! String
            detailsViewController.genreLabel = selected["genre"] as! String
            detailsViewController.scoreLabel = selected["score"] as! String
            detailsViewController.episodeLabel = selected["ep"] as! String
            detailsViewController.synopsislabel = selected["Synopsis"] as! String
            detailsViewController.imageURL = selected["image"] as! String
            
            collectionView.deselectItem(at: indexPath, animated: true)}
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}
