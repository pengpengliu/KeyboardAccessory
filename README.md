MessageKeyboardAccessory
=============================================

Imitate the input box of Message.app of iOS system, You can drag and drop to hide.

![Demo Gif](Screenshots/messagekeyboardaccessory.gif)

## Implementation ideas
After iOS 7, UIScrollView added the `UIScrollViewKeyboardDismissMode` feature, which uses an interactive way to hide the Keyboard. If the gesture is applied to the edge of the Keyboard, the Keyboard will move or hide with the gesture.

However, the system does not directly support the interactions like Message.app. Only black magic can be used to achieve this effect.
- Bind the InputView's Frame to the Keyboard: If Keyboard appears, move the InputView's position to the top of the Keyboard
- Adds a transparent InputAccessoryView to the input box in order to extend the trigger draggable area to the InputView
- Listen for changes to the Keyboard's Frame and change the position of the InputView

## Reference

- [SlackTextViewController](https://github.com/slackhq/SlackTextViewController)
- [KeyboardAccessory] (https://developer.apple.com/library/ios/samplecode/KeyboardAccessory/Introduction/Intro.html)
