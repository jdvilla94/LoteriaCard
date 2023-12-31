//
//  previousCardsVC.swift
//  LoteriaCard
//
//  Created by JD Villanueva on 10/25/23.
//

import UIKit

class previousCardsVC: UIViewController {
    
    var cardsFromPreviousArray:[UIImage]! = []
    @IBOutlet var cardImageView: UIImageView!
    var currentIndex: Int = 0
    
    @IBOutlet var buttons: [UIButton]!
    
    var deckCount = 0
    var currentCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        print(cardsFromPreviousArray!.count)
        cardImageView.layer.borderWidth = 2
        cardImageView.layer.borderColor = UIColor.black.cgColor
        cardImageView.layer.cornerRadius = 10
        
        for button in buttons{
            button.layer.cornerRadius = 10
        }
        cardsFromPreviousArray.reverse()
        
        addCardToImageView()
        addOrRemoveButtons()
    
    }
    
    
    func addCardToImageView(){

        for (index,image) in cardsFromPreviousArray.enumerated(){
            cardImageView.image = image
            currentIndex = index
        }
    }
    
    func addOrRemoveButtons(){
        buttons[0].alpha = 0
        if cardsFromPreviousArray.count == 1 {
            buttons[0].alpha = 0
            buttons[1].alpha = 0
        }
    }
    
    @IBAction func previousButtonTapped(_ sender: UIButton) {
        if currentIndex < cardsFromPreviousArray.count{
            
            cardImageView.image = cardsFromPreviousArray[currentIndex]
            currentIndex += 1
            buttons[1].alpha = 1
//            print(currentIndex)
//            print(cardsFromPreviousArray.count)
            if currentIndex == cardsFromPreviousArray.count{
                buttons[0].alpha = 0
            }
        }
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        if currentIndex >= 0{
            currentIndex -= 1
            buttons[0].alpha = 1
            cardImageView.image = cardsFromPreviousArray[currentIndex]
            if currentIndex == 0{
                buttons[1].alpha = 0
            }
        }
    }
}
