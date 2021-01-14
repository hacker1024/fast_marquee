library fast_marquee;

import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

/// A widget that repeats text and automatically scrolls it infinitely.
///
/// ## Sample code
///
/// This is a minimalistic example:
///
/// ```dart
/// Marquee(
///   text: 'There once was a boy who told this story about a boy: "',
/// )
/// ```
///
/// And here's a piece of code that makes full use of the marquee's
/// customizability:
///
/// ```dart
/// Marquee(
///   text: 'Some sample text that takes some space.',
///   style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
///   velocity: 100,
///   blankSpace: 10,
///   startPadding: 10,
///   reverse: true,
///   bounce: true,
///   startAfter: const Duration(seconds: 2),
///   pauseAfterRound: const Duration(seconds: 1),
///   numberOfRounds: 5,
///   showFadingOnlyWhenScrolling: false,
///   fadingEdgeStartFraction: 0.05,
///   fadingEdgeEndFraction: 0.05,
///   curve: Curves.easeInOut,
/// )
/// ```
class Marquee extends StatefulWidget {
  Marquee({
    Key? key,
    required this.text,
    this.style = const TextStyle(color: Colors.green),
    this.velocity = 100,
    this.blankSpace = 0,
    this.startPadding = 0,
    this.reverse = false,
    this.bounce = false,
    this.startAfter = Duration.zero,
    this.pauseAfterRound = Duration.zero,
    this.numberOfRounds,
    this.showFadingOnlyWhenScrolling = true,
    this.fadingEdgeStartFraction = 0,
    this.fadingEdgeEndFraction = 0,
    final Curve curve = Curves.linear,
  })  : _curveTween = CurveTween(curve: curve),
        _fadeGradient =
            fadingEdgeStartFraction == 0 && fadingEdgeEndFraction == 0
                ? null
                : LinearGradient(
                    colors: const [
                      Colors.transparent,
                      Colors.black,
                      Colors.black,
                      Colors.transparent,
                    ],
                    stops: [
                      0,
                      fadingEdgeStartFraction,
                      1 - fadingEdgeEndFraction,
                      1,
                    ],
                  ),
        assert(
            text != null,
            'The text cannot be null. If you don\'t want to display something, '
            'consider passing an empty string instead.'),
        assert(
            blankSpace != null,
            'The blankSpace cannot be null. If you don\'t want any blank space, '
            'consider setting it to zero instead.'),
        assert(!blankSpace.isNaN),
        assert(blankSpace >= 0, 'The blankSpace needs to be positive or zero.'),
        assert(blankSpace.isFinite),
        assert(velocity != null),
        assert(!velocity.isNaN),
        assert(velocity != 0.0, 'The velocity cannot be zero.'),
        assert(velocity > 0,
            'The velocity cannot be negative. Set reverse to true instead.'),
        assert(velocity.isFinite),
        assert(
            startAfter != null,
            'The startAfter cannot be null. If you want to start immediately, '
            'consider setting it to Duration.zero instead.'),
        assert(
            pauseAfterRound != null,
            'The pauseAfterRound cannot be null. If you don\'t want to pause, '
            'consider setting it to Duration.zero instead.'),
        assert(
            pauseAfterRound >= Duration.zero,
            'The pauseAfterRound cannot be negative as time travel isn\'t '
            'invented yet.'),
        assert(fadingEdgeStartFraction >= 0 && fadingEdgeStartFraction <= 0.5,
            'The fadingEdgeGradientFractionOnStart value should be between 0 and 0.5, inclusive'),
        assert(fadingEdgeEndFraction >= 0 && fadingEdgeEndFraction <= 0.5,
            'The fadingEdgeGradientFractionOnEnd value should be between 0 and 0.5, inclusive'),
        assert(
            startPadding != null,
            'The start padding cannot be null. If you don\'t want any '
            'startPadding, consider setting it to zero.'),
        assert(startPadding <= blankSpace,
            'The startPadding must be less than or equal to the blankSpace.'),
        assert(numberOfRounds == null || numberOfRounds > 0),
        assert(curve != null,
            'Curve cannot be null. If you don\'t want to use one, consider using Curves.linear.'),
        super(key: key);

