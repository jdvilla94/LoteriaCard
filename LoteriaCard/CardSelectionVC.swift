//
//  CardSelectionVC.swift
//  LoteriaCard
//
//  Created by JD Villanueva on 10/25/23.
//

import UIKit
import AVFoundation

class CardSelectionVC: UIViewController {

    @IBOutlet var cardImageView: UIImageView!
//    @IBOutlet var startButton: UIButton!
//    @IBOutlet var stopButton: UIButton!
//    @IBOutlet var restartButton: UIButton!
//    @IBOutlet var previousCardsButton: UIButton!
    
    var player: AVAudioPlayer!
    

    @IBOutlet var buttons: [UIButton]!
//    var cardArray: [UIImage] = Deck.allValues
    var cardArray: [String:UIImage] = Deck.allValues
    var audioDict: [String:String] = audio.allValues
    var previousCardsArray: [UIImage] = []
    var didYouReset: Bool = false
    
    var timer: Timer!

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cardImageView.layer.borderWidth = 2
        cardImageView.layer.borderColor = UIColor.black.cgColor
        cardImageView.layer.cornerRadius = 10
        for button in buttons{
            button.layer.cornerRadius = 10
        }
        
        
    }
    
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        timer.invalidate()
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! previousCardsVC
        destVC.cardsFromPreviousArray = sender as? [UIImage]
    }
    
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(showRandomImage), userInfo: nil, repeats: true)
    }
    
//    func playSound(){
//        let url = Bundle.main.url(forResource: cardArray[0]., withExtension: "mp3")
//        player = try! AVAudioPlayer(contentsOf: url!)
//        player!.play()
//    }
    
    @objc func showRandomImage() {
        if cardArray.count != 0{
            guard let randomCard = cardArray.randomElement() else{return}
            let image = randomCard.value
//            guard let index = cardArray.firstIndex(of: randomCard) else{return}
            cardImageView.image = image
            previousCardsArray.append(image)
            cardArray.removeValue(forKey: randomCard.key)
            guard let url = Bundle.main.url(forResource: randomCard.key, withExtension: "mp3") else {return}
            player = try! AVAudioPlayer(contentsOf: url)
            player.play()

//            cardImageView.image = randomCard
//            cardArray.remove(at: index)
//            previousCardsArray.append(randomCard)
//            print(cardArray.count)
    //        cardImageView.image = cardArray.randomElement() ?? UIImage(named: "elAlacran")
        }else{
            // Create an instance of UIAlertController
              let alertController = UIAlertController(
                  title: "THE END",
                  message: "You've reached the end of the deck.",
                  preferredStyle: .alert
              )

              // Create an action for the alert (e.g., an "OK" button)
              let okAction = UIAlertAction(
                  title: "Restart",
                  style: .default,
                  handler: { action in
                      // Handle the OK button action
                      self.timer.invalidate()
                      self.cardArray = Deck.allValues
                      self.cardImageView.image = nil
                      self.previousCardsArray = []
//                      print(self.cardArray.count)
                      self.startTimer()
                      self.didYouReset = true
                  }
              )

              // Add the action to the alert
              alertController.addAction(okAction)

              // Present the alert on the current view controller
              present(alertController, animated: true, completion: nil)
          }

    }
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        startTimer()
    }
    
    @IBAction func stopButtonTapped(_ sender: UIButton) {
        timer.invalidate()
//        print(cardArray.count)
        
    }
    
    @IBAction func restartButtonTapped(_ sender: UIButton) {
        timer.invalidate()
        cardArray = Deck.allValues
        cardImageView.image = nil
        startTimer()
        didYouReset = true
        previousCardsArray = []
//        print(cardArray.count)
    }
    
    @IBAction func previousButtonTapped(_ sender: UIButton) {
        if previousCardsArray.count == 0 {
            print("ITS NIL, CANT GO THERE")
        }else{
            timer.invalidate()
            performSegue(withIdentifier: "toPreviousCards", sender: previousCardsArray)
        }
        
        
    }
}



