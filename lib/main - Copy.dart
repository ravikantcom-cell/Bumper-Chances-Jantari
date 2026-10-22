import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'historical_data.dart';
import 'login_screen.dart';

final Uint8List _shivHeaderBytes = base64Decode('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');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const GuessingNumberApp());
}

class GuessingNumberApp extends StatelessWidget {
  const GuessingNumberApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bumper Chances & Jantari',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6B4EFF), brightness: Brightness.light),
        scaffoldBackgroundColor: const Color(0xFFF5F6FA),
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFFF5F6FA), foregroundColor: Color(0xFF17152A), centerTitle: false, elevation: 0),
        cardTheme: CardThemeData(color: Colors.white, elevation: 2, shadowColor: Color(0x14000000), shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18)))),
        useMaterial3: true,
      ),
      home: const MahakalWelcomeScreen(),
    );
  }
}


class MahakalWelcomeScreen extends StatefulWidget {
  const MahakalWelcomeScreen({super.key});
  @override
  State<MahakalWelcomeScreen> createState() => _MahakalWelcomeScreenState();
}

class _MahakalWelcomeScreenState extends State<MahakalWelcomeScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800), lowerBound: 0.985, upperBound: 1.025)..repeat(reverse: true);
  Timer? _timer;
  void _continue() {
    _timer?.cancel();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => LoginScreen(
          onLoginSuccess: () => const HomeScreen(),
        ),
      ),
    );
  }
  @override
  void initState() { super.initState(); _timer = Timer(const Duration(seconds: 4), _continue); }
  @override
  void dispose() { _timer?.cancel(); _pulse.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF050A13),
    body: GestureDetector(
      behavior: HitTestBehavior.opaque, onTap: _continue,
      child: Stack(fit: StackFit.expand, children: [
        ScaleTransition(scale: _pulse, child: Image.asset('assets/images/mahakal_welcome.png', fit: BoxFit.cover)),
        DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.black.withValues(alpha: .08), Colors.transparent, Colors.black.withValues(alpha: .48)]))),
        Positioned(left: 0, right: 0, bottom: 38, child: Center(child: Text('आगे बढ़ने के लिए स्क्रीन पर टैप करें', style: TextStyle(color: Colors.white.withValues(alpha: .9), fontSize: 14, fontWeight: FontWeight.w500)))),
      ]),
    ),
  );
}

// ================= HOME SCREEN =================

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _resultsSubscription;
  Map<String, Map<String, dynamic>> _liveRows = {};

  @override
  void initState() {
    super.initState();
    _resultsSubscription = FirebaseFirestore.instance.collection('results').snapshots().listen((snap) {
      if (!mounted) return;
      setState(() => _liveRows = {for (final doc in snap.docs) doc.id: doc.data()});
    }, onError: (Object error) {
      debugPrint('Home results read failed: $error');
    });
  }

  @override
  void dispose() {
    _resultsSubscription?.cancel();
    super.dispose();
  }

  static String? _validNumber(dynamic value) {
    if (value == null) return null;
    final text = value.toString().trim();
    return RegExp(r'^\d{1,2}$').hasMatch(text) ? text.padLeft(2, '0') : null;
  }

  static String? _historicalValue(HistoricalRow row, String game) {
    switch (game) {
      case 'Faridabad': return _validNumber(row.faridabad);
      case 'Ghaziabad': return _validNumber(row.ghaziabad);
      case 'Gali': return _validNumber(row.gali);
      case 'Disawar': return _validNumber(row.disawar);
      default: return null;
    }
  }

  static String _dateKey(DateTime d) => '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Map<String, _HomeLatestResult> _latestResults() {
    final merged = <String, Map<String, String>>{};
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    for (final row in historicalData) {
      if (row.dateValue.isAfter(todayDate)) continue;
      final key = _dateKey(row.dateValue);
      merged[key] = {
        for (final game in games)
          if (_historicalValue(row, game) != null) game: _historicalValue(row, game)!,
      };
    }
    for (final entry in _liveRows.entries) {
      final date = DateTime.tryParse(entry.key);
      if (date == null || DateTime(date.year, date.month, date.day).isAfter(todayDate)) continue;
      final values = merged.putIfAbsent(_dateKey(date), () => {});
      for (final game in games) {
        // A deleted official result must never fall back to bundled history.
        if (entry.value.containsKey(game)) {
          final value = _validNumber(entry.value[game]);
          if (value == null) { values.remove(game); } else { values[game] = value; }
        } else if (entry.value['deleted_$game'] == true) {
          values.remove(game);
        }
      }
    }
    final result = <String, _HomeLatestResult>{};
    final dates = merged.keys.toList()..sort((a, b) => b.compareTo(a));
    for (final key in dates) {
      for (final game in games) {
        final number = merged[key]?[game];
        if (number != null && !result.containsKey(game)) {
          result[game] = _HomeLatestResult(number, DateTime.parse(key));
        }
      }
      if (result.length == games.length) break;
    }
    return result;
  }

  static const List<String> games = [
    'Faridabad',
    'Ghaziabad',
    'Gali',
    'Disawar',
  ];

  @override
  Widget build(BuildContext context) {
    final latest = _latestResults();
    return Scaffold(
      backgroundColor: const Color(0xFF050A16),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF100C13),
              Color(0xFF08080F),
              Color(0xFF030405),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 86,
                      height: 86,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFFFC857), width: 1.4),
                        boxShadow: [BoxShadow(color: const Color(0xFFFFC857).withValues(alpha: .12), blurRadius: 10)],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.memory(_shivHeaderBytes, fit: BoxFit.cover),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Bumper Chances & Jantari',
                              style: TextStyle(
                                color: Color(0xFFFFD77B),
                                fontFamily: 'serif',
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                height: 1.15,
                                letterSpacing: .2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'जय महाकाल  •  नंबर सुझाव',
                              style: TextStyle(
                                color: Color(0xFFFFC857),
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              width: 120,
                              height: 2,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(colors: [Color(0x00FFC857), Color(0xFFFFC857), Color(0x00FFC857)]),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFFFC857), width: 1.3),
                          color: const Color(0x221B2440),
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () => _showHomeTip(context),
                          icon: const Icon(Icons.info_outline_rounded),
                          color: const Color(0xFFFFD77B),
                          iconSize: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(14, 10, 14, 16),
                  child: Column(children: [
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: games.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, crossAxisSpacing: 12,
                        mainAxisSpacing: 12, childAspectRatio: 0.83,
                      ),
                      itemBuilder: (context, index) => GameCard(gameName: games[index], latest: latest[games[index]]),
                    ),
                    const SizedBox(height: 18),
                    _MonthlyBumperPerformance(liveRows: _liveRows),
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _HomeNavItem(icon: Icons.home_rounded, label: 'होम', active: true, onTap: () {}),
                    _HomeNavItem(icon: Icons.history_rounded, label: 'पुराने रिकॉर्ड', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ResultChartScreen()))),
                    _HomeNavItem(icon: Icons.analytics_rounded, label: 'विश्लेषण', onTap: () => _openAnalysisPicker(context)),
                    _HomeNavItem(icon: Icons.settings_rounded, label: 'सेटिंग्स', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const _JantriSettingsScreen()))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Retrospective historical backtest. This is NOT an archived live prediction.
// Each target day's inputs end on the preceding calendar day.
class _BumperMonthlyStats {
  final List<int> passes = List<int>.filled(3, 0);
  final List<int> evaluated = List<int>.filled(3, 0);
}