  /// The text to be displayed.
  ///
  /// See also:
  ///
  /// * [style] to style the text.
  final String text;

  /// The style of the text to be displayed.
  ///
  /// Note: this should usually be used to set a color, as green is
  /// the default. (Green is the default instead of black because the default
  /// Flutter text themes don't use pure black. If black was the default here,
  /// people may use it instead of the correct shade.)
  ///
  /// ## Sample code
  ///
  /// This marquee has a bold text:
  ///
  /// ```dart
  /// Marquee(
  ///   text: 'This is some bold text.',
  ///   style: TextStyle(weight: FontWeight.bold)
  /// )
  /// ```
  ///
  /// See also:
  ///
  /// * [text] to provide the text itself.
  final TextStyle style;

  /// The extend of blank space to display between instances of the text.
  ///
  /// ## Sample code
  ///
  /// In this example, there's 300 density pixels between the text instances:
  ///
  /// ```dart
  /// Marquee(
  ///   blankSpace: 300.0,
  ///   child: 'Wait for it...',
  /// )
  /// ```
  final double blankSpace;

  /// The scrolling velocity in logical pixels per second.
  /// The velocity must not be negative. [reverse] may be set
  /// to change the direction instead.
  ///
  /// ## Sample code
  ///
  /// This marquee scrolls backwards with 1000 pixels per second:
  ///
  /// ```dart
  /// Marquee(
  ///   velocity: 1000.0,
  ///   text: 'Gotta go fast',
  /// )
  /// ```
  final double velocity;

  /// Set as true to reverse the scroll direction.
  ///
  /// ## Sample code
  ///
  /// ```dart
  /// Marquee(
  ///   reverse: true,
  ///   text: 'Wheee!',
  /// )
  /// ```
  final bool reverse;

  /// Bounce the text back and fourth instead of scrolling it infinitely.
  ///
  /// ## Sample code
  ///
  /// ```dart
  /// Marquee(
  ///   bounce: true,
  ///   text: 'Boing!',
  /// )
  /// ```
  final bool bounce;

  /// Start scrolling after this duration after the widget is first displayed.
  ///
  /// ## Sample code
  ///
  /// This Marquee starts scrolling one second after being displayed.
  ///
  /// ```dart
  /// Marquee(
  ///   startAfter: const Duration(seconds: 1),
  ///   text: 'Starts one second after being displayed.',
  /// )
  /// ```
  final Duration startAfter;

  /// After each round, a pause of this duration occurs.
  ///
  /// ## Sample code
  ///
  /// After every round, this marquee pauses for one second.
  ///
  /// ```dart
  /// Marquee(
  ///   pauseAfterRound: const Duration(seconds: 1),
  ///   text: 'Pausing for some time after every round.',
  /// )
  /// ```
  final Duration pauseAfterRound;

  /// When the text scrolled around [numberOfRounds] times, it will stop scrolling
  /// `null` indicates there is no limit
  ///
  /// ## Sample code
  ///
  /// This marquee stops after 3 rounds
  ///
  /// ```dart
  /// Marquee(
  ///   numberOfRounds: 3,
  ///   text: 'Stopping after three rounds.',
  /// )
  /// ```
  final int? numberOfRounds;

  /// Whether the fading edge should only appear while the text is
  /// scrolling.
  ///
  /// ## Sample code
  ///
  /// This marquee will only show the fade while scrolling.
  ///
  /// ```dart
  /// Marquee(
  ///   showFadingOnlyWhenScrolling: true,
  ///   fadingEdgeStartFraction: 0.1,
  ///   fadingEdgeEndFraction: 0.1,
  ///   text: 'Example text.',
  /// )
  /// ```
  final bool showFadingOnlyWhenScrolling;

