# ruuiDynamicTextView

A production level reusable UITextView that expands and contracts like a chat input field. 

This class takes care of these things while minimizing jitter and keeping the caret in view.

Class is WIP but should be stable enough for production use.

**I love contributions.** Send me your fixes.

## Demo

![alt text](http://i.stack.imgur.com/iBD0m.gif "demo")

## Usage

Usage is straight forward.

```swift
let textView = ruuiDynamicTextView(frame: CGRectMake(10, 10, 100, 35))
textView.maxHeight = 100
containerView.addSubview(textView)
```

## Features

* Grow & shrink
* Keeps caret in view
* Animates cleanly
* Maximum and minimum size

## Testing

* Tested on iOS 9.3.1
