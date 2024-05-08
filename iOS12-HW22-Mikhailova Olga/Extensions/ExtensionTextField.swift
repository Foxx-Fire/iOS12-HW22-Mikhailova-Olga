//
//  ExtensionTextField.swift
//  iOS12-HW22-Mikhailova Olga
//
//  Created by FoxxFire on 06.05.2024.
//

import UIKit

extension UITextField {

    //MARK:- Set Image on the right of text fields

  func setupRightImage(imageName:String){
    let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 25, height: 25))
    imageView.image = UIImage(systemName: imageName)
    let imageContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 55, height: 40))
    imageContainerView.addSubview(imageView)
    rightView = imageContainerView
    rightViewMode = .always
    self.tintColor = .lightGray
}

 //MARK:- Set Image on left of text fields

    func setupLeftImage(imageName:String){
       let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 25, height: 25))
       imageView.image = UIImage(systemName: imageName)
       let imageContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 55, height: 40))
       imageContainerView.addSubview(imageView)
       leftView = imageContainerView
       leftViewMode = .always
       self.tintColor = .lightGray
     }
    
    func underline(borderColor: UIColor) {
           
           self.borderStyle = UITextField.BorderStyle.none
           self.backgroundColor = UIColor.clear
           
           let borderLine = UIView()
           let height = 2.0
           borderLine.frame = CGRect(x: 0, y: Double(self.frame.height) + height, width: Double(self.frame.width), height: height)
           
           borderLine.backgroundColor = borderColor
           self.addSubview(borderLine)
       }
  }

