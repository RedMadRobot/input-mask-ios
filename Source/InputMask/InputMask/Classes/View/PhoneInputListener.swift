//
// Project «InputMask»
// Created by Jeorge Taflanidi
//


import Foundation


open class PhoneInputListener: MaskedTextInputListener {
    open private(set) var computedCountry: Country?
    open private(set) var computedCountries: [Country] = []
    
    open var enableCountries: [String]?
    open var disableCountries: [String]?
    
    open var customCountries: [Country]?
    
    open override func pickMask(forText text: CaretString) -> Mask {
        computedCountries = Country.findCountries(amongCountries: customCountries, withTerms: enableCountries, excluding: disableCountries, phone: text.string)
        computedCountry = computedCountries.count == 1 ? computedCountries.first : nil
        
        guard
            let country = computedCountry
        else {
            return try! Mask(format: "+[000] [000] [000] [00] [00]")
        }

        primaryMaskFormat = country.primaryFormat
        affineFormats = country.affineFormats
        
        return super.pickMask(forText: text)
    }
}
