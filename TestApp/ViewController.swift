//
//  ViewController.swift
//  TestApp
//
//  Created by Estefania Fernandez Muñoz on 7/5/17.
//  Copyright © 2017 Estefania Fernandez Muñoz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var enterYourName: UILabel!
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var switchLabel: UILabel!
    @IBOutlet weak var switchButton: UISwitch!
    @IBOutlet weak var textToIncrease: UITextView!
    @IBOutlet weak var sliderButton: UISlider!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        textToIncrease.text = "Hey There"
        textToIncrease.font = UIFont(name: "Arial", size: 20)
        sliderButton.minimumValue = 10
        sliderButton.value = 20
        sliderButton.maximumValue = 50
        switchButton.isHidden=false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func clickAction(_ sender: Any) {
        if(nameInput.text?.isEmpty)!{
            print("Nothing was entered on the textfield")
            return
        }
        else{
            enterYourName.text = "Hello: \(nameInput.text!)"
        }
    }
    
    @IBAction func switchButtonAction(_ sender: Any) {
        if(switchButton.isOn){
            switchLabel.text = "ON"
        }
        else{
            switchLabel.text = "OFF"
        }
    }
    
    @IBAction func increaseTextAction(_ sender: UISlider) {
        textToIncrease.isEditable = true
        
        textToIncrease.font = UIFont(name: "Arial", size: CGFloat (sender.value))
        
        textToIncrease.isEditable = false
        
    }
    

}

