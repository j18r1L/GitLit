//
//  ViewController.swift
//  GitLit
//
//  Created by Марк on 11.10.17.
//  Copyright © 2017 GitLit. All rights reserved.
//


import UIKit

class ViewController: UIViewController, MenuViewControllerDelegate {
    
    
    var blackMaskView = UIView(frame: CGRect.zero)
    
    //View Controller
    let menuViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
    
    //Constraint (Used animate menu in/out)
    var menuLeftConstraint: NSLayoutConstraint?
    
    var isShowingMenu = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Add menu view controller
        addChildViewController(menuViewController)
        menuViewController.delegate = self
        menuViewController.didMove(toParentViewController: self)
        menuViewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(menuViewController.view)
        
        let topConstraint = NSLayoutConstraint(item: menuViewController.view, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
        
        let bottomConstraint = NSLayoutConstraint(item: menuViewController.view, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        
        let widthConstraint = NSLayoutConstraint(item: menuViewController.view, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 250)
        
        menuLeftConstraint = NSLayoutConstraint(item: menuViewController.view, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.left, multiplier: 1, constant: -widthConstraint.constant)
        
        view.addConstraints([topConstraint, menuLeftConstraint!, bottomConstraint, widthConstraint])
        
        toogleMenu()
        
    }
    
    func toogleMenu() {
        isShowingMenu = !isShowingMenu
        
        if(isShowingMenu) {
            //Hide Menu
            //setStatusBarHidden(_ hidden: Bool, with animation: UIStatusBarAnimation)
            //UIApplication.shared.setStatusBarHidden(false, with: UIStatusBarAnimation.slide)
            //UIApplication.shared.setStatusBarHidden(false, with: UIStatusBarAnimation.slide)
            
            menuLeftConstraint?.constant = -menuViewController.view.bounds.size.width
            
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.5, options: UIViewAnimationOptions(), animations: { () -> Void in
                self.view.layoutIfNeeded()
            }, completion: { (completed) -> Void in
                self.menuViewController.view.isHidden = true
            })
            
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions(), animations: { () -> Void in
                self.view.layoutIfNeeded()
                self.blackMaskView.alpha = 0.0
            }, completion: { (completed) -> Void in
                self.blackMaskView.removeFromSuperview()
            })
            
        } else {
            //Present Menu
            
            //UIApplication.shared.setStatusBarHidden(true, with: UIStatusBarAnimation.slide)
            
            blackMaskView = UIView(frame: CGRect.zero)
            blackMaskView.alpha = 0.0
            blackMaskView.translatesAutoresizingMaskIntoConstraints = false
            blackMaskView.backgroundColor = UIColor.black
            view.insertSubview(blackMaskView, belowSubview: menuViewController.view)
            
            let topConstraint = NSLayoutConstraint(item: blackMaskView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
            
            let bottomConstraint = NSLayoutConstraint(item: blackMaskView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
            
            let leftConstraint = NSLayoutConstraint(item: blackMaskView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
            
            let rightConstraint = NSLayoutConstraint(item: blackMaskView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
            
            view.addConstraints([topConstraint, bottomConstraint, leftConstraint, rightConstraint])
            view.layoutIfNeeded()
            
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions(), animations: { () -> Void in
                self.view.layoutIfNeeded()
                self.blackMaskView.alpha = 0.5
            }, completion: { (completed) -> Void in
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapGestureRecognized))
                self.blackMaskView.addGestureRecognizer(tapGesture)
            })
            
            menuViewController.view.isHidden = false
            menuLeftConstraint?.constant = 0
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.5, options: UIViewAnimationOptions(), animations: { () -> Void in
                self.view.layoutIfNeeded()
            }, completion: { (completed) -> Void in
                
            })
        }
    }
    
    func tapGestureRecognized() {
        toogleMenu()
    }
    
    @IBAction func menuButtonDidTouch(_ sender: AnyObject) {
        toogleMenu()
    }
    
    
    func menuCloseButtonTapped() {
        toogleMenu()
    }
    
}

