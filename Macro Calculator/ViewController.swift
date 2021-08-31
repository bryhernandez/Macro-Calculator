//
//  ViewController.swift
//  Macro Calculator
//
//  Created by Bryan Hernandez on 8/28/21.
//  Copyright © 2021 Bryan Hernandez. All rights reserved.
//

import UIKit

//These are the activity levels based on users activity level
let sedentary = 1.2
let lightly = 1.37
let moderate = 1.55
let very = 1.72
let extreme = 1.9

//calculates the calories based on just fat
func calc_fat_cals(fat: Double, total_cals: Int) -> Int{
    return Int(fat*Double(total_cals))
}

//calculates excatly how many grams of fat in terms of calories
func calc_fat(fat: Double, total_cals: Int) -> Int{
    var fat_macros = fat*Double(total_cals)
    fat_macros = fat_macros/9

    return Int(fat_macros)
}

//calculates maintanence calories given user bmr and activty level
func calc_cals(activity: Int, bmr: Int) -> Int{
    if activity == 1{
        return Int(Double(bmr) * sedentary)
    } else if activity == 2 {
        return Int(Double(bmr) * lightly)
    } else if activity == 3{
        return Int(Double(bmr) * moderate)
    } else if activity == 4 {
        return Int(Double(bmr) * very)
    } else if activity == 5 {
        return Int(Double(bmr) * extreme)
    }
    
    return 1
      
}

//mifflin aquation to solve for male and female bmr
func mifflin_equation_female(kg: Double, cm: Double, age: Double) -> Double{
     let bmr = (9.99 * kg) + (6.25 * cm) - (4.92 * age) - 161;
    
    return bmr;
}

func mifflin_equation_male(kg: Double, cm: Double, age: Double) -> Double {
     let bmr = (9.99 * kg) + (6.25 * cm) - (4.92 * age) + 5;
    
    return bmr;
}



class ViewController: UIViewController {
    
    @IBOutlet weak var lbsTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var genderControl: UISegmentedControl!
    @IBOutlet weak var activityControl: UISegmentedControl!
    @IBOutlet weak var totalMaintanenceCals: UILabel!
    @IBOutlet weak var proteinControl: UISegmentedControl!
    @IBOutlet weak var addOrSubtractTextField: UITextField!
    @IBOutlet weak var fatControl: UISegmentedControl!
    @IBOutlet weak var proteinTextField: UILabel!
    @IBOutlet weak var fatTextField: UILabel!
    @IBOutlet weak var carbsTextField: UILabel!
    @IBOutlet weak var totalCaloriesTextField: UILabel!
    
    var maintanence_cals = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func calcMaintanenceCals(_ sender: Any) {
        let lbs = Double(lbsTextField.text!) ?? 0 //takes user input fro weight
        let kg = lbs/2.20462 //converts lbs to kg
        print(kg)
        
        let inch = Double(heightTextField.text!) ?? 0 //takes user input for height
        let cm = inch*2.54 //converts inches to cm
        print(cm)
        
        let age = Double(ageTextField.text!) ?? 0 //takes user input for age
        print(age)
        
        let gender = [1, 2] 
        var bmr = 0.0
        if gender[genderControl.selectedSegmentIndex] == 1 {
            bmr = mifflin_equation_male(kg: kg, cm: cm, age: age)
            print(gender)
            print(bmr)
        } else {
            bmr = mifflin_equation_female(kg: kg, cm: cm, age: age)
            print(gender)
            print(bmr)
        }
        
        let activityC = [1, 2, 3, 4, 5]
        let activity = activityC[activityControl.selectedSegmentIndex]
        print(activity)
        
        maintanence_cals = calc_cals(activity: activity, bmr: Int(bmr))
        print(maintanence_cals)
        
        totalMaintanenceCals.text = String(format: "%.0f", Double(maintanence_cals))

    }
    
    
    @IBAction func calc_macros(_ sender: Any) {
        let plus_minus = Int(addOrSubtractTextField.text!) ?? 0 //takes user input for how many calories they want to cut or bulk
        let total_cals = maintanence_cals+plus_minus
        let lbs = Double(lbsTextField.text!) ?? 0
        
        let protein_vals = [0.8, 0.9, 1.0, 1.1, 1.2]
        let protein = protein_vals[proteinControl.selectedSegmentIndex]
        let total_protein = protein*lbs
        
        let fat_vals = [0.2, 0.22, 0.24, 0.26, 0.28, 0.30]
        let fat = fat_vals[fatControl.selectedSegmentIndex]
        let total_fat = calc_fat(fat: fat, total_cals: total_cals)
        print("fat: ", total_fat)
        
        let carbs = (maintanence_cals) - ((Int(total_protein)*4) + calc_fat_cals(fat: fat, total_cals: total_cals))
        let total_carbs = carbs/4
        print("carbs: ", total_carbs)
        
        proteinTextField.text = String(format: "Protein: %.0f g", total_protein)
        fatTextField.text = String("Fat: \(total_fat) g")
        carbsTextField.text = String("Carbs: \(total_carbs) g")
        totalCaloriesTextField.text = String(total_cals)
        
    }
    
    
}

