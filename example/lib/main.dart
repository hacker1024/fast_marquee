import 'package:fast_marquee/fast_marquee.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'fast_marquee example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget buildSimpleMarquee() {
      return const Marquee(
        text: 'This is a simple marquee.',
        blankSpace: 10,
      );
    }

    Widget buildCustomizedMarquee() {
      return const Marquee(
        text: 'This is a very customized marquee.',
        velocity: 150,
        blankSpace: 30,
        startPadding: 10,
        reverse: true,
        bounce: true,
        startAfter: Duration.zero,
        pauseAfterRound: Duration(seconds: 1),
        // numberOfRounds: 5,
        showFadingOnlyWhenScrolling: true,
        fadingEdgeStartFraction: 0.05,
        fadingEdgeEndFraction: 0.05,
        curve: Curves.easeOut,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('fast_marquee example'),
      ),
      body: Center(
        child: SizedBox(
          width: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              buildSimpleMarquee(),
              const SizedBox(height: 16),
              buildCustomizedMarquee(),
            ],
          ),
        ),
      ),
    );
  }
}