class _BumperHistoryEngine {
  static String key(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  static String? normal(dynamic value) {
    if (value == null) return null;
    final text = value.toString().trim();
    return RegExp(r'^\d{1,2}$').hasMatch(text) ? text.padLeft(2, '0') : null;
  }

  static String? result(HistoricalRow row, String game) {
    switch (game) {
      case 'Faridabad': return normal(row.faridabad);
      case 'Ghaziabad': return normal(row.ghaziabad);
      case 'Gali': return normal(row.gali);
      case 'Disawar': return normal(row.disawar);
    }
    return null;
  }

  static List<HistoricalRow> merged(Map<String, Map<String, dynamic>> live) {
    final data = <String, HistoricalRow>{for (final r in historicalData) key(r.dateValue): r};
    for (final e in live.entries) {
      final parsed = DateTime.tryParse(e.key);
      if (parsed == null) continue;
      final date = DateTime(parsed.year, parsed.month, parsed.day);
      final k = key(date);
      final old = data[k];
      final f = e.value;
      data[k] = HistoricalRow(
        period: old?.period ?? 0,
        dateValue: date,
        disawar: f.containsKey('Disawar') ? normal(f['Disawar']) : old?.disawar,
        faridabad: f.containsKey('Faridabad') ? normal(f['Faridabad']) : old?.faridabad,
        ghaziabad: f.containsKey('Ghaziabad') ? normal(f['Ghaziabad']) : old?.ghaziabad,
        gali: f.containsKey('Gali') ? normal(f['Gali']) : old?.gali,
      );
    }
    return data.values.toList()..sort((a, b) => a.dateValue.compareTo(b.dateValue));
  }

  // A backtest prediction for 'target' sees data strictly before target.
  // No future data, no skip over missing results, no look-ahead.
  static List<Set<String>> predict(List<HistoricalRow> rows, DateTime target, String game) {
    final cutoff = DateTime(target.year, target.month, target.day);
    final previous = cutoff.subtract(const Duration(days: 1));
    final past = rows.where((r) => r.dateValue.isBefore(cutoff)).toList();
    if (past.isEmpty) return [<String>{}, <String>{}, <String>{}];
    HistoricalRow? triggerRow;
    for (final row in past.reversed) {
      if (key(row.dateValue) == key(previous)) { triggerRow = row; break; }
      if (row.dateValue.isBefore(previous)) break;
    }
    final trigger = triggerRow == null ? null : result(triggerRow, game);
    if (trigger == null) return [<String>{}, <String>{}, <String>{}];
    final nextDay = <String>[];
    for (var i = 0; i < past.length - 1; i++) {
      final row = past[i];
      if (result(row, game) != trigger) continue;
      final n = past[i + 1];
      if (key(n.dateValue) != key(row.dateValue.add(const Duration(days: 1)))) continue;
      final v = result(n, game);
      if (v != null) nextDay.add(v);
    }
    if (nextDay.isEmpty) return [<String>{}, <String>{}, <String>{}];

    final freq = List<int>.filled(10, 0);
    final inside = List<int>.filled(10, 0);
    final outside = List<int>.filled(10, 0);
    final observed = nextDay.toSet();
    for (final n in nextDay) {
      freq[int.parse(n) ~/ 10]++;
      inside[int.parse(n[0])]++;
      outside[int.parse(n[1])]++;
    }
    final ranges = List<int>.generate(10, (i) => i)
      ..sort((a, b) { final d = freq[b].compareTo(freq[a]); return d != 0 ? d : a.compareTo(b); });
    final candidates = <String>[];
    for (final range in ranges) {
      for (var n = range * 10; n < range * 10 + 10; n++) {
        final value = n.toString().padLeft(2, '0');
        if (!observed.contains(value)) candidates.add(value);
      }
    }
    final b1 = candidates.take(10).toSet();

    // Approved Bumper 2: use the remaining pool after Bumper 1 point 7;
    // highest average of inside and outside digit percentages wins.
    final b2Candidates = [...candidates]..sort((a, b) {
      final sa = inside[int.parse(a[0])] + outside[int.parse(a[1])];
      final sb = inside[int.parse(b[0])] + outside[int.parse(b[1])];
      final d = sb.compareTo(sa);
      return d != 0 ? d : a.compareTo(b);
    });
    final b2 = b2Candidates.take(10).toSet();

    final tenDayStart = previous.subtract(const Duration(days: 9));
    final recent = <String>{};
    for (final row in past) {
      if (row.dateValue.isBefore(tenDayStart)) continue;
      for (final g in _HomeScreenState.games) {
        final v = result(row, g);
        if (v != null) recent.add(v);
      }
    }
    final b3 = candidates.where((n) => !recent.contains(n)).take(10).toSet();
    return [b1, b2, b3];
  }

  // Former Bumper 4 (Bhole ka prashad), used by the new Bumper 2
  // dashboard backtest. Only dates before target are accessible.
  static Set<String> predictFormer4(List<HistoricalRow> rows,
      DateTime target, String game) {
    final day = DateTime(target.year, target.month, target.day);
    final values = <DateTime, String>{};
    for (final row in rows) {
      if (!row.dateValue.isBefore(day)) continue;
      final n = result(row, game);
      if (n != null) {
        values[DateTime(row.dateValue.year, row.dateValue.month,
          row.dateValue.day)] = n;
      }
    }
    if (values.isEmpty) return <String>{};
    final dates = values.keys.toList()..sort();
    final latest = dates.last;
    // A prediction needs its immediately preceding day's trigger.
    if (key(latest) != key(day.subtract(const Duration(days: 1)))) {
      return <String>{};
    }
    final trigger = values[latest]!;
    final recentStart = latest.subtract(const Duration(days: 9));
    final excluded = <String>{
      for (final date in dates)
        if (!date.isBefore(recentStart)) values[date]!,
    };
    final earliest3 = DateTime(latest.year - 3, latest.month, latest.day);
    final earliest5 = DateTime(latest.year - 5, latest.month, latest.day);
    List<List<String>> samples(DateTime start) {
      final a = <String>[];
      final b = <String>[];
      for (final date in dates) {
        if (date.isBefore(start) || !date.isBefore(latest)) continue;
        final next = date.add(const Duration(days: 1));
        if (!next.isBefore(latest)) continue;
        final outcome = values[next];
        if (outcome == null) continue;
        final n = values[date]!;
        if (n[0] == trigger[0]) a.add(outcome);
        if (n[1] == trigger[1]) b.add(outcome);
      }
      return [a, b];
    }
    var start = earliest3;
    var groups = samples(start);
    int overlap(DateTime minDate) {
      var count = 0;
      for (final date in dates) {
        if (date.isBefore(minDate) || !date.isBefore(latest)) continue;
        final next = date.add(const Duration(days: 1));
        if (!next.isBefore(latest) || values[next] == null) continue;
        final n = values[date]!;
        if (n[0] == trigger[0] && n[1] == trigger[1]) count++;
      }
      return count;
    }
    if (groups[0].length + groups[1].length - overlap(start) < 30) {
      start = earliest5;
      groups = samples(start);
    }
    final active = groups.where((g) => g.isNotEmpty).length;
    if (active == 0) return <String>{};
    final scores = List<double>.filled(100, 0);
    for (final group in groups) {
      if (group.isEmpty) continue;
      final exact = List<int>.filled(100, 0);
      final andar = List<int>.filled(10, 0);
      final bahar = List<int>.filled(10, 0);
      for (final outcome in group) {
        final n = int.parse(outcome);
        exact[n]++;
        andar[n ~/ 10]++;
        bahar[n % 10]++;
      }
      for (var n = 0; n < 100; n++) {
        scores[n] += 0.5 * exact[n] / group.length +
          0.5 * (andar[n ~/ 10] + bahar[n % 10]) / (2 * group.length);
      }
    }
    final thirtyStart = latest.subtract(const Duration(days: 29));
    final recentFreq = List<int>.filled(100, 0);
    for (final date in dates) {
      if (!date.isBefore(thirtyStart)) recentFreq[int.parse(values[date]!)]++;
    }
    final ranked = <int>[
      for (var n = 0; n < 100; n++)
        if (!excluded.contains(n.toString().padLeft(2, '0'))) n,
    ];
    ranked.sort((a, b) {
      final byScore = scores[b].compareTo(scores[a]);
      if (byScore != 0) return byScore;
      final byRecent = recentFreq[b].compareTo(recentFreq[a]);
      return byRecent != 0 ? byRecent : a.compareTo(b);
    });
    return ranked.take(25).map((n) => n.toString().padLeft(2, '0')).toSet();
  }

  // Bumper 5: 30-day same-game + 5-day all-games exclusions,
  // historical exact next-day outcomes occurring 2+ times excluded.
  // Remaining eligible pool is scored by historical range and two digit
  // frequencies (equal Andar/Bahar weight), then its Top 25 selected.
  // Historical samples and exclusion windows end BEFORE target date.
  static List<String> predict5(List<HistoricalRow> rows, DateTime target,
      String game, {int fromYear = 2015, int? toYear}) {
    final day = DateTime(target.year, target.month, target.day);
    final yesterday = day.subtract(const Duration(days: 1));
    final history = rows.where((r) => r.dateValue.isBefore(day)).toList()
      ..sort((a, b) => a.dateValue.compareTo(b.dateValue));
    String? trigger;
    for (final r in history.reversed) {
      if (key(r.dateValue) == key(yesterday)) {
        trigger = result(r, game);
        break;
      }
      if (r.dateValue.isBefore(yesterday)) break;
    }
    if (trigger == null) return const [];
    final sample = <String>[];
    final untilYear = toYear ?? yesterday.year;
    for (var i = 0; i < history.length - 1; i++) {
      final r = history[i];
      if (r.dateValue.year < fromYear || r.dateValue.year > untilYear) continue;
      if (result(r, game) != trigger) continue;
      if (key(history[i+1].dateValue) !=
          key(r.dateValue.add(const Duration(days: 1)))) continue;
      final next = result(history[i+1], game);
      if (next != null) sample.add(next);
    }
    if (sample.isEmpty) return const [];
    final occurrences = <String, int>{};
    final range = List<int>.filled(10, 0);
    final andar = List<int>.filled(10, 0);
    final bahar = List<int>.filled(10, 0);
    for (final n in sample) {
      occurrences[n] = (occurrences[n] ?? 0) + 1;
      range[int.parse(n) ~/ 10]++;
      andar[int.parse(n[0])]++;
      bahar[int.parse(n[1])]++;
    }
    final excluded = <String>{
      for (final entry in occurrences.entries)
        if (entry.value >= 2) entry.key,
    };
    final thirtyStart = day.subtract(const Duration(days: 30));
    final fiveStart = day.subtract(const Duration(days: 5));
    for (final r in history) {
      if (!r.dateValue.isBefore(thirtyStart)) {
        final n = result(r, game);
        if (n != null) excluded.add(n);
      }
      if (!r.dateValue.isBefore(fiveStart)) {
        for (final g in _HomeScreenState.games) {
          final n = result(r, g);
          if (n != null) excluded.add(n);
        }
      }
    }
    final ranked = <String>[
      for (var i = 0; i < 100; i++)
        if (!excluded.contains(i.toString().padLeft(2, '0')))
          i.toString().padLeft(2, '0')
    ];
    double score(String n) =>
      range[int.parse(n) ~/ 10] / sample.length +
      (andar[int.parse(n[0])] + bahar[int.parse(n[1])]) /
          (2 * sample.length);
    ranked.sort((a, b) {
      final d = score(b).compareTo(score(a));
      return d != 0 ? d : a.compareTo(b);
    });
    return ranked.take(25).toList();
  }

  static Map<String, _BumperMonthlyStats> evaluate(
    List<HistoricalRow> rows, int year, int month) {
    final now = DateTime.now();
    final currentDay = DateTime(now.year, now.month, now.day);
    final results = {for (final game in _HomeScreenState.games) game: _BumperMonthlyStats()};
    for (final row in rows) {
      final day = row.dateValue;
      if (day.year != year || day.month != month || !day.isBefore(currentDay)) continue;
      for (final game in _HomeScreenState.games) {
        final actual = result(row, game);
        if (actual == null) continue;
        final old = predict(rows, day, game);
        final combined = <String>{...old[0], ...old[1], ...old[2]};
        if (combined.isNotEmpty) {
          results[game]!.evaluated[0]++;
          if (combined.contains(actual)) results[game]!.passes[0]++;
        }
        final former4 = predictFormer4(rows, day, game);
        if (former4.length == 25) {
          results[game]!.evaluated[1]++;
          if (former4.contains(actual)) results[game]!.passes[1]++;
        }
        final former5 = predict5(rows, day, game);
        if (former5.length == 25) {
          results[game]!.evaluated[2]++;
          if (former5.contains(actual)) results[game]!.passes[2]++;
        }
      }
    }
    return results;
  }
}

class _MonthlyBumperPerformance extends StatefulWidget {
  const _MonthlyBumperPerformance({required this.liveRows});
  final Map<String, Map<String, dynamic>> liveRows;
  @override
  State<_MonthlyBumperPerformance> createState() => _MonthlyBumperPerformanceState();
}

class _MonthlyBumperPerformanceState extends State<_MonthlyBumperPerformance> {
  late int year = DateTime.now().year;
  late int month = DateTime.now().month;
  static const monthNames = ['January','February','March','April','May','June',
    'July','August','September','October','November','December'];
  @override
  Widget build(BuildContext context) {
    final currentYear = DateTime.now().year;
    final report = _BumperHistoryEngine.evaluate(
      _BumperHistoryEngine.merged(widget.liveRows), year, month);
    final totalPass = List<int>.generate(3, (i) =>
      report.values.fold<int>(0, (sum, v) => sum + v.passes[i]));
    final totalEval = List<int>.generate(3, (i) =>
      report.values.fold<int>(0, (sum, v) => sum + v.evaluated[i]));
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF1F160D), Color(0xFF080B14)]),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFFC857), width: 2),
        boxShadow: [BoxShadow(color: const Color(0xFFFFC857).withValues(alpha: .12), blurRadius: 12)]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Row(children: [Icon(Icons.emoji_events, color: Color(0xFFFFC352)),
          SizedBox(width: 8), Expanded(child: Text('Monthly Bumper Performance',
            style: TextStyle(color: Color(0xFFFFD77B), fontFamily: 'serif', fontWeight: FontWeight.w900, fontSize: 16)))]),
        const SizedBox(height: 5),
        const Text('Historical Backtest • Not saved live predictions',
          style: TextStyle(color: Color(0xFFBECFF8), fontSize: 11)),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(child: _filter(year.toString(), [for (var y = 2015; y <= currentYear; y++) y.toString()],
            (v) => setState(() { year = int.parse(v!); if (year == currentYear && month > DateTime.now().month) month = DateTime.now().month; }))),
          const SizedBox(width: 10),
          Expanded(child: _filter(monthNames[month - 1],
            [for (var m = 1; m <= (year == currentYear ? DateTime.now().month : 12); m++) monthNames[m - 1]],
            (v) => setState(() => month = monthNames.indexOf(v!) + 1))),
        ]),
        const SizedBox(height: 12),
        Row(children: [for (var i = 0; i < 3; i++) ...[
          if (i > 0) const SizedBox(width: 7),
          Expanded(child: _statTile(i, totalPass[i], totalEval[i])),
        ]]),
        const SizedBox(height: 15),
        const Text('Game-wise PASS / Evaluated', style: TextStyle(color: Colors.white,
          fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 8),
        Table(columnWidths: const {0: FlexColumnWidth(1.4), 1: FlexColumnWidth(),
          2: FlexColumnWidth(), 3: FlexColumnWidth()},
          children: [
            _row(['Game','Bumper 1','Bumper 2','Bumper 3'], heading: true),
            for (final game in _HomeScreenState.games)
              _row([game, for (var i = 0; i < 3; i++)
                '${report[game]!.passes[i]}/${report[game]!.evaluated[i]}']),
            _row(['TOTAL', for (var i = 0; i < 3; i++) '${totalPass[i]}/${totalEval[i]}'], heading: true),
          ]),
        const SizedBox(height: 10),
        const Text('PASS = actual result selected numbers mein match. Bumper 1 = former 1+2+3 unique union; '
          'Each date uses only earlier results. Missing/scheduled-off dates excluded. '
          'Bumper 2 = former Bumper 4 (25 numbers); Bumper 3 = former Bumper 5 (25 numbers).',
          style: TextStyle(color: Color(0xFFC9D4F1), fontSize: 10.5)),
      ]),
    );
  }

  Widget _filter(String selected, List<String> items, ValueChanged<String?> change) =>
    Container(padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(color: const Color(0xFF151A27),
        borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFB98C36))),
      child: DropdownButtonHideUnderline(child: DropdownButton<String>(
        isExpanded: true, value: selected,
        dropdownColor: const Color(0xFF151A27),
        style: const TextStyle(color: Colors.white, fontSize: 12),
        items: [for (final v in items) DropdownMenuItem(value: v, child: Text(v))],
        onChanged: change)));

  Widget _statTile(int i, int pass, int evaluated) {
    const colors = [Color(0xFF008E76), Color(0xFF813BE1), Color(0xFFE77821)];
    final rate = evaluated == 0 ? '—' : '${(pass / evaluated * 100).toStringAsFixed(1)}%';
    return Container(padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      decoration: BoxDecoration(color: colors[i].withValues(alpha: .34),
        borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFFFC857))),
      child: Column(children: [
        Text('Bumper ${i + 1}', style: const TextStyle(color: const Color(0xFFFFD77B), fontFamily: 'serif', fontSize: 12, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Text('$pass / $evaluated', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
        Text(rate, style: const TextStyle(color: Color(0xFFE8F5FF), fontSize: 11)),
      ]));
  }

  static TableRow _row(List<String> values, {bool heading = false}) => TableRow(
    decoration: BoxDecoration(color: heading ? const Color(0xFF263D79) : const Color(0xFF172957)),
    children: [for (final v in values) Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 9),
      child: Text(v, textAlign: TextAlign.center, maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.white,
          fontSize: 10.5, fontWeight: heading ? FontWeight.w800 : FontWeight.w500)))],
  );
}

class _JantriQuickCard extends StatelessWidget {
  const _JantriQuickCard(this.label, this.icon, this.color, this.onTap);
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Material(color: Colors.transparent,
    child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(17),
      child: Ink(decoration: BoxDecoration(borderRadius: BorderRadius.circular(17),
        gradient: LinearGradient(colors: [color, Color.lerp(color, const Color(0xFF101849), .55)!])),
        child: Padding(padding: const EdgeInsets.all(12),
          child: Row(children: [Icon(icon, color: Colors.white, size: 26), const SizedBox(width: 8),
            Expanded(child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w800)))])))));
}

class _HomeNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _HomeNavItem({
    required this.icon,
    required this.label,
    this.active = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? const Color(0xFFFFC857) : const Color(0xFF7890B8);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: active ? BoxDecoration(border: Border.all(color: const Color(0xFFFFC857), width: 1), borderRadius: BorderRadius.circular(9)) : null,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 7),
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 3),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
      ),
    );
  }
}

void _showHomeTip(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Bumper Chances & Jantari'),
      content: const Text('गेम कार्ड से भविष्यवाणी और हरुफ विश्लेषण खोलें। पुराने रिकॉर्ड में चारों गेम के रिजल्ट देखें।'),
      actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('ठीक है'))],
    ),
  );
}

