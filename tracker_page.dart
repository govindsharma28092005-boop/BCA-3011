import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrackerPage extends StatefulWidget {
  const TrackerPage({super.key});

  @override
  State<TrackerPage> createState() => _TrackerPageState();
}

class _TrackerPageState extends State<TrackerPage> {
  StreamSubscription<StepCount>? _stepSub;

  // Raw sensor value (total steps since boot)
  int _rawSteps = 0;

  // Baseline at start of day OR when user presses Reset
  int _baseline = 0;

  // UI values (only when tracking == true)
  int _todaySteps = 0;
  double _distanceKm = 0;
  double _calories = 0;

  final _weightCtrl = TextEditingController();
  final _heightCtrl = TextEditingController();
  bool _isTracking = false;

  // User details confirmed or not
  bool _userConfirmed = false;

  // Simple in‑memory activity log
  // Each entry: {date, time, steps, distance, calories}
  final List<Map<String, dynamic>> _activityLog = [];

  static const stepLen = 0.78; // meter per step approx
  static const calPerStep = 0.04; // calories per step approx

  @override
  void initState() {
    super.initState();
    _loadBaseline();
    _initPedometer();
  }

  Future<void> _loadBaseline() async {
    final prefs = await SharedPreferences.getInstance();
    final savedDate = prefs.getString('baseline_date');
    final now = DateTime.now();
    final today = '${now.year}-${now.month}-${now.day}';

    if (savedDate == today) {
      _baseline = prefs.getInt('baseline_steps') ?? 0;
    } else {
      _baseline = 0;
      await prefs.setString('baseline_date', today);
      await prefs.setInt('baseline_steps', 0);
    }
  }

  void _initPedometer() {
    _stepSub = Pedometer.stepCountStream.listen(
      (event) async {
        _rawSteps = event.steps;

        // Agar baseline 0 hai (pehli baar), set karo
        if (_baseline == 0) {
          final prefs = await SharedPreferences.getInstance();
          _baseline = _rawSteps;
          await prefs.setInt('baseline_steps', _baseline);
        }

        // Sirf tab update karo jab tracking ON ho
        if (_isTracking) {
          _updateValues();
        }
      },
      onError: (err) {
        debugPrint('Pedometer error: $err');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Step sensor se data nahi aa raha. Device ya permissions check karo.',
              ),
            ),
          );
        }
      },
    );
  }

  bool _validHuman(double w, double h) =>
      w >= 30 && w <= 250 && h >= 120 && h <= 230;

  void _updateValues() {
    final steps = _rawSteps - _baseline;
    _todaySteps = steps < 0 ? 0 : steps;
    _distanceKm = (_todaySteps * stepLen) / 1000;
    _calories = _todaySteps * calPerStep;
    if (mounted) setState(() {});
  }

  void _start() {
    if (!_userConfirmed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill weight & height and press OK first.'),
        ),
      );
      return;
    }

    final w = double.tryParse(_weightCtrl.text) ?? 0;
    final h = double.tryParse(_heightCtrl.text) ?? 0;
    if (!_validHuman(w, h)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Enter realistic weight (30–250 kg) & height (120–230 cm).',
          ),
        ),
      );
      setState(() => _userConfirmed = false);
      return;
    }

    setState(() {
      _isTracking = true;
    });

    // Agar sensor pehle se values de raha hai, turant update
    _updateValues();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Tracking started.')));
  }

  void _stop() {
    // Agar current session me kuch steps aaye hain, to log me entry add karo
    if (_isTracking && _todaySteps > 0) {
      final now = DateTime.now();
      _activityLog.insert(0, {
        'date': '${now.day}/${now.month}/${now.year}',
        'time':
            '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
        'steps': _todaySteps,
        'distance': _distanceKm,
        'calories': _calories,
      });
    }

    setState(() {
      _isTracking = false;
    });
  }

  Future<void> _reset() async {
    final prefs = await SharedPreferences.getInstance();
    _baseline = _rawSteps;
    await prefs.setInt('baseline_steps', _baseline);

    _todaySteps = 0;
    _distanceKm = 0;
    _calories = 0;
    setState(() {});
  }

  @override
  void dispose() {
    _stepSub?.cancel();
    _weightCtrl.dispose();
    _heightCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final date = '${now.day}/${now.month}/${now.year}';

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          _header(),
          const SizedBox(height: 8),
          _summaryRow(),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              children: [
                _userCard(),
                _trackerCard(date),
                const SizedBox(height: 8),
                _activityLogCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------- UI widgets ----------

  Widget _header() => const ListTile(
    title: Text(
      'Smart Fitness Tracker',
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
    subtitle: Text(
      'Real sensor steps & distance Tracker',
      style: TextStyle(fontSize: 12),
    ),
  );

  Widget _summaryRow() => Row(
    children: [
      _summary('Steps', '$_todaySteps'),
      const SizedBox(width: 6),
      _summary('Km', _distanceKm.toStringAsFixed(2)),
      const SizedBox(width: 6),
      _summary('Cal', _calories.toStringAsFixed(0)),
    ],
  );

  Widget _summary(String label, String value) => Expanded(
    child: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: const Color(0xFF020617),
        border: Border.all(color: Colors.grey.shade700),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ),
  );

  Widget _userCard() => Card(
    color: const Color(0xFF020617),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'User Details',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _weightCtrl,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Weight (kg)',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _heightCtrl,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Height (cm)',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final w = double.tryParse(_weightCtrl.text) ?? 0;
                final h = double.tryParse(_heightCtrl.text) ?? 0;
                if (!_validHuman(w, h)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Enter realistic weight (30–250 kg) & height (120–230 cm).',
                      ),
                    ),
                  );
                  setState(() => _userConfirmed = false);
                  return;
                }
                setState(() => _userConfirmed = true);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'User details saved. You can start tracking now.',
                    ),
                  ),
                );
              },
              child: Text(_userConfirmed ? 'Details OK ✓' : 'OK'),
            ),
          ),
        ],
      ),
    ),
  );

  Widget _trackerCard(String date) => Card(
    color: const Color(0xFF020617),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Today • $date',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _summary('Steps', '$_todaySteps'),
              const SizedBox(width: 6),
              _summary('Km', _distanceKm.toStringAsFixed(2)),
              const SizedBox(width: 6),
              _summary('Cal', _calories.toStringAsFixed(0)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _start,
                  child: const Text('Start'),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: OutlinedButton(
                  onPressed: _stop,
                  child: Text(_isTracking ? 'Stop' : 'Stop'),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: ElevatedButton(
                  onPressed: _reset,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade700,
                  ),
                  child: const Text('Reset'),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  Widget _activityLogCard() => Card(
    color: const Color(0xFF020617),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Activity History',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          if (_activityLog.isEmpty)
            const Text(
              'No sessions yet. Start a walk to see history here.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            )
          else
            SizedBox(
              height: 160,
              child: ListView.builder(
                itemCount: _activityLog.length,
                itemBuilder: (context, index) {
                  final e = _activityLog[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${e['date']} • ${e['time']}',
                              style: const TextStyle(fontSize: 12),
                            ),
                            Text(
                              '${e['steps']} steps, '
                              '${e['distance'].toStringAsFixed(2)} km, '
                              '${e['calories'].toStringAsFixed(0)} cal',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    ),
  );
}
