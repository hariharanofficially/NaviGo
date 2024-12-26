import 'package:flutter/material.dart';
import 'package:EquineApp/feature/common/widgets/navigation_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../subscripition/manage_dashboard/singlestable_menu/bloc/singestablemenu_bloc.dart';
import '../subscripition/manage_dashboard/singlestable_menu/view/singlestablemenu_view.dart';
import '../nav_bar/Dashboard/bloc/Dashboard_bloc.dart';
import '../nav_bar/Dashboard/view/Dashboard_view.dart';
import '../header/app_bar.dart';
import '../home/home_screen.dart';
import '../nav_bar/nav_bar.dart';
import 'bloc/horseactivity_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:weekly_date_picker/weekly_date_picker.dart';

class horseactivity extends StatefulWidget {
  const horseactivity({super.key});

  @override
  State<horseactivity> createState() => _horseactivityState();
}

class _horseactivityState extends State<horseactivity>
    with TickerProviderStateMixin {
  int selectedTab = 0;
  PageController _pageController = PageController();
  DateTime selectedDate = DateTime.now();
  DateTime focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  late AnimationController _animationController;
  late Animation<double> _animation;
  late AnimationController _animationweekController;
  late Animation<double> _animationweek;
  bool _isCalendarExpanded = false;
  bool _isCalendarweekExpanded = false;

  @override
  void initState() {
    super.initState();

    // Initialize AnimationController for dropdown animation
    _animationController = AnimationController(
      vsync: this, // Provides Ticker for animation
      duration: const Duration(milliseconds: 300),
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    // Initialize AnimationController for dropdown animation
    _animationweekController = AnimationController(
      vsync: this, // Provides Ticker for animation
      duration: const Duration(milliseconds: 300),
    );

    _animationweek = CurvedAnimation(
      parent: _animationweekController,
      curve: Curves.easeInOut,
    );

    context.read<horseactivitybloc>().add(const LoadHorsesactivity());
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<horseactivitybloc, HorsesactivityState>(
      listener: (context, state) {
        if (state is HorsesactivityError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: const CustomAppBar(),
          endDrawer: const NavigitionWidget(),
          body: state is HorsesactivityLoading
              ? const Center(child: CircularProgressIndicator())
              : state is HorsesactivityLoaded
                  ? Column(
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back,
                                  color: Colors.redAccent),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            Text(
                              'Horses Activity',
                              style: GoogleFonts.karla(
                                textStyle: const TextStyle(
                                  color: Color(0xFF595BD4),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildTabButton('Daily', 0),
                            _buildTabButton('Weekly', 1),
                            _buildTabButton('Monthly', 2),
                          ],
                        ),
                        const Divider(thickness: 2),
                        Expanded(
                          child: PageView(
                            controller: _pageController,
                            onPageChanged: (index) {
                              setState(() {
                                selectedTab = index;
                              });
                            },
                            children: [
                              _buildTabList(state.horsesactivity1, 'Daily'),
                              _buildTabList(state.horsesactivity2, 'Weekly'),
                              _buildTabList(state.horsesactivity3, 'Monthly'),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Container(),
          // floatingActionButtonLocation:
          //     FloatingActionButtonLocation.centerDocked,
          // floatingActionButton: Container(
          //   margin: const EdgeInsets.only(top: 80),
          //   height: 64,
          //   width: 64,
          //   child: FloatingActionButton(
          //     backgroundColor: Colors.white,
          //     elevation: 0,
          //     onPressed: () => Navigator.push(context,
          //         MaterialPageRoute(builder: (context) => const HomeScreen())),
          //     shape: RoundedRectangleBorder(
          //       side: const BorderSide(
          //           width: 1.5, color: Color.fromRGBO(254, 149, 38, 0.7)),
          //       borderRadius: BorderRadius.circular(100),
          //     ),
          //     child: Image.asset('assets/images/Racing.png'),
          //   ),
          // ),
          bottomNavigationBar: NavBar(
            pageIndex: selectedTab,
          ),
        );
      },
    );
  }

  Widget _buildTabButton(String title, int index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton(
          onPressed: () {
            setState(() {
              selectedTab = index;
              _pageController.animateToPage(index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn);
            });
          },
          child: Text(
            title,
            style: TextStyle(
              color: selectedTab == index ? Colors.black : Colors.black,
              fontWeight:
                  selectedTab == index ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
        if (selectedTab == index)
          Container(
            height: 4,
            width: 60,
            color: Colors.black, // Green bar color
            margin: const EdgeInsets.only(top: 2),
          ),
      ],
    );
  }

  Widget _buildTabList(dynamic data, String tabType) {
    switch (tabType) {
      case 'Daily':
        return SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 31, // Set the height of the container
                width: 300,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0055D5), Color(0xFF1B1E64)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Ceradero',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              _buildCustomCalendarHeader(),
              SizeTransition(
                sizeFactor: _animation,
                axisAlignment: -1.0,
                child: TableCalendar(
                  focusedDay: focusedDay,
                  // focusedDay: DateTime.now(),
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                  selectedDayPredicate: (day) => isSameDay(selectedDate, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      selectedDate = selectedDay;
                      this.focusedDay =
                          focusedDay; // Update the focusedDay as well
                      _toggleCalendar(); // Automatically close calendar after selecting a date
                      // Handle the selected date here
                    });
                  },
                  calendarFormat: CalendarFormat.month,
                  headerVisible: false,
                  calendarStyle: CalendarStyle(
                    selectedDecoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                    defaultDecoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                  ),
                  onPageChanged: (newFocusedDay) {
                    setState(() {
                      focusedDay =
                          newFocusedDay; // Update focusedDay whenever the page changes
                    });
                  },
                ),
              ),
              // Multiple Bar Charts
              _buildBarChart("Heart Rate (bpm)"),
              _buildBarChart("Speed (KM)"),
              _buildBarChart("Distance (KM)"),
              // Add any other widgets you want to display for the Daily tab
            ],
          ),
        );
      case 'Weekly':
        return SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 31, // Set the height of the container
                width: 300,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0055D5), Color(0xFF1B1E64)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Ceradero',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              _buildCustomweekCalendarHeader(),
              SizeTransition(
                sizeFactor: _animationweek,
                axisAlignment: -1.0,
                child: WeeklyDatePicker(
                  selectedDay: selectedDate,
                  changeDay: (value) => setState(() {
                    _selectedDay = value;
                    _toggleweekCalendar();
                  }),
                  enableWeeknumberText: true,
                  weeknumberColor: Color.fromARGB(255, 115, 188, 248),
                  weeknumberTextColor: Colors.black,
                  backgroundColor: Color.fromARGB(255, 255, 255, 255),
                  weekdayTextColor: Color.fromARGB(255, 0, 0, 0),
                  digitsColor: Colors.black,
                  selectedDigitBackgroundColor: Color.fromARGB(255, 9, 44, 240),
                  weekdays: const ["Mo", "Tu", "We", "Th", "Fr"],
                  daysInWeek: 5,
                ),
              ),
              // SizeTransition(
              //   sizeFactor: _animation,
              //   axisAlignment: -1.0,
              //   child: TableCalendar(
              //     focusedDay: focusedDay,
              //     // focusedDay: DateTime.now(),
              //     firstDay: DateTime.utc(2010, 10, 16),
              //     lastDay: DateTime.utc(2030, 3, 14),
              //     selectedDayPredicate: (day) => isSameDay(selectedDate, day),
              //     onDaySelected: (selectedDay, focusedDay) {
              //       setState(() {
              //         selectedDate = selectedDay;
              //         this.focusedDay =
              //             focusedDay; // Update the focusedDay as well
              //         _toggleCalendar(); // Automatically close calendar after selecting a date
              //         // Handle the selected date here
              //       });
              //     },
              //     calendarFormat: CalendarFormat.month,
              //     headerVisible: false,
              //     calendarStyle: CalendarStyle(
              //       selectedDecoration: BoxDecoration(
              //         color: Colors.blue,
              //         shape: BoxShape.circle,
              //       ),
              //       todayDecoration: BoxDecoration(
              //         color: Colors.orange,
              //         shape: BoxShape.circle,
              //       ),
              //       defaultDecoration: BoxDecoration(
              //         shape: BoxShape.circle,
              //       ),
              //     ),
              //     onPageChanged: (newFocusedDay) {
              //       setState(() {
              //         focusedDay =
              //             newFocusedDay; // Update focusedDay whenever the page changes
              //       });
              //     },
              //   ),
              // ),
              // Multiple Bar Charts
              _buildBarChart("Heart Rate (bpm)"),
              _buildBarChart("Speed (KM)"),
              _buildBarChart("Distance (KM)"),
              // Add any other widgets you want to display for the Daily tab
            ],
          ),
        );
      case 'Monthly':
        return SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 31, // Set the height of the container
                width: 300,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0055D5), Color(0xFF1B1E64)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Ceradero',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              _buildCustomCalendarHeader(),
              SizeTransition(
                sizeFactor: _animation,
                axisAlignment: -1.0,
                child: TableCalendar(
                  focusedDay: focusedDay,
                  // focusedDay: DateTime.now(),
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                  selectedDayPredicate: (day) => isSameDay(selectedDate, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      selectedDate = selectedDay;
                      this.focusedDay =
                          focusedDay; // Update the focusedDay as well
                      _toggleCalendar(); // Automatically close calendar after selecting a date
                      // Handle the selected date here
                    });
                  },
                  calendarFormat: CalendarFormat.month,
                  headerVisible: false,
                  calendarStyle: CalendarStyle(
                    selectedDecoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                    defaultDecoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                  ),
                  onPageChanged: (newFocusedDay) {
                    setState(() {
                      focusedDay =
                          newFocusedDay; // Update focusedDay whenever the page changes
                    });
                  },
                ),
              ),
              // Multiple Bar Charts
              _buildBarChart("Heart Rate (bpm)"),
              _buildBarChart("Speed (KM)"),
              _buildBarChart("Distance (KM)"),
              // Add any other widgets you want to display for the Daily tab
            ],
          ),
        );
      default:
        return Container();
    }
  }

  Widget _buildCustomweekCalendarHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              setState(() {
                _selectedDay = _selectedDay.subtract(Duration(days: 7));
              });
            },
          ),
          GestureDetector(
            onTap: () => _toggleweekCalendar(),
            child: Text(
              _formatWeekRange(_selectedDay),
              style:
                  const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              setState(() {
                _selectedDay = _selectedDay.add(Duration(days: 7));
              });
            },
          ),
        ],
      ),
    );
  }