  /// The fraction of the [Marquee] that will be faded on the left or top.
  /// By default, there won't be any fading.
  ///
  /// ## Sample code
  ///
  /// This marquee fades the edges while scrolling
  ///
  /// ```dart
  /// Marquee(
  ///   showFadingOnlyWhenScrolling: true,
  ///   fadingEdgeStartFraction: 0.1,
  ///   fadingEdgeEndFraction: 0.1,
  ///   text: 'Example text.',
  /// )
  /// ```
  final double fadingEdgeStartFraction;

  /// The fraction of the [Marquee] that will be faded on the right or down.
  /// By default, there won't be any fading.
  ///
  /// ## Sample code
  ///
  /// This marquee fades the edges while scrolling
  ///
  /// ```dart
  /// Marquee(
  ///   showFadingOnlyWhenScrolling: true,
  ///   fadingEdgeStartFraction: 0.1,
  ///   fadingEdgeEndFraction: 0.1,
  ///   text: 'Example text.',
  /// )
  /// ```
  final double fadingEdgeEndFraction;

  /// A padding for the resting position.
  ///
  /// In between rounds, the marquee stops at this position. This parameter is
  /// especially useful if the marquee pauses after rounds and some other
  /// widgets are stacked on top of the marquee and block the sides, like
  /// fading gradients.
  ///
  /// ## Sample code
  ///
  /// ```dart
  /// Marquee(
  ///   startPadding: 20.0,
  ///   pauseAfterRound: Duration(seconds: 1),
  ///   text: 'During pausing, this text is shifted 20 pixel to the right.',
  /// )
  /// ```
  final double startPadding;

  /// The animation curve.
  /// Use the [curve] constructor argument to set this.
  ///
  /// This curve defines the text's movement speed over one cycle.
  ///
  /// ## Sample code
  ///
  /// ```dart
  /// Marquee(
  //    startPadding: 20.0,
  //    text: 'During pausing, this text is shifted 20 pixel to the right.',
  //  )
  /// ```
  final CurveTween _curveTween;

  /// An internal gradient generated for use when fading the edges.
  /// See [showFadingOnlyWhenScrolling], [fadingEdgeStartFraction], and
  /// [fadingEdgeEndFraction] for fading configuration.
  final LinearGradient? _fadeGradient;

  @override
  _MarqueeState createState() => _MarqueeState();

  bool equals(Object other) {
    return other is Marquee &&
        text == other.text &&
        style == other.style &&
        blankSpace == other.blankSpace &&
        velocity == other.velocity &&
        startPadding == other.startPadding &&
        pauseAfterRound == other.pauseAfterRound &&
        numberOfRounds == other.numberOfRounds;
  }
}

