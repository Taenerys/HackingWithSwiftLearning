//
//  ViewController.swift
//  Project2
//
//  Created by Pham Ha Thu Anh on 2020/05/14.
//  Copyright © 2020 AnhWorld. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var questionAnswered = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor //converted to core graphic framework
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Score", style: .plain, target: self, action: #selector(scoreTapped))
        
        // Do any additional setup after loading the view.
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        askQuestion(action: nil)
    }
    
    func askQuestion(action: UIAlertAction!) {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal) //.normal is a static property of a struct called UIControlState in Swift
        
        title = countries[correctAnswer].uppercased()
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        
        if sender.tag == correctAnswer {
            title = "That's right!!"
            score += 1
            questionAnswered += 1
        } else {
            title = "Sorry that's wrong..."
            score -= 1
            questionAnswered += 1
        }
        
        let ac = UIAlertController(title: title, message: "Your score is \(score)", preferredStyle: .alert)
        let final_ac = UIAlertController(title: title, message: "You have tapped on 10 countries already! Your final score is \(score)!", preferredStyle: .alert)
        let wrong_ac = UIAlertController(title: title, message: "That's the flag of \(countries[sender.tag].uppercased()). Try again!", preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        wrong_ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        
        if questionAnswered == 10 {
            present(final_ac, animated: true)
        } else if questionAnswered != 10 && sender.tag == correctAnswer {
            present(ac, animated: true)
        } else {
            present(wrong_ac, animated: true)
        }
    }
    
    @objc func scoreTapped() {
        let scoreAlert = UIAlertController(title: "Score", message: "\(score)", preferredStyle: .alert)
        scoreAlert.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
        present(scoreAlert, animated: true)
    }
    
}

