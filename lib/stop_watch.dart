import 'dart:async';

import 'package:flutter/material.dart';

class StopWatchScreen extends StatefulWidget {
  const StopWatchScreen({Key? key}) : super(key: key);

  @override
  State<StopWatchScreen> createState() => _StopWatchScreenState();
}

class _StopWatchScreenState extends State<StopWatchScreen> {
  // 타이머 생성
  Timer? _timer;

  // 초 값
  int _time = 0;

  // 재생 중지
  bool _isRunning = false;

  // 시간 리스트로 받음
  List<String> _lapTimes = [];

  // 상태가 바뀌어야함. 재생 눌렀을 때
  void _clickButton() {
    setState(() {
      _isRunning = !_isRunning;

      if (_isRunning) {
        _start();
      } else {
        _pause();
      }
    });
  }

  void _start() {
    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      setState(() {
        _time++;
      });
    });
  }

  void _pause() {
    _timer?.cancel();
  }

  // 초기화.
  void _reset() {
    _isRunning = false;
    _timer?.cancel();
    _lapTimes.clear();
    _time = 0;
  }

  // 0번째에 하나를 넣겠다는 의미임.
  void _recordLapTime(String time) {
    _lapTimes.insert(0, '${_lapTimes.length + 1}등 $time');
  }

  @override
  void dispose() {
    // 널이 아니면 캔슬을 안하고 널이면 아무것도 안함
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int sec = _time ~/ 100;
    // 한자리로 표시될 때 0이 뒤에 안붙는 문제 해결
    // 2자리가 아니면 0을 넣겠다는 뜻
    String hundredth = '${_time % 100}'.padLeft(2, '0');
    return Scaffold(
      appBar: AppBar(
        title: const Text('스톱워치'),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Row(
            // 0이랑 00이 가운데 배치된다.
            mainAxisAlignment: MainAxisAlignment.center,
            // 00이 밑으로 살짝 내려간다.
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$sec',
                style: TextStyle(fontSize: 50),
              ),
              Text(
                '$hundredth',
              ),
            ],
          ),
          // 랩타임 구간
          SizedBox(
            width: 100,
            height: 200,
            child: ListView(
              children: _lapTimes.map((time) => Center(child: Text(time))).toList(),
            ),
          ),
          // 위에 공간이 꽉차고 로우는 내려감. 로우 위에 썼으니까 로우 위 공간이 꽉차는거같음
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton(
                backgroundColor: Colors.orange,
                onPressed: () {
                  setState(() {
                    _reset();
                  });
                },
                child: const Icon(Icons.refresh),
              ),
              FloatingActionButton(
                onPressed: () {
                  setState(() {
                    _clickButton();
                  });
                },
                // 재생 버튼 바뀜.
                child: _isRunning
                    ? const Icon(Icons.pause)
                    : const Icon(Icons.play_arrow),
              ),
              FloatingActionButton(
                backgroundColor: Colors.green,
                onPressed: () {
                  setState(() {
                    _recordLapTime('$sec.$hundredth');
                  });
                },
                child: const Icon(Icons.add),
              )
            ],
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
