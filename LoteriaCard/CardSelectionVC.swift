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
    
    var player: AVAudioPlayer!
    @IBOutlet var collectionView: UICollectionView!
    

    @IBOutlet var buttons: [UIButton]!
//    var cardArray: [UIImage] = Deck.allValues
    var cardArray: [String:UIImage] = Deck.allValues
    var audioDict: [String:String] = audio.allValues
    var previousCardsArray: [UIImage] = []
    var isButtonEnabled = false
        
    var timer: Timer!
    
    var deckCount = 54
    var currentCount = 0
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("The deck count is \(deckCount) and the current count is \(currentCount)")
        DispatchQueue.main.async {
            self.buttons[3].titleLabel?.text = "Previous: \(self.currentCount)"
            self.buttons[4].titleLabel?.text = "Left: \(self.deckCount)"
        }
      
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
        DispatchQueue.main.async {
            self.buttons[3].titleLabel?.text = "Previous: \(self.currentCount)"
            self.buttons[4].titleLabel?.text = "Left: \(self.deckCount)"
        }
        
        cardImageView.layer.borderWidth = 2
        cardImageView.layer.borderColor = UIColor.black.cgColor
        cardImageView.layer.cornerRadius = 10
        for button in buttons{
            button.layer.cornerRadius = 10
        }
        
        buttons[1].isEnabled = false
        buttons[1].alpha = 0.5

        buttons[2].isEnabled = false
        buttons[2].alpha = 0.5

        buttons[3].isEnabled = false
        buttons[3].alpha = 0.5
        
        buttons[4].isEnabled = false
        buttons[4].alpha = 0.5
        
    }

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPreviousCards"{
            let destVC = segue.destination as! previousCardsVC
            destVC.cardsFromPreviousArray = sender as? [UIImage]
            destVC.deckCount = 54 - previousCardsArray.count
            destVC.currentCount = previousCardsArray.count
        }

    }
    

    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(showRandomImage), userInfo: nil, repeats: true)
        buttons[0].alpha = 0.5
        buttons[0].isEnabled = false
    }
    
    @objc func showRandomImage() {
    
        if cardArray.count > 0{
            guard let randomCard = cardArray.randomElement() else{return}
            let image = randomCard.value
           
//            guard let index = cardArray.firstIndex(of: randomCard) else{return}
            guard let flip = Bundle.main.url(forResource: "flipCard", withExtension: "mp3") else {return}
            player = try! AVAudioPlayer(contentsOf: flip)
            player.play()
            cardImageView.image = image
            guard let url = Bundle.main.url(forResource: randomCard.key, withExtension: "mp3") else {return}
            player = try! AVAudioPlayer(contentsOf: url)
            player.play()
            previousCardsArray.insert(image, at: 0)
//            previousCardsArray.append(image)
            cardArray.removeValue(forKey: randomCard.key)
            currentCount += 1
            deckCount -= 1
            
            DispatchQueue.main.async {
                self.buttons[3].titleLabel?.text = "Previous: \(self.currentCount)"
                self.buttons[4].titleLabel?.text = "Left: \(self.deckCount)"
            }
//            buttons[3].titleLabel?.text = "Previous: \(previousCardsArray.count)"
//            buttons[4].titleLabel?.text = "Left: \(54 - previousCardsArray.count)"

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
                      self.buttons[2].isEnabled = true
                      self.buttons[2].alpha = 1
                      self.cardArray = Deck.allValues
                      self.cardImageView.image = nil
                      self.startTimer()
                      self.previousCardsArray = []
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
        
        buttons[1].isEnabled = true
        buttons[1].alpha = 1
        
        buttons[2].isEnabled = true
        buttons[2].alpha = 1
        
        buttons[3].isEnabled = true
        buttons[3].alpha = 1
        
        buttons[4].isEnabled = true
        buttons[4].alpha = 1
        
    }
    
    @IBAction func stopButtonTapped(_ sender: UIButton) {
        if sender.isEnabled{
            sender.isEnabled = false
            buttons[2].alpha = 0.5
        }
        
        buttons[0].alpha = 1
        buttons[0].isEnabled = true
        timer.invalidate()
    }
    
    @IBAction func restartButtonTapped(_ sender: UIButton) {
        
        timer.invalidate()
        // Create an instance of UIAlertController
        let alertController = UIAlertController(
              title: "RESTART",
              message: "Are you sure you want to restart?.",
              preferredStyle: .alert
          )

          // Create an action for the alert (e.g., an "OK" button)
        let okAction = UIAlertAction(
              title: "Restart",
              style: .default,
              handler: { action in
                  // Handle the OK button action
                  self.timer.invalidate()
                  self.buttons[2].isEnabled = true
                  self.buttons[2].alpha = 1
                  self.cardArray = Deck.allValues
                  self.cardImageView.image = nil
                  self.previousCardsArray = []
                  self.startTimer()
  
              }
          )

          // Add the action to the alert
        alertController.addAction(okAction)
        // Add a "Cancel" button with a handler
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            // Handle the "Cancel" button action here
            self.startTimer()
            self.dismiss(animated: true, completion: nil)
        })

          // Present the alert on the current view controller
          present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func previousButtonTapped(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.buttons[3].titleLabel?.text = "Previous: \(self.currentCount)"
            self.buttons[4].titleLabel?.text = "Left: \(self.deckCount)"
        }
        if previousCardsArray.count == 0 {
            print("ITS NIL, CANT GO THERE")
        }else{
            timer.invalidate()
            buttons[0].isEnabled = true
            buttons[0].alpha = 1
            
            performSegue(withIdentifier: "toPreviousCards", sender: previousCardsArray)
        }
    }
}

extension CardSelectionVC: UICollectionViewDataSource,UICollectionViewDelegate{
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        DispatchQueue.main.async {
//            self.previousCardsArray.reverse()
            self.collectionView.reloadData()
        }
        return previousCardsArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! previousCardCollectionCell
//        previousCardsArray.reverse()
        cell.card.image = previousCardsArray[indexPath.row]
        return cell
    }
}
