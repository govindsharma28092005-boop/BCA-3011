import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class BmiPage extends StatefulWidget {
  const BmiPage({super.key});

  @override
  State<BmiPage> createState() => _BmiPageState();
}

class _BmiPageState extends State<BmiPage> {
  final _wCtrl = TextEditingController();
  final _hCtrl = TextEditingController();
  double? _bmi;
  String _status = '';

  // STOPWATCH STATE
  Timer? _timer;
  int _elapsedSeconds = 0;
  bool _isRunning = false;

  void _calc() {
    final w = double.tryParse(_wCtrl.text) ?? 0;
    final h = double.tryParse(_hCtrl.text) ?? 0;
    if (w <= 0 || h <= 0) return;

    final bmi = w / pow(h / 100, 2); // w(kg) / (h(m)^2)

    setState(() {
      _bmi = double.parse(bmi.toStringAsFixed(1));
      if (bmi < 18.5) {
        _status = 'Underweight';
      } else if (bmi < 25) {
        _status = 'Normal';
      } else if (bmi < 30) {
        _status = 'Overweight';
      } else {
        _status = 'Obese';
      }
    });
  }

  // STOPWATCH METHODS
  void _startTimer() {
    if (_isRunning) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _elapsedSeconds++;
      });
    });
    setState(() => _isRunning = true);
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _elapsedSeconds = 0;
      _isRunning = false;
    });
  }

  String get _formattedTime {
    final h = _elapsedSeconds ~/ 3600;
    final m = (_elapsedSeconds % 3600) ~/ 60;
    final s = _elapsedSeconds % 60;
    String two(int v) => v.toString().padLeft(2, '0');
    if (h > 0) {
      return '${two(h)}:${two(m)}:${two(s)}';
    }
    return '${two(m)}:${two(s)}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _wCtrl.dispose();
    _hCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ListTile(
              title: Text(
                'BMI Calculator',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Body Mass Index', style: TextStyle(fontSize: 12)),
            ),
            // BMI INPUT
            Card(
              color: const Color(0xFF020617),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    TextField(
                      controller: _wCtrl,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Weight (kg)',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _hCtrl,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Height (cm)',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _calc,
                        child: const Text('Calculate BMI'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            // BMI RESULT
            Card(
              color: const Color(0xFF020617),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('BMI: ${_bmi?.toStringAsFixed(1) ?? '-'}'),
                    Text('Status: ${_status.isEmpty ? '-' : _status}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            // ACTIVITY STOPWATCH
            Card(
              color: const Color(0xFF020617),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      ' STOP WATCH',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Use this to time any activity (walking, workout, yoga, etc.).',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: Text(
                        _formattedTime,
                        style: const TextStyle(
                          fontSize: 32,
                          fontFeatures: [FontFeature.tabularFigures()],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isRunning ? null : _startTimer,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            child: const Text('Start'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isRunning ? _stopTimer : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                            ),
                            child: const Text('Stop'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _elapsedSeconds > 0 ? _resetTimer : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: const Text('Reset'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
