import Cocoa
import CreateML

//let data = try MLDataTable(contentsOf: URL(fileURLWithPath: "/Users/rimvydas/Downloads/twitter-sanders-apple3.csv"))
let data = try MLDataTable(contentsOf: URL(fileURLWithPath: "/Users/rimvydas/Projects/Udemy Angela/Twittermenti-iOS13/untitled folder/twitter-sanders-apple3.csv"))


let(trainingData, testingData) = data.randomSplit(by: 0.8, seed: 5)

let sentimentClassifier = try MLTextClassifier(trainingData: trainingData, textColumn: "text", labelColumn: "class")

//let evaluationMetrics = sentimentClassifier.evaluation(on: testingData)
let evaluationMetrics = sentimentClassifier.evaluation(on: testingData, textColumn: "text", labelColumn: "class")

let evelatuanioAccuracy = (1.0 - evaluationMetrics.classificationError) * 100

let metaData = MLModelMetadata(author: "Rimvydas P.", shortDescription: "A model trained to Clasify sentiment on Tweets", version: "1.0")

//try sentimentClassifier.write(to: (URL(fileURLWithPath: "/Users/rimvydas/Downloads/TweetSentimentClassifier.mlmodel")))
try sentimentClassifier.write(to: (URL(fileURLWithPath: "/Users/rimvydas/Projects/Udemy Angela/Twittermenti-iOS13/untitled folder/TweetSentimentClassifier.mlmodel")))

