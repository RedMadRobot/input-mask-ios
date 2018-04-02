//
// Project «InputMask»
// Created by Jeorge Taflanidi
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
    
    open func textField(
        _ textField: UITextField,
        didFillMandatoryCharacters complete: Bool,
        didExtractValue value: String
    ) {
        print(value)
    }
    
}