void _openAnalysisPicker(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(title: Text('किस गेम का विश्लेषण देखें?', style: TextStyle(fontWeight: FontWeight.bold)), subtitle: Text('गेम चुनने पर उसका मौजूदा विश्लेषण खुलेगा')),
            for (final game in _HomeScreenState.games)
              ListTile(
                leading: const Icon(Icons.analytics_rounded, color: Color(0xFF2459D0)),
                title: Text(game),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () {
                  Navigator.pop(sheetContext);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => PredictionScreen(gameName: game)));
                },
              ),
          ],
        ),
      ),
    ),
  );
}

class _JantriSettingsScreen extends StatelessWidget {
  const _JantriSettingsScreen();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(title: const Text('सेटिंग्स')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: const LinearGradient(colors: [Color(0xFF194CA0), Color(0xFF7644BE)]),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Icon(Icons.account_circle_rounded, color: Colors.white, size: 40),
              const SizedBox(height: 8),
              const Text('मेरा अकाउंट', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(user?.email ?? user?.phoneNumber ?? 'अकाउंट जानकारी उपलब्ध नहीं', style: const TextStyle(color: Colors.white)),
            ]),
          ),
          const SizedBox(height: 18),
          Card(child: ListTile(
            leading: const Icon(Icons.history_rounded, color: Color(0xFF2459D0)),
            title: const Text('पुराने रिकॉर्ड'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ResultChartScreen())),
          )),
          Card(child: ListTile(
            leading: const Icon(Icons.analytics_rounded, color: Color(0xFF8746DD)),
            title: const Text('विश्लेषण'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _openAnalysisPicker(context),
          )),
          Card(child: ListTile(
            leading: const Icon(Icons.info_outline, color: Color(0xFF079884)),
            title: const Text('ऐप के बारे में'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showHomeTip(context),
          )),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('लॉग आउट करें?'),
                  content: const Text('आपको फिर से लॉग इन करना होगा।'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('रद्द करें')),
                    FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('लॉग आउट')),
                  ],
                ),
              );
              if (confirm != true || !context.mounted) return;
              await FirebaseAuth.instance.signOut();
              if (!context.mounted) return;
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => LoginScreen(onLoginSuccess: () => const HomeScreen())),
                (route) => false,
              );
            },
            icon: const Icon(Icons.logout_rounded),
            label: const Text('लॉग आउट'),
          ),
        ],
      ),
    );
  }
}

class _HomeLatestResult {
  const _HomeLatestResult(this.number, this.date);
  final String number;
  final DateTime date;
}

