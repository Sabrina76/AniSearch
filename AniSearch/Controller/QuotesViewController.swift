//
//  QuotesViewController.swift
//  AniSearch
//
//  Created by Sabrina Chen on 4/3/22.
//

import UIKit

class QuotesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    var quotes = [QuoteList]()
    var color = UIColor.white
    var animes = [AnimeModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        loadQuotes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setColor()
    }
    
    func setColor(){
        color = UIColor(red: CGFloat(UserDefaults.standard.float(forKey: "Background_R")), green:CGFloat(UserDefaults.standard.float(forKey:"Background_G")), blue:CGFloat(UserDefaults.standard.float(forKey: "Background_B")), alpha: 1)
        tableView.backgroundColor = color
        tableView.reloadData()
    }
    
    func loadQuotes() {
        let url = URL(string: "https://animechan.vercel.app/api/quotes")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error{
                print(error.localizedDescription)
            }
            else if let data = data{
                let quotesDictionary: [QuoteList] = try! JSONDecoder().decode([QuoteList].self, from: data)
                self.quotes = quotesDictionary
                self.tableView.reloadData()
            }
        }
        task.resume()
    }
    
    func loadMoreQuotes(){
        let url = URL(string: "https://animechan.vercel.app/api/quotes")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error{
                print(error.localizedDescription)
            }
            else if let data = data{
                let quotesDictionary: [QuoteList] = try! JSONDecoder().decode([QuoteList].self, from: data)
                
                for quote in quotesDictionary {
                    self.quotes.append(quote)
                }
                self.tableView.reloadData()
            }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.backgroundColor = color
        if indexPath.row + 1 == quotes.count{
            loadMoreQuotes()
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quotes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuoteCell") as! QuoteCell
        let Quote = quotes[indexPath.row]
        let quote = Quote.quote
        let character = Quote.character
        let anime = Quote.anime
        cell.quoteLabel.text = quote
        cell.characterLabel.text = "-" + (character ?? "")
        cell.animeLabel.text = anime
        return cell
    }
    // MARK: - Navigation
/*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
    }
    */

}
