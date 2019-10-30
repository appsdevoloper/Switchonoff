//
//  HomeViewController.swift
//  Demo
//
//  Created by Apple on 29/07/19.
//  Copyright © 2019 demo. All rights reserved.
//

import UIKit
import NextGrowingTextView

class KeyboardViewController: UIViewController, UITextViewDelegate {
   
  @IBOutlet weak var inputContainerView: UIView!
  @IBOutlet weak var inputContainerViewBottom: NSLayoutConstraint!
  @IBOutlet weak var growingTextView: NextGrowingTextView!
  @IBOutlet weak var cornerView: UIView!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var dayView: UIView!
  @IBOutlet weak var mainviewHeight: NSLayoutConstraint!
  @IBOutlet weak var topConstraints: NSLayoutConstraint!
  @IBOutlet weak var bottomConstraints: NSLayoutConstraint!
  @IBOutlet weak var dayViewHeight: NSLayoutConstraint!
    
  override func viewDidLoad() {
    super.viewDidLoad()
    
    NotificationCenter.default.addObserver(self, selector: #selector(KeyboardViewController.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(KeyboardViewController.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)

    self.growingTextView.layer.cornerRadius = 4
    self.growingTextView.backgroundColor = UIColor.clear
    self.growingTextView.placeholderAttributedText = NSAttributedString(
      string: "Placeholder text",
      attributes: [
        .font: self.growingTextView.textView.font!,
        .foregroundColor: UIColor.gray
      ]
    )
    
    // MARK: TapGesture For Self View
    //let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
    //self.view.addGestureRecognizer(tap)
    
    let slideDown = UISwipeGestureRecognizer(target: self, action: #selector(dismissView(gesture:)))
    slideDown.direction = .down
    view.addGestureRecognizer(slideDown)
    
    // MARK: View Background
    self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
    
    //MARK:- Corner Radius of only two side of UIViews
    //self.cornerView.roundCorners([.topLeft, .topRight], radius: 12)
    
    self.cornerView.clipsToBounds = true
    self.cornerView.layer.cornerRadius = 12
    if #available(iOS 11.0, *) {
      self.cornerView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    } else {
      // Fallback on earlier versions
    }
    
    self.scrollView.delegate = self
  }
    
  @IBAction func offClick(_ sender: Any) {
    self.dayView.isHidden = true
    self.topConstraints.constant = 7.5
    self.bottomConstraints.constant = 7.5
    self.dayViewHeight.constant = 0
    self.mainviewHeight.constant = 227
  }
    
  @IBAction func onClick(_ sender: Any) {
    self.dayView.isHidden = false
    self.topConstraints.constant = 15
    self.bottomConstraints.constant = 15
    self.dayViewHeight.constant = 28
    self.mainviewHeight.constant = 270
  }
  
  @objc func dismissView(gesture: UISwipeGestureRecognizer) {
    UIView.animate(withDuration: 0.4) {
      self.view.endEditing(true)
      self.dismiss(animated: true, completion: nil)
    }
  }
  
  override func viewWillLayoutSubviews() {
    self.navigationController?.isNavigationBarHidden = true
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.growingTextView.becomeFirstResponder()
    self.scrollView.isScrollEnabled = false
  }
  
  @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
    self.growingTextView.resignFirstResponder()
    self.dismiss(animated: true, completion: nil)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  @objc func keyboardWillHide(_ sender: Notification) {
    if let userInfo = (sender as NSNotification).userInfo {
      if let _ = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height {
        self.inputContainerViewBottom.constant =  0
        UIView.animate(withDuration: 0.25, animations: { () -> Void in self.view.layoutIfNeeded() })
      }
    }
  }
  
  @objc func keyboardWillShow(_ sender: Notification) {
    if let userInfo = (sender as NSNotification).userInfo {
      if let keyboardHeight = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height {
        self.inputContainerViewBottom.constant = keyboardHeight
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
          self.view.layoutIfNeeded()
        })
      }
    }
  }
}

extension UIView {
  func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
    let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
    let mask = CAShapeLayer()
    mask.path = path.cgPath
    self.layer.mask = mask
  }
}

