// lib/screens/home_screen.dart

import 'package:fittracker/screens/history_page.dart';
import 'package:fittracker/screens/profile_page.dart';
import 'package:fittracker/screens/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/meal.dart';
import 'select_or_add_meal_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final Box<Meal> mealBox = Hive.box<Meal>('meals');

  static const int maxCalories = 2000,
      maxProtein = 200,
      maxCarbs = 275,
      maxFats = 70;

  int _currentDayOffset = 0;
  List<Meal> _todaysMeals = [];

  late final AnimationController _slideController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
  )..forward();
  late final Animation<Offset> _slideAnimation = Tween<Offset>(
    begin: const Offset(0, 0.3),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

  late FlutterLocalNotificationsPlugin _notifications;

  @override
  void initState() {
    super.initState();
    tzdata.initializeTimeZones();
    _initNotifications();
    _scheduleDailyReminder();
  }

  Future<void> _initNotifications() async {
    _notifications = FlutterLocalNotificationsPlugin();
    await _notifications.initialize(const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    ));
  }

  Future<void> _scheduleDailyReminder() async {
    final now = tz.TZDateTime.now(tz.local);
    var sched = tz.TZDateTime(tz.local, now.year, now.month, now.day, 20);
    if (sched.isBefore(now)) sched = sched.add(const Duration(days: 1));
    await _notifications.zonedSchedule(
      0,
      'Log Your Meals',
      'Don\'t forget to add today\'s meals!',
      sched,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_reminder',
          'Daily Reminder',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {});
  }

  Future<void> _openSelectOrAddMealScreen() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (_) => const SelectOrAddMealScreen()),
    );
    if (result != null && result.containsKey('meal') && result.containsKey('save')) {
      final meal = result['meal'] as Meal;
      final save = result['save'] as bool;
      await mealBox.add(meal);
      if (save) {
        final Box<Meal> savedBox = Hive.box<Meal>('saved_meals');
        await savedBox.add(meal);
      }
      setState(() {});
    }
  }

  void _previousDay() => setState(() => _currentDayOffset++);
  void _nextDay() {
    if (_currentDayOffset > 0) setState(() => _currentDayOffset--);
  }

  void _prepareTodaysMeals(List<Meal> meals) {
    final key = DateFormat('yyyy-MM-dd').format(
      DateTime.now().subtract(Duration(days: _currentDayOffset)),
    );
    _todaysMeals = meals
        .where((m) => DateFormat('yyyy-MM-dd').format(m.dateTime) == key)
        .toList();
  }

  List<BarChartGroupData> _buildWeeklyBarData(List<Meal> meals) {
    final now = DateTime.now().subtract(Duration(days: _currentDayOffset));
    return List.generate(7, (i) {
      final day = now.subtract(Duration(days: i));
      final label = DateFormat('yyyy-MM-dd').format(day);
      final sum = meals
          .where((m) => DateFormat('yyyy-MM-dd').format(m.dateTime) == label)
          .fold(0, (t, m) => t + m.calories);
      final pct = (sum / maxCalories).clamp(0.0, 1.0);
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: sum.toDouble(),
            width: 14,
            borderRadius: BorderRadius.circular(6),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: maxCalories.toDouble(),
              color: const Color(0xFF2A1B17),
            ),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Color.lerp(const Color(0xFFD86C2F), const Color(0xFF4A1A00), pct)!,
                Color.lerp(const Color(0xFF4A1A00), const Color(0xFF2A1B17), pct)!,
              ],
            ),
          )
        ],
      );
    }).reversed.toList();
  }

  List<GaugeRange> _buildGradientRanges(double maxCalories) {
    final ranges = <GaugeRange>[];
    const steps = 100;
    for (var i = 0; i < steps; i++) {
      final start = (maxCalories / steps) * i;
      final end = (maxCalories / steps) * (i + 1);
      final t = i / steps;
      final color = Color.lerp(
          const Color(0xFFD86C2F), // warm orange
          const Color(0xFF4A1A00), // dark burnt orange
          t)!;
      ranges.add(GaugeRange(
        startValue: start,
        endValue: end,
        color: color,
        startWidth: 12,
        endWidth: 12,
      ));
    }
    return ranges;
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = const Color(0xFF2A1B17);
    final cardColor = const Color(0xFF4A342E);
    final accentColor = const Color(0xFFD86C2F);
    final textColorPrimary = const Color(0xFFEDE3DB);
    final textColorSecondary = const Color(0xFFBFAF9F);

    return NeumorphicTheme(
      themeMode: ThemeMode.dark,
      theme: NeumorphicThemeData(
        baseColor: baseColor,
        lightSource: LightSource.topLeft,
        depth: 6,
        intensity: 0.9,
        shadowLightColor: Colors.orange.shade200.withOpacity(0.3),
        shadowDarkColor: Colors.black87,
      ),
      child: Scaffold(
        backgroundColor: baseColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(90),
          child: Neumorphic(
            style: NeumorphicStyle(
              depth: 6,
              color: baseColor,
              boxShape: NeumorphicBoxShape.roundRect(
                BorderRadius.vertical(bottom: Radius.circular(24)),
              ),
              shadowLightColor: Colors.orange.shade200.withOpacity(0.3),
              shadowDarkColor: Colors.black87,
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 16, top: 12, bottom: 10),
                child: ValueListenableBuilder<Box<Meal>>(
                  valueListenable: mealBox.listenable(),
                  builder: (_, box, __) {
                    final meals = box.values.toList()
                      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
                    _prepareTodaysMeals(meals);

                    final totalCal = _todaysMeals.fold<int>(0, (s, m) => s + m.calories);

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.fitness_center, size: 36, color: accentColor),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'FitTracker',
                                style: GoogleFonts.poppins(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w700,
                                  color: textColorPrimary,
                                ),
                              ),
                              Text(
                                'Track your nutrition & health',
                                style: GoogleFonts.poppins(
                                  fontSize: 8,
                                  color: textColorSecondary,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Today',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: textColorSecondary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$totalCal / $maxCalories kcal',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: accentColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 12),
                        NeumorphicButton(
                          style: NeumorphicStyle(
                            boxShape: NeumorphicBoxShape.circle(),
                            depth: 6,
                            intensity: 0.9,
                            color: baseColor,
                            shadowLightColor: Colors.orange.shade200.withOpacity(0.3),
                            shadowDarkColor: Colors.black87,
                          ),
                          padding: const EdgeInsets.all(8),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const SettingsPage()),
                            );
                          },
                          child: Icon(Icons.settings, color: accentColor),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: Neumorphic(
          style: NeumorphicStyle(
            depth: -6,
            color: baseColor,
            shadowLightColor: Colors.orange.shade200.withOpacity(0.2),
            shadowDarkColor: Colors.black87,
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            selectedItemColor: accentColor,
            unselectedItemColor: textColorSecondary,
            onTap: (index) {
              if (index == 1) {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryPage()));
              } else if (index == 2) {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage()));
              }
            },
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home, color: accentColor), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.history, color: textColorSecondary), label: 'History'),
              BottomNavigationBarItem(icon: Icon(Icons.person, color: textColorSecondary), label: 'Profile'),
            ],
          ),
        ),
        floatingActionButton: SpeedDial(
          backgroundColor: accentColor,
          foregroundColor: baseColor,
          icon: Icons.add,
          activeIcon: Icons.close,
          children: [
            SpeedDialChild(child: const Icon(Icons.fastfood), label: 'Add Meal', onTap: _openSelectOrAddMealScreen),
            SpeedDialChild(child: const Icon(Icons.today), label: 'Today', onTap: () => setState(() => _currentDayOffset = 0)),
          ],
        ),
        body: RefreshIndicator(
          color: accentColor,
          onRefresh: _onRefresh,
          child: ValueListenableBuilder<Box<Meal>>(
            valueListenable: mealBox.listenable(),
            builder: (_, box, __) {
              final meals = box.values.toList()..sort((a, b) => b.dateTime.compareTo(a.dateTime));
              if (meals.isEmpty) return _buildEmptyState(textColorSecondary);

              _prepareTodaysMeals(meals);
              final totalCal = _todaysMeals.fold<int>(0, (s, m) => s + m.calories);
              final totalP = _todaysMeals.fold<int>(0, (s, m) => s + m.protein);
              final totalC = _todaysMeals.fold<int>(0, (s, m) => s + m.carbs);
              final totalF = _todaysMeals.fold<int>(0, (s, m) => s + m.fats);

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Neumorphic(
                    style: NeumorphicStyle(
                      color: cardColor,
                      depth: 4,
                      boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(16)),
                      shadowLightColor: Colors.orange.shade200.withOpacity(0.2),
                      shadowDarkColor: Colors.black87,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Text('Today’s Intake',
                              style: GoogleFonts.poppins(color: textColorPrimary, fontSize: 20, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 18),
                          SfRadialGauge(axes: [
                            RadialAxis(
                              minimum: 0,
                              maximum: maxCalories.toDouble(),
                              showTicks: true,
                              showLabels: true,
                              axisLineStyle: AxisLineStyle(
                                thickness: 0.2,
                                thicknessUnit: GaugeSizeUnit.factor,
                                cornerStyle: CornerStyle.bothCurve,
                                color: const Color(0xFF3B2A27),
                              ),
                              ranges: _buildGradientRanges(maxCalories.toDouble()),
                              pointers: [
                                NeedlePointer(
                                  value: totalCal.toDouble(),
                                  needleLength: 0.75,
                                  needleStartWidth: 1,
                                  needleEndWidth: 7,
                                  knobStyle: KnobStyle(knobRadius: 0.08, sizeUnit: GaugeSizeUnit.factor, color: accentColor),
                                  needleColor: accentColor,
                                )
                              ],
                              annotations: [
                                GaugeAnnotation(
                                  widget: Text(
                                    '$totalCal / $maxCalories kcal',
                                    style: GoogleFonts.poppins(color: textColorPrimary, fontSize: 16),
                                  ),
                                  angle: 90,
                                  positionFactor: 0.7,
                                )
                              ],
                            )
                          ]),
                          const SizedBox(height: 20),
                          SlideTransition(
                            position: _slideAnimation,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildMacroBadge('Protein', totalP, maxProtein, const Color(0xFFEA9E55)),
                                _buildMacroBadge('Carbs', totalC, maxCarbs, const Color(0xFFD86C2F)),
                                _buildMacroBadge('Fat', totalF, maxFats, const Color(0xFF7B3F00)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(icon: Icon(Icons.chevron_left, size: 32, color: accentColor), onPressed: _previousDay),
                      Text(
                        DateFormat.yMMMd().format(DateTime.now().subtract(Duration(days: _currentDayOffset))),
                        style: GoogleFonts.poppins(color: textColorPrimary, fontSize: 22, fontWeight: FontWeight.w600),
                      ),
                      IconButton(icon: Icon(Icons.chevron_right, size: 32, color: accentColor), onPressed: _nextDay),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: GlassmorphicContainer(
                      width: double.infinity,
                      height: 180,
                      borderRadius: 14,
                      blur: 10,
                      border: 1.5,
                      linearGradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.04),
                          Colors.white.withOpacity(0.01)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderGradient: LinearGradient(
                        colors: [
                          accentColor.withOpacity(0.3),
                          accentColor.withOpacity(0.3)
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        child: BarChart(BarChartData(
                          alignment: BarChartAlignment.spaceBetween,
                          barTouchData: BarTouchData(enabled: false),
                          gridData: FlGridData(show: false),
                          borderData: FlBorderData(show: false),
                          maxY: maxCalories.toDouble(),
                          minY: 0,
                          barGroups: _buildWeeklyBarData(meals),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 28,
                                    interval: maxCalories / 4,
                                    getTitlesWidget: (v, meta) => Text(v.toInt().toString(),
                                        style: GoogleFonts.poppins(color: const Color(0xFF7B5E57), fontSize: 10)))),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 24,
                                getTitlesWidget: (v, meta) {
                                  final day = DateTime.now().subtract(Duration(days: _currentDayOffset + (6 - v.toInt())));
                                  return SideTitleWidget(
                                    meta: meta,
                                    space: 4,
                                    child: Text(
                                      DateFormat('E').format(day),
                                      style: GoogleFonts.poppins(color: const Color(0xFF7B5E57), fontSize: 10),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        )),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'Meals on ${DateFormat.yMMMd().format(DateTime.now().subtract(Duration(days: _currentDayOffset)))}',
                      style: GoogleFonts.poppins(
                        color: textColorPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Divider(color: const Color(0xFF7B5E57)),
                  ..._todaysMeals.map((m) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Neumorphic(
                          style: NeumorphicStyle(
                            color: cardColor,
                            depth: 4,
                            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                            shadowLightColor: Colors.orange.shade200.withOpacity(0.2),
                            shadowDarkColor: Colors.black87,
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: Dismissible(
                            key: Key(m.id),
                            direction: DismissDirection.endToStart,
                            onDismissed: (_) {
                              final idx = mealBox.values.toList().indexWhere((x) => x.id == m.id);
                              mealBox.deleteAt(idx);
                            },
                            background: Container(
                              decoration: BoxDecoration(color: Colors.redAccent.shade700, borderRadius: BorderRadius.circular(12)),
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              child: const Icon(Icons.delete, color: Colors.white),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              title: Text(
                                m.name,
                                style: GoogleFonts.poppins(
                                  color: textColorPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                '${m.calories} kcal • P:${m.protein}g • C:${m.carbs}g • F:${m.fats}g',
                                style: GoogleFonts.poppins(
                                  color: textColorSecondary,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(Color textColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.restaurant_menu, size: 80, color: textColor.withOpacity(0.6)),
          const SizedBox(height: 16),
          Text('No meals logged yet',
              style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: textColor.withOpacity(0.8))),
          const SizedBox(height: 8),
          Text('Tap + to add your first meal', style: GoogleFonts.poppins(fontSize: 16, color: textColor.withOpacity(0.6))),
        ],
      ),
    );
  }

  Widget _buildMacroBadge(String label, int val, int max, Color color) => Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        decoration: BoxDecoration(color: color.withOpacity(0.25), borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Text(label, style: GoogleFonts.poppins(color: color, fontWeight: FontWeight.w700, fontSize: 15)),
            const SizedBox(height: 4),
            Text('$val / $max', style: GoogleFonts.poppins(color: color, fontSize: 13)),
          ],
        ),
      );
}
