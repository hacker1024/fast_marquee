library fast_marquee;

import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/widgets.dart';

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
class Marquee extends StatelessWidget {
  /// The text to be displayed.
  ///
  /// See also:
  ///
  /// * [style] to style the text.
  final String text;

  /// The style of the text to be displayed.
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
  final TextStyle? style;

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
  /// If the marquee text will never scroll (when there's enough space to show
  /// it all), fading will never occur regardless of this value.
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
  final Curve curve;

  const Marquee({
    Key? key,
    required this.text,
    this.style,
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
    this.curve = Curves.linear,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => _StyledMarquee(
        text: text,
        style: style ?? DefaultTextStyle.of(context).style,
        velocity: velocity,
        blankSpace: blankSpace,
        startPadding: startPadding,
        reverse: reverse,
        bounce: bounce,
        startAfter: startAfter,
        pauseAfterRound: pauseAfterRound,
        numberOfRounds: numberOfRounds,
        showFadingOnlyWhenScrolling: showFadingOnlyWhenScrolling,
        fadingEdgeStartFraction: fadingEdgeStartFraction,
        fadingEdgeEndFraction: fadingEdgeEndFraction,
        curve: curve,
      );
}

class _StyledMarquee extends StatefulWidget {
  /// Equivalent to [Marquee.text].
  final String text;

  /// Equivalent to [Marquee.style].
  final TextStyle style;

  /// Equivalent to [Marquee.blankSpace].
  final double blankSpace;

  /// Equivalent to [Marquee.velocity].
  final double velocity;

  /// Equivalent to [Marquee.reverse].
  final bool reverse;

  /// Equivalent to [Marquee.bounce].
  final bool bounce;

  /// Equivalent to [Marquee.startAfter].
  final Duration startAfter;

  /// Equivalent to [Marquee.pauseAfterRound].
  final Duration pauseAfterRound;

  /// Equivalent to [Marquee.numberOfRounds].
  final int? numberOfRounds;

  /// Equivalent to [Marquee.showFadingOnlyWhenScrolling].
  final bool showFadingOnlyWhenScrolling;

  /// Equivalent to [Marquee.startPadding].
  final double startPadding;

  /// Equivalent to [Marquee.curve].
  final Curve curve;

  /// An internal gradient generated for use when fading the edges.
  /// See [showFadingOnlyWhenScrolling], [fadingEdgeStartFraction], and
  /// [fadingEdgeEndFraction] for fading configuration.
  final Gradient? _fadeGradient;

  _StyledMarquee({
    Key? key,
    required this.text,
    required this.style,
    required this.velocity,
    required this.blankSpace,
    required this.startPadding,
    required this.reverse,
    required this.bounce,
    required this.startAfter,
    required this.pauseAfterRound,
    this.numberOfRounds,
    required this.showFadingOnlyWhenScrolling,
    required double fadingEdgeStartFraction,
    required double fadingEdgeEndFraction,
    required this.curve,
  })   : assert(!blankSpace.isNaN),
        assert(blankSpace >= 0, 'The blankSpace needs to be positive or zero.'),
        assert(blankSpace.isFinite),
        assert(!velocity.isNaN),
        assert(velocity != 0.0, 'The velocity cannot be zero.'),
        assert(velocity > 0,
            'The velocity cannot be negative. Set reverse to true instead.'),
        assert(velocity.isFinite),
        assert(
            pauseAfterRound >= Duration.zero,
            'The pauseAfterRound cannot be negative as time travel isn\'t '
            'invented yet.'),
        assert(fadingEdgeStartFraction >= 0 && fadingEdgeStartFraction <= 0.5,
            'The fadingEdgeGradientFractionOnStart value should be between 0 and 0.5, inclusive'),
        assert(fadingEdgeEndFraction >= 0 && fadingEdgeEndFraction <= 0.5,
            'The fadingEdgeGradientFractionOnEnd value should be between 0 and 0.5, inclusive'),
        assert(startPadding <= blankSpace,
            'The startPadding must be less than or equal to the blankSpace.'),
        assert(numberOfRounds == null || numberOfRounds > 0),
        _fadeGradient =
            _buildFadeGradient(fadingEdgeStartFraction, fadingEdgeEndFraction),
        super(key: key);

  @override
  _StyledMarqueeState createState() => _StyledMarqueeState();

  static Gradient? _buildFadeGradient(
          double startFraction, double endFraction) =>
      startFraction == 0 && endFraction == 0
          ? null
          : LinearGradient(
              colors: const [
                Color(0x00000000),
                Color(0xFF000000),
                Color(0xFF000000),
                Color(0x00000000),
              ],
              stops: [
                0,
                startFraction,
                1 - endFraction,
                1,
              ],
            );
}

class _StyledMarqueeState extends State<_StyledMarquee>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _textAnimation;
  late TextPainter _textPainter;
  late Size _textSize;

  bool _roundsComplete = false;

  TextPainter _buildTextPainter() => TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(
          text: widget.text,
          style: widget.style,
        ),
      )..layout();

