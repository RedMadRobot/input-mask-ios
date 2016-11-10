//
//  ViewController.swift
//  Sample
//
//  Created by Egor Taflanidi on 17.08.28.
//  Copyright © 28 Heisei Egor Taflanidi. All rights reserved.
//

import UIKit
import InputMask


open class ViewController: UIViewController, MaskedTextFieldDelegateListener {
    
    @IBOutlet weak var listener: PolyMaskTextFieldDelegate!
    @IBOutlet weak var field: UITextField!
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        listener.affineFormats = [
            "8 ([000]) [000] [00] [00]"
        ]
    }
    
    open func textField(_ textField: UITextField, didExtractValue value: String) {
        print(value)
    }
    
    public func textField(_ textField: UITextField, didFillMandatoryCharacters complete: Bool) {
        print(complete)
    }
    
}

