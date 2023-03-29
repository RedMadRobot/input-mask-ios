//
// Project «InputMask»
// Created by Jeorge Taflanidi
//


import UIKit
import InputMask


open class ViewController: UIViewController, OnMaskedTextChangedListener {
    
    @IBOutlet weak var phoneListener: PhoneInputListener!
    @IBOutlet weak var dateListener: MaskedTextInputListener!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var textView: UITextView!
    
    weak var countryFlag: UILabel!
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        phoneListener.affinityCalculationStrategy = .prefix
        phoneListener.disableCountries = ["🇳🇱"]
        
        let countryFlagLabel = UILabel(frame: CGRect.zero)
        countryFlagLabel.textColor = UIColor.gray
        countryFlagLabel.font = UIFont.systemFont(ofSize: 12)
        
        let completePhoneLabel = UILabel(frame: CGRect.zero)
        completePhoneLabel.font = UIFont.systemFont(ofSize: 14)
        completePhoneLabel.text = "👍"
        
        let completeDateLabel = UILabel(frame: CGRect.zero)
        completeDateLabel.font = UIFont.systemFont(ofSize: 14)
        completeDateLabel.text = "👍"
        
        countryFlag = countryFlagLabel
        
        phoneField.leftView = countryFlagLabel
        phoneField.rightView = completePhoneLabel
        phoneField.placeholder = phoneListener.placeholder
        
        dateField.placeholder = dateListener.placeholder
        dateField.rightView = completeDateLabel
    }
    
    public func textInput(_ textInput: UITextInput, didExtractValue value: String, didFillMandatoryCharacters complete: Bool) {
        print(value)
        
        if let country = phoneListener.computedCountry {
            phoneField.leftViewMode = .always
            countryFlag.text = "\(country.emoji) \(country.iso3166alpha3)"
        } else {
            phoneField.leftViewMode = .never
        }
        
        textView.text = phoneListener.computedCountries.map { "+\($0.countryCode) \($0.emoji) \($0.name)" }.joined(separator: "\n")
        
        if textInput === phoneField {
            phoneField.rightViewMode = complete ? .always : .never
        }

        if textInput === dateField {
            dateField.rightViewMode = complete ? .always : .never
        }
    }
    
}
