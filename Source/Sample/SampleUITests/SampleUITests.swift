//
// Project «InputMask»
// Created by Jeorge Taflanidi
//


import XCTest


final class SampleUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUp() {
        app.launch()
    }
    
    func testFillFields_noPunctuation_putsPunctuation() {
        let dateField = app.textFields["00.00.0000"]
        let phoneField = app.textFields["+380 (00) 000-00-00"]
        
        dateField.tap()
        dateField.typeText("23022022")
        XCTAssertEqual(dateField.value as! String, "23.02.2022")
        
        phoneField.tap()
        phoneField.typeText("38981234567")
        XCTAssertEqual(phoneField.value as! String, "+380 (98) 123-45-67")
    }
}