// Home-only ornamental frame. It never affects taps or game results.
class _VintageBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final pen = Paint()..color = const Color(0xFFFFCB62)
      ..style = PaintingStyle.stroke..strokeWidth = 1.0;
    final glow = Paint()..color = const Color(0xFFFFD67C).withValues(alpha: .46)
      ..style = PaintingStyle.stroke..strokeWidth = .75;
    final outer = Rect.fromLTWH(6, 6, size.width - 12, size.height - 12);
    canvas.drawRRect(RRect.fromRectAndRadius(outer, const Radius.circular(10)), glow);
    for (final sx in [1.0, -1.0]) {
      for (final sy in [1.0, -1.0]) {
        final x = sx > 0 ? 9.0 : size.width - 9.0;
        final y = sy > 0 ? 9.0 : size.height - 9.0;
        final path = Path()..moveTo(x, y + sy * 22)
          ..quadraticBezierTo(x + sx * 3, y + sy * 6, x + sx * 23, y)
          ..moveTo(x + sx * 4, y + sy * 15)
          ..quadraticBezierTo(x + sx * 13, y + sy * 13, x + sx * 15, y + sy * 4)
          ..moveTo(x + sx * 9, y + sy * 19)
          ..quadraticBezierTo(x + sx * 18, y + sy * 17, x + sx * 19, y + sy * 9);
        canvas.drawPath(path, pen);
        canvas.drawCircle(Offset(x + sx * 18, y + sy * 18), 1.6, pen);
      }
    }
    canvas.drawLine(Offset(size.width / 2 - 12, 6),
      Offset(size.width / 2 + 12, 6), pen);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class GameCard extends StatelessWidget {
  final String gameName;

  final _HomeLatestResult? latest;

  const GameCard({super.key, required this.gameName, this.latest});

  Color get cardColor {
    switch (gameName) {
      case 'Faridabad':
        return const Color(0xFF630F0F);
      case 'Ghaziabad':
        return const Color(0xFF07315C);
      case 'Gali':
        return const Color(0xFF0B4A22);
      case 'Disawar':
        return const Color(0xFF400C6D);
      default:
        return const Color(0xFF6046D8);
    }
  }

  static String _displayDate(DateTime date) {
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
  }

  IconData get gameIcon {
    switch (gameName) {
      case 'Faridabad':
        return Icons.account_balance_rounded;
      case 'Ghaziabad':
        return Icons.location_city_rounded;
      case 'Gali':
        return Icons.temple_hindu_rounded;
      case 'Disawar':
        return Icons.architecture_rounded;
      default:
        return Icons.auto_awesome_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFFFC95A);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => PredictionScreen(gameName: gameName))),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [cardColor, Color.lerp(cardColor, Colors.black, .80)!],
            ),
            border: Border.all(color: gold, width: 1.6),
            boxShadow: [BoxShadow(color: gold.withValues(alpha: .12), blurRadius: 12)],
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(child: CustomPaint(painter: _VintageBorderPainter())),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2B1B16).withValues(alpha: .7),
                    shape: BoxShape.circle,
                    border: Border.all(color: gold, width: 1.1),
                  ),
                  child: const Icon(Icons.arrow_forward_rounded, color: gold, size: 18),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
                child: Column(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: gold.withValues(alpha: .10),
                        border: Border.all(color: gold.withValues(alpha: .55)),
                      ),
                      child: Icon(gameIcon, color: gold, size: 31),
                    ),
                    const SizedBox(height: 10),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        gameName.toUpperCase(),
                        maxLines: 1,
                        style: const TextStyle(
                          color: Color(0xFFFFE5A5),
                          fontFamily: 'serif',
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          letterSpacing: .2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            latest?.number ?? '--',
                            style: const TextStyle(
                              color: Color(0xFFFFE9AD),
                              fontSize: 46,
                              fontWeight: FontWeight.w900,
                              height: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(minHeight: 34),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFB06D1E), Color(0xFFFFDA83), Color(0xFFB06D1E)],
                        ),
                        borderRadius: BorderRadius.circular(9),
                        border: Border.all(color: const Color(0xFFFFE7A3), width: 1.1),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withValues(alpha: .10), blurRadius: 5, offset: const Offset(0, 2)),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.calendar_month_rounded, size: 14, color: Color(0xFF2B1805)),
                          const SizedBox(width: 5),
                          Flexible(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                latest == null ? 'Result unavailable' : _displayDate(gameName == 'Disawar' ? DateTime.now() : latest!.date),
                                maxLines: 1,
                                style: const TextStyle(
                                  color: Color(0xFF291800),
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

class PredictionScreen extends StatefulWidget {
  final String gameName;

  const PredictionScreen({super.key, required this.gameName});

  @override
  State<PredictionScreen> createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
      _badshahSubscription;
  List<_ApprovedUserPrediction> _approvedPredictions = [];
  bool _approvedLoading = true;
  bool _approvedReadError = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _listenForBadshahNumbers();
  }

  String get todayKey {
    final now = DateTime.now();
    return '${now.year.toString().padLeft(4, '0')}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')}';
  }

  void _listenForBadshahNumbers() {
    _badshahSubscription = FirebaseFirestore.instance
        .collection('badshahNumbers')
        .snapshots()
        .listen(
      (snapshot) {
        final items = <_ApprovedUserPrediction>[];
        for (final doc in snapshot.docs) {
          final data = doc.data();
          final game = data['game']?.toString();
          final date = data['date']?.toString();
          final published = data['published'] == true;

          if (game != widget.gameName || date != todayKey || !published) {
            continue;
          }

          final rawNumbers = data['numbers'];
          final numbers = <String>[];
          if (rawNumbers is Iterable) {
            for (final value in rawNumbers) {
              final text = value.toString().trim();
              if (RegExp(r'^\d{1,2}$').hasMatch(text)) {
                numbers.add(text.padLeft(2, '0'));
              }
            }
          }
          if (numbers.isEmpty) continue;

          final rawUpdatedAt = data['updatedAt'];
          DateTime? updatedAt;
          if (rawUpdatedAt is Timestamp) {
            updatedAt = rawUpdatedAt.toDate();
          }

          items.add(
            _ApprovedUserPrediction(
              userName: (data['userName'] ?? data['publisherName'] ?? 'Admin')
                  .toString(),
              numbers: numbers.take(20).toList(),
              updatedAt: updatedAt,
            ),
          );
        }

        if (!mounted) return;
        setState(() {
          _approvedPredictions = items;
          _approvedLoading = false;
          _approvedReadError = false;
        });
      },
      onError: (_) {
        if (!mounted) return;
        setState(() {
          _approvedLoading = false;
          _approvedReadError = true;
          _approvedPredictions = [];
        });
      },
    );
  }

  @override
  void dispose() {
    _badshahSubscription?.cancel();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.gameName} Prediction',
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 0),
            child: Material(
              color: const Color(0xFFE8EBF2),
              borderRadius: BorderRadius.circular(14),
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.white,
                unselectedLabelColor: const Color(0xFF202533),
                indicator: BoxDecoration(
                  color: const Color(0xFF1769E0),
                  borderRadius: BorderRadius.circular(12),
                ),
                tabs: const [
                  Tab(text: 'बम्पर चांस'),
                  Tab(text: 'नंबर के बादशाह'),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _SystemPredictionView(gameName: widget.gameName),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                      child: _SpecialUserPublisher(gameName: widget.gameName),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                      child: _SpecialResultUploadAccess(gameName: widget.gameName),
                    ),
                    Expanded(
                      child: _ApprovedPredictionView(
                        gameName: widget.gameName,
                        loading: _approvedLoading,
                        readError: _approvedReadError,
                        predictions: _approvedPredictions,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PredictionItem {
  final String number;
  final int score;

  const _PredictionItem({required this.number, required this.score});
}

class _SystemPredictionView extends StatefulWidget {
  final String gameName;

  const _SystemPredictionView({required this.gameName});

  @override
  State<_SystemPredictionView> createState() => _SystemPredictionViewState();
}

class _SystemPredictionViewState extends State<_SystemPredictionView> {
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _subscription;
  Timer? _predictionClock;
  DateTime _predictionNow = DateTime.now();
  Map<String, Map<String, dynamic>> _liveResults = {};
  int _fromYear = 2015;
  int _toYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    _listenForLiveResults();
    // Release predictions on time without requiring another Firestore update.
    _predictionClock = Timer.periodic(const Duration(seconds: 30), (_) {
      if (!mounted) return;
      final now = DateTime.now();
      if (_predictionReleaseDay(now) != _predictionReleaseDay(_predictionNow)) {
        setState(() => _predictionNow = now);
      }
    });
  }

  // Faridabad/Ghaziabad release at next-day midnight, Gali at next-day
  // 02:00. Disawar always uses a freshly published result immediately.
  DateTime _predictionReleaseDay(DateTime now) {
    if (widget.gameName == 'Gali' && now.hour < 2) {
      return DateTime(now.year, now.month, now.day).subtract(const Duration(days: 1));
    }
    return DateTime(now.year, now.month, now.day);
  }

  DateTime _predictionAsOf() {
    if (widget.gameName == 'Disawar') return _predictionNow;
    final day = _predictionReleaseDay(_predictionNow);
    return DateTime(day.year, day.month, day.day,
        widget.gameName == 'Gali' ? 2 : 0);
  }

  bool _availableForPrediction(DateTime resultDate, String game) {
    // The deadline belongs to the *result date*, never to upload time.
    // Updating yesterday's result after its scheduled deadline releases it
    // immediately and does not add another day's delay.
    final asOf = _predictionAsOf();
    if (game == 'Disawar') {
      // Without a saved publication timestamp, only completed prior dates
      // can enter another game's time-frozen prediction calculation.
      return widget.gameName == 'Disawar' ||
          resultDate.isBefore(DateTime(asOf.year, asOf.month, asOf.day));
    }
    final release = DateTime(resultDate.year, resultDate.month,
        resultDate.day + 1, game == 'Gali' ? 2 : 0);
    return !asOf.isBefore(release);
  }

  void _listenForLiveResults() {
    _subscription = FirebaseFirestore.instance
        .collection('results')
        .snapshots()
        .listen((snapshot) {
      final live = <String, Map<String, dynamic>>{};
      for (final doc in snapshot.docs) {
        live[doc.id] = doc.data();
      }
      if (!mounted) return;
      // Use the actual current clock when a late result is uploaded.
      // Example: an Oct 18 result saved after Oct 19 midnight must
      // become available immediately, not wait until Oct 20.
      setState(() {
        _predictionNow = DateTime.now();
        _liveResults = live;
      });
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _predictionClock?.cancel();
    super.dispose();
  }

  String? _normalise(dynamic value) {
    if (value == null) return null;
    final text = value.toString().trim();
    if (!RegExp(r'^\d{1,2}$').hasMatch(text)) return null;
    return text.padLeft(2, '0');
  }

  String _keyForDate(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  String? _valueForGame(HistoricalRow row) {
    switch (widget.gameName) {
      case 'Faridabad':
        return row.faridabad;
      case 'Ghaziabad':
        return row.ghaziabad;
      case 'Gali':
        return row.gali;
      case 'Disawar':
        return row.disawar;
      default:
        return null;
    }
  }

  List<HistoricalRow> _mergedRows() {
    final byDate = <String, HistoricalRow>{
      for (final row in historicalData) _keyForDate(row.dateValue): row,
    };

    for (final entry in _liveResults.entries) {
      final date = DateTime.tryParse(entry.key);
      if (date == null) continue;

      final base = byDate[entry.key];
      final fields = entry.value;

      byDate[entry.key] = HistoricalRow(
        period: base?.period ?? 0,
        dateValue: DateTime(date.year, date.month, date.day),
        disawar: fields.containsKey('Disawar')
            ? _normalise(fields['Disawar'])
            : (fields['deleted_Disawar'] == true ? null : base?.disawar),
        faridabad: fields.containsKey('Faridabad')
            ? _normalise(fields['Faridabad'])
            : (fields['deleted_Faridabad'] == true ? null : base?.faridabad),
        ghaziabad: fields.containsKey('Ghaziabad')
            ? _normalise(fields['Ghaziabad'])
            : (fields['deleted_Ghaziabad'] == true ? null : base?.ghaziabad),
        gali: fields.containsKey('Gali')
            ? _normalise(fields['Gali'])
            : (fields['deleted_Gali'] == true ? null : base?.gali),
      );
    }

    // Freeze all source games at this prediction page's release boundary,
    // so early changes to other games cannot change Bumper rankings either.
    return byDate.values.map((row) => HistoricalRow(
      period: row.period,
      dateValue: row.dateValue,
      disawar: _availableForPrediction(row.dateValue, 'Disawar') ? row.disawar : null,
      faridabad: _availableForPrediction(row.dateValue, 'Faridabad') ? row.faridabad : null,
      ghaziabad: _availableForPrediction(row.dateValue, 'Ghaziabad') ? row.ghaziabad : null,
      gali: _availableForPrediction(row.dateValue, 'Gali') ? row.gali : null,
    )).toList()
      ..sort((a, b) => a.dateValue.compareTo(b.dateValue));
  }

  /// Exactly the same next-day matching method used by the historical
  /// analysis card: adjacent rows only, day gap must be exactly 1.
  List<String> _nextDayResultsForLatest() {
    final rows = _mergedRows();

    final rangeFrom = _fromYear <= _toYear ? _fromYear : _toYear;
    final rangeTo = _fromYear <= _toYear ? _toYear : _fromYear;

    final validRows = rows.where((row) {
      final value = _valueForGame(row);
      return row.dateValue.year >= rangeFrom &&
          row.dateValue.year <= rangeTo &&
          value != null &&
          RegExp(r'^\d{2}$').hasMatch(value);
    }).toList();

    if (validRows.isEmpty) return const [];

    final trigger = _valueForGame(validRows.last)!;

    final results = <String>[];

    for (var i = 0; i < rows.length - 1; i++) {
      final currentRow = rows[i];

      if (currentRow.dateValue.year < rangeFrom ||
          currentRow.dateValue.year > rangeTo) {
        continue;
      }

      final current = _valueForGame(currentRow);
      if (current != trigger) continue;

      final next = rows[i + 1];
      final dayGap =
          next.dateValue.difference(currentRow.dateValue).inDays;

      if (dayGap != 1) continue;

      final nextValue = _valueForGame(next);
      if (nextValue == null ||
          !RegExp(r'^\d{2}$').hasMatch(nextValue)) {
        continue;
      }

      results.add(nextValue);
    }

    return results;
  }

  /// बम्पर चान्स:
  /// - Use the latest result from the same live+historical data as the chart.
  /// - Find all occurrences of that result.
  /// - Use only immediate next-day results.
  /// - Rank 00-09 ... 90-99 ranges by their frequency in that sample.
  /// - Exclude ONLY numbers that appeared in that next-day sample.
  /// - Return 10 numbers from the highest-priority ranges.
  List<_PredictionItem> _bumperChance() {
    final nextResults = _nextDayResultsForLatest();
    if (nextResults.isEmpty) return const [];

    final rangeFrequency = List<int>.filled(10, 0);
    final excluded = <String>{};

    for (final value in nextResults) {
      final number = int.parse(value);
      rangeFrequency[number ~/ 10]++;
      excluded.add(value);
    }

    final ranges = List<int>.generate(10, (i) => i)
      ..sort((a, b) {
        final frequencyCompare =
            rangeFrequency[b].compareTo(rangeFrequency[a]);
        return frequencyCompare != 0
            ? frequencyCompare
            : a.compareTo(b);
      });

    final result = <_PredictionItem>[];

    for (final range in ranges) {
      final rangePercent =
          ((rangeFrequency[range] / nextResults.length) * 100).round();

      for (var number = range * 10; number < range * 10 + 10; number++) {
        final key = number.toString().padLeft(2, '0');
        if (excluded.contains(key)) continue;

        result.add(
          _PredictionItem(
            number: key,
            score: rangePercent,
          ),
        );

        if (result.length == 10) return result;
      }
    }

    return result;
  }

  /// Bumper 2: after Bumper 1 rule #7, exclude observed next-day numbers;
  /// rank the remaining candidates by the average Andar/Bahar digit percent.
  List<_PredictionItem> _bumperChance2() {
    final nextResults = _nextDayResultsForLatest();
    if (nextResults.isEmpty) return const [];
    final inside = List<int>.filled(10, 0);
    final outside = List<int>.filled(10, 0);
    final observed = nextResults.toSet();
    for (final value in nextResults) {
      inside[int.parse(value[0])]++;
      outside[int.parse(value[1])]++;
    }
    final candidates = <_PredictionItem>[];
    for (var n = 0; n < 100; n++) {
      final number = n.toString().padLeft(2, '0');
      if (observed.contains(number)) continue;
      final score = ((inside[int.parse(number[0])] +
        outside[int.parse(number[1])]) * 50 / nextResults.length).round();
      candidates.add(_PredictionItem(number: number, score: score));
    }
    candidates.sort((a, b) {
      final byScore = b.score.compareTo(a.score);
      return byScore != 0 ? byScore : a.number.compareTo(b.number);
    });
    return candidates.take(10).toList();
  }

  /// बम्पर चान्स -3:
  /// - Start with the same historical next-day range priority as Bumper-1.
  /// - Exclude exact numbers already present in that historical next-day sample.
  /// - Additionally exclude every number seen in ALL 4 games during the last 10 days.
  /// - Year filter applies to the historical trigger/next-day analysis.
  /// - Continue through the priority ranges until 10 eligible numbers are found.
  List<_PredictionItem> _bumperChance3() {
    final nextResults = _nextDayResultsForLatest();
    if (nextResults.isEmpty) return const [];

    final rangeFrequency = List<int>.filled(10, 0);
    final historicalExcluded = <String>{};

    for (final value in nextResults) {
      final number = int.parse(value);
      rangeFrequency[number ~/ 10]++;
      historicalExcluded.add(value);
    }

    final ranges = List<int>.generate(10, (i) => i)
      ..sort((a, b) {
        final frequencyCompare =
            rangeFrequency[b].compareTo(rangeFrequency[a]);
        return frequencyCompare != 0
            ? frequencyCompare
            : a.compareTo(b);
      });

    // Last 10 calendar days across ALL FOUR games.
    final rows = _mergedRows();
    if (rows.isEmpty) return const [];

    final latestDate = rows.last.dateValue;
    final tenDayStart = DateTime(
      latestDate.year,
      latestDate.month,
      latestDate.day,
    ).subtract(const Duration(days: 9));

    final last10Excluded = <String>{};
    for (final row in rows) {
      final date = DateTime(
        row.dateValue.year,
        row.dateValue.month,
        row.dateValue.day,
      );
      if (date.isBefore(tenDayStart) || date.isAfter(latestDate)) continue;

      final values = <String?>[
        row.disawar,
        row.faridabad,
        row.ghaziabad,
        row.gali,
      ];

      for (final value in values) {
        if (value != null && RegExp(r'^\d{2}$').hasMatch(value)) {
          last10Excluded.add(value);
        }
      }
    }

    final result = <_PredictionItem>[];
    for (final range in ranges) {
      final rangePercent =
          ((rangeFrequency[range] / nextResults.length) * 100).round();

      for (var number = range * 10; number < range * 10 + 10; number++) {
        final key = number.toString().padLeft(2, '0');

        if (historicalExcluded.contains(key)) continue;
        if (last10Excluded.contains(key)) continue;

        result.add(
          _PredictionItem(
            number: key,
            score: rangePercent,
          ),
        );

        if (result.length == 10) return result;
      }
    }

    return result;
  }

  /// Bhole ka prashad (Bumper 4): V1, game-wise, past-only data.
  /// Separate trigger sets are each normalized before combining 50/50.
  List<_PredictionItem> _bholeKaPrashad() {
    final rows = _mergedRows();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final history = rows.where((r) => !r.dateValue.isAfter(today)).toList();
    if (history.isEmpty) return const [];
    final values = <DateTime, String>{};
    for (final row in history) {
      final value = _normalise(_valueForGame(row));
      if (value != null) values[DateTime(row.dateValue.year, row.dateValue.month, row.dateValue.day)] = value;
    }
    if (values.isEmpty) return const [];
    final available = values.keys.toList()..sort();
    final latest = available.last;
    final trigger = values[latest]!;
    // Exclude the latest day and nine preceding CALENDAR days.
    final recentStart = latest.subtract(const Duration(days: 9));
    final excluded = <String>{};
    for (final date in available) {
      if (!date.isBefore(recentStart) && !date.isAfter(latest)) {
        excluded.add(values[date]!);
      }
    }
    // For a current prediction, only outcomes strictly before today can train.
    // For pre-result evaluation, the latest trigger is already known.
    final earliest = DateTime(latest.year - 3, latest.month, latest.day);
    final earliest5 = DateTime(latest.year - 5, latest.month, latest.day);
    List<List<String>> samples(DateTime start) {
      final andar = <String>[];
      final bahar = <String>[];
      for (final date in available) {
        if (date.isBefore(start) || !date.isBefore(latest)) continue;
        final nextDate = date.add(const Duration(days: 1));
        if (!nextDate.isBefore(today) || !nextDate.isBefore(latest)) continue;
        final next = values[nextDate];
        if (next == null) continue;
        final value = values[date]!;
        if (value[0] == trigger[0]) andar.add(next);
        if (value[1] == trigger[1]) bahar.add(next);
      }
      return [andar, bahar];
    }
    var groups = samples(earliest);
    var sampleStart = earliest;
    // Count unique matching trigger occurrences: a number matching both
    // Haruf signals must count as just one historical sample.
    int sampleCount(List<List<String>> g) =>
        g[0].length + g[1].length - _overlapTriggerCount(values, available,
          sampleStart, latest, today, trigger);
    if (sampleCount(groups) < 30) {
      sampleStart = earliest5;
      groups = samples(earliest5);
    }

    final score = List<double>.filled(100, 0);
    for (final set in groups) {
      if (set.isEmpty) continue;
      final exact = List<int>.filled(100, 0);
      final inDigits = List<int>.filled(10, 0);
      final outDigits = List<int>.filled(10, 0);
      for (final outcome in set) {
        final n = int.parse(outcome);
        exact[n]++;
        inDigits[n ~/ 10]++;
        outDigits[n % 10]++;
      }
      for (var n = 0; n < 100; n++) {
        final e = exact[n] / set.length;
        final h = (inDigits[n ~/ 10] + outDigits[n % 10]) / (2 * set.length);
        // 50% exact frequency, 50% digit frequency;
        // each trigger-side set contributes half when both exist.
        score[n] += 0.5 * e + 0.5 * h;
      }
    }
    final activeSets = groups.where((g) => g.isNotEmpty).length;
    if (activeSets == 0) return const [];
    final thirtyDayStart = latest.subtract(const Duration(days: 29));
    final recentFrequency = List<int>.filled(100, 0);
    for (final date in available) {
      if (!date.isBefore(thirtyDayStart) && !date.isAfter(latest)) {
        recentFrequency[int.parse(values[date]!)]++;
      }
    }
    final ranked = <int>[for (var n = 0; n < 100; n++) if (!excluded.contains(n.toString().padLeft(2, '0'))) n];
    ranked.sort((a, b) {
      final byScore = score[b].compareTo(score[a]);
      if (byScore != 0) return byScore;
      final byRecent = recentFrequency[b].compareTo(recentFrequency[a]);
      return byRecent != 0 ? byRecent : a.compareTo(b);
    });
    return ranked.take(25).map((n) => _PredictionItem(
      number: n.toString().padLeft(2, '0'),
      score: (100 * score[n] / activeSets).round(),
    )).toList();
  }

  List<_PredictionItem> _bumperChance5() {
    final rows = _mergedRows();
    final effective = widget.gameName == 'Disawar' ? _predictionNow : _predictionReleaseDay(_predictionNow);
    final cutoff = DateTime(effective.year, effective.month, effective.day);
    // Disawar should react immediately to today's saved result.
    final prior = rows.where((r) => widget.gameName == 'Disawar'
        ? !r.dateValue.isAfter(cutoff)
        : r.dateValue.isBefore(cutoff)).toList();
    if (prior.isEmpty) return const [];
    // Generate the next calendar-day prediction based on the latest same-game trigger.
    HistoricalRow? lastGame;
    for (final row in prior.reversed) {
      if (_normalise(_valueForGame(row)) != null) {lastGame = row; break;}
    }
    if (lastGame == null) return const [];
    final target = lastGame.dateValue.add(const Duration(days: 1));
    // A stale trigger should not be presented as today's prediction.
    if (target.isBefore(cutoff)) return const [];
    final numbers = _BumperHistoryEngine.predict5(rows, target,
      widget.gameName, fromYear: _fromYear, toYear: _toYear);
    return numbers.map((n) => _PredictionItem(number: n, score: 0)).toList();
  }

  int _overlapTriggerCount(Map<DateTime, String> values, List<DateTime> available,
      DateTime start, DateTime latest, DateTime today, String trigger) {
    var count = 0;
    for (final date in available) {
      if (date.isBefore(start) || !date.isBefore(latest)) continue;
      final next = date.add(const Duration(days: 1));
      if (!next.isBefore(today) || !next.isBefore(latest) || values[next] == null) continue;
      if (values[date] == trigger) count++;
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    final bumper = _bumperChance();
    final bumper2 = _bumperChance2();
    final bumper3 = _bumperChance3();
    final bumper4 = _bholeKaPrashad();
    final bumper5 = _bumperChance5();
    // Keep the three original selectors unchanged, but display each number
    // only once in the merged Bumper Chance 1 group.
    final uniqueNumbers = <String, _PredictionItem>{};
    for (final item in [...bumper, ...bumper2, ...bumper3]) {
      uniqueNumbers.putIfAbsent(item.number, () => item);
    }
    final combinedBumper1 = uniqueNumbers.values.toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 28),
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            widget.gameName == 'Disawar'
                ? 'Prediction update: result save hote hi'
                : 'Prediction update: next day ${widget.gameName == 'Gali' ? '2:00 AM' : '12:00 AM'}',
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ),
        _HistoricalChartCard(
          gameName: widget.gameName,
          predictionRows: _mergedRows(),
          onYearRangeChanged: (range) {
            if (!mounted || range.length < 2) return;
            setState(() {
              _fromYear = range[0];
              _toYear = range[1];
            });
          },
        ),
        const SizedBox(height: 16),
        _PredictionGroup(
          title: 'बम्पर चान्स',
          items: combinedBumper1,
          background: const Color(0xFFEFFBF1),
          titleColor: const Color(0xFF159447),
        ),
        const SizedBox(height: 12),
        _BholePrashadGroup(items: bumper4),
        const SizedBox(height: 12),
        _PredictionGroup(
          title: 'बम्पर चान्स -3',
          items: bumper5,
          background: const Color(0xFFE6F2FF),
          titleColor: const Color(0xFF1872B9),
        ),
        const SizedBox(height: 8),
        const Text(
          'यह historical data analysis पर आधारित ranking है, guaranteed prediction नहीं है।',
          style: TextStyle(fontSize: 11.5, color: Colors.black54),
        ),
      ],
    );
  }
}

class _PredictionDataRow {
  final DateTime date;
  final String value;

  const _PredictionDataRow({
    required this.date,
    required this.value,
  });
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionTitle({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5FF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFB8DFFF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
          const SizedBox(height: 3),
          Text(subtitle, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black54)),
        ],
      ),
    );
  }
}

