//
//  ViewController.swift
//  Example
//
//  Created by Egor Taflanidi on 17.08.28.
//  Copyright © 28 Heisei Egor Taflanidi. All rights reserved.
//

import UIKit
import InputMask


open class ViewController: UIViewController, MaskedTextFieldDelegateListener {
    
    @IBOutlet weak var listener: MaskedTextFieldDelegate!
    @IBOutlet weak var field: UITextField!
    
    open override func viewDidLoad() {
        listener.put(text: "+7123", into: field)
    }
    
    open func textField(_ textField: UITextField, didExtractValue value: String) {
        print(value)
    }
    
}

