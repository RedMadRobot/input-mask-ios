# 𝌡Changelog

## 7.3.2

**⤵️ Added:**

* Full **macOS** support: a brand new `TextViewListener` class for `NSTextView` instances 

## 7.2.8

**⤵️ Added:**

* `MaskedTextInputListener` now provides call forwarding to its corresponding `textFieldDelegate` and `textViewDelegate`

## 7.2.6

**🔄 Modified:**

* `Country::findCountries` → fix bloomer

## 7.2.1

**🔄 Modified:**
* `NumberInputListener` was made available to iOS 15.6

## 7.2.0

**🔄 Modified:**
* `MaskedTextInputListener.replaceCharacters()`: apply a patch to counter iOS Undo Manager, see https://github.com/RedMadRobot/input-mask-ios/issues/84

## 7.1.1

**🔄 Modified:**
* `UITextInput.caretPosition.setter` now updates caret position only if it changed 

## 7.1.0

**⤵️ Added:**

* `NumberInputListener`: a `MaskedTextInputListener` allowing to enter currencies and other numbers
* `"".numberOfOccurrencesOf(string)`: a helper method to count occurencies of substrings

**🔄 Modified:**

* `CharacterSet.isMember(character:)` made `public`
* `MaskedTextInputListener`: `UITextFieldDelegate` and `UITextViewDelegate` extensions made `open`
* `MaskedTextInputListener.atomicCaretMovement` is now applied everywhere

## 7.0.1

**🔄 Modified:**

* `spec.platform` → `ios, 15.6`

## 7.0.0

**⤵️ Added:**

* New logo :D 
* New README :D 
* A basic UI test in the **Sample** project for the date/phone fields
* `"".extractDigits()`: a helper method to extract digits from a `String`
* `"".boxSizeWithFont(font)`: a helper method to calculate a rectangle size for a `String`
* Text listener callbacks now return a `tailPlaceholder` for the value to be completed
* `Country`: a model object representing a country with phone formatting, ISO codes & emojis
* `Country.all`: a dictionary of known countries
* `MaskedTextField`: a SwiftUI `TextField` with an attached mask
* A SwiftUI sample project
* `PhoneInputListener`: a `MaskedTextInputListener` allowing to enter a phone number of any known country

**⤴️ Removed:**

* `UITextField.cursorPosition`: please use a `UITextInput.caretPosition` property instead
* `UITextView.cursorPosition`: please use a `UITextInput.caretPosition` property instead

**🔄 Modified:**

* `swift-tools-version` → `5.7.1`
* Pod platform → `16.1`

## 6.1.0

**⤵️ Added:**

* iOS text suggestions support (see [`UITextContentType`](https://developer.apple.com/documentation/uikit/uitextcontenttype))

## 6.0.0

**⤴️ Removed:**

* `Mask::apply()`, the `autocomplete` flag (this flag is now a part of the `CaretGravity.forward` enum case)

**⤵️ Added:**

* `CaretGravity.forward`, the `autocomplete` flag
* `CaretGravity.backward`, the [`autoskip`](https://github.com/RedMadRobot/input-mask-ios/wiki/0.-Mask#autoskip-flag) flag

## 5.0.0

**⤴️ Removed:**

* `CaretStringIterator::beforeCaret()` (this method is now replaced with `::insertionAffectsCaret()` and `::deletionAffectsCaret()` calls)

* `::deleteText()` and `::modifyText()` in `MaskedTextFieldDelegate`, `MaskedTextInputListener` and `MaskedTextViewDelegate` (these methods had been refactored and merged)

Please, consider overriding corresponding  
`textField(:shouldChangeCharactersIn:replacementString:)`  
`textInput(:isChangingCharactersIn:replacementString:)` or  
`textView(:shouldChangeTextIn:replacementText:)`  
instead.

**⤵️ Added:**

* `CaretString` instances now contain caret gravity.

Caret gravity affects caret movement when `Mask` adds characters precisely at the caret position during formatting. It is important to retain caret position after text deletion/backspacing.

Default `CaretGravity` is `.forward`. Set caret gravity to `.backward` only when user hits backspace.

* `CaretStringIterator::insertionAffectsCaret()` and `CaretStringIterator::deletionAffectsCaret()`

These methods allow to incorporate new caret gravity setting. `RTLCaretStringIterator` had also been rewritten to reflect these changes.

**🔄 Modified:**

* [Atomic cursor movement](https://github.com/RedMadRobot/input-mask-ios/wiki/2.-Text-Field-Listener#atomic-cursor-movement-an-ugly-workaround-property) is now turned off by default.

## 4.3.0

**⤵️ Added:**

* `AffinityCalculationStrategy.extractedValueCapacity` option allowing to have radically different mask format depending on the extracted value length

## 4.2.0

**⤵️ Added:**

* `AffinityCalculationStrategy.capacity` option allowing to have radically different mask format depending on the input length

## 4.1.0

**⤵️ Added:**

* `Mask.isValid(format:customNotations:)` method for format checks
* `MaskedTextFieldDelegate.atomicCursorMovement` and `MaskedTextInputListener.atomicCaretMovement` properties in order to address issue [#32](https://github.com/RedMadRobot/input-mask-ios/issues/32)

**↩️ Fixed:**

* Optional blocks of symbols are now ignored when extracted value completeness is calculated
* `textFieldDidEndEditing` delegate method not called
	* by [Mikhail Zhadko](https://github.com/while366) in [PR#65](https://github.com/RedMadRobot/input-mask-ios/pull/65)
