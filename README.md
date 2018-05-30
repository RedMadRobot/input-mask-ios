<img src="https://raw.githubusercontent.com/RedMadRobot/input-mask-ios/assets/Assets/input-mask-cursor.gif" alt="Input Mask" height="40" />

[![Awesome](https://cdn.rawgit.com/sindresorhus/awesome/d7305f38d29fed78fa85652e3a63e154dd8e8829/media/badge.svg)](https://github.com/sindresorhus/awesome)
[![Version Badge](https://img.shields.io/cocoapods/v/InputMask.svg)](https://cocoapods.org/pods/InputMask)
[![SPM compatible](https://img.shields.io/badge/SPM-compatible-4BC51D.svg?style=flat)](https://swift.org/package-manager)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![license](https://img.shields.io/github/license/mashape/apistatus.svg)](#license)
[![Build Status](https://travis-ci.org/RedMadRobot/input-mask-ios.svg?branch=master)](https://travis-ci.org/RedMadRobot/input-mask-ios)
[![codebeat badge](https://codebeat.co/badges/d753a2f1-173d-4c13-a97a-1680164e7bcf)](https://codebeat.co/projects/github-com-redmadrobot-input-mask-ios-master)

[![Platform](https://cdn.rawgit.com/RedMadRobot/input-mask-ios/assets/Assets/shields/platform.svg)]()[![Android](https://cdn.rawgit.com/RedMadRobot/input-mask-ios/assets/Assets/shields/android.svg)](https://github.com/RedMadRobot/input-mask-android)[![iOS](https://cdn.rawgit.com/RedMadRobot/input-mask-ios/assets/Assets/shields/ios_rect.svg)](https://github.com/RedMadRobot/input-mask-ios)[![macOS](https://cdn.rawgit.com/RedMadRobot/input-mask-ios/assets/Assets/shields/macos.svg)](https://github.com/RedMadRobot/input-mask-ios)

<img src="https://raw.githubusercontent.com/RedMadRobot/input-mask-ios/assets/Assets/phone_input.gif" alt="Input Mask" width="640" />

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
7. `…` — ellipsis. Allows to enter endless count of symbols. For details and rules see [Elliptical masks](#elliptical).

Other symbols inside square brackets will cause a mask initialization error, unless you have used [custom notations](#custom_notation).

Blocks may contain mixed types of symbols; such that, `[000AA]` will end up being divided in two groups: `[000][AA]` (this happens automatically). Though, it's highly recommended not to mix default symbols with symbols from [custom notations](#custom_notation). 

Blocks must not contain nested brackets. `[[00]000]` format will cause a mask initialization error.

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
5. [A][-----------------------------------------------------]
6. [A][_______________________________________________________________]
7. 8 [0000000000] 
8. 8([000])[000]-[00]-[00]
9. [0000]{-}[00]
10. +1 ([000]) [000] [00] [00]

### Character escaping

Mask format supports backslash escapes when you need square or curly brackets in the output.

For instance, `\[[00]\]` mask will allow user to enter `[12]`. Extracted value will be equal to `12`.

Note that you've got to escape backslashes in the actual code:

```swift
let format: String = "\\[[00]\\]"
```

Escaped square or curly brackets might be included in the extracted value. For instance, `\[[00]{\]}` mask will allow user 
to enter the same `[12]`, yet the extracted value will contain the latter square bracket: `12]`.

# Installation
## CocoaPods

```ruby
pod 'InputMask'
```

## Carthage

```ruby
git "https://github.com/RedMadRobot/input-mask-ios.git"
```

## Swift Package Manager

```swift
dependencies: [
    .Package(url: "https://github.com/RedMadRobot/input-mask-ios", majorVersion: 3)
]
```

# Usage
## Simple UITextField for the phone numbers

Listening to the text change events of `UITextField` and simultaneously altering the entered text could be a bit tricky as
long as you need to add, remove and replace symbols intelligently preserving the cursor position.

Thus, the library provides corresponding `MaskedTextFieldDelegate` class.

`MaskedTextFieldDelegate` conforms to `UITextFieldDelegate` protocol and encaspulates logic to process text edit events.
The object might be instantiated via code or might be dropped on the Interface Builder canvas as an NSObject and then 
wired with the corresponding `UITextField`.

`MaskedTextFieldDelegate` has his own listener `MaskedTextFieldDelegateListener`, which extends `UITextFieldDelegate` protocol
with a callback providing actual extracted value. All the `UITextFieldDelegate` calls from
the client `UITextField` are forwarded to the `MaskedTextFieldDelegateListener` object, yet it doesn't allow to override
`textField(textField:shouldChangeCharactersIn:replacementString:)` result, always returning `false`.

![Interface Builder](https://raw.githubusercontent.com/RedMadRobot/input-mask-ios/assets/Assets/shot.png "Interface Builder")

```swift
class ViewController: UIViewController, MaskedTextFieldDelegateListener {
    
    var maskedDelegate: MaskedTextFieldDelegate!

    @IBOutlet weak var field: UITextField!
    
    open override func viewDidLoad() {
        maskedDelegate = MaskedTextFieldDelegate(format: "{+7} ([000]) [000] [00] [00]")
        maskedDelegate.listener = self

        field.delegate = maskedDelegate

        maskedDelegate.put(text: "+7 123", into: field)
    }
    
    open func textField(
        _ textField: UITextField, 
        didFillMandatoryCharacters complete: Bool,
        didExtractValue value: String
    ) {
        print(value)
    }
    
}
```

Sample project might be found under `Source/Sample`

## String formatting without views

In case you want to format a `String` somewhere in your applicaiton's code, `Mask` is the class you are looking for.
Instantiate a `Mask` instance and feed it with your string, mocking the cursor position:

```swift
let mask: Mask = try! Mask(format: "+7 ([000]) [000] [00] [00]")
let input: String = "+71234567890"
let result: Mask.Result = mask.apply(
    toText: CaretString(
        string: input,
        caretPosition: input.endIndex
    ),
    autocomplete: true // you may consider disabling autocompletion for your case
)
let output: String = result.formattedText.string
```

## Affine masks

An experimental feature. While transforming the text, `Mask` calculates `affinity` index, which is basically an `Int` that shows the absolute rate of similarity between the text and the mask pattern.

This index might be used to choose the most suitable pattern between predefined, and then applied to format the text.

For the implementation, look for the `PolyMaskTextFieldDelegate` class, which inherits logic from `MaskedTextFieldDelegate`. It has its primary mask pattern and corresponding list of affine formats.

``` swift
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
        print(complete)
        print(value)
    }
        
}
```

<a name="elliptical" />

## Elliptical masks

An experimental feature. Allows to enter endless line of symbols of specific type. Ellipsis "inherits" its symbol type from the 
previous character in format string. Masks like `[A…]` or `[a…]` will allow to enter letters, `[0…]` or `[9…]` — numbers, etc.

Be aware that ellipsis doesn't count as a required character. Also, ellipsis works as a string terminator, such that mask `[0…][AAA]`
filled with a single digit `5` returns `true` in `Result.complete`, yet continues to accept **digits** (not letters!). Format after ellipsis is compiled into the mask but 
never actually used; characters `[AAA]` in the `[0…][AAA]` mask are pretty much useless.

Elliptical format examples: 

1. `[…]` is a wildcard mask, allowing to enter letters and digits. Always returns `true` in `Result.complete`.
2. `[00…]` is a numeric mask, allowing to enter digits. Requires at least two digits to be `complete`.
3. `[9…]` is a numeric mask, allowing to enter digits. Always returns `true` in `Result.complete`.
4. `[_…]` is a wildcard mask with a single mandatory character. Allows to enter letters and digits. Requires a single character (digit or letter).
5. `[-…]` acts same as `[…]`.

Elliptical masks support custom notations, too.

<a name="custom_notation" />

## Custom notations

An advanced experimental feature. Use with caution.

Internal `Mask` compiler supports a series of symbols which represent letters and numbers in user input. Each symbol stands for its own character set; for instance, `0` and `9` stand for numeric character set. This means user can type any digit instead of `0` or `9`, or any letter instead of `A` or `a`. 

The difference between `0` and `9` is that `0` stands for a **mandatory** digit, while `9` stands for **optional**. This means with the mask like `[099][A]` user may enter `1b`, `12c` or `123d`, while with the mask `[000][A]` user won't be able to enter the last letter unless he has entered three digits: `1` or `12` or `123` or `123e`.

Summarizing, each symbol supported by the compiler has its own **character set** associated with it, and also has an option to be **mandatory** or not.

This said, you may configure your own symbols in addition to the default ones through the `Notation` objects:

```swift
Mask(
    format: "[999][.][99]",
    customNotations: [
        Notation(
            character: ".", 
            characterSet: CharacterSet(charactersIn: ".,"), 
            isOptional: true
        ),
    ]
)
```

or 

```swift
Mask.getOrCreate(
    withFormat: "[999][.][99]",
    customNotations: [
        Notation(
            character: ".", 
            characterSet: CharacterSet(charactersIn: ".,"), 
            isOptional: true
        ),
    ]
)
```

For your convenience, `MaskedTextFieldDelegate` and its children now contains a `customNotations` field. You may still use the Interface Builder with custom formats, just don't forget to programmatically assign your custom notations:

```swift
class ViewController: UIViewController {
    @IBOutlet weak var listener: PolyMaskTextFieldDelegate!
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        listener.customNotations = [
            Notation(
                character: ".", 
                characterSet: CharacterSet(charactersIn: ".,"), 
                isOptional: true
            ),
        ]
    }
}
```

Please note, that you won't have autocompletion for any of your custom symbols. For more examples, see below.

### A floating point number with two decimal places

Mask: `[999999999][.][99]`

<details>
<summary>Custom notations:</summary>

```swift
Notation(character: ".", characterSet: CharacterSet(charactersIn: "."), isOptional: true)
```
</details>

<details>
<summary>Results</summary>

```
1
123
1234.
1234.5
1234.56
```

</details>

### An email (please use regular expressions instead)

With optional and mantatory "**d**ots" and "at" symbol.

Mask: `[aaaaaaaaaa][d][aaaaaaaaaa][@][aaaaaaaaaa][d][aaaaaaaaaa][D][aaaaaaaaaa]`

<details>
<summary>Custom notations:</summary>


```swift
Notation(
    character: "D",
    characterSet: CharacterSet(charactersIn: "."),
    isOptional: false
),
Notation(
    character: "d",
    characterSet: CharacterSet(charactersIn: "."),
    isOptional: true
),
Notation(
    character: "@",
    characterSet: CharacterSet(charactersIn: "@"),
    isOptional: false
)
```

</details>

<details>
<summary>Results</summary>

```
d
derh
derh.
derh.a
derh.asd
derh.asd@
derh.asd@h
derh.asd@hello.
derh.asd@hello.c
derh.asd@hello.com.
derh.asd@hello.com.u
derh.asd@hello.com.uk
```

</details>

### An optional currency symbol

Mask: `[s][9999]`

<details>
<summary>Custom notations:</summary>

```swift
Notation(character: "s", characterSet: CharacterSet(charactersIn: "$€"), isOptional: true)
```
</details>

<details>
<summary>Results</summary>

```
12
$12
918
€918
1000
$1000
```

</details>

# Known issues

## `UITextFieldTextDidChange` notification and target-action `editingChanged` event

`UITextField` with assigned `MaskedTextFieldDelegate` or `PolyMaskTextFieldDelegate` object won't issue `UITextFieldTextDidChange` notifications and `editingChanged` control events. This happens due to the `textField(_:shouldChangeCharactersIn:replacementString:)` method implementation, which always returns `false`.

Consider using following workaround in case if you do really need to catch editing events:

```swift
class NotifyingMaskedTextFieldDelegate: MaskedTextFieldDelegate {
    weak var editingListener: NotifyingMaskedTextFieldDelegateListener?
    
    override func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        defer {
            self.editingListener?.onEditingChanged(inTextField: textField)
        }
        return super.textField(textField, shouldChangeCharactersIn: range, replacementString: string)
    }
}


protocol NotifyingMaskedTextFieldDelegateListener: class {
    func onEditingChanged(inTextField: UITextField)
}
```

Please, avoid at all costs sending SDK events and notifications manually.

## Carthage vs. IBDesignables, IBInspectables, views and their outlets

Interface Builder struggles to support modules imported in a form of a dynamic framework. For instance, custom views annotated as IBDesignable, containing IBInspectable and IBOutlet fields aren't recognized properly from the drag'n'dropped \*.framework.

In case you are using our library as a Carthage-built dynamic framework, be aware you won't be able to easily wire your `MaskedTextFieldDelegate` objects and their listeners from storyboards in your project. There is a couple of workarounds described in [the corresponding discussion](https://github.com/Carthage/Carthage/issues/335), though.

Also, consider filing a radar to Apple, like [this one](https://openradar.appspot.com/23114017).

## Cut action doesn't put text into the pasteboard

When you cut text, characters get deleted yet you won't be able to paste them somewhere as they aren't actually in your pasteboard.

iOS hardwires `UIMenuController`'s cut action to the `UITextFieldDelegate`'s `textField(_:shouldChangeCharactersIn:replacementString:)` return value. This means "Cut" behaviour actually depends on the ability to edit the text.

Bad news are, our library returns `false` in `textField(_:shouldChangeCharactersIn:replacementString:)`, and heavily depends on this `false`. It would require us to rewrite a lot of logic in order to change this design, and there's no guarantee we'll be able to do so.

Essentially, there's no distinct way to differentiate "Cut selection" and "Delete selection" actions on the `UITextFieldDelegate` side. However, you may consider using a workaround, which will require you to subclass `UITextField` overriding its `cut(sender:)` method like this:

```swift
class UITextFieldMonkeyPatch: UITextField {
    override func cut(_ sender: Any?) {
        copy(sender)
        super.cut(sender)
    }
}
```

From our library perspective, this looks like a highly invasive solution. Thus, in the long term, we are going to investigate a "costly" method to bring the behaviour matching the iOS SDK logic. Yet, here "long term" might mean months.

# License

The library is distributed under the MIT [LICENSE](https://opensource.org/licenses/MIT).
