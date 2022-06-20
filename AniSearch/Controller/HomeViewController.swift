//
//  HomeViewController.swift
//  AniSearch
//
//  Created by Sabrina Chen on 3/13/22.
//

import UIKit
import Parse

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, FromSettings {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
    
    var max = 0
    var animes = [AnimeModel]()
    var pageNumber = 2
    var color = UIColor.white
    var call:String = "/seasons/now"
    var random = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        call = UserDefaults.standard.string(forKey: "HomeDefault")!
        
        setColor()
        
        spinner.startAnimating()
        tableView.backgroundView = spinner
        
        if (call == "/random/anime") {
            random = true
            loadRandom()
        }
        else{
            random = false
            loadAnime()
        }
        self.tableView.reloadData()
        // Do any additional setup after loading the view.
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setColor()
    }
    
    func setColor(){
        color = UIColor(red: CGFloat(UserDefaults.standard.float(forKey: "Background_R")), green:CGFloat(UserDefaults.standard.float(forKey:"Background_G")), blue:CGFloat(UserDefaults.standard.float(forKey: "Background_B")), alpha: 1)
        tableView.backgroundColor = color
        searchBar.barTintColor = color
        tableView.reloadData()
    }
    
    func reloadDefault(_ reload: Bool, _ endpoint: String) {
        if reload {
            animes.removeAll()
            tableView.reloadData()
            spinner.startAnimating()
            tableView.backgroundView = spinner
            if endpoint == "/random/anime" {
                self.random = true
                loadRandom()
            }
            else{
                self.random = false
                self.call = endpoint
                loadAnime()
            }
            self.tableView.reloadData()
        }
    }
    
    
    //API calls
    func loadAnime(){
        let url = URL(string: "https://api.jikan.moe/v4\(call)?sfw")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) {(data,response, error) in
            if let error = error{
                print(error.localizedDescription)
            }
            else if let data = data{
                let animeDictionary = self.parseJSON(data)
                self.animes = animeDictionary!
                self.tableView.reloadData()
            }
        }
        task.resume()
    }
    func loadMoreAnime(){
        let url = URL(string: "https://api.jikan.moe/v4\(call)?q=&page=\(String(pageNumber))&sfw")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { [self](data,response, error) in
            if let error = error{
                print(error.localizedDescription)
            }
            else if let data = data{
                let animeDictionary = self.parseJSON(data)
                for anime in animeDictionary! {
                    self.animes.append(anime)
                }
                pageNumber += 1
                self.tableView.reloadData()
            }
        }
        task.resume()
    }
    
    func loadRandom() {
        print(random)
        let url = URL(string: "https://api.jikan.moe/v4/random/anime?sfw")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) {(data, response,error)  in
            if let error = error{
                print(error.localizedDescription)
            }
            else if let data = data{
                let animeDictionary = try! JSONDecoder().decode(Random.self, from:data)
                self.animes = [animeDictionary.data]
                self.tableView.reloadData()
            }
        }
        task.resume()
    }
    func loadMoreRandom(){
        self.random = true
        let url = URL(string: "https://api.jikan.moe/v4/random/anime?sfw")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) {(data, response,error)  in
            if let error = error{
                print(error.localizedDescription)
            }
            else if let data = data{
                let animeDictionary = try! JSONDecoder().decode(Random.self, from:data)
                self.animes.append(animeDictionary.data)
                self.tableView.reloadData()
            }
        }
        task.resume()
    }
    
    
    //Table View
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.backgroundColor = color
        if indexPath.row + 1 == animes.count {
            if random == true {
                loadMoreRandom()
            }
            if pageNumber <= max{
                loadMoreAnime()
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return animes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnimeCell") as! AnimeCell
        let anime = self.animes[indexPath.row]
        let title = anime.title
        let synopsis = anime.synopsis
        
        let url = anime.images.jpg.image_url
        cell.titleLabel.text = title
        cell.synopsisLabel.text = synopsis
        cell.posterView.loadFrom(URLAddress: url)
        cell.backgroundColor = color
        return cell
    }
    
    
    //JSONDecoder
    func parseJSON(_ animeList: Data) -> [AnimeModel]? {
        let decoder = JSONDecoder()
        do {
            let decodedAnimeList = try decoder.decode(AnimeList.self, from: animeList)
            self.max = decodedAnimeList.pagination.last_visible_page
            return decodedAnimeList.data
        } catch {
            return nil
        }
    }
    
    
    @IBAction func logoutButton(_ sender: Any) {
        PFUser.logOut()
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = main.instantiateViewController(withIdentifier: "LoginViewController")
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
        let delegate = windowScene.delegate as? SceneDelegate else {return}
        delegate.window?.rootViewController = loginViewController
    }
    
    // Search Bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText:String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload(_:)), object: searchBar)
        perform(#selector(self.reload(_:)), with: searchBar, afterDelay: 0.5)
    }
    
    @objc func reload(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, query.trimmingCharacters(in: .whitespaces) != "" else {
            if(random) {
                loadRandom()
            }
            else{
                pageNumber = 2
                loadAnime()
            }
            return
        }
        let filter = query.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        let url = URL(string: "https://api.jikan.moe/v4/anime?q=\(filter)&sfw")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) {(data,response, error) in
            if let error = error{
                print(error.localizedDescription)
            }
            else if let data = data{
                let animeDictionary = self.parseJSON(data)
                self.animes = animeDictionary!
                self.tableView.reloadData()
            }
        }
        task.resume()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        //Find the selected cell
        if (segue.identifier == "toDetails") {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let anime = animes[indexPath!.row]
            //Pass the selected to the detail view controller
            let detailViewController = segue.destination as! DetailsViewController
            detailViewController.anime = anime
            
            tableView.deselectRow(at: indexPath!, animated: true)
        }
        if (segue.identifier == "HometoSettings") {
            if let nav = segue.destination as? UINavigationController, let settingsViewController = nav.topViewController as? SettingsViewController {
                settingsViewController.delegate = self
                settingsViewController.fromHome = true;
            }
        }
    }
}
extension UIImageView {
    func loadFrom(URLAddress: String) {
        guard let url = URL(string: URLAddress) else {
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            if let imageData = try? Data(contentsOf: url) {
                if let loadedImage = UIImage(data: imageData) {
                    self?.image = loadedImage
                }
            }
        }
    }
}
