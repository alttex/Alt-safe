//
//  RechangeViewController.swift
//  Alttex safe
//
//  Created by Vlad Kovryzhenko on 1/17/18.
//  Copyright © 2018 Vlad Kovryzhenko. All rights reserved.
//

import UIKit
import Foundation
import StepIndicator


class WithdrawViewController: UIViewController,UIScrollViewDelegate {
    var screen = UIScreen.main.bounds
      let tableView = UITableView()
    @IBOutlet weak var stepIndicatorView: StepIndicatorView!
    @IBOutlet weak var scrollView:UIScrollView!
    //@IBOutlet weak var timeframeButton: UIBarButtonItem!

    

    
   
    let cardView = AMCreditCardView()
    let cardTextField = UITextField()
    @objc func inputFieldEditingChanged(_ textField: UITextField) {
        if textField.placeholder == "CVV" {
            cardView.cvv = textField.text
        } else {
            cardView.cardNumber = textField.text
        }
    }
    
    
    @IBAction func timeFrameTapped(_ sender: Any) {
    
    }
    
    
 private var isScrollViewInitialized = false
   
    override func viewDidLoad() {
        super.viewDidLoad()
      
       self.tableView.backgroundColor = UIColor.rbg(r: 24, g: 24, b: 24)
        self.tableView.separatorStyle = .none
        cardTextField.backgroundColor = .white
       
        tableView.backgroundView?.backgroundColor = .black
       
        
        
        //self.tableView.addSubview(self.refreshControl)
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !isScrollViewInitialized {
            isScrollViewInitialized = true
            self.initScrollView()
        }
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func handleRefresh(refreshControl: UIRefreshControl) {
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...
        
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    
    private func initScrollView() {
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width * CGFloat(self.stepIndicatorView.numberOfSteps ), height: self.scrollView.frame.height)
        for i in 1...self.stepIndicatorView.numberOfSteps + 1  {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100))
            tableView.frame = CGRect(x: 0, y: 0, width: screen.width, height: scrollView.frame.height)
            cardView.frame  = CGRect(x: screen.maxX, y: 0, width: screen.width, height: scrollView.frame.height-230)
            cardTextField.frame = CGRect(x: screen.maxX, y: 270, width: screen.width, height: 40)
            cardTextField.inputView?.backgroundColor = .white
            if i<=self.stepIndicatorView.numberOfSteps + 1 {
            if self.stepIndicatorView.currentStep == 1{
                self.scrollView.addSubview(tableView)
               
                
            }
           
            
            if i>=self.stepIndicatorView.numberOfSteps + 1 {
               
                     self.scrollView.addSubview(cardView)
                    scrollView.bringSubview(toFront: cardView)
                self.scrollView.addSubview(cardTextField)
                scrollView.bringSubview(toFront: cardTextField)
                
            }
            else{
                label.text = "Operation successful!"
                }
           
            }
//            label.textAlignment = NSTextAlignment.center
//            label.font = UIFont.systemFont(ofSize: 25)
//            label.textColor = UIColor.lightGray
//            label.center = CGPoint(x: self.scrollView.frame.width / 2.0 * (CGFloat(i - 1) * 2.0 + 1.0), y: self.scrollView.frame.height / 2.0)
//            self.scrollView.addSubview(label)
            
        }
    }
    
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageIndex = scrollView.contentOffset.x / scrollView.frame.size.width
        stepIndicatorView.currentStep = Int(pageIndex)
    }
}

//extension WithdrawViewController: UITextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.text = ""
//        if textField.placeholder == "CVV" {
//            textField.resignFirstResponder()
//        }
//        textField.placeholder = textField.placeholder == "CVV" ? "Card Number" : "CVV"
//        cardView.flip()
//        return true
//    }
//}

