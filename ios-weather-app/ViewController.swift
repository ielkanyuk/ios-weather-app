//
//  ViewController.swift
//  ios-weather-app
//
//  Created by Igor Elkanyuk on 22.11.2020.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
    }

}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let _urlString = "http://api.weatherstack.com/current?access_key=00b764ee34f436a1ae759512cbbc34d8&query=\(searchBar.text!)"
        
        let url = URL(string: _urlString)
        
        var locationName: String?
        var temperature: Double?
        
        let task = URLSession.shared.dataTask(with: url!) {[weak self] (data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: AnyObject]
                
                if let location = json["location"] {
                    locationName = location["name"] as? String
                }
                
                if let current = json["current"] {
                    temperature = current["temperature"] as? Double
                }
                
                DispatchQueue.main.async {
                    self?.cityLabel.text = locationName
                    self?.temperatureLabel.text = "\(temperature!)"
                }
            }
            catch let jsonError {
                print(jsonError)
            }
        }
        
        task.resume()
    }
}
