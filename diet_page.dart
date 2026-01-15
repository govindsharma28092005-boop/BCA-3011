import 'package:flutter/material.dart';

class DietPage extends StatefulWidget {
  const DietPage({super.key});

  @override
  State<DietPage> createState() => _DietPageState();
}

class _DietPageState extends State<DietPage> {
  String _level = 'beginner';
  String _sport = 'general';

  // Your original weekly diet plans
  final Map<String, List<String>> _dietPlans = {
    'beginner': [
      'Monday: Oats + milk + banana; lunch: dal + rice; dinner: light roti + sabzi; 2–3L pani.',
      'Tuesday: Poha + chai; lunch: 2 roti + sabzi; snack: curd + fruits; no cold drinks.',
      'Wednesday: Upma + chutney; lunch: brown rice + veggies; snack: handful nuts.',
      'Thursday: Paratha (kam tel) + curd; lunch: dal + rice; evening: seasonal fruits.',
      'Friday: Idli + sambar; lunch/dinner: khichdi + salad; buttermilk.',
      'Saturday: Sprouts / boiled eggs; lunch: roti + paneer; snack: salad + fruits.',
      'Sunday (Rest): Light cheat day; fried/sugar control me rakho, zyada na khao.',
    ],
    'moderate': [
      'Monday: High-fiber breakfast (oats + seeds); lunch: grilled chicken/paneer + salad; dinner: roti + dal.',
      'Tuesday: Eggs/sprouts; lunch: brown rice + dal; snack: fruit + yogurt; no soda.',
      'Wednesday: Millet (jowar/bajra) roti; lunch: mixed veg + dal; snack: seeds (chia/flax).',
      'Thursday: Protein smoothie; lunch: veg pulao + salad; dinner: light roti + sabzi.',
      'Friday: Paneer bhurji; quinoa/brown rice; fruits; 3L pani.',
      'Saturday: Boiled chana; stir-fry veggies; sweet sirf 1 chhota portion.',
      'Sunday (Rest): Clean ghar ka normal khana, junk minimal.',
    ],
    'advanced': [
      'Monday: 1.6–2 g/kg protein; complex carbs pre-workout; sab meals me veggies.',
      'Tuesday: 5–6 chhote meals; calories roughly track karo; sugar avoid.',
      'Wednesday: Lean protein (fish/chicken/tofu); deep fried zero; salad high.',
      'Thursday: Healthy fats (nuts, seeds, olive oil) controlled quantity.',
      'Friday: No sugary drinks; sirf pani, black coffee, green tea.',
      'Saturday: Strict portion control; zyada salad, boiled/steamed items.',
      'Sunday (Rest): Light carb refeed, protein high; outside junk minimal.',
    ],
  };