// Helper function to format the week range
  String _formatWeekRange(DateTime date) {
    final startOfWeek = date.subtract(
        Duration(days: date.weekday - 1)); // Start of the week (Monday)
    final endOfWeek = startOfWeek.add(Duration(
        days: 4)); // End of the week (Friday, as daysInWeek is set to 5)

    final startFormat = DateFormat('d MMM');
    final endFormat = DateFormat('d MMM');

    return '${startFormat.format(startOfWeek)} - ${endFormat.format(endOfWeek)}';
  }

  void _toggleweekCalendar() {
    setState(() {
      _isCalendarweekExpanded = !_isCalendarweekExpanded;
      _isCalendarweekExpanded
          ? _animationweekController.forward()
          : _animationweekController.reverse();
    });
  }

  Widget _buildCustomCalendarHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              setState(() {
                focusedDay = DateTime(
                  focusedDay.year,
                  focusedDay.month - 1,
                );
              });
            },
          ),
          GestureDetector(
            onTap: () => _toggleCalendar(),
            child: Text(
              DateFormat('EEEE, d MMMM yyyy').format(focusedDay),
              style:
                  const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              setState(() {
                focusedDay = DateTime(
                  focusedDay.year,
                  focusedDay.month + 1,
                );
              });
            },
          ),
        ],
      ),
    );
  }

  void _toggleCalendar() {
    setState(() {
      _isCalendarExpanded = !_isCalendarExpanded;
      _isCalendarExpanded
          ? _animationController.forward()
          : _animationController.reverse();
    });
  }

  Widget _buildBarChart(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 20,
                barGroups: [
                  BarChartGroupData(
                    x: 0,
                    barRods: [
                      BarChartRodData(
                        toY: 0,
                        color: Color(0xFF8B48DF),
                        width: 15,
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 1,
                    barRods: [
                      BarChartRodData(
                        toY: 10,
                        color: Color(0xFF8B48DF),
                        width: 15,
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 2,
                    barRods: [
                      BarChartRodData(
                        toY: 6,
                        color: Color(0xFF8B48DF),
                        width: 15,
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 3,
                    barRods: [
                      BarChartRodData(
                        toY: 6,
                        color: Color(0xFF8B48DF),
                        width: 15,
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 4,
                    barRods: [
                      BarChartRodData(
                        toY: 6,
                        color: Color(0xFF8B48DF),
                        width: 15,
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 5,
                    barRods: [
                      BarChartRodData(
                        toY: 8,
                        color: Color(0xFF8B48DF),
                        width: 15,
                      ),
                    ],
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
