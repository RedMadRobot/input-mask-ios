# Changelog

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
