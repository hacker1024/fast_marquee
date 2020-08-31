# fast_marquee

This is a clone of the `marquee` package that uses a `CustomPainter` instead
of a `ScrollView` for better performance.

Many parts of this package (including most parameter names, some assertion
code, some documentation, and most of this README) are copied from `marquee`. Switching should
be a fairly straightforward process.

⏩ A Flutter widget that scrolls text infinitely. Provides many customizations
including durations, curves, and fading, as well as pauses after
every round and start delays.

*Appreciate the widget? Show some ❤️ and star the repo to support the project.*

- [Pub Package](https://pub.dartlang.org/packages/fast_marquee)
- [GitHub Repository](https://github.com/hacker1024/fast_marquee)
- [API reference](https://pub.dartlang.org/documentation/fast_marquee/)

## Usage

This is a minimalistic example:

```dart
Marquee(
  text: 'There once was a boy who told this story about a boy: "',
)
```

And here's a piece of code that makes full use of the marquee's
customizability:

```dart
Marquee(
  text: 'Some sample text that takes some space.',
  style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
  velocity: 100,
  blankSpace: 10,
  startPadding: 10,
  reverse: true,
  bounce: true,
  startAfter: const Duration(seconds: 2),
  pauseAfterRound: const Duration(seconds: 1),
  numberOfRounds: 5,
  showFadingOnlyWhenScrolling: false,
  fadingEdgeStartFraction: 0.05,
  fadingEdgeEndFraction: 0.05,
  curve: Curves.easeInOut,
)
```

For more information about the properties, have a look at the
[API reference](https://pub.dartlang.org/documentation/fast_marquee/).

## LICENSE

```
Copyright (c) 2020 hacker1024

Some components (some parameter names, assertion code, documentation and
parts of the README) are Copyright (c) 2018 Marcel Garus.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```