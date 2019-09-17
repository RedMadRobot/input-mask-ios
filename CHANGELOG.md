# Changelog

### `5.0.0`

#### Removed:

* `CaretStringIterator::beforeCaret()`

This method is now replaced with `::insertionAffectsCaret()` and `::deletionAffectsCaret()` calls. 

* `::deleteText()` and `::modifyText()` in `MaskedTextFieldDelegate`, `MaskedTextInputListener` and `MaskedTextViewDelegate`

These methods had been refactored and merged.

Please, consider overriding corresponding  
`textField(:shouldChangeCharactersIn:replacementString:)`  
`textInput(:isChangingCharactersIn:replacementString:)` or  
`textView(:shouldChangeTextIn:replacementText:)`  
instead.

#### Added:

* `CaretString` instances now contain caret gravity.

Caret gravity affects caret movement when `Mask` adds characters precisely at the caret position during formatting. It is important to retain caret position after text deletion/backspacing.

Default `CaretGravity` is `.forward`. Set caret gravity to `.backward` only when user hits backspace.

* `CaretStringIterator::insertionAffectsCaret()` and `CaretStringIterator::deletionAffectsCaret()`

These methods allow to incorporate new caret gravity setting. `RTLCaretStringIterator` had also been rewritten to reflect these changes.

### `4.3.0`

#### Added:

* `AffinityCalculationStrategy.extractedValueCapacity` option allowing to have radically different mask format depending on the extracted value length

### `4.2.0`

#### Added:

* `AffinityCalculationStrategy.capacity` option allowing to have radically different mask format depending on the input length

### `4.1.0`

#### Added:

* `Mask.isValid(format:customNotations:)` method for format checks
* `MaskedTextFieldDelegate.atomicCursorMovement` and `MaskedTextInputListener.atomicCaretMovement` properties in order to address issue [#32](https://github.com/RedMadRobot/input-mask-ios/issues/32)

#### Fixed:

* Optional blocks of symbols are now ignored when extracted value completeness is calculated
* `textFieldDidEndEditing` delegate method not called
	* by [Mikhail Zhadko](https://github.com/while366) in [PR#65](https://github.com/RedMadRobot/input-mask-ios/pull/65)
