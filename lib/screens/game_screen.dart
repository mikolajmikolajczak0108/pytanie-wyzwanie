import 'package:flutter/material.dart';
import '../models/category.dart';
import 'dart:async';
import 'dart:math';

class GameScreen extends StatefulWidget {
  final Category category;

  GameScreen({required this.category});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with SingleTickerProviderStateMixin {
  String? currentTask;
  final Random random = Random();
  Timer? _timer;
  AnimationController? _controller;
  Animation<double>? _sizeAnimation;
  int countdown = 3;
  bool isTaskVisible = false;
  bool isChallenge = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 3));
    _sizeAnimation = Tween<double>(begin: 1.0, end: 2.0).animate(_controller!);
    startCountdown();
  }

  void startCountdown() {
    setState(() {
      currentTask = null;
      isTaskVisible = false;
    });
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (countdown > 0) {
        setState(() {
          countdown--;
        });
      } else {
        _timer?.cancel();
        setState(() {
          isTaskVisible = true;
        });
      }
    });
  }

  void pickTask(bool challenge) {
    setState(() {
      isChallenge = challenge;
      currentTask = challenge
          ? widget.category.challenges[random.nextInt(widget.category.challenges.length)]
          : widget.category.questions[random.nextInt(widget.category.questions.length)];
    });
    _controller!.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    String backgroundImagePath = isChallenge ? 'assets/images/challenge_bg.png' : 'assets/images/question_bg.png';

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.name, style: TextStyle(color: Colors.white, fontFamily: 'Arial')),
      ),
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: Duration(seconds: 1),
            child: Container(
              key: ValueKey<String>(backgroundImagePath),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(backgroundImagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    if (countdown > 0 || currentTask == null)
                      ScaleTransition(
                        scale: _sizeAnimation!,
                        child: Text(
                          countdown > 0 ? '$countdown' : 'Start!',
                          style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold, fontFamily: 'Arial', color: Colors.white),
                        ),
                      ),
                    SizedBox(height: 20),
                    if (isTaskVisible && currentTask == null)
                      Column(
                        children: [
                          _buildButton('Pytanie', Colors.blue, () => pickTask(false)),
                          SizedBox(height: 10),
                          _buildButton('Wyzwanie', Colors.red, () => pickTask(true)),
                        ],
                      ),
                    if (currentTask != null)
                      Text(
                        currentTask!,
                        style: TextStyle(fontSize: 24, fontFamily: 'Arial', color: Colors.white),
                      ),
                    if (currentTask != null)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.green),
                        onPressed: () {
                          setState(() {
                            isTaskVisible = false;
                            countdown = 3;
                          });
                          startCountdown();
                        },
                        child: Text('Zrobione', style: TextStyle(fontSize: 20, fontFamily: 'Arial')),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ElevatedButton _buildButton(String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
        primary: color,
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
    textStyle: TextStyle(fontSize: 20, fontFamily: 'Arial'),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          onPrimary: Colors.white,  // Kolor tekstu na przycisku
        ),
      onPressed: onPressed,
      child: Text(text),
      onHover: (isHovering) {
        if (isHovering) {
          // Można dodać efekty hover, np. zmiana koloru
        } else {
          // Powrót do normalnego stanu
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller?.dispose();
    super.dispose();
  }
}