class _BholePrashadGroup extends StatelessWidget {
  final List<_PredictionItem> items;
  const _BholePrashadGroup({required this.items});

  @override
  Widget build(BuildContext context) {
    const purple = Color(0xFF7132D7);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFFF1E8FF), Color(0xFFE8E1FF)]),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: purple, width: 1.2),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Row(children: [
          Icon(Icons.auto_awesome_rounded, color: purple, size: 26),
          SizedBox(width: 8),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Bumper Chance - 2', style: TextStyle(fontWeight: FontWeight.w900, color: purple, fontSize: 16)),
            Text('Bhole ka prashad', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF543086))),
          ])),
          Text('25 Numbers', style: TextStyle(color: purple, fontWeight: FontWeight.bold)),
        ]),
        const SizedBox(height: 8),
        const Text('Haruf-based hybrid • last 3 years (up to 5 if fewer than 30 samples) • same-game last 10 days excluded',
          style: TextStyle(fontSize: 11, color: Color(0xFF543086))),
        const SizedBox(height: 12),
        if (items.isEmpty) const Text('Abhi prediction ke liye sufficient historical data nahi hai.')
        else GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5, mainAxisSpacing: 7, crossAxisSpacing: 6, childAspectRatio: 1.4),
          itemBuilder: (_, index) => Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(9),
              border: Border.all(color: const Color(0xFFD3B7F8))),
            child: Text(items[index].number, style: const TextStyle(fontSize: 18, color: purple, fontWeight: FontWeight.w900)),
          ),
        ),
      ]),
    );
  }
}

class _PredictionGroup extends StatelessWidget {
  final String title;
  final List<_PredictionItem> items;
  final Color background;
  final Color titleColor;

  const _PredictionGroup({
    required this.title,
    required this.items,
    required this.background,
    required this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    final isFirst = title == 'बम्पर चान्स';
    final isSecond = title.contains('-2');
    final isThird = title.contains('-3');
    final color = isFirst ? const Color(0xFF08B86C)
        : isSecond ? const Color(0xFF9237F3)
        : isThird ? const Color(0xFF1872B9) : const Color(0xFFFF6A24);
    final icon = isFirst ? Icons.emoji_events_rounded
        : isSecond ? Icons.adjust_rounded : Icons.shield_rounded;
    final subtitle = isFirst ? 'Unique numbers from former Bumper 1 + 2 + 3'
        : isSecond ? 'Andar-Bahar Average % Based'
        : isThird ? 'Top 25 • Self 30d + All Games 5d + Historical 2+ Excluded'
        : 'Range Based (Last 10 Days Excluded)';
    final heading = isFirst ? 'Bumper Chance - 1'
        : isSecond ? 'Bumper Chance - 2'
        : 'Bumper Chance - 3';
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color.alphaBlend(color.withValues(alpha: .08), Colors.white),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: .23)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(13)),
            child: Icon(icon, color: Colors.white, size: 23)),
          const SizedBox(width: 9),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(heading, style: TextStyle(fontWeight: FontWeight.w900, color: color, fontSize: 16)),
            Text(subtitle, style: const TextStyle(fontSize: 10.5, color: Color(0xFF37465A))),
          ])),
        ]),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5, crossAxisSpacing: 5, mainAxisSpacing: 7,
            childAspectRatio: 1.32,
          ),
          itemBuilder: (context, index) {
            final item = items[index];
            return Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .75),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(item.number, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.w900)),
                Text('${item.score}%', style: const TextStyle(fontSize: 11, color: Color(0xFF43516C), fontWeight: FontWeight.w700)),
              ]),
            );
          },
        ),
      ]),
    );
  }
}

class _ApprovedUserPrediction {
  final String userName;
  final List<String> numbers;
  final DateTime? updatedAt;

  const _ApprovedUserPrediction({
    required this.userName,
    required this.numbers,
    this.updatedAt,
  });
}

// The dialog owns its controller so the controller is disposed only after
// the dialog's TextField is fully removed from the widget tree.
class _BadshahNumberDialog extends StatefulWidget {
  const _BadshahNumberDialog({required this.gameName});
  final String gameName;

  @override
  State<_BadshahNumberDialog> createState() => _BadshahNumberDialogState();
}

class _BadshahNumberDialogState extends State<_BadshahNumberDialog> {
  final TextEditingController _controller = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final values = <String>[];
    final seen = <String>{};
    for (final match in RegExp(r'\d+').allMatches(_controller.text)) {
      final n = int.tryParse(match.group(0)!);
      if (n == null || n < 0 || n > 99) continue;
      final value = n.toString().padLeft(2, '0');
      if (seen.add(value)) values.add(value);
    }
    if (values.isEmpty || values.length > 20) {
      setState(() => _error = values.isEmpty
          ? 'कम से कम 1 valid number दें।'
          : 'अधिकतम 20 नंबर।');
      return;
    }
    Navigator.of(context).pop(values);
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text('${widget.gameName} — नंबर जारी करें'),
    content: TextField(
      controller: _controller,
      autofocus: true,
      minLines: 3,
      maxLines: 5,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'अधिकतम 20 नंबर',
        hintText: 'उदाहरण: 21, 62, 01, 86, 50',
        border: const OutlineInputBorder(),
        errorText: _error,
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Cancel'),
      ),
      FilledButton(onPressed: _submit, child: const Text('जारी करें')),
    ],
  );
}

class _SpecialUserPublisher extends StatefulWidget {
  final String gameName;

  const _SpecialUserPublisher({required this.gameName});

  @override
  State<_SpecialUserPublisher> createState() => _SpecialUserPublisherState();
}

class _SpecialUserPublisherState extends State<_SpecialUserPublisher> {
  bool _loading = true;
  bool _allowed = false;
  String _userName = '';
  bool _saving = false;
  String? _permissionIssue;

  String get _todayKey {
    final now = DateTime.now();
    return '${now.year.toString().padLeft(4, '0')}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    _loadPermission();
  }

  Future<void> _loadPermission() async {
    if (mounted) setState(() { _loading = true; _permissionIssue = null; _allowed = false; });
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (mounted) setState(() { _loading = false; _permissionIssue = 'Special User account se login karein.'; });
      return;
    }

    try {
      // UID-keyed profile: only the signed-in user's record is readable.
      final profile = await FirebaseFirestore.instance.collection('specialUsers').doc(user.uid).get();
      final Map<String, dynamic>? data = profile.data();
      if (data == null) {
        if (mounted) setState(() { _loading = false; _permissionIssue = 'Is login ke liye specialUsers record nahi mila. Admin Panel mein UID aur email check karein.'; });
        return;
      }
      final games = (data['games'] as List?)?.map((e) => e.toString()).toSet() ?? {};
      final active = data['active'] != false;
      final boundUid = (data['uid'] ?? '').toString().trim();
      final correctAccount = boundUid == user.uid;

      if (mounted) {
        setState(() {
          _allowed = correctAccount && active && games.contains(widget.gameName);
          _permissionIssue = !correctAccount ? 'Firebase UID match nahi ho raha.' : !active ? 'Special User inactive hai.' : !games.contains(widget.gameName) ? '${widget.gameName} permission nahi di gayi.' : null;
          _userName = data?['name']?.toString() ?? user.displayName ?? user.email ?? 'Special User';
          _loading = false;
        });
      }
    } on FirebaseException catch (e) {
      if (mounted) setState(() { _loading = false; _permissionIssue = 'Firestore: ${e.code}. Admin se read permission check karwayein.'; });
    } catch (e) {
      if (mounted) setState(() { _loading = false; _permissionIssue = 'Access check failed: $e'; });
    }
  }

  List<String> _parseNumbers(String text) {
    final matches = RegExp(r'\d+').allMatches(text);
    final values = <String>[];
    final seen = <String>{};
    for (final match in matches) {
      final n = int.tryParse(match.group(0)!);
      if (n == null || n < 0 || n > 99) continue;
      final value = n.toString().padLeft(2, '0');
      if (seen.add(value)) values.add(value);
    }
    return values;
  }

  Future<void> _publish() async {
    if (!_allowed || _saving) return;

    final numbers = await showDialog<List<String>>(
      context: context,
      builder: (_) => _BadshahNumberDialog(gameName: widget.gameName),
    );

    if (!mounted) return;
    if (numbers == null || numbers.isEmpty) return;

    setState(() => _saving = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('Login required');

      final docId = '${_todayKey}_${widget.gameName}_${user.uid}';
      await FirebaseFirestore.instance.collection('badshahNumbers').doc(docId).set({
        'date': _todayKey,
        'game': widget.gameName,
        'numbers': numbers,
        'published': true,
        'userName': _userName,
        'publisherName': _userName,
        'publisherUid': user.uid,
        'updatedAt': FieldValue.serverTimestamp(),
        'updatedBy': user.uid,
      }, SetOptions(merge: true));

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('नंबर के बादशाह में नंबर जारी हो गए।')),
      );
    } on FirebaseException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Publish failed: ${e.message ?? e.code}')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Publish failed: $e')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Padding(padding: EdgeInsets.all(8), child: LinearProgressIndicator());
    if (!_allowed) return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(children: [
        Expanded(child: Text(_permissionIssue ?? 'Publisher permission unavailable', style: const TextStyle(fontSize: 12, color: Colors.deepOrange))),
        TextButton(onPressed: _loadPermission, child: const Text('Retry')),
      ]),
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F8FF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFB9D5FF)),
      ),
      child: Row(
        children: [
          const Icon(Icons.verified_user_rounded, color: Color(0xFF1769E0)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Special User: $_userName', style: const TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 2),
                Text('${widget.gameName} के नंबर जारी कर सकते हैं।', style: const TextStyle(fontSize: 12, color: Colors.black54)),
              ],
            ),
          ),
          FilledButton.icon(
            onPressed: _saving ? null : _publish,
            icon: _saving
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.upload_rounded, size: 18),
            label: const Text('नंबर जारी करें'),
          ),
        ],
      ),
    );
  }
}