  /// Supplements / recovery tips per level and sport.
  /// NOTE: No specific drugs or steroid names, only general safe guidance.
  final Map<String, Map<String, List<String>>> _supplements = {
    'beginner': {
      'general': [
        'Focus on normal ghar ka khana; sabse pehle diet strong banao.',
        'Basic whey protein ya doodh + daal se protein pura karo (doctor/nutritionist se consult karke).',
        'Simple multivitamin sirf agar doctor suggest kare.[web:9]',
        'Pani 2–3L daily, ORS/electrolyte sirf zyada garmi ya heavy sweating me.',
      ],
      'running': [
        'Hydration pe focus: pani + occasional electrolyte drink.',
        'Post-run: protein source (doodh, dahi, paneer, egg) for recovery.',
        'Koi bhi supplement start karne se pahle coach/doctor se baat karo.',
      ],
      'swimming': [
        'Swim ke baad 15–30 min me protein source (doodh, dahi, paneer, eggs).',
        'Thoda sodium/electrolyte useful ho sakta hai heavy training ke baad.[web:8]',
        'Har supplement se pehle qualified professional se advice lo.',
      ],
      'cricket': [
        'Normal balanced diet + hydration pe focus.',
        'Match/practice ke baad protein + carbs (roti + dal, doodh, dahi).',
      ],
      'volleyball': [
        'Leg strength aur jumping ke liye sufficient protein zaroori.',
        'Training ke baad dahi, doodh, paneer, eggs jaisi cheezein lo.',
      ],
      'basketball': [
        'High movement sport: pani + occasional electrolyte helpful.',
        'Recovery ke liye protein‑rich snacks (eggs, paneer, sprouts).',
      ],
    },
    'moderate': {
      'general': [
        'Har meal me protein source rakho (daal, chana, rajma, paneer, eggs).',
        'Whey protein shake use kar sakte ho agar food se protein kam pad raha ho (coach/doctor se consult).',
        'Quality multivitamin only on medical advice, overdose se bacho.[web:9]',
        'Omega‑3 fats (fish, akhrot, flaxseed) diet se lo; supplement sirf doctor ki dekh‑rekh me.',
      ],
      'running': [
        'Long runs ke liye electrolyte + water, carb snack (banana, dates) helpful.',
        'Post‑run whey/plant protein shake recovery fast kar sakta hai.[web:8]',
      ],
      'swimming': [
        'Swimming me high‑intensity sets ke liye whey + balanced carbs useful.',
        'Advanced swimmers creatine/beta‑alanine kabhi‑kabhi use karte hain, but sirf coach + sports doctor ke under, anti‑doping rules follow karke.[web:8][web:11]',
      ],
      'cricket': [
        'Match se pehle light carb snack + hydration.',
        'Strength training kar rahe ho to whey protein consider kar sakte ho (coach/doctor se pooch kar).',
      ],
      'volleyball': [
        'Muscle recovery ke liye whey/plant protein + proper sleep.',
        'Electrolyte drink intense matches/practice me kabhi‑kabhi use kar sakte ho.',
      ],
      'basketball': [
        'Fast game ke liye hydration + carbs important.',
        'Strength + conditioning ke baad protein shake helpful ho sakta hai.',
      ],
    },
    'advanced': {
      'general': [
        'Protein target 1.6–2 g/kg bodyweight food + approved protein supplements se, lekin sports nutritionist se plan banwao.[web:8]',
        'Koi bhi anabolic steroids, pro‑hormones, ya banned performance‑enhancing drugs health ke liye dangerous hain aur competitive sports me illegal hain.[web:7][web:10]',
        'Advanced athletes usually doctor + sports nutritionist ke saath blood tests aur vitamin/mineral status check karwate hain.',
      ],
      'running': [
        'Endurance runners scientifically planned carbs, electrolytes, aur protein use karte hain, lekin sab kuch coach/sports‑doctor ke under.',
        'Banned stimulants ya steroids se door raho; long‑term heart, liver, hormones sab damage ho sakte hain.[web:7][web:10]',
      ],
      'swimming': [
        'High‑level swimmers me whey protein, creatine, beta‑alanine jaise supplements kabhi use hote hain, but hamesha professional supervision + anti‑doping compliance ke saath.[web:8][web:11]',
        'Random stack follow mat karo; har cheez lab tested, certified aur allowed list me honi chahiye.',
      ],
      'cricket': [
        'Strength/power ke liye periodized training + protein important.',
        'Banned substances se lifetime ban ka risk hota hai; sirf legal, tested supplements hi, woh bhi expert supervision me.',
      ],
      'volleyball': [
        'Jump + power training ke baad protein + proper recovery protocol.',
        'Performance badhane ke liye hamesha training, sleep, nutrition pe focus karo, drugs nahi.',
      ],
      'basketball': [
        'Explosive movements ke liye strength training + clean diet best “supplement” hai.',
        'Anabolics short term me help lag sakte hain but long term me serious health damage aur ban ka risk hota hai.[web:7][web:10]',
      ],
    },
  };

  @override
  Widget build(BuildContext context) {
    final plan = _dietPlans[_level]!;
    final sportSupps = _supplements[_level]![_sport]!;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ListTile(
            title: Text(
              'AI Weekly Diet Plan',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Beginner • Moderate • Advanced',
              style: TextStyle(fontSize: 12),
            ),
          ),

          // Level + Sport selectors
          Card(
            color: const Color(0xFF020617),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
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
                    const SizedBox(width: 24),
                    const Text('Sport: '),
                    const SizedBox(width: 8),
                    DropdownButton<String>(
                      value: _sport,
                      dropdownColor: const Color(0xFF020617),
                      items: const [
                        DropdownMenuItem(
                          value: 'general',
                          child: Text('General'),
                        ),
                        DropdownMenuItem(
                          value: 'running',
                          child: Text('Running'),
                        ),
                        DropdownMenuItem(
                          value: 'swimming',
                          child: Text('Swimming'),
                        ),
                        DropdownMenuItem(
                          value: 'cricket',
                          child: Text('Cricket'),
                        ),
                        DropdownMenuItem(
                          value: 'volleyball',
                          child: Text('Volleyball'),
                        ),
                        DropdownMenuItem(
                          value: 'basketball',
                          child: Text('Basketball'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() => _sport = value);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Diet + Supplements card
          Expanded(
            child: Card(
              color: const Color(0xFF020617),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: ListView(
                padding: const EdgeInsets.all(10),
                children: [
                  const Text(
                    'Weekly Diet Plan',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  ...List.generate(
                    plan.length,
                    (index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        plan[index],
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ),
                  const Divider(height: 24),
                  const Text(
                    'Supplement & Recovery Tips',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  ...List.generate(
                    sportSupps.length,
                    (index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        '• ${sportSupps[index]}',
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Disclaimer: This app does not prescribe medicines or steroids. '
                    'Supplements should only be used after consulting a doctor or certified coach.',
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
