import 'package:flutter/material.dart';

class AiDailyPage extends StatefulWidget {
  const AiDailyPage({super.key});

  @override
  State<AiDailyPage> createState() => _AiDailyPageState();
}

class _AiDailyPageState extends State<AiDailyPage> {
  String _level = 'beginner'; // beginner / moderate / advanced
  String _focus = 'steps_fatloss'; // steps_fatloss / strength / endurance
  int _yesterdaySteps = 0;
  late List<_TaskItem> _tasks;

  @override
  void initState() {
    super.initState();
    _generateTasks();
  }

  // Approx calories = steps * 0.04 (rough estimate, 70kg person) [web:48][web:56]
  int _estimateCaloriesFromSteps(int steps) {
    return (steps * 0.04).round();
  }

  void _generateTasks() {
    final List<_TaskItem> baseTasks = [];

    // ----- 1. STEP TARGET + CALORIES -----
    int stepTarget;
    if (_level == 'beginner') {
      stepTarget = _yesterdaySteps < 3000 ? 4000 : 6000;
    } else if (_level == 'moderate') {
      stepTarget = _yesterdaySteps < 6000 ? 8000 : 10000;
    } else {
      stepTarget = _yesterdaySteps < 9000 ? 10000 : 12000;
    }
    final estCal = _estimateCaloriesFromSteps(stepTarget);

    baseTasks.add(
      _TaskItem(
        title: 'Walk $stepTarget steps (~$estCal kcal)',
        detail: 'Tracker tab se steps & calories track karo.',
      ),
    );

    // ----- 2. HYDRATION -----
    baseTasks.add(
      _TaskItem(
        title: 'Drink 2–3 liters of water',
        detail: 'Morning se night tak thoda‑thoda paani piyo.',
      ),
    );

    // ----- 3. WORKOUT BASED ON FOCUS -----
    if (_focus == 'steps_fatloss') {
      _buildFatLossBlock(baseTasks);
    } else if (_focus == 'strength') {
      _buildStrengthBlock(baseTasks);
    } else {
      _buildEnduranceBlock(baseTasks);
    }

    // ----- 4. NUTRITION -----
    baseTasks.add(
      _TaskItem(
        title: '1 high‑protein & clean meal',
        detail:
            'Examples: dal + roti, paneer bhurji, eggs, curd + chana, ya whey shake.',
      ),
    );

    // ----- 5. RECOVERY / SLEEP -----
    baseTasks.add(
      _TaskItem(
        title: 'No screens 30 min before sleep',
        detail: 'Deep sleep se recovery, hormones & fat loss better hote hain.',
      ),
    );

    setState(() {
      _tasks = baseTasks;
    });
  }

  void _buildFatLossBlock(List<_TaskItem> baseTasks) {
    if (_level == 'beginner') {
      baseTasks.addAll([
        _TaskItem(
          title: '2 × 10 min easy walk after meals',
          detail: 'Lunch & dinner ke baad halka walk.',
        ),
        _TaskItem(
          title: '10 min mobility (hips, shoulders, ankles)',
          detail: 'YouTube / simple stretching follow kar sakte ho.',
        ),
      ]);
    } else if (_level == 'moderate') {
      baseTasks.addAll([
        _TaskItem(
          title: '20 min brisk walk / light jog',
          detail: 'Heart rate thoda upar, par baat kar pao aise pace pe.',
        ),
        _TaskItem(
          title: '10–15 min bodyweight circuit (no rest)',
          detail: 'Squats, pushups, mountain climbers, jumping jacks.',
        ),
      ]);
    } else {
      baseTasks.addAll([
        _TaskItem(
          title: '25–30 min interval cardio',
          detail: '1 min fast walk/run + 1 min easy, 10–12 rounds.',
        ),
        _TaskItem(
          title: 'Core finisher (3 rounds)',
          detail: 'Plank, side plank, leg raises, hollow hold.',
        ),
      ]);
    }
  }

  void _buildStrengthBlock(List<_TaskItem> baseTasks) {
    if (_level == 'beginner') {
      baseTasks.addAll([
        _TaskItem(
          title: '3 × week full‑body (aaj ka session)',
          detail: '2 sets: squats, wall pushups, hip bridge, row with band.',
        ),
        _TaskItem(
          title: '5–10 min warm‑up',
          detail: 'Arm circles, leg swings, light walk.',
        ),
      ]);
    } else if (_level == 'moderate') {
      baseTasks.addAll([
        _TaskItem(
          title: 'Upper body strength (today)',
          detail: '3 sets: pushups, rows, shoulder taps, dips (8–12 reps).',
        ),
        _TaskItem(
          title: '10 min cool‑down stretching',
          detail: 'Chest, shoulders, hips, hamstrings stretch.',
        ),
      ]);
    } else {
      baseTasks.addAll([
        _TaskItem(
          title: 'Power / strength session',
          detail:
              'Heavy compound lifts / advanced bodyweight (as per your gym plan).',
        ),
        _TaskItem(
          title: 'Walk 5–10 min after workout',
          detail: 'Lactic acid flush + recovery improve hoti hai.',
        ),
      ]);
    }
  }