class _ApprovedPredictionView extends StatelessWidget {
  final String gameName;
  final bool loading;
  final bool readError;
  final List<_ApprovedUserPrediction> predictions;

  const _ApprovedPredictionView({
    required this.gameName,
    required this.loading,
    required this.readError,
    required this.predictions,
  });

  Color _numberColor(int index) {
    const colors = [
      Color(0xFFFFB3BE),
      Color(0xFF9FE3FF),
      Color(0xFFFFE58A),
      Color(0xFFF6B0E8),
      Color(0xFFA8E7B7),
      Color(0xFFB8C5FF),
    ];
    return colors[index % colors.length];
  }

  Color _avatarColor(int index) {
    const colors = [
      Color(0xFF2478E8),
      Color(0xFFE83F86),
      Color(0xFF2EAE4F),
      Color(0xFF8A4DE8),
      Color(0xFFF27B18),
    ];
    return colors[index % colors.length];
  }

  String _dateText(DateTime? value) {
    if (value == null) return '';
    final d = value.toLocal();
    return '${d.day.toString().padLeft(2, '0')}-'
        '${d.month.toString().padLeft(2, '0')}-'
        '${d.year.toString().padLeft(4, '0')} '
        '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Center(child: CircularProgressIndicator());

    if (readError) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'नंबर के बादशाह के numbers अभी उपलब्ध नहीं हैं।',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (predictions.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'आज के लिए Admin द्वारा कोई नंबर publish नहीं किया गया है।',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 28),
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFF8FBFF), Color(0xFFEAF4FF)],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFC8DFFF)),
          ),
          child: const Row(
            children: [
              Text('👑', style: TextStyle(fontSize: 34)),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'नंबर के बादशाह',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF102A63),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'विशेष उपयोगकर्ताओं द्वारा जारी नंबर',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: Color(0xFF66738B),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        ...predictions.asMap().entries.map((entry) {
          final index = entry.key;
          final prediction = entry.value;
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE0E7F2)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x12000000),
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _avatarColor(index),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            prediction.userName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF15213D),
                            ),
                          ),
                          if (_dateText(prediction.updatedAt).isNotEmpty)
                            Text(
                              _dateText(prediction.updatedAt),
                              style: const TextStyle(
                                fontSize: 10.5,
                                color: Color(0xFF68748A),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF7EE),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '#${index + 1}',
                        style: const TextStyle(
                          color: Color(0xFF21883D),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 11),
                Wrap(
                  spacing: 7,
                  runSpacing: 7,
                  children: prediction.numbers.asMap().entries.map((item) {
                    return Container(
                      width: 52,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _numberColor(item.key),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Text(
                        item.value,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF172033),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class _HistoricalChartCard extends StatefulWidget {
  final String gameName;
  final List<HistoricalRow> predictionRows;
  final ValueChanged<List<int>>? onYearRangeChanged;

  const _HistoricalChartCard({required this.gameName, required this.predictionRows, this.onYearRangeChanged});

  @override
  State<_HistoricalChartCard> createState() => _HistoricalChartCardState();
}

class _HistoricalChartCardState extends State<_HistoricalChartCard> {

  int _fromYear = 2015;
  int _toYear = DateTime.now().year;

  Widget _yearDropdown({
    required int value,
    required List<int> years,
    required ValueChanged<int?> onChanged,
  }) {
    final safeValue = years.contains(value) ? value : years.first;

    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFB8C8DC)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: safeValue,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Color(0xFF25324D),
          ),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: Color(0xFF25324D),
          ),
          items: years
              .map(
                (year) => DropdownMenuItem<int>(
                  value: year,
                  child: Text(year.toString()),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  String _keyForDate(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  String? _asResult(dynamic value) {
    if (value == null) return null;
    final text = value.toString().trim();
    if (text.toUpperCase() == 'XX') return 'XX';
    if (RegExp(r'^\d{1,2}$').hasMatch(text)) return text.padLeft(2, '0');
    return null;
  }

  String? _valueForGame(HistoricalRow row) {
    switch (widget.gameName) {
      case 'Faridabad':
        return row.faridabad;
      case 'Ghaziabad':
        return row.ghaziabad;
      case 'Gali':
        return row.gali;
      case 'Disawar':
        return row.disawar;
      default:
        return null;
    }
  }

  // Parent provides data frozen at this game's scheduled release time.
  List<HistoricalRow> get mergedRows => widget.predictionRows;

  @override
  Widget build(BuildContext context) {
    final rows = mergedRows;
    final validRows = rows.where((row) {
      final value = _valueForGame(row);
      return value != null && RegExp(r'^\d{2}$').hasMatch(value);
    }).toList();

    if (validRows.isEmpty) {
      return _chartShell(
        child: const Text('No historical result available.'),
      );
    }

    final latest = validRows.last;
    final trigger = _valueForGame(latest)!;

    final availableYears = rows
        .map((row) => row.dateValue.year)
        .toSet()
        .toList()
      ..sort();

    final minYear = availableYears.first;
    final maxYear = availableYears.last;
    final safeFromYear = _fromYear.clamp(minYear, maxYear) as int;
    final safeToYear = _toYear.clamp(minYear, maxYear) as int;

    final rangeFrom = safeFromYear <= safeToYear ? safeFromYear : safeToYear;
    final rangeTo = safeFromYear <= safeToYear ? safeToYear : safeFromYear;

    final matches = <_NextDayMatch>[];
    for (var i = 0; i < rows.length - 1; i++) {
      final currentRow = rows[i];
      if (currentRow.dateValue.year < rangeFrom ||
          currentRow.dateValue.year > rangeTo) {
        continue;
      }

      final current = _valueForGame(currentRow);
      if (current != trigger) continue;

      final next = rows[i + 1];
      final dayGap = next.dateValue.difference(rows[i].dateValue).inDays;
      if (dayGap != 1) continue;

      final nextValue = _valueForGame(next);
      if (nextValue == null || !RegExp(r'^\d{2}$').hasMatch(nextValue)) {
        continue;
      }

      matches.add(
        _NextDayMatch(
          triggerDate: rows[i].dateValue,
          nextDate: next.dateValue,
          result: nextValue,
        ),
      );
    }

    final insideHits = List<int>.filled(10, 0);
    final outsideHits = List<int>.filled(10, 0);
    for (final match in matches) {
      insideHits[int.parse(match.result[0])]++;
      outsideHits[int.parse(match.result[1])]++;
    }

    final total = matches.length;
    final triggerNumber = int.parse(trigger).toString();
    final sequence = matches
        .map((match) => match.result)
        .toList()
        .reversed
        .join(';');

    // Presentation only: the historical matching/count logic above is unchanged.
    final orderedNextMatches = matches.reversed.toList();
    final orderedNextNumbers = orderedNextMatches.map((m) => m.result).toList();
    final counts = <String, int>{};
    for (final number in orderedNextNumbers) {
      counts[number] = (counts[number] ?? 0) + 1;
    }
    final repeated = counts.entries.where((e) => e.value >= 2).toList()
      ..sort((a, b) {
        final byFrequency = b.value.compareTo(a.value);
        return byFrequency != 0 ? byFrequency : a.key.compareTo(b.key);
      });

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 4),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FD),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFDCE6F5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF173B71), Color(0xFF2866B1)]),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(children: [
              const Icon(Icons.analytics_outlined, color: Colors.white, size: 27),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(widget.gameName, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                Text('$trigger Aane par', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
              ])),
              Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                decoration: BoxDecoration(color: const Color(0xFFFFDEA3), borderRadius: BorderRadius.circular(14)),
                child: Column(children: [
                  const Text('LATEST', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700)),
                  Text(trigger, style: const TextStyle(fontSize: 31, fontWeight: FontWeight.w900, color: Color(0xFF182D4A))),
                ])),
            ]),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE0E8F4))),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Row(children: [Icon(Icons.date_range_rounded, color: Color(0xFF2866B1)), SizedBox(width: 8),
                Text('Calculation Period', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15))]),
              const SizedBox(height: 9),
              Row(children: [
                Expanded(child: _yearDropdown(value: safeFromYear, years: availableYears, onChanged: (year) {
                  if (year == null) return;
                  setState(() { _fromYear = year; if (_fromYear > _toYear) _toYear = _fromYear; });
                  widget.onYearRangeChanged?.call([_fromYear, _toYear]);
                })),
                const Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Text('से', style: TextStyle(fontWeight: FontWeight.w800))),
                Expanded(child: _yearDropdown(value: safeToYear, years: availableYears, onChanged: (year) {
                  if (year == null) return;
                  setState(() { _toYear = year; if (_toYear < _fromYear) _fromYear = _toYear; });
                  widget.onYearRangeChanged?.call([_fromYear, _toYear]);
                })),
              ]),
            ]),
          ),
          const SizedBox(height: 13),
          Row(children: [
            const Expanded(child: Text('अब तक आने वाले numbers का हरुफ %', style: TextStyle(fontSize: 17, color: Color(0xFF172D53), fontWeight: FontWeight.w900))),
            Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7), decoration: BoxDecoration(color: const Color(0xFFE8EFFC), borderRadius: BorderRadius.circular(10)),
              child: Text('Matches: $total', style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF224C88)))),
          ]),
          const SizedBox(height: 10),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: _professionalDigitPanel('अंदर हरुफ', insideHits, total, const Color(0xFFEA603C))),
            const SizedBox(width: 8),
            Expanded(child: _professionalDigitPanel('बाहर हरुफ', outsideHits, total, const Color(0xFF286FE0))),
          ]),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(17), border: Border.all(color: const Color(0xFFDBE6F3))),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [const Icon(Icons.grid_view_rounded, color: Color(0xFF08A668)), const SizedBox(width: 8),
                const Expanded(child: Text('Next Day Numbers', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900))),
                Text('$total results', style: const TextStyle(color: Color(0xFF52637D), fontWeight: FontWeight.w700))]),
              const SizedBox(height: 4),
              Text('जब $triggerNumber आया था, उसके अगले दिन के परिणाम • Latest first', style: const TextStyle(fontSize: 12, color: Color(0xFF66758C))),
              const SizedBox(height: 12),
              if (orderedNextNumbers.isEmpty)
                const Text('इस result के लिए historical next-day match नहीं मिला।')
              else LayoutBuilder(builder: (context, constraints) {
                const gap = 6.0;
                final cellWidth = (constraints.maxWidth - gap * 5) / 6;
                return Wrap(spacing: gap, runSpacing: gap,
                  children: orderedNextMatches.map((match) => InkWell(
                    borderRadius: BorderRadius.circular(9),
                    onTap: () {
                      const days = ['सोमवार', 'मंगलवार', 'बुधवार', 'गुरुवार', 'शुक्रवार', 'शनिवार', 'रविवार'];
                      String formatDate(DateTime date) => '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year} (${days[date.weekday - 1]})';
                      showDialog<void>(context: context, builder: (dialogContext) => AlertDialog(
                        title: Text('${match.result} — Historical Result'),
                        content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('Game: ${widget.gameName}'),
                          const SizedBox(height: 10),
                          Text('Trigger $trigger: ${formatDate(match.triggerDate)}'),
                          const SizedBox(height: 8),
                          Text('Next day ${match.result}: ${formatDate(match.nextDate)}'),
                        ]),
                        actions: [TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: const Text('Close'))],
                      ));
                    },
                    child: Container(
                      width: cellWidth, height: 38, alignment: Alignment.center,
                      decoration: BoxDecoration(color: const Color(0xFFF3F7FC), borderRadius: BorderRadius.circular(9),
                        border: Border.all(color: const Color(0xFFDFE8F3))),
                      child: Text(match.result, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800,
                        color: Color(0xFF1C3050))),
                    ),
                  )).toList());
              }),
              const SizedBox(height: 13),
              Container(width: double.infinity, padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: const Color(0xFFF5ECFF), borderRadius: BorderRadius.circular(13)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [const Icon(Icons.repeat_rounded, color: Color(0xFF8729D3)), const SizedBox(width: 8),
                    const Expanded(child: Text('ज्यादा repeat होने वाले numbers', style: TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF6823A3)))),
                    Text('${repeated.length} नंबर', style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF6823A3)))]),
                  const SizedBox(height: 9),
                  if (repeated.isEmpty) const Text('कोई नंबर दो या अधिक बार नहीं आया।')
                  else LayoutBuilder(builder: (context, constraints) {
                    const gap = 6.0;
                    final width = (constraints.maxWidth - 2 * gap) / 3;
                    return Wrap(spacing: gap, runSpacing: gap,
                      children: repeated.map((entry) => Container(
                        width: width, padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 9),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFDDC2F7))),
                        child: Text('${entry.key}  ${entry.value} बार', textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF63209D))),
                      )).toList());
                  }),
                ]),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _professionalDigitPanel(String title, List<int> hits, int total, Color accent) {
    Color percentColor(int count) {
      if (total == 0) return const Color(0xFF9CA3AF);
      final rates = [for (final h in hits) h / total];
      final low = rates.reduce(min);
      final high = rates.reduce(max);
      final fraction = high == low ? .5 : ((count / total - low) / (high - low)).clamp(0.0, 1.0);
      if (fraction <= .5) {
        return Color.lerp(const Color(0xFFF33449), const Color(0xFFFFD029), fraction * 2)!;
      }
      return Color.lerp(const Color(0xFFFFD029), const Color(0xFF00B96B), (fraction - .5) * 2)!;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 11),
      decoration: BoxDecoration(
        color: Color.alphaBlend(accent.withValues(alpha: .05), Colors.white),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accent.withValues(alpha: .16)),
      ),
      child: Column(children: [
        Row(children: [
          Icon(Icons.track_changes_rounded, color: accent, size: 20),
          const SizedBox(width: 4),
          Expanded(child: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 15, color: accent, fontWeight: FontWeight.w900))),
        ]),
        const SizedBox(height: 10),
        const Row(children: [
          Expanded(flex: 2, child: Text('अंक', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
          Expanded(flex: 3, child: Text('कुल बार', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
          Expanded(flex: 3, child: Text('प्रतिशत', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
        ]),
        const SizedBox(height: 5),
        for (final digit in const [0,1,2,3,4,5,6,7,8,9])
          Container(
            margin: const EdgeInsets.only(bottom: 4),
            padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: .82), borderRadius: BorderRadius.circular(8)),
            child: Row(children: [
              Expanded(flex: 2, child: Center(child: Container(
                width: 27, height: 27, alignment: Alignment.center,
                decoration: BoxDecoration(color: percentColor(hits[digit]), borderRadius: BorderRadius.circular(7)),
                child: Text('$digit', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13)),
              ))),
              Expanded(flex: 3, child: Text('${hits[digit]}', textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800))),
              Expanded(flex: 3, child: Text('${total == 0 ? 0 : (hits[digit] / total * 100).round()}%',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: percentColor(hits[digit])))),
            ]),
          ),
      ]),
    );
  }

  Widget _chartShell({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFB8DFFF)),
      ),
      child: child,
    );
  }
}

