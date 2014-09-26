模仿iOS系统的Message App的输入框，可以拖拽隐藏。

## 实现思路
iOS 7之后，UIScrollView加入了`UIScrollViewKeyboardDismissMode`特性，它采用交互的方式来隐藏keyboard，如果手势作用于keyboard的边缘，那么Keyboard会随着手势进行移动/隐藏。e.g. Message App

但是系统对于Message的交互并不直接支持，只能使用黑魔法实现这种效果
- 将inputView的Frame和keyboard绑定：如果keyboard出现的时候，将inputView的位置移动到keyboard的上方
- 为输入框添加透明的inputAccessoryView，目的是为了将触发拖拽区域扩大到inputView
- 监听keyboard的Frame变化，改变inputView的位置

## 参考

- [SlackTextViewController](https://github.com/slackhq/SlackTextViewController)
- [KeyboardAccessory](https://developer.apple.com/library/ios/samplecode/KeyboardAccessory/Introduction/Intro.html)
