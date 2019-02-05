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

`Input Mask` is an [Android](https://github.com/RedMadRobot/input-mask-android) & [iOS](https://github.com/RedMadRobot/input-mask-ios) native library allowing to format user input on the fly.

The library provides you with a text field listener; when attached, it puts separators into the text while user types it in, and gets rid of unwanted symbols, all according to custom predefined pattern.

This allows to reformat whole strings pasted from the clipboard, e.g. turning pasted `8 800 123-45-67` into  
`8 (800) 123 45 67`.

Each pattern allows to extract valuable symbols from the entered text, returning you the immediate result with the text field listener's callback when the text changes. Such that, you'll be able to extract `1234567` from `8 (800) 123 45 67` or `19991234567` from `1 (999) 123 45 67` with two different patterns.

All separators and valuable symbol placeholders have their own syntax. We call such patterns "masks".

Mask examples:

1. International phone numbers: `+1 ([000]) [000] [00] [00]`
2. Local phone numbers: `([000]) [000]-[00]-[00]`
3. Names: `[A][-----------------------------------------------------]` 
4. Text: `[A…]`
5. Dates: `[00]{.}[00]{.}[9900]`
6. Serial numbers: `[AA]-[00000099]`
7. IPv4: `[099]{.}[099]{.}[099]{.}[099]`
8. Visa card numbers: `[0000] [0000] [0000] [0000]`
9. MM/YY: `[00]{/}[00]`

## Questions & Issues

Check out our [wiki](https://github.com/RedMadRobot/input-mask-ios/wiki) for further reading.  
Please also take a closer look at our [Known issues](#knownissues) section before you incorporate our library into your project.

For your bugreports and feature requests please file new issues as usually.

Should you have any questions, search for closed [issues](https://github.com/RedMadRobot/input-mask-ios/issues?q=is%3Aclosed) or open new ones at **[StackOverflow](https://stackoverflow.com/questions/tagged/input-mask)** with the `input-mask` tag.

We also have a community-driven [cookbook](https://github.com/RedMadRobot/input-mask-ios/blob/master/Documentation/COOKBOOK.md) of recipes, be sure to check it out, too.

<a name="installation" />

## Installation

### CocoaPods

```ruby
pod 'InputMask'
```

### Carthage

```ruby
git "https://github.com/RedMadRobot/input-mask-ios.git"
```

### Swift Package Manager

```swift
dependencies: [
    .Package(url: "https://github.com/RedMadRobot/input-mask-ios", majorVersion: 4)
]
```

### Manual

0. `git clone` this repository;
1. Add `InputMask.xcodeproj` into your project/workspace;
2. Go to your target's settings, add `InputMask.framework` under the `Embedded Binaries` section
3. For `ObjC` projects:
	* (~Xcode 8.x) make sure `Build Options` has `Embedded Content Contains Swift Code` enabled;
	* import bridging header.

<a name="knownissues" />

## Known issues

### `UITextFieldTextDidChange` notification and target-action `editingChanged` event

`UITextField` with assigned `MaskedTextFieldDelegate` object won't issue `UITextFieldTextDidChange` notifications and `editingChanged` control events. This happens due to the `textField(_:shouldChangeCharactersIn:replacementString:)` method implementation, which always returns `false`.

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

### Carthage vs. IBDesignables, IBInspectables, views and their outlets

Interface Builder struggles to support modules imported in a form of a dynamic framework. For instance, custom views annotated as IBDesignable, containing IBInspectable and IBOutlet fields aren't recognized properly from the drag'n'dropped \*.framework.

In case you are using our library as a Carthage-built dynamic framework, be aware you won't be able to easily wire your `MaskedTextFieldDelegate` objects and their listeners from storyboards in your project. There is a couple of workarounds described in [the corresponding discussion](https://github.com/Carthage/Carthage/issues/335), though.

Also, consider filing a radar to Apple, like [this one](https://openradar.appspot.com/23114017).

### Cut action doesn't put text into the pasteboard

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

### Incorrect cursor position after pasting

Shortly after new text is being pasted from the clipboard, every ```UITextInput``` receives a new value for its `selectedTextRange` property from the system. This new range is not consistent with the formatted text and calculated caret position most of the time, yet it's being assigned just after ```set caretPosition``` call.
     
To ensure correct caret position is set, it might be assigned asynchronously (presumably after a vanishingly small delay), if caret movement is set to be non-atomic; see `MaskedTextFieldDelegate.atomicCursorMovement` property.

### `MaskedTextInputListener`

In case you are wondering why do we have two separate `UITextFieldDelegate` and `UITextViewDelegate` implementations, the answer is simple: prior to **iOS 11** `UITextField` and `UITextView` had different behaviour in some key situations, which made it difficult to implement common logic. 

Both had the same [bug](http://jon-nolen.blogspot.com/2013/10/uitextview-returns-nil-for-uitextinput.html) with the `UITextInput.beginningOfDocument` property, which rendered impossible to use the generic `UITextInput` protocol `UITextField` and `UITextView` have in common.

Since **iOS 11** most of the things received their fixes (except for the `UITextView` [edge case](https://github.com/RedMadRobot/input-mask-ios/blob/master/Source/InputMask/InputMask/Classes/View/MaskedTextInputListener.swift#L140)). In case your project is not going to support anything below 11, consider using the modern `MaskedTextInputListener`.

## References

The list of projects that are using this library which were kind enough to share that information.

Feel free to add yours below.

## Special thanks

These folks rock:

* Mikhail [while366](https://github.com/while366) Zhadko
* Sergey [SergeyCHiP](https://github.com/SergeyCHiP) Germanovich
* Luiz [LuizZak](https://github.com/LuizZak) Fernando
* Ivan [vani](https://github.com/vani2) Vavilov

# License

The library is distributed under the MIT [LICENSE](https://opensource.org/licenses/MIT).