class _ScreenshotHeaderCell extends StatelessWidget {
  final String text;
  final Color color;

  const _ScreenshotHeaderCell(this.text, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 74),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 8),
      color: color,
      child: Text(
        text,
        textAlign: TextAlign.center,
        maxLines: 2,
        style: const TextStyle(
          fontSize: 15,
          height: 1.0,
          fontWeight: FontWeight.w900,
          color: Colors.white,
        ),
      ),
    );
  }
}


class _ScreenshotNumberCell extends StatelessWidget {
  final String text;
  final Color background;

  const _ScreenshotNumberCell(this.text, this.background);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 54),
      alignment: Alignment.center,
      color: background,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w800,
          color: Colors.black,
        ),
      ),
    );
  }
}

class _ScreenshotCountCell extends StatelessWidget {
  final String text;
  final Color background;

  const _ScreenshotCountCell(this.text, this.background);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 54),
      alignment: Alignment.center,
      color: background,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),
    );
  }
}

class _ScreenshotPercentCell extends StatelessWidget {
  final int value;

  const _ScreenshotPercentCell(this.value);

  Color _heatColor(int value) {
    final v = value.clamp(0, 30) / 30.0;

    if (v <= 0.20) {
      return Color.lerp(
        const Color(0xFFFF8A8A),
        const Color(0xFFFFB56B),
        v / 0.20,
      )!;
    }

    if (v <= 0.50) {
      return Color.lerp(
        const Color(0xFFFFB56B),
        const Color(0xFFFFE66D),
        (v - 0.20) / 0.30,
      )!;
    }

    return Color.lerp(
      const Color(0xFFFFE66D),
      const Color(0xFF62DC78),
      (v - 0.50) / 0.50,
    )!;
  }

  @override
  Widget build(BuildContext context) {
    final background = _heatColor(value);
    final foreground =
        value <= 7 ? const Color(0xFF991B1B) : const Color(0xFF073B18);

    return Container(
      constraints: const BoxConstraints(minHeight: 54),
      alignment: Alignment.center,
      color: const Color(0xFFEAF3FF),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 7, vertical: 6),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 3),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(13),
        ),
        child: Text(
          '$value%',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w900,
            color: foreground,
          ),
        ),
      ),
    );
  }
}


class _NextDayMatch {
  final DateTime triggerDate;
  final DateTime nextDate;
  final String result;

  const _NextDayMatch({
    required this.triggerDate,
    required this.nextDate,
    required this.result,
  });
}


// ================= RESULT CHART =================

class ResultChartScreen extends StatefulWidget {
  const ResultChartScreen({super.key});

  @override
  State<ResultChartScreen> createState() => _ResultChartScreenState();
}

class _ResultChartScreenState extends State<ResultChartScreen> {
  late int selectedYear;
  late int selectedMonth;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _resultsSubscription;
  Map<String, Map<String, dynamic>> _liveResults = {};

  static const List<String> monthNamesHindi = [
    'जनवरी', 'फरवरी', 'मार्च', 'अप्रैल', 'मई', 'जून',
    'जुलाई', 'अगस्त', 'सितम्बर', 'अक्टूबर', 'नवम्बर', 'दिसम्बर',
  ];