  bool _needsNewTextPainter(_StyledMarquee oldWidget) =>
      oldWidget.text != widget.text || oldWidget.style != widget.style;

  Duration _getDuration() => _MarqueePainter.calculateDurationFromVelocity(
      widget.velocity, _textSize.width, widget.blankSpace);

  AnimationController _buildAnimationController() => AnimationController(
        vsync: this,
        duration: _getDuration(),
      );

  bool _needsUpdateAnimationController(_StyledMarquee oldWidget,
          {required bool needsNewTextPainter}) =>
      needsNewTextPainter ||
      oldWidget.velocity != widget.velocity ||
      oldWidget.blankSpace != widget.blankSpace;

  void _updateAnimationController() => _controller.duration = _getDuration();

  Animation<double> _buildTextAnimation() => (widget.reverse
          ? Tween<double>(
              end: _textSize.width + widget.blankSpace,
              begin: 0,
            )
          : Tween<double>(
              begin: _textSize.width + widget.blankSpace,
              end: 0,
            ))
      .chain(CurveTween(curve: widget.curve))
      .animate(_controller);

  bool _needsNewTextAnimation(
    _StyledMarquee oldWidget, {
    required bool needsNewTextPainter,
    required bool needsUpdateAnimationController,
  }) =>
      needsNewTextPainter ||
      needsUpdateAnimationController ||
      oldWidget.reverse != widget.reverse ||
      oldWidget.blankSpace != widget.blankSpace ||
      oldWidget.curve != widget.curve;

  @override
  void initState() {
    super.initState();

    // Make the text painter, and record its size
    _textPainter = _buildTextPainter();
    _textSize = _textPainter.size;

    // Create the animation controller
    _controller = _buildAnimationController();

    // Create a scaled, curved animation that has a value equal to the horizontal text position
    _textAnimation = _buildTextAnimation();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
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
            if (widget.bounce) {
              _controller.reverse(from: 1);
            } else {
              _controller.forward(from: 0);
            }
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
            microseconds: (_controller.duration!.inMicroseconds +
                    widget.pauseAfterRound.inMicroseconds) *
                widget.numberOfRounds!,
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
  void didUpdateWidget(_StyledMarquee oldWidget) {
    super.didUpdateWidget(oldWidget);
    final needsNewTextPainter = _needsNewTextPainter(oldWidget);
    if (needsNewTextPainter) {
      _textPainter = _buildTextPainter();
      _textSize = _textPainter.size;
    }
    final needsUpdateAnimationController = _needsUpdateAnimationController(
      oldWidget,
      needsNewTextPainter: needsNewTextPainter,
    );
    if (needsUpdateAnimationController) _updateAnimationController();
    final needsNewTextAnimation = _needsNewTextAnimation(
      oldWidget,
      needsNewTextPainter: needsNewTextPainter,
      needsUpdateAnimationController: needsUpdateAnimationController,
    );
    if (needsNewTextAnimation) _textAnimation = _buildTextAnimation();
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
    // the widget isn't scrolling and it's set not to fade in that circumstance.
    if (widget._fadeGradient == null ||
        (widget.showFadingOnlyWhenScrolling && !_controller.isAnimating)) {
      return scroller;
    }

    return ShaderMask(
      shaderCallback: (rect) {
        final shaderRect = Rect.fromLTRB(0, 0, rect.width, rect.height);

        // Don't fade if the text won't scroll at all.
        if (_textSize.width < rect.width) {
          return const LinearGradient(
            colors: <Color>[Color(0xFF000000), Color(0xFF000000)],
          ).createShader(shaderRect);
        }

        return widget._fadeGradient!.createShader(shaderRect);
      },
      blendMode: BlendMode.dstIn,
      child: scroller,
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
  })   : assert(blankSpace >= 0),
        assert(startPadding >= 0);

  static Duration calculateDurationFromVelocity(
    double velocity,
    double textWidth,
    double blankSpace,
  ) =>
      Duration(
          microseconds: ((Duration.microsecondsPerSecond / velocity) *
                  (textWidth + blankSpace))
              .toInt());

  @override
  bool shouldRepaint(_MarqueePainter oldDelegate) =>
      horizontalTextPosition != oldDelegate.horizontalTextPosition ||
      textPainter != oldDelegate.textPainter ||
      textSize != oldDelegate.textSize ||
      blankSpace != oldDelegate.blankSpace ||
      startPadding != oldDelegate.startPadding;

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
