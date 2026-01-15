import 'package:flutter/material.dart';

class TrainingPage extends StatefulWidget {
  const TrainingPage({super.key});

  @override
  State<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  String _level = 'beginner';

  final Map<String, List<String>> _trainingPlans = {
    'beginner': [
      'Monday: 20 min normal walk + light stretching.',

      'Tuesday: 10 min walk + 2 set x 10 bodyweight squats + 10 wall pushups.',

      'Wednesday: Rest day ya sirf halki walk.',

      'Thursday: 20–25 min brisk walk (thodi tezz).',

      'Friday: 2 set: 10 squats, 10 lunges (each leg), 10 knee pushups.',

      'Saturday: 20 min walk + 5 min deep breathing / light yoga.',

      'Sunday (Rest): Full rest + mobility (joint rotation).',
    ],
    'moderate': [
      'Monday: 10 min jog + 3 set: squats, pushups, plank 20s.',

      'Tuesday: 30 min brisk walk ya easy jog.',

      'Wednesday: Lower body: squats, lunges, glute bridge, 3 set each.',

      'Thursday: Upper body: pushups, dips, rows (band/bench), 3 set.',

      'Friday: 20 min HIIT (30s work / 30s rest, 8–10 round).',

      'Saturday: Core (plank, leg raise, crunches) + stretching.',

      'Sunday (Rest): Active rest – halki walk/yoga sirf.',
    ],
    'advanced': [
      'Monday: Heavy legs: squats, deadlifts, lunges (4 set).',

      'Tuesday: Push day: bench press, pushups, shoulder press, dips.',

      'Wednesday: Pull day: rows, pullups/chinups, face pulls, curls.',

      'Thursday: HIIT cardio 25–30 min (sprints / cycle).',

      'Friday: Full body compound: squats, bench, rows, overhead press.',

      'Saturday: Core & mobility: long stretching, core circuits.',

      'Sunday (Rest): Complete rest ya sirf bahut light walk.',
    ],
  };

  @override
  Widget build(BuildContext context) {
    final plan = _trainingPlans[_level]!;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ListTile(
            title: Text(
              'AI Weekly Training Plan',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Beginner • Moderate • Advanced',
              style: TextStyle(fontSize: 12),
            ),
          ),
          Card(
            color: const Color(0xFF020617),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  const Text('Level: '),
                  const SizedBox(width: 8),
                  DropdownButton<String>(
                    value: _level,
                    dropdownColor: const Color(0xFF020617),
                    items: const [
                      DropdownMenuItem(
                        value: 'beginner',
                        child: Text('Beginner'),
                      ),
                      DropdownMenuItem(
                        value: 'moderate',
                        child: Text('Moderate'),
                      ),
                      DropdownMenuItem(
                        value: 'advanced',
                        child: Text('Advanced'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => _level = value);
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Card(
              color: const Color(0xFF020617),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: plan.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      plan[index],
                      style: const TextStyle(fontSize: 13),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
