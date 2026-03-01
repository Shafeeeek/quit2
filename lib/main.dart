import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(const QuitSmokingApp());
}

class QuitSmokingApp extends StatelessWidget {
  const QuitSmokingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quit Smoking',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF136F63)),
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _slideAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..forward();

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<double>(begin: 30, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.1, 0.8, curve: Curves.easeOutCubic),
      ),
    );
    _scaleAnimation = Tween<double>(begin: 0.92, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOutBack),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goToDashboard() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 700),
        pageBuilder: (_, _, _) => const HomeScreen(),
        transitionsBuilder: (_, animation, _, child) {
          final offsetAnimation = Tween<Offset>(
            begin: const Offset(0.25, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(position: offsetAnimation, child: child),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF103A37), Color(0xFF1A7F72), Color(0xFF67C5B8)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (_, _) {
                return Opacity(
                  opacity: _fadeAnimation.value,
                  child: Transform.translate(
                    offset: Offset(0, _slideAnimation.value),
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 108,
                              height: 108,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.55),
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.favorite_rounded,
                                color: Colors.white,
                                size: 52,
                              ),
                            ),
                            const SizedBox(height: 26),
                            const Text(
                              'Welcome Back',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Track your progress, reduce cravings, and stay in control one day at a time.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withValues(alpha: 0.9),
                                height: 1.45,
                              ),
                            ),
                            const SizedBox(height: 34),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _goToDashboard,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: const Color(0xFF0E5D54),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  textStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                child: const Text('Start Journey'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final Map<DateTime, int> _dailyLog = {};
  late final AnimationController _liveIconController;

  double pricePerCigarette = 5;

  double stressLevel = 3;
  double sleepHours = 6;

  DateTime startDate = DateTime.now();

  /// 🧠 Weekly Data (Mock AI Learning Data)
  /// Index 0 = Monday ... 6 = Sunday
  List<int> weeklyData = [8, 10, 7, 6, 5, 4, 3];

  @override
  void initState() {
    super.initState();
    _liveIconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
  }

  @override
  void dispose() {
    _liveIconController.dispose();
    super.dispose();
  }

  DateTime _dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);

  int _countForDate(DateTime date) => _dailyLog[_dateOnly(date)] ?? 0;

  int get cigarettesToday => _countForDate(DateTime.now());

  int get cigarettesThisMonth {
    final now = DateTime.now();
    int total = 0;
    _dailyLog.forEach((date, count) {
      if (date.year == now.year && date.month == now.month) {
        total += count;
      }
    });
    return total;
  }

  int get cigarettesThisYear {
    final now = DateTime.now();
    int total = 0;
    _dailyLog.forEach((date, count) {
      if (date.year == now.year) {
        total += count;
      }
    });
    return total;
  }

  void addCigarette() {
    setState(() {
      final today = _dateOnly(DateTime.now());
      _dailyLog[today] = cigarettesToday + 1;
      weeklyData[DateTime.now().weekday - 1]++;
    });
  }

  void removeCigarette() {
    if (cigarettesToday > 0) {
      setState(() {
        final today = _dateOnly(DateTime.now());
        _dailyLog[today] = cigarettesToday - 1;
        final dayIndex = DateTime.now().weekday - 1;
        if (weeklyData[dayIndex] > 0) {
          weeklyData[dayIndex]--;
        }
      });
    }
  }

  double get moneySpent => cigarettesToday * pricePerCigarette;

  int get daysSinceStart =>
      DateTime.now().difference(startDate).inDays;

  _HarmEffectData get _harmEffect {
    final monthlyCount = cigarettesThisMonth;

    if (monthlyCount >= 120) {
      return const _HarmEffectData(
        title: "Severe Harm Risk",
        message:
            "High cigarette volume can seriously damage lungs and heart over time.",
        emoji: "🫁",
        pictureColors: [Color(0xFF7F1D1D), Color(0xFFDC2626)],
        accent: Color(0xFFB42318),
        background: Color(0xFFFEE4E2),
      );
    }
    if (monthlyCount >= 60) {
      return const _HarmEffectData(
        title: "Moderate Harm Signs",
        message:
            "Breathing strain and blood vessel stress can increase with this level.",
        emoji: "❤️",
        pictureColors: [Color(0xFF9A3412), Color(0xFFEA580C)],
        accent: Color(0xFFB54708),
        background: Color(0xFFFFF3D8),
      );
    }
    if (monthlyCount >= 20) {
      return const _HarmEffectData(
        title: "Early Harm Phase",
        message:
            "Even low regular smoking can irritate lungs and reduce oxygen flow.",
        emoji: "🌫️",
        pictureColors: [Color(0xFF92400E), Color(0xFFF59E0B)],
        accent: Color(0xFFB26A00),
        background: Color(0xFFFFF8E1),
      );
    }
    return const _HarmEffectData(
      title: "Low Exposure",
      message:
          "You are at a lower exposure level now. Keeping this low protects your body.",
      emoji: "🛡️",
      pictureColors: [Color(0xFF065F46), Color(0xFF10B981)],
      accent: Color(0xFF067647),
      background: Color(0xFFE8FFF3),
    );
  }

  int get _quitScore {
    final month = cigarettesThisMonth;
    final risk = getCravingRisk();
    int base = 100 - (month ~/ 2) - (cigarettesToday * 3);
    if (risk == "HIGH") base -= 20;
    if (risk == "MEDIUM") base -= 10;
    if (base < 0) return 0;
    if (base > 100) return 100;
    return base;
  }

  List<_RecommendationItem> _buildRecommendations(String risk) {
    final month = cigarettesThisMonth;
    final List<_RecommendationItem> items = [];

    if (risk == "HIGH") {
      items.add(
        const _RecommendationItem(
          icon: Icons.phone_in_talk_rounded,
          title: "Call Support Now",
          detail: "Message a friend or coach when craving starts.",
        ),
      );
      items.add(
        const _RecommendationItem(
          icon: Icons.timer_rounded,
          title: "Use 10-Min Delay",
          detail: "Delay smoking 10 minutes and drink water first.",
        ),
      );
    } else if (risk == "MEDIUM") {
      items.add(
        const _RecommendationItem(
          icon: Icons.self_improvement_rounded,
          title: "2-Min Breathing",
          detail: "Use slow breathing when urge intensity rises.",
        ),
      );
      items.add(
        const _RecommendationItem(
          icon: Icons.directions_walk_rounded,
          title: "Take a Walk",
          detail: "Walk for 5-10 minutes to interrupt the trigger loop.",
        ),
      );
    } else {
      items.add(
        const _RecommendationItem(
          icon: Icons.verified_rounded,
          title: "Protect Your Streak",
          detail: "You are in a safer zone, avoid known smoking triggers.",
        ),
      );
    }

    if (month >= 100) {
      items.add(
        const _RecommendationItem(
          icon: Icons.medical_information_rounded,
          title: "Plan Professional Help",
          detail: "Consider clinic support and nicotine replacement options.",
        ),
      );
    } else {
      items.add(
        const _RecommendationItem(
          icon: Icons.event_available_rounded,
          title: "Set Daily Limit",
          detail: "Reduce by 1 cigarette every 2 days this week.",
        ),
      );
    }

    items.add(
      const _RecommendationItem(
        icon: Icons.bedtime_rounded,
        title: "Improve Sleep Tonight",
        detail: "Sleep earlier to lower evening cravings.",
      ),
    );

    return items;
  }

  ////////////////////////////////////////////////////////////
  /// AI CRAVING PREDICTION
  ////////////////////////////////////////////////////////////

  String getCravingRisk() {
    int score = 0;

    if (cigarettesToday > 10) {
      score += 3;
    } else if (cigarettesToday > 5) score += 2;
    else if (cigarettesToday > 0) score += 1;

    if (stressLevel >= 4) {
      score += 3;
    } else if (stressLevel >= 3) score += 2;

    if (sleepHours < 5) {
      score += 2;
    } else if (sleepHours < 7) score += 1;

    int hour = DateTime.now().hour;
    if (hour >= 18) score += 2;

    if (score >= 7) return "HIGH";
    if (score >= 4) return "MEDIUM";
    return "LOW";
  }

  ////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    String risk = getCravingRisk();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ////////////////////////////////////////////////////
            /// COUNTER CARD
            ////////////////////////////////////////////////////

            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text("Cigarettes Today",
                        style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 10),
                    _buildLiveCigaretteIcon(),
                    const SizedBox(height: 10),
                    Text(
                      "$cigarettesToday",
                      style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: removeCigarette,
                          icon: const Icon(Icons.remove_circle),
                        ),
                        IconButton(
                          onPressed: addCigarette,
                          icon: const Icon(Icons.add_circle),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                child: Row(
                  children: [
                    _CountTile(
                      label: "Day",
                      value: cigarettesToday,
                      color: const Color(0xFF0E5D54),
                    ),
                    _CountTile(
                      label: "Month",
                      value: cigarettesThisMonth,
                      color: const Color(0xFF2A9D8F),
                    ),
                    _CountTile(
                      label: "Year",
                      value: cigarettesThisYear,
                      color: const Color(0xFF457B9D),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            _buildHarmEffectCard(),

            const SizedBox(height: 20),

            _buildRecommendationDashboard(risk),

            const SizedBox(height: 20),

            ////////////////////////////////////////////////////
            /// 📊 WEEKLY CHART
            ////////////////////////////////////////////////////

            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [

                    const Text(
                      "Weekly Smoking Trend",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      height: 200,
                      child: BarChart(
                        BarChartData(
                          borderData: FlBorderData(show: false),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: true),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget:
                                    (value, meta) {
                                  const days = [
                                    "M",
                                    "T",
                                    "W",
                                    "T",
                                    "F",
                                    "S",
                                    "S"
                                  ];
                                  return Text(
                                      days[value.toInt()]);
                                },
                              ),
                            ),
                          ),
                          barGroups: List.generate(
                            weeklyData.length,
                            (index) => BarChartGroupData(
                              x: index,
                              barRods: [
                                BarChartRodData(
                                  toY:
                                      weeklyData[index]
                                          .toDouble(),
                                  width: 18,
                                  borderRadius:
                                      BorderRadius.circular(
                                          4),
                                  color: Colors.green,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            ////////////////////////////////////////////////////
            /// AI RISK CARD
            ////////////////////////////////////////////////////

            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [

                    const Text(
                      "AI Craving Risk",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      risk,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: risk == "HIGH"
                            ? Colors.red
                            : risk == "MEDIUM"
                                ? Colors.orange
                                : Colors.green,
                      ),
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

  Widget _buildLiveCigaretteIcon() {
    return AnimatedBuilder(
      animation: _liveIconController,
      builder: (context, child) {
        final phase = _liveIconController.value;
        final phaseTwo = (phase + 0.4) % 1.0;
        final pulse = phase <= 0.5 ? 0.96 + (phase * 0.2) : 1.06 - ((phase - 0.5) * 0.2);

        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.deepOrange.withValues(alpha: 0.12 + (phase * 0.12)),
              ),
            ),
            Transform.scale(
              scale: pulse,
              child: const Icon(
                Icons.smoking_rooms,
                size: 40,
                color: Colors.deepOrange,
              ),
            ),
            Positioned(
              right: 18,
              top: 10 - (phase * 10),
              child: Opacity(
                opacity: 1 - phase,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white70,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 26,
              top: 14 - (phaseTwo * 11),
              child: Opacity(
                opacity: 1 - phaseTwo,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white60,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHarmEffectCard() {
    final effect = _harmEffect;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Harm Effect Picture (This Month: $cigarettesThisMonth)",
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            AnimatedContainer(
              duration: const Duration(milliseconds: 450),
              curve: Curves.easeOutCubic,
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: effect.background,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: effect.accent.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    transitionBuilder: (child, animation) => ScaleTransition(
                      scale: animation,
                      child: FadeTransition(opacity: animation, child: child),
                    ),
                    child: Container(
                      key: ValueKey(effect.title),
                      width: 82,
                      height: 82,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: effect.pictureColors,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: effect.accent.withValues(alpha: 0.25),
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          effect.emoji,
                          style: const TextStyle(fontSize: 36),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          effect.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: effect.accent,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          effect.message,
                          style: const TextStyle(fontSize: 13.5, height: 1.35),
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
    );
  }

  Widget _buildRecommendationDashboard(String risk) {
    final recommendations = _buildRecommendations(risk);
    final score = _quitScore;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Recommendation Dashboard",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Quit Score: $score/100",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text(
                  "Risk: $risk",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: risk == "HIGH"
                        ? Colors.red
                        : risk == "MEDIUM"
                            ? Colors.orange
                            : Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: score / 100,
                minHeight: 11,
                backgroundColor: Colors.grey.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(
                  score < 40
                      ? const Color(0xFFDC2626)
                      : score < 70
                          ? const Color(0xFFD97706)
                          : const Color(0xFF059669),
                ),
              ),
            ),
            const SizedBox(height: 14),
            ...recommendations.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: const Color(0xFFF4F7F9),
                    border: Border.all(color: const Color(0xFFD6DEE5)),
                  ),
                  child: Row(
                    children: [
                      Icon(item.icon, size: 22, color: const Color(0xFF1F4C48)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item.detail,
                              style: const TextStyle(fontSize: 13, height: 1.3),
                            ),
                          ],
                        ),
                      ),
                    ],
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

class _CountTile extends StatelessWidget {
  const _CountTile({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: color.withValues(alpha: 0.24),
          ),
        ),
        child: Column(
          children: [
            Text(
              "$value",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HarmEffectData {
  const _HarmEffectData({
    required this.title,
    required this.message,
    required this.emoji,
    required this.pictureColors,
    required this.accent,
    required this.background,
  });

  final String title;
  final String message;
  final String emoji;
  final List<Color> pictureColors;
  final Color accent;
  final Color background;
}

class _RecommendationItem {
  const _RecommendationItem({
    required this.icon,
    required this.title,
    required this.detail,
  });

  final IconData icon;
  final String title;
  final String detail;
}
