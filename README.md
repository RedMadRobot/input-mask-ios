# InputMask

![Preview](https://raw.githubusercontent.com/RedMadRobot/input-mask-ios/assets/Assets/phone_input_cropped.gif "Preview")

## Description
The library allows to format user input on the fly according to the provided mask and to extract valueable characters.  

Masks consist of blocks of symbols, which may include:

* `[]` — a block for valueable symbols written by user. 

Square brackets block may contain any number of special symbols:

1. `0` — mandatory digit. For instance, `[000]` mask will allow user to enter three numbers: `123`.
2. `9` — optional digit . For instance, `[00099]` mask will allow user to enter from three to five numbers.
3. `А` — mandatory letter. `[AAA]` mask will allow user to enter three letters: `abc`.
4. `а` — optional letter. `[АААааа]` mask will allow to enter from three to six letters.
5. `_` — mandatory symbol (digit or letter).
6. `-` — optional symbol (digit or letter).

Blocks cannot contain mixed types of symbols; such that, `[000AA]` will cause a mask initialization error.
Instead, the block should be divided: `[000][AA]`.

Symbols outside the square brackets will take a place in the output.
For instance, `+7 ([000]) [000]-[0000]` mask will format the input field to the form of `+7 (123) 456-7890`. 

* `{}` — a block for valueable yet fixed symbols, which could not be altered by the user.

Symbols within the square and curly brackets form an extracted value (valueable characters).
In other words, `[00]-[00]` and `[00]{-}[00]` will format the input to the same form of `12-34`, 
but in the first case the value, extracted by the library, will be equal to `1234`, and in the second case it will result in `12-34`. 

Mask format examples:

1. [00000000000]
2. {401}-[000]-[00]-[00]
3. [000999999]
4. {818}-[000]-[00]-[00]
5. [009999]
6. [A-----------------------------------------------------]
7. [000000000099999]
8. [A_______________________________________________________________]
9. [A__________________________________________________________________] 
10. 8 [0000000000] 
11. [A_____________________________________________________] 
12. [000000000999]
13. 8([000])[000]-[00]-[00]
14. [0000]{-}[00]
15. +1 ([000]) [000] [00] [00]

# Installation
## CocoaPods

`pod 'InputMask'`

# Usage
## Simple UITextField for the phone numbers

Listening to the text change events of `UITextField` and simultaneously altering the entered text could be a bit tricky as
long as you need to add, remove and replace symbols intelligently preserving the cursor position.

Thus, the library provides corresponding `MaskedTextFieldDelegate` class.

`MaskedTextFieldDelegate` conforms to `UITextFieldDelegate` protocol and encaspulates logic to process text edit events.
The object might be instantiated via code or might be dropped on the Interface Builder canvas as an NSObject and then 
wired with the corresponding `UITextField`.

`MaskedTextFieldDelegate` has his own listener `MaskedTextFieldDelegateListener`, which extends `UITextFieldDelegate` protocol
with a `textField(textField: UITextField, didExtractValue value: String)` method. All the `UITextFieldDelegate` calls from
the client `UITextField` are forwarded to the `MaskedTextFieldDelegateListener` object, yet it doesn't allow to override
`textField(textField:shouldChangeCharactersIn:replacementString:)` result, always returning `false`.

![Interface Builder](https://raw.githubusercontent.com/RedMadRobot/input-mask-ios/assets/Assets/shot.png "Interface Builder")

```
class ViewController: UIViewController, MaskedTextFieldDelegateListener {
    
    var maskedDelegate: MaskedTextFieldDelegate!

    @IBOutlet weak var field: UITextField!
    
    open override func viewDidLoad() {
        maskedDelegate = MaskedTextFieldDelegate(format: "{+7} ([000]) [000] [00] [00]")
        maskedDelegate.listener = self

        field.delegate = maskedDelegate

        maskedDelegate.put(text: "+7 123", into: field)
    }
    
    open func textField(_ textField: UITextField, didExtractValue value: String) {
        print(value)
    }
    
}
```

Sample project might be found under `Source/Example`

# License

The library is distributed under the MIT [LICENSE](https://opensource.org/licenses/MIT).