class _MarqueeState extends State<Marquee> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _textAnimation;
  late final TextPainter _textPainter;
  late final Size _textSize;

  bool _roundsComplete = false;

  @override
  void initState() {
    super.initState();

    // Make the text painter, and record its size
    _textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: widget.text,
        style: widget.style,
      ),
    )..layout();
    _textSize = _textPainter.size;

    // Create the animation controller
    _controller = AnimationController(
      vsync: this,
      duration: _MarqueePainter.getDurationFromVelocity(
          widget.velocity, _textSize.width, widget.blankSpace),
    );

    // Create a scaled, curved animation that has a value equal to the horizontal text position
    _textAnimation = (widget.reverse
            ? Tween<double>(
                end: _textSize.width + widget.blankSpace,
                begin: 0,
              )
            : Tween<double>(
                begin: _textSize.width + widget.blankSpace,
                end: 0,
              ))
        .chain(widget._curveTween)
        .animate(_controller);

    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      // Wait for the duration passed in startAfter
      await Future.delayed(widget.startAfter);
      if (!mounted) return;

      // Restart or reverse the animation when required
      _controller.addStatusListener((status) async {
        // Set state so the widget rebuilds with/without a fade
        if (widget.showFadingOnlyWhenScrolling) setState(() {});

        // Wait for the pauseAfterRound time
        await Future.delayed(widget.pauseAfterRound);

        if (!mounted || _roundsComplete) return;
        if (widget.bounce && status == AnimationStatus.dismissed) {
          _controller.forward(from: 0);
        } else {
          if (status == AnimationStatus.completed) {
            if (widget.bounce)
              _controller.reverse(from: 1);
            else
              _controller.forward(from: 0);
          }
        }
      });

      // Start the animation
      _controller.forward();

      // Stop the animation after the time taken to complete the given
      // number of rounds has elapsed.
      if (widget.numberOfRounds != null) {
        Timer(
          Duration(
            microseconds: ((_controller.duration!.inMicroseconds +
                    widget.pauseAfterRound.inMicroseconds) *
                widget.numberOfRounds!),
          ),
          () {
            _roundsComplete = true;
          },
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Make the custom painter
    final scroller = AnimatedBuilder(
      animation: _textAnimation,
      builder: (context, _) {
        return CustomPaint(
          size: Size(double.infinity, _textSize.height),
          painter: _MarqueePainter(
            horizontalTextPosition: _textAnimation.value,
            textPainter: _textPainter,
            textSize: _textSize,
            blankSpace: widget.blankSpace,
            startPadding: widget.startPadding,
          ),
        );
      },
    );

    // Flutter doesn't support the shader used on Web yet.
    if (kIsWeb) return scroller;

    // Don't draw a gradient shader if the gradient isn't assigned, or if
    // the widget isn't scrolling and it's set not to fade in that circumstance
    if ((widget._fadeGradient == null ||
        (widget.showFadingOnlyWhenScrolling && !_controller.isAnimating)))
      return scroller;

    return ShaderMask(
      child: scroller,
      shaderCallback: (rect) {
        final shaderRect = Rect.fromLTRB(0, 0, rect.width, rect.height);

        // Don't fade if the text won't scroll at all
        // and fading while not scrolling is off
        if (widget.showFadingOnlyWhenScrolling &&
            _textSize.width < rect.width) {
          return const LinearGradient(
            colors: const <Color>[Colors.black, Colors.black],
          ).createShader(shaderRect);
        }

        return widget._fadeGradient!.createShader(shaderRect);
      },
    );
  }
}

class _MarqueePainter extends CustomPainter {
  final double horizontalTextPosition;
  final TextPainter textPainter;
  final Size textSize;
  final double blankSpace;
  final double startPadding;

  const _MarqueePainter({
    required this.horizontalTextPosition,
    required this.textPainter,
    required this.textSize,
    required this.blankSpace,
    required this.startPadding,
  });

  static Duration getDurationFromVelocity(
    double velocity,
    double textWidth,
    double blankSpace,
  ) {
    return Duration(
      microseconds: ((Duration.microsecondsPerSecond / velocity) *
              (textWidth + blankSpace))
          .toInt(),
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    final old = (oldDelegate as _MarqueePainter);
    return (horizontalTextPosition != old.horizontalTextPosition ||
        textSize.width != old.textSize.width);
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Calculate the vertical offset.
    final verticalPosition = (size.height - textPainter.height) / 2;

    // If the text all fits on screen, no need to scroll.
    if (textSize.width < size.width) {
      textPainter.paint(canvas, Offset(0, verticalPosition));
      return;
    }

    // Clip the canvas in order not to draw text out of bounds.
    canvas.clipRect(Rect.fromLTRB(0, 0, size.width, size.height));

    // Draw the text twice in succession, with relation to the calculated horizontal offset.
    // Drawn twice because there will only be a maximum of two texts visible at any point in time.
    textPainter.paint(
      canvas,
      Offset(startPadding + horizontalTextPosition, verticalPosition),
    );
    textPainter.paint(
      canvas,
      Offset(
        startPadding + horizontalTextPosition - textSize.width - blankSpace,
        verticalPosition,
      ),
    );
  }
}
