import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SimplePomodoro(),
    );
  }
}

class SimplePomodoro extends StatefulWidget {
  const SimplePomodoro({Key? key}) : super(key: key);

  @override
  _SimplePomodoroState createState() => _SimplePomodoroState();
}

class _SimplePomodoroState extends State<SimplePomodoro> {
  late Timer _timer;

  int _start = 1 * 10; // 25 minutos convertidos em
  bool isBreak = false;
  final player = AudioPlayer();


  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            player.play(AssetSource('alarm.mp3'));
            if (isBreak) {
              isBreak = false;
            } else {
              isBreak = true;
              _start = 5 * 60; // 5 minutos intervalo
              startTimer();
            }
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  void resetTimer() {
    _timer.cancel();
    setState(() {
      _start = isBreak ? 5 * 60 : 25 * 60;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pomodoro'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '${_start ~/ 60}:${(_start % 60).toString().padLeft(2, '0')}',
              style: Theme.of(context).textTheme.headline1,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                startTimer();
              },
              child: const Text('Iniciar Pomodoro'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                dispose();
              },
              child: const Text('Cancelar'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                resetTimer(); // Chama a função resetTimer quando o botão é pressionado
              },
              child: const Text('Reiniciar'),
            ),
          ],
        ),
      ),
    );
  }
}