  String _keyForDate(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  String? _asResult(dynamic value) {
    if (value == null) return null;
    final text = value.toString().trim();
    if (text.toUpperCase() == 'XX') return 'XX';
    if (RegExp(r'^\d{1,2}$').hasMatch(text)) return text.padLeft(2, '0');
    return null;
  }

  List<HistoricalRow> get mergedRows {
    final byDate = <String, HistoricalRow>{
      for (final row in historicalData) _keyForDate(row.dateValue): row,
    };

    for (final entry in _liveResults.entries) {
      final date = DateTime.tryParse(entry.key);
      if (date == null) continue;
      final base = byDate[entry.key];
      final fields = entry.value;
      byDate[entry.key] = HistoricalRow(
        period: base?.period ?? 0,
        dateValue: DateTime(date.year, date.month, date.day),
        disawar: fields.containsKey('Disawar')
            ? _asResult(fields['Disawar'])
            : (fields['deleted_Disawar'] == true ? null : base?.disawar),
        faridabad: fields.containsKey('Faridabad')
            ? _asResult(fields['Faridabad'])
            : (fields['deleted_Faridabad'] == true ? null : base?.faridabad),
        ghaziabad: fields.containsKey('Ghaziabad')
            ? _asResult(fields['Ghaziabad'])
            : (fields['deleted_Ghaziabad'] == true ? null : base?.ghaziabad),
        gali: fields.containsKey('Gali')
            ? _asResult(fields['Gali'])
            : (fields['deleted_Gali'] == true ? null : base?.gali),
      );
    }

    return byDate.values.toList()
      ..sort((a, b) => a.dateValue.compareTo(b.dateValue));
  }

  void _listenForLiveResults() {
    _resultsSubscription = FirebaseFirestore.instance
        .collection('results')
        .snapshots()
        .listen(
      (snapshot) {
        if (!mounted) return;
        final next = <String, Map<String, dynamic>>{};
        for (final doc in snapshot.docs) {
          next[doc.id] = doc.data();
        }
        setState(() => _liveResults = next);
      },
      onError: (Object error) {
        // Bundled historical data remains available if Firestore is offline.
      },
    );
  }

  List<(int, int)> get availableMonths {
    final keys = mergedRows
        .map((row) => (row.year, row.month))
        .toSet()
        .toList()
      ..sort((a, b) {
        final yearCompare = a.$1.compareTo(b.$1);
        return yearCompare != 0 ? yearCompare : a.$2.compareTo(b.$2);
      });
    return keys;
  }

  @override
  void initState() {
    super.initState();
    final latest = availableMonths.isNotEmpty
        ? availableMonths.last
        : (DateTime.now().year, DateTime.now().month);
    selectedYear = latest.$1;
    selectedMonth = latest.$2;
    _listenForLiveResults();
  }

  List<int> get availableYears =>
      availableMonths.map((item) => item.$1).toSet().toList()..sort();

  List<int> get availableMonthsForYear => availableMonths
      .where((item) => item.$1 == selectedYear)
      .map((item) => item.$2)
      .toList();

  int get selectedMonthIndex =>
      availableMonths.indexOf((selectedYear, selectedMonth));

  void moveMonth(int direction) {
    final index = selectedMonthIndex + direction;
    if (index < 0 || index >= availableMonths.length) return;
    setState(() {
      selectedYear = availableMonths[index].$1;
      selectedMonth = availableMonths[index].$2;
    });
  }

  List<HistoricalRow> get periodRows => mergedRows
      .where((row) => row.year == selectedYear && row.month == selectedMonth)
      .toList()
    ..sort((a, b) => a.dateValue.compareTo(b.dateValue));

  @override
  void dispose() {
    _resultsSubscription?.cancel();
    super.dispose();
  }

  String display(String? value) => value ?? 'XX';

  String formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';

  Widget _monthButton({
    required String text,
    required IconData icon,
    required VoidCallback? onPressed,
    required bool iconOnLeft,
  }) {
    return SizedBox(
      width: 44,
      height: 44,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1264E8),
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(0xFF9EBCE8),
          disabledForegroundColor: Colors.white70,
          elevation: 0,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Icon(icon, size: 26),
      ),
    );
  }

  Widget _monthButtonRight({
    required String text,
    required VoidCallback? onPressed,
  }) {
    return SizedBox(
      width: 44,
      height: 44,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1264E8),
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(0xFF9EBCE8),
          disabledForegroundColor: Colors.white70,
          elevation: 0,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Icon(Icons.chevron_right_rounded, size: 26),
      ),
    );
  }

  Widget _selector<T>({
    required T value,
    required List<T> values,
    required String Function(T) label,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFF9AAAC0), width: 1.2),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 7),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: values.contains(value) ? value : null,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
          style: const TextStyle(
            color: Color(0xFF10233B),
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
          items: values
              .map((item) => DropdownMenuItem<T>(
                    value: item,
                    child: Text(label(item)),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _headerCell(String text, Color color) {
    return Container(
      height: 42,
      alignment: Alignment.center,
      color: color,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _tableCell(String text, {bool bold = false}) {
    return Container(
      height: 36,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        border: Border(
          right: BorderSide(color: Color(0xFFD0DCE8), width: 0.8),
          bottom: BorderSide(color: Color(0xFFD0DCE8), width: 0.8),
        ),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: const Color(0xFF111111),
          fontSize: 12,
          fontWeight: bold ? FontWeight.w800 : FontWeight.w500,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rows = periodRows;
    final years = availableYears;
    final months = availableMonthsForYear;
    final canPrevious = selectedMonthIndex > 0;
    final canNext = selectedMonthIndex >= 0 &&
        selectedMonthIndex < availableMonths.length - 1;

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFD),
      appBar: AppBar(
        backgroundColor: const Color(0xFF06284E),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: const Text(
          'इतिहास डेटा (सभी गेम)',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'होम',
            onPressed: () => Navigator.of(context)
                .popUntil((route) => route.isFirst),
            icon: const Icon(Icons.home_rounded, color: Colors.white, size: 28),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(12, 14, 12, 12),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final compact = constraints.maxWidth < 600;
                  if (compact) {
                    return Column(
                      children: [
                        Row(
                          children: [
                            _monthButton(
                              text: 'पिछला महीना',
                              icon: Icons.chevron_left_rounded,
                              iconOnLeft: true,
                              onPressed: canPrevious ? () => moveMonth(-1) : null,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              flex: 3,
                              child: _selector<int>(
                                value: selectedMonth,
                                values: months,
                                label: (m) => monthNamesHindi[m - 1],
                                onChanged: (m) {
                                  if (m != null) {
                                    setState(() => selectedMonth = m);
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              flex: 3,
                              child: _selector<int>(
                                value: selectedYear,
                                values: years,
                                label: (y) => '$y',
                                onChanged: (y) {
                                  if (y == null) return;
                                  final yearMonths = availableMonths
                                      .where((item) => item.$1 == y)
                                      .map((item) => item.$2)
                                      .toList();
                                  setState(() {
                                    selectedYear = y;
                                    selectedMonth = yearMonths.contains(selectedMonth)
                                        ? selectedMonth
                                        : yearMonths.last;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 6),
                            _monthButtonRight(
                              text: 'अगला महीना',
                              onPressed: canNext ? () => moveMonth(1) : null,
                            ),
                          ],
                        ),
                      ],
                    );
                  }

                  return Row(
                    children: [
                      _monthButton(
                        text: 'पिछला महीना',
                        icon: Icons.chevron_left_rounded,
                        iconOnLeft: true,
                        onPressed: canPrevious ? () => moveMonth(-1) : null,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 3,
                        child: _selector<int>(
                          value: selectedMonth,
                          values: months,
                          label: (m) => monthNamesHindi[m - 1],
                          onChanged: (m) {
                            if (m != null) setState(() => selectedMonth = m);
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 3,
                        child: _selector<int>(
                          value: selectedYear,
                          values: years,
                          label: (y) => '$y',
                          onChanged: (y) {
                            if (y == null) return;
                            final yearMonths = availableMonths
                                .where((item) => item.$1 == y)
                                .map((item) => item.$2)
                                .toList();
                            setState(() {
                              selectedYear = y;
                              selectedMonth = yearMonths.contains(selectedMonth)
                                  ? selectedMonth
                                  : yearMonths.last;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      _monthButtonRight(
                        text: 'अगला महीना',
                        onPressed: canNext ? () => moveMonth(1) : null,
                      ),
                    ],
                  );
                },
              ),
            ),
            Expanded(
              child: rows.isEmpty
                  ? const Center(
                      child: Text(
                        'इस महीने का कोई परिणाम उपलब्ध नहीं है।',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(12, 2, 12, 12),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: const Color(0xFFD0DCE8)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: SingleChildScrollView(
                          child: Table(
                            columnWidths: const {
                              0: FlexColumnWidth(1.12),
                              1: FlexColumnWidth(1),
                              2: FlexColumnWidth(1.15),
                              3: FlexColumnWidth(1.15),
                              4: FlexColumnWidth(1),
                            },
                            children: [
                              TableRow(
                                children: [
                                  _headerCell('तारीख', const Color(0xFF092A50)),
                                  _headerCell('DISAWAR', const Color(0xFF5717D9)),
                                  _headerCell('FARIDABAD', const Color(0xFFF21C2B)),
                                  _headerCell('GHAZIABAD', const Color(0xFF1261D8)),
                                  _headerCell('GALI', const Color(0xFF00943B)),
                                ],
                              ),
                              ...rows.asMap().entries.map((entry) {
                                final index = entry.key;
                                final row = entry.value;
                                final shade = index.isEven
                                    ? const Color(0xFFF9FCFF)
                                    : const Color(0xFFEAF4FC);
                                return TableRow(
                                  decoration: BoxDecoration(color: shade),
                                  children: [
                                    _tableCell(formatDate(row.dateValue)),
                                    _tableCell(display(row.disawar), bold: true),
                                    _tableCell(display(row.faridabad), bold: true),
                                    _tableCell(display(row.ghaziabad), bold: true),
                                    _tableCell(display(row.gali), bold: true),
                                  ],
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultNumber extends StatelessWidget {
  final String value;

  const _ResultNumber({required this.value});

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }
}

// ================= HISTORICAL DATA =================

class HistoricalDataScreen extends StatefulWidget {
  final String gameName;

  const HistoricalDataScreen({super.key, required this.gameName});

  @override
  State<HistoricalDataScreen> createState() => _HistoricalDataScreenState();
}

class _HistoricalDataScreenState extends State<HistoricalDataScreen> {
  final TextEditingController searchController = TextEditingController();
  String search = '';

  String? valueForGame(HistoricalRow row) {
    switch (widget.gameName) {
      case 'Disawar':
        return row.disawar;
      case 'Faridabad':
        return row.faridabad;
      case 'Ghaziabad':
        return row.ghaziabad;
      case 'Gali':
        return row.gali;
      default:
        return null;
    }
  }

  List<HistoricalRow> get filteredRows {
    final query = search.trim().toLowerCase();
    final rows = historicalData.where((row) {
      final number = valueForGame(row);
      if (number == null) return false;
      if (query.isEmpty) return true;
      return number == query ||
          row.date.toString() == query ||
          'period ${row.period}'.contains(query);
    }).toList();

    return rows.reversed.toList();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rows = filteredRows;

    return Scaffold(
      appBar: AppBar(title: Text('${widget.gameName} History')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: searchController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Search number or day',
                hintText: 'Example: 28 or 15',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: search.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          searchController.clear();
                          setState(() => search = '');
                        },
                      ),
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() => search = value),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${rows.length} records • ${historicalData.length} total rows',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
          Expanded(
            child: rows.isEmpty
                ? const Center(child: Text('No matching historical data.'))
                : ListView.builder(
                    itemCount: rows.length,
                    itemBuilder: (context, index) {
                      final row = rows[index];
                      final number = valueForGame(row)!;
                      return ListTile(
                        leading: CircleAvatar(
                          child: Text(row.date.toString()),
                        ),
                        title: Text(
                          'Period ${row.period} • Day ${row.date}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: const Text('Historical database'),
                        trailing: Text(
                          number,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ================= ANDAR / BAHAR =================

class AndarBaharScreen extends StatefulWidget {
  final String gameName;

  const AndarBaharScreen({super.key, required this.gameName});

  @override
  State<AndarBaharScreen> createState() => _AndarBaharScreenState();
}

class _AndarBaharScreenState extends State<AndarBaharScreen> {
  final TextEditingController controller = TextEditingController();

  String leftDigit = '-';
  String rightDigit = '-';

  void analyzeNumber() {
    final value = controller.text.trim();

    if (value.length != 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a 2-digit number, e.g. 28')),
      );
      return;
    }

    setState(() {
      leftDigit = value[0];
      rightDigit = value[1];
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.gameName} - Andar/Bahar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller,
              maxLength: 2,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter Number',
                hintText: '28',
                border: OutlineInputBorder(),
              ),
            ),
            ElevatedButton(
              onPressed: analyzeNumber,
              child: const Text('Analyze'),
            ),
            const SizedBox(height: 24),
            Table(
              border: TableBorder.all(),
              children: [
                const TableRow(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('Digit', textAlign: TextAlign.center),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('Left', textAlign: TextAlign.center),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('Right', textAlign: TextAlign.center),
                    ),
                  ],
                ),
                ...List.generate(10, (index) {
                  final digit = index.toString();
                  return TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(digit, textAlign: TextAlign.center),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          digit == leftDigit ? '1' : '0',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          digit == rightDigit ? '1' : '0',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


/// Official results uploader. Separate from Number Ke Badshah publisher access.
class _SpecialResultUploadAccess extends StatefulWidget {
  final String gameName;
  const _SpecialResultUploadAccess({required this.gameName});

  @override
  State<_SpecialResultUploadAccess> createState() => _SpecialResultUploadAccessState();
}

class _SpecialResultUploadAccessState extends State<_SpecialResultUploadAccess> {
  bool _allowed = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (mounted) setState(() { _allowed = false; _loading = false; });
      return;
    }
    try {
      final doc = await FirebaseFirestore.instance
          .collection('specialUsers').doc(user.uid).get();
      final profile = doc.data();
      final games = (profile?['games'] as List?)?.map((e) => e.toString()).toList() ?? <String>[];
      final allowed = profile?['active'] == true &&
          profile?['uid'] == user.uid &&
          profile?['canUploadResults'] == true &&
          games.contains(widget.gameName);
      if (mounted) setState(() { _allowed = allowed; _loading = false; });
    } catch (_) {
      if (mounted) setState(() { _allowed = false; _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const SizedBox.shrink();
    if (!_allowed) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        width: double.infinity,
        child: FilledButton.icon(
          icon: const Icon(Icons.edit_calendar_rounded),
          label: const Text('All Games Result Add / Edit'),
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => _SpecialResultEditor(gameName: widget.gameName),
          )),
        ),
      ),
    );
  }
}

class _SpecialResultEditor extends StatefulWidget {
  final String gameName;
  const _SpecialResultEditor({required this.gameName});
  @override
  State<_SpecialResultEditor> createState() => _SpecialResultEditorState();
}

class _SpecialResultEditorState extends State<_SpecialResultEditor> {
  static const _games = ['Faridabad', 'Ghaziabad', 'Gali', 'Disawar'];
  DateTime _date = DateTime.now();
  final Map<String, TextEditingController> _controllers = {
    for (final game in _games) game: TextEditingController(),
  };
  bool _saving = false;
  final Map<String, String> _originalValues = {};
  String? _message;

  String get _dateKey => '${_date.year.toString().padLeft(4, '0')}-'
      '${_date.month.toString().padLeft(2, '0')}-'
      '${_date.day.toString().padLeft(2, '0')}';

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) { controller.dispose(); }
    super.dispose();
  }

  Future<void> _load() async {
    for (final controller in _controllers.values) { controller.clear(); }
    _originalValues.clear();
    try {
      final doc = await FirebaseFirestore.instance.collection('results').doc(_dateKey).get();
      if (!mounted) return;
      setState(() {
        for (final game in _games) {
          final value = doc.data()?[game]?.toString() ?? '';
          _controllers[game]!.text = value;
          _originalValues[game] = value;
        }
        _message = null;
      });
    } on FirebaseException catch (e) {
      if (mounted) setState(() => _message = 'Read error: ${e.code}');
    }
  }

  Future<void> _chooseDate() async {
    final chosen = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2015),
      lastDate: DateTime.now(),
    );
    if (chosen != null && mounted) {
      setState(() => _date = chosen);
      await _load();
    }
  }

  Future<Set<String>> _verifyPermission() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return {};
    final doc = await FirebaseFirestore.instance.collection('specialUsers').doc(user.uid).get();
    final data = doc.data();
    if (data?['active'] != true || data?['uid'] != user.uid || data?['canUploadResults'] != true) {
      return {};
    }
    return (data?['games'] as List?)?.map((e) => e.toString()).where(_games.contains).toSet() ?? {};
  }

  Future<void> _save() async {
    if (_saving) return;
    final changed = <String, String>{};
    for (final game in _games) {
      final raw = _controllers[game]!.text.trim();
      if (raw.isEmpty) continue;
      if (!RegExp(r'^\d{1,2}$').hasMatch(raw)) {
        setState(() => _message = '$game: 00 se 99 tak valid result dalein.');
        return;
      }
      final normalized = raw.padLeft(2, '0');
      if (normalized != (_originalValues[game] ?? '')) changed[game] = normalized;
    }
    if (changed.isEmpty) {
      setState(() => _message = 'Koi naya ya changed result nahi hai.');
      return;
    }
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    setState(() { _saving = true; _message = null; });
    try {
      final allowed = await _verifyPermission();
      if (!changed.keys.every(allowed.contains)) {
        throw FirebaseException(plugin: 'cloud_firestore', code: 'permission-denied',
            message: 'Admin Panel se sabhi selected games ka access enable karein.');
      }
      final succeeded = <String>[];
      final failed = <String>[];
      final ref = FirebaseFirestore.instance.collection('results').doc(_dateKey);
      // Each write modifies one game, matching Firestore's game-wise ACL.
      for (final entry in changed.entries) {
        try {
          await ref.set({
            'date': _dateKey,
            entry.key: entry.value,
            'deleted_${entry.key}': false,
            'updatedBy': user.uid,
            'updatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
          succeeded.add(entry.key);
        } on FirebaseException catch (error) {
          failed.add('${entry.key} (${error.code})');
        }
      }
      if (!mounted) return;
      // Successful fields remain visible; failed entries can be retried.
      for (final game in succeeded) {
        _originalValues[game] = changed[game]!;
      }
      setState(() => _message =
          '${succeeded.length} result saved.' +
          (failed.isEmpty ? '' : ' Failed: ${failed.join(', ')}'));
    } on FirebaseException catch (e) {
      if (mounted) setState(() => _message = 'Save failed: ${e.message ?? e.code}');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _deleteGameResult(String game) async {
    if (_saving || (_originalValues[game] ?? '').isEmpty) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('$game result delete karein?'),
        content: Text('$_dateKey ka $game result permanently delete hoga. Baaki games ke results unchanged rahenge.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(dialogContext, true), child: const Text('Delete')),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() { _saving = true; _message = null; });
    try {
      final allowed = await _verifyPermission();
      if (!allowed.contains(game)) {
        throw FirebaseException(plugin: 'cloud_firestore', code: 'permission-denied',
          message: 'Admin Panel se $game result edit/delete permission chahiye.');
      }
      // Delete only the selected game field, NOT the entire date document.
      // A transaction avoids deleting a value changed by another publisher since loading.
      final ref = FirebaseFirestore.instance.collection('results').doc(_dateKey);
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(ref);
        if (!snapshot.exists) {
          throw FirebaseException(plugin: 'cloud_firestore', code: 'not-found',
              message: 'Result record nahi mila.');
        }
        final currentValue = snapshot.data()?[game]?.toString() ?? '';
        if (currentValue != _originalValues[game]) {
          throw FirebaseException(plugin: 'cloud_firestore', code: 'aborted',
              message: 'Result kisi aur ne update kiya hai. Reload karke try karein.');
        }
        transaction.update(ref, {
          game: FieldValue.delete(),
          // Tombstone prevents hardcoded historical data restoring this result.
          'deleted_$game': true,
          'updatedBy': FirebaseAuth.instance.currentUser!.uid,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      });
      if (!mounted) return;
      _controllers[game]!.clear();
      _originalValues[game] = '';
      setState(() => _message = '$game ($_dateKey) result deleted. Baaki results safe hain.');
    } on FirebaseException catch (e) {
      if (mounted) setState(() => _message = 'Delete failed: ${e.message ?? e.code}');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Games Result Add / Edit')),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        const Text('Official Results — All Four Games',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text('Ek hi date par ek ya sabhi games update karein. Saved result ke saath Delete icon hai. Blank fields unchanged rahenge. Har game separately save hoga aur permission zaroori hai.'),
        const SizedBox(height: 16),
        OutlinedButton.icon(onPressed: _chooseDate,
            icon: const Icon(Icons.calendar_month), label: Text('Result date: $_dateKey')),
        const SizedBox(height: 16),
        for (final game in _games) ...[
          Row(children: [
            Expanded(child: TextField(controller: _controllers[game],
              keyboardType: TextInputType.number,
              maxLength: 2,
              decoration: InputDecoration(labelText: '$game Result (00–99)',
                  border: const OutlineInputBorder()),
            )),
            const SizedBox(width: 8),
            IconButton(
              tooltip: '$game ka saved result delete karein',
              onPressed: _saving || (_originalValues[game] ?? '').isEmpty
                  ? null : () => _deleteGameResult(game),
              icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
            ),
          ]),
          const SizedBox(height: 8),
        ],
        FilledButton.icon(
          onPressed: _saving ? null : _save,
          icon: const Icon(Icons.save_rounded),
          label: Text(_saving ? 'Saving...' : 'Save / Update Games'),
        ),
        if (_message != null) Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text(_message!, style: const TextStyle(fontWeight: FontWeight.w600)),
        ),
      ]),
    );
  }
}