  void _buildEnduranceBlock(List<_TaskItem> baseTasks) {
    if (_level == 'beginner') {
      baseTasks.addAll([
        _TaskItem(
          title: '15 min easy continuous walk',
          detail: 'Jog nahi, sirf steady comfortable walk.',
        ),
        _TaskItem(
          title: 'Ankle & calf stretching 5 min',
          detail: 'Running me injury risk kam hota hai.',
        ),
      ]);
    } else if (_level == 'moderate') {
      baseTasks.addAll([
        _TaskItem(
          title: '20–25 min steady run / cycle',
          detail: '1 pace choose karo, pura time sustain karne ki koshish.',
        ),
        _TaskItem(
          title: 'Short strides / sprints (6–8 × 10–15 sec)',
          detail: 'Har sprint ke baad 45–60 sec slow walk.',
        ),
      ]);
    } else {
      baseTasks.addAll([
        _TaskItem(
          title: '30–40 min mixed intervals',
          detail: '3–4 min fast + 2 min easy, 6–8 rounds.',
        ),
        _TaskItem(
          title: 'Electrolyte + hydration during/after',
          detail: 'Long endurance me sodium + water maintain karo.',
        ),
      ]);
    }
  }

  int get _completedCount => _tasks.where((t) => t.done).length;

  @override
  Widget build(BuildContext context) {
    final completion = _tasks.isEmpty
        ? 0
        : ((_completedCount / _tasks.length) * 100).round();

    // calories estimate show ke लिए overall bhi
    final dayStepTarget = _tasks.isNotEmpty ? _yesterdaySteps : 0;
    final approxDayCal = _estimateCaloriesFromSteps(dayStepTarget);

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          const ListTile(
            title: Text(
              'AI Daily Activity Plan',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Adaptive plan from your steps, level & focus',
              style: TextStyle(fontSize: 12),
            ),
          ),
          _topRow(completion, approxDayCal),
          const SizedBox(height: 8),
          Expanded(child: _taskListCard()),
          const SizedBox(height: 6),
          _noteCard(),
          const SizedBox(height: 8),
          _finishButton(),
        ],
      ),
    );
  }

  Widget _topRow(int completion, int approxCal) => Row(
    children: [
      Expanded(child: _levelCard()),
      const SizedBox(width: 8),
      Expanded(child: _yesterdayStepsCard(approxCal)),
      const SizedBox(width: 8),
      _completionCard(completion),
    ],
  );

  Widget _levelCard() => Card(
    color: const Color(0xFF020617),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    child: Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Level',
            style: TextStyle(fontSize: 11, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          DropdownButton<String>(
            value: _level,
            dropdownColor: const Color(0xFF020617),
            isDense: true,
            underline: const SizedBox(),
            items: const [
              DropdownMenuItem(value: 'beginner', child: Text('Beginner')),
              DropdownMenuItem(value: 'moderate', child: Text('Moderate')),
              DropdownMenuItem(value: 'advanced', child: Text('Advanced')),
            ],
            onChanged: (value) {
              if (value == null) return;
              _level = value;
              _generateTasks();
            },
          ),
          const SizedBox(height: 8),
          const Text(
            'Focus',
            style: TextStyle(fontSize: 11, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          DropdownButton<String>(
            value: _focus,
            dropdownColor: const Color(0xFF020617),
            isDense: true,
            underline: const SizedBox(),
            items: const [
              DropdownMenuItem(
                value: 'steps_fatloss',
                child: Text('Steps / Fat loss'),
              ),
              DropdownMenuItem(value: 'strength', child: Text('Strength')),
              DropdownMenuItem(value: 'endurance', child: Text('Endurance')),
            ],
            onChanged: (value) {
              if (value == null) return;
              _focus = value;
              _generateTasks();
            },
          ),
        ],
      ),
    ),
  );

  Widget _yesterdayStepsCard(int approxCal) => Card(
    color: const Color(0xFF020617),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    child: Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Yesterday steps (0–10000)',
            style: TextStyle(fontSize: 11, color: Colors.grey),
          ),
          const SizedBox(height: 2),
          SizedBox(
            height: 28,
            child: TextField(
              keyboardType: const TextInputType.numberWithOptions(
                decimal: false,
              ),
              decoration: const InputDecoration(
                isDense: true,
                hintText: 'e.g. 4500',
              ),
              onSubmitted: (val) {
                int v = int.tryParse(val) ?? 0;
                if (v < 0) v = 0;
                if (v > 10000) v = 10000;
                _yesterdaySteps = v;
                _generateTasks();
              },
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Approx burn ~${_estimateCaloriesFromSteps(_yesterdaySteps)} kcal',
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
    ),
  );

  Widget _completionCard(int completion) => Card(
    color: const Color(0xFF020617),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    child: SizedBox(
      width: 80,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            const Text(
              'Today',
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              '$completion%',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text(
              'done',
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _taskListCard() => Card(
    color: const Color(0xFF020617),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    child: ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _tasks.length,
      itemBuilder: (context, index) {
        final task = _tasks[index];
        return CheckboxListTile(
          value: task.done,
          onChanged: (v) {
            setState(() {
              task.done = v ?? false;
            });
          },
          title: Text(
            task.title,
            style: TextStyle(
              fontSize: 14,
              decoration: task.done ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: Text(
            task.detail,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: const EdgeInsets.symmetric(vertical: 2),
        );
      },
    ),
  );

  Widget _noteCard() => Card(
    color: const Color(0xFF020617),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    child: const Padding(
      padding: EdgeInsets.all(8),
      child: Text(
        'Note: Plan simple AI rules par based hai .',
        style: TextStyle(fontSize: 11, color: Colors.grey),
      ),
    ),
  );

  Widget _finishButton() => SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: () {
        final allDone = _tasks.isNotEmpty && _completedCount == _tasks.length;
        final message = allDone
            ? 'All tasks done – Good job!'
            : 'Please complete the above tasks.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF22C55E),
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Text(
        'Finish Today',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
  );
}

class _TaskItem {
  final String title;
  final String detail;
  bool done;

  _TaskItem({required this.title, required this.detail, this.done = false});
}
