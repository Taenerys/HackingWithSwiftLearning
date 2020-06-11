//
//  ViewController.swift
//  Project7
//
//  Created by Pham Ha Thu Anh on 2020/05/24.
//  Copyright © 2020 AnhWorld. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(showCredits))
        
        let filterButton = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(promptFilter))
        
        let resetButton = UIBarButtonItem(title:"Reset", style: .plain, target: self, action: #selector(resetPetitions))
        
        navigationItem.leftBarButtonItems = [filterButton, resetButton]
        
        let urlString: String
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }
        showError()
    }
    
    @objc func resetPetitions() {
        //TODO: Implement reset
    }
    
    @objc func promptFilter() {
        let ac = UIAlertController(title: "Filter", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitFilter = UIAlertAction(title: "Ok", style: .default) {
            [weak self, weak ac] _ in
            guard let filterAnswer = ac?.textFields?[0].text else { return }
            self?.filter(filterAnswer)
        }
        
        ac.addAction(submitFilter)
        present(ac, animated: true)
    }
    
    func filter(_ answer: String) {
        let lowerAnswer = answer.lowercased()
        
        for petition in petitions {
            if petition.title.lowercased().contains(lowerAnswer) {
                filteredPetitions.append(petition)
            }
        }
        petitions = filteredPetitions
        tableView.reloadData()
    }
    
    @objc func showCredits() {
        let ac = UIAlertController(title: "Credits To", message: "The petitions are taken from We The People API of the White House", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = petitions[indexPath.row]

        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }


}

