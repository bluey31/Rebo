//
//  BWDialog.swift
//  Survival of Rebo
//
//  Created by Brendon Warwick on 24/03/2017.
//  Copyright © 2017 Brendon Warwick. All rights reserved.
//

// import UIKit

/**
 *
 * BWDialog presents a dialog to the user with given information, a title, message and a dimiss message.
 *
 */

//class BWDialog: UIView {
//    
//    // MARK: Attributes
//    
//    var title: String
//    var message: String
//    var dismissMessage: String
//    
//    // Initialize the dialog with a title, message, dismiss message and a view to place the view in
//    init(in frame: CGRect, title: String, message: String, dismissMessage: String){
//        self.title = title
//        self.message = message
//        self.dismissMessage = dismissMessage
//        // The view will be placed in the center of the parent view
//        super.init(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
//        self.backgroundColor = .white
//        self.layer.cornerRadius = 12
//        self.tag = 1
//        addText(title: title, message: message, dismissMessage: dismissMessage)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        self.title = ""
//        self.message = ""
//        self.dismissMessage = ""
//        super.init(coder: aDecoder)
//    }
//    
//    func addText(title: String, message: String, dismissMessage: String){
//        let dialogTitle = UILabel(frame: CGRect(x: 16, y: 32, width: self.frame.width-32, height: 20))
//        dialogTitle.font = UIFont(name: "Chalkduster", size: 24.0)
//        dialogTitle.textColor = .black
//        dialogTitle.textAlignment = .center
//        
//        dialogTitle.text = title
//        self.addSubview(dialogTitle)
//        
//        let descriptionText = UILabel(frame: CGRect(x: 16, y: 64, width: self.frame.width-32, height: self.frame.height-64))
//        descriptionText.font = UIFont(name: "Chalkduster", size: 14.0)
//        descriptionText.textColor = .black
//        descriptionText.textAlignment = .center
//        descriptionText.numberOfLines = 0
//        descriptionText.text = "\(message)\n\n\n\(dismissMessage)"
//        self.addSubview(descriptionText)
//    }
//}

