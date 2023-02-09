//
//  ViewController.swift
//  Twittermenti
//
//  Created by Rimvydas on 2023-02-09.
//

import UIKit
import SwifteriOS
import CoreML
import SwiftyJSON

class ViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!
    
    let tweetCount = 100
    
    //    let sentimentClassifier = TweetSentimentClassifier()
    let model: TweetSentimentClassifier = {
        
        do {
            let config = MLModelConfiguration()
            return try TweetSentimentClassifier(configuration: config)
        } catch {
            print(error)
            fatalError("Couldn't create MobileNetV2")
        }
    }()
    
    let swifter = Swifter(consumerKey: "uv5Ms3VWyxDpDIcYpFryTdWVq", consumerSecret: "ldbkjqOLZoKhiHgwcE2He3ZtsBjV7ToviyeTT33i4ugZMjc5SX")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func predictPressed(_ sender: Any) {
        
        fetchTweets()
    }
    
    func fetchTweets() {
        if let searchText = textField.text {
            
            swifter.searchTweet(using: searchText, lang: "en", count: 100, tweetMode: .extended, success: { (results, Metadata) in
                
                var tweets = [TweetSentimentClassifierInput]()
                
                for i in 0..<self.tweetCount {
                    if let tweet = results[i]["full_text"].string{
                        let tweetForClasification = TweetSentimentClassifierInput(text: tweet)
                        tweets.append(tweetForClasification)
                    }
                }
                
                self.makePrediction(with: tweets)
                
            }) { (error) in
                print("There was an error with the Twitter API Request, .\(error)")
            }
        }
    }
    
    func makePrediction(with tweets: [TweetSentimentClassifierInput] ) {
        
        do {
            
            let predictions = try self.model.predictions(inputs: tweets)
            
            var sentimentScore = 0
            
            for pred in predictions {
                let sentiment = pred.label
                
                if sentiment == "Pos" {
                    sentimentScore += 1
                } else if sentiment == "Neg" {
                    sentimentScore -= 1
                }
            }
            
            updateUI(with: sentimentScore)
            
        } catch {
            print("There was an error with making a prediction, \(error)")
        }
    }
    
    func updateUI(with sentimentScore: Int) {
        
        if sentimentScore > 20 {
            self.sentimentLabel.text = "😍"
        } else if sentimentScore > 10 {
            self.sentimentLabel.text = "😀"
        } else if sentimentScore > 0 {
            self.sentimentLabel.text = "🙂"
        } else if sentimentScore == 0 {
            self.sentimentLabel.text = "😐"
        } else if sentimentScore > -10 {
            self.sentimentLabel.text = "😕"
        } else if sentimentScore > 20 {
            self.sentimentLabel.text = "😡"
        } else {
            self.sentimentLabel.text = "🤮"
        }
    }
    
}

