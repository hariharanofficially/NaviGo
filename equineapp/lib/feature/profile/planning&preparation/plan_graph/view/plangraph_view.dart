import 'package:EquineApp/data/models/horse_model.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import '../../../../nav_bar/Dashboard/bloc/Dashboard_bloc.dart';
import '../../../../nav_bar/Dashboard/view/Dashboard_view.dart';
import '../../../../../utils/constants/icons.dart';
import '../../../../common/widgets/navigation_widget.dart';
import '../../../../header/app_bar.dart';
import '../../../../home/home_screen.dart';
import '../../../../nav_bar/nav_bar.dart';
import '../../../../subscripition/manage_dashboard/singlestable_menu/bloc/singestablemenu_bloc.dart';
import '../../../../subscripition/manage_dashboard/singlestable_menu/view/singlestablemenu_view.dart';
import '../../plan_form/bloc/plan_form_bloc.dart';
import '../../plan_form/view/plan_form_view.dart';
import '../bloc/plangraph_bloc.dart';

class Plangraph extends StatefulWidget {
  final HorseModel horse;
  const Plangraph({super.key, required this.horse});

  @override
  State<Plangraph> createState() => _PlangraphState();
}

class _PlangraphState extends State<Plangraph> {
  int selectedTab = 0;
  @override
  void initState() {
    super.initState();
    context.read<PlangraphBloc>().add(LoadPlangraph());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlangraphBloc, PlangraphState>(
        listener: (context, state) {
      if (state is PlangraphError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load graph')),
        );
      }
    }, builder: (context, state) {
      return Scaffold(
        appBar: CustomAppBar(),
        endDrawer: NavigitionWidget(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: state is PlangraphLoading
                ? Center(child: CircularProgressIndicator())
                : state is PlangraphLoaded
                    ? Column(
                        children: [
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.arrow_back,
                                    color: Colors.redAccent), // Back icon
                                onPressed: () {
                                  Navigator.pop(
                                      context); // Action when back icon is pressed
                                },
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color(
                                          0xFFE5E5FC), // Set the background color to blue
                                      borderRadius: BorderRadius.circular(
                                          8.0), // Set the border radius
                                    ),
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 10, 25, 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Planning & Preparation',
                                          style: GoogleFonts.karla(
                                            textStyle: TextStyle(
                                              color: Color(0xFF595BD4),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 25,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      BlocProvider(
                                                        create: (context) =>
                                                            PlanFormBloc(),
                                                        child: PlanForn(
                                                          horse: widget.horse,
                                                        ),
                                                      )),
                                            );
                                          },
                                          child: Container(
                                            width:
                                                30, // Adjust width to fit the icon
                                            height:
                                                50, // Adjust height to fit the icon
                                            decoration: BoxDecoration(
                                              color: Color(0xFF595BD4),
                                              shape: BoxShape
                                                  .circle, // Circular shape
                                            ),
                                            child: Center(
                                              child: Icon(
                                                Icons.add, // Plus icon
                                                color: Colors.white,
                                                size: 24, // Icon size
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                                28,
                                (index) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4.0),
                                      child: Container(
                                        width: 3, // Width of each dot
                                        height: 2, // Height of each dot
                                        decoration: BoxDecoration(
                                          color:
                                              Colors.grey, // Color of the dots
                                          shape: BoxShape
                                              .rectangle, // Shape of the dots
                                        ),
                                      ),
                                    )),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Summary",
                                  style: GoogleFonts.karla(
                                      textStyle: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ))),
                              RichText(
                                text: TextSpan(
                                  text: '4th Aug ', // First part
                                  style: GoogleFonts.karla(
                                    textStyle: TextStyle(
                                      color: Colors
                                          .black, // Give this part a different color
                                      fontSize: 14,
                                      // fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  children: [
                                    TextSpan(
                                      text: ' - ', // Second part
                                      style: GoogleFonts.karla(
                                        textStyle: TextStyle(
                                          color: Colors
                                              .black, // Default color for this part
                                          fontSize: 14,
                                          // fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    TextSpan(
                                      text: '5 Sep', // Second part
                                      style: GoogleFonts.karla(
                                        textStyle: TextStyle(
                                          color: Colors
                                              .black, // Default color for this part
                                          fontSize: 14,
                                          // fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  Text('30 days'),
                                  PopupMenuButton<String>(
                                    icon: Iconify(
                                      moreHorizondal, // Use the correct Iconify icon
                                      color: Color.fromRGBO(234, 146, 53, 1),
                                      size: 28,
                                    ),
                                    onSelected: (value) {
                                      switch (value) {
                                        case 'edit':
                                          // Handle edit action

                                          print('Edit selected');
                                          break;
                                        case 'delete':
                                          // Show confirmation dialog before deleting
                                          // Show confirmation dialog before deleting
                                          showDialog(
                                            context: context,
                                            builder:
                                                (BuildContext dialogContext) {
                                              // Use a new context variable here
                                              return AlertDialog(
                                                title: Text('Confirm Delete'),
                                                content: Text(
                                                    'Are you sure you want to delete this horse?'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: Text('Cancel'),
                                                    onPressed: () {
                                                      Navigator.of(
                                                              dialogContext)
                                                          .pop(); // Use dialogContext here to close the dialog
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: Text('Confirm'),
                                                    onPressed: () {
                                                      // Use the original context to access the HorseDashboardBloc

                                                      print('Delete selected');
                                                      Navigator.of(
                                                              dialogContext)
                                                          .pop(); // Use dialogContext here to close the dialog after confirming
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );

                                          break;
                                      }
                                    },
                                    itemBuilder: (BuildContext context) {
                                      return [
                                        PopupMenuItem<String>(
                                          value: 'edit',
                                          child: Text('Edit'),
                                        ),
                                        PopupMenuItem<String>(
                                          value: 'delete',
                                          child: Text('Delete'),
                                        ),
                                      ];
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // Wrapping BarChart in a container with height and width
                          // Container(
                          //   height: 300, // Define a fixed height
                          //   width: double
                          //       .infinity, // Set width to fill available space
                          //   child: BarChart(
                          //     BarChartData(
                          //       alignment: BarChartAlignment.spaceBetween,
                          //       barGroups: state.graphData.map((data) {
                          //         return BarChartGroupData(
                          //           x: data.x.toInt(), // X-axis value
                          //           barRods: [
                          //             BarChartRodData(
                          //               toY: data.y, // Y-axis value
                          //               color: Colors.blue, // Bar color
                          //               width: 20, // Bar width
                          //               borderRadius: BorderRadius.circular(5),
                          //             ),
                          //           ],
                          //         );
                          //       }).toList(),
                          //       titlesData: FlTitlesData(
                          //         leftTitles: AxisTitles(
                          //           sideTitles: SideTitles(showTitles: true),
                          //         ),
                          //         bottomTitles: AxisTitles(
                          //           sideTitles: SideTitles(showTitles: true),
                          //         ),
                          //       ),
                          //       gridData: FlGridData(show: true),
                          //       borderData: FlBorderData(
                          //         show: true,
                          //         border:
                          //             Border.all(color: Colors.black, width: 1),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          SizedBox(height: 16),
                          _buildSection(
                              "Body Measurement",
                              Column(children: [
                                _buildBodyMeasurementBarChart(),
                                SizedBox(height: 8),
                                _buildLegend(),
                              ])),
                          SizedBox(height: 16),
                          _buildSection(
                              "Training",
                              Column(children: [
                                _buildTrainingBarChart(),
                                SizedBox(height: 8),
                                _buildLegend(),
                              ])),
                          SizedBox(height: 16),
                          _buildSection(
                              "Blood Test",
                              Column(children: [
                                _buildBloodTestBarChart(),
                                SizedBox(height: 8),
                                _buildLegend(),
                              ])),
                        ],
                      )
                    : Container(),
          ),
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // floatingActionButton: Container(
        //   margin: const EdgeInsets.only(top: 80),
        //   height: 64,
        //   width: 64,
        //   child: FloatingActionButton(
        //     backgroundColor: Colors.white,
        //     elevation: 0,
        //     onPressed: () => Navigator.push(
        //         // context, MaterialPageRoute(builder: (context) => TrackDeviceInfoScreen())),
        //         context,
        //         MaterialPageRoute(builder: (context) => HomeScreen())),
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
    });
  }

  // Section Builder
  Widget _buildSection(String title, Widget chart) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.karla(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          chart,
        ],
      ),
    );
  }

  // Body Measurement Bar Chart
  Widget _buildBodyMeasurementBarChart() {
    return SizedBox(
      height: 140,
      child: BarChart(
        BarChartData(
          gridData: FlGridData(
            show: true,
            drawHorizontalLine: true,
            drawVerticalLine: false, // Disable vertical lines if not needed
            horizontalInterval: 88, // Adjust this based on your Y-axis scale
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.shade300, // Adjust the line color if needed
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false, // Disable Y-axis (left) titles
              ),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false, // Disable X-axis (top) titles
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true, // Enable Y-axis (left) titles
                reservedSize: 20, // Adjust to provide space for Y-axis labels
                getTitlesWidget: (value, meta) {
                  // Show only 300 and 150
                  if (value == 300) {
                    return Text('300', style: TextStyle(fontSize: 10));
                  } else if (value == 150) {
                    return Text('150', style: TextStyle(fontSize: 10));
                  }
                  return Container(); // Don't show labels for other values
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  switch (value.toInt()) {
                    case 0:
                      return Text('5', style: TextStyle(fontSize: 10));
                    case 1:
                      return Text('10', style: TextStyle(fontSize: 10));
                    case 2:
                      return Text('15', style: TextStyle(fontSize: 10));
                    case 3:
                      return Text('20', style: TextStyle(fontSize: 10));
                    case 4:
                      return Text('25', style: TextStyle(fontSize: 10));
                    case 5:
                      return Text('31', style: TextStyle(fontSize: 10));
                    default:
                      return Text('');
                  }
                },
                reservedSize: 30, // Adjust this to add padding for labels
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true, // Show the border
            border: Border(
              bottom: BorderSide(color: Colors.grey, width: 1), // Bottom border
              left: BorderSide(
                  color: Colors.transparent, width: 0), // Hide left border
              right: BorderSide(
                  color: Colors.transparent, width: 0), // Hide right border
              top: BorderSide(
                  color: Colors.transparent, width: 0), // Hide top border
            ),
          ),
          // borderData: FlBorderData(
          //   show: false, // No border will be shown
          // ),
          // borderData: FlBorderData(
          //   show: true,
          //   border: Border.all(
          //     color: Colors.grey, // Adjust the color to match your theme
          //     width: 1,
          //   ),
          // ),
          barGroups: [
            BarChartGroupData(x: 0, barRods: [
              BarChartRodData(toY: 200, color: Colors.blue, width: 16),
              BarChartRodData(toY: 250, color: Colors.redAccent, width: 16),
            ]),
            BarChartGroupData(x: 1, barRods: [
              BarChartRodData(toY: 200, color: Colors.blue, width: 16),
              BarChartRodData(toY: 300, color: Colors.redAccent, width: 16),
            ]),
            BarChartGroupData(x: 2, barRods: [
              BarChartRodData(toY: 300, color: Colors.blue, width: 16),
              BarChartRodData(toY: 290, color: Colors.redAccent, width: 16),
            ]),
          ],
        ),
      ),
    );
  }

  // Training Bar Chart
  Widget _buildTrainingBarChart() {
    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          gridData: FlGridData(
            show: true,
            drawHorizontalLine: true,
            drawVerticalLine: false, // Disable vertical lines if not needed
            horizontalInterval: 50, // Adjust this based on your Y-axis scale
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.shade300, // Adjust the line color if needed
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false, // Disable Y-axis (left) titles
              ),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false, // Disable X-axis (top) titles
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true, // Enable Y-axis (left) titles
                reservedSize: 20, // Adjust to provide space for Y-axis labels
                getTitlesWidget: (value, meta) {
                  // Show only 300 and 150
                  if (value == 100) {
                    return Text('100', style: TextStyle(fontSize: 10));
                  } else if (value == 50) {
                    return Text('50', style: TextStyle(fontSize: 10));
                  }
                  return Container(); // Don't show labels for other values
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  switch (value.toInt()) {
                    case 0:
                      return Text('Walk');
                    case 1:
                      return Text('Trot');
                    case 2:
                      return Text('Canter');
                    case 3:
                      return Text('Gallop');
                    default:
                      return Text('');
                  }
                },
                reservedSize: 30, // Adjust this to add padding for labels
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true, // Show the border
            border: Border(
              bottom: BorderSide(color: Colors.grey, width: 1), // Bottom border
              left: BorderSide(
                  color: Colors.transparent, width: 0), // Hide left border
              right: BorderSide(
                  color: Colors.transparent, width: 0), // Hide right border
              top: BorderSide(
                  color: Colors.transparent, width: 0), // Hide top border
            ),
          ),
          barGroups: [
            BarChartGroupData(x: 0, barRods: [
              BarChartRodData(toY: 80, color: Colors.blue, width: 16),
              BarChartRodData(toY: 60, color: Colors.redAccent, width: 16),
            ]),
            BarChartGroupData(x: 1, barRods: [
              BarChartRodData(toY: 100, color: Colors.blue, width: 16),
              BarChartRodData(toY: 120, color: Colors.redAccent, width: 16),
            ]),
            BarChartGroupData(x: 2, barRods: [
              BarChartRodData(toY: 150, color: Colors.blue, width: 16),
              BarChartRodData(toY: 170, color: Colors.redAccent, width: 16),
            ]),
          ],
        ),
      ),
    );
  }

  // Blood Test Bar Chart
  Widget _buildBloodTestBarChart() {
    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          gridData: FlGridData(
            show: true,
            drawHorizontalLine: true,
            drawVerticalLine: false, // Disable vertical lines if not needed
            horizontalInterval: 50, // Adjust this based on your Y-axis scale
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.shade300, // Adjust the line color if needed
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false, // Disable Y-axis (left) titles
              ),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false, // Disable X-axis (top) titles
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true, // Enable Y-axis (left) titles
                reservedSize: 20, // Adjust to provide space for Y-axis labels
                getTitlesWidget: (value, meta) {
                  // Show only 300 and 150
                  if (value == 100) {
                    return Text('100', style: TextStyle(fontSize: 10));
                  } else if (value == 150) {
                    return Text('150', style: TextStyle(fontSize: 10));
                  }
                  return Container(); // Don't show labels for other values
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  switch (value.toInt()) {
                    case 0:
                      return Text('6');
                    case 1:
                      return Text('13');
                    case 2:
                      return Text('25');
                    default:
                      return Text('');
                  }
                },
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true, // Show the border
            border: Border(
              bottom: BorderSide(color: Colors.grey, width: 1), // Bottom border
              left: BorderSide(
                  color: Colors.transparent, width: 0), // Hide left border
              right: BorderSide(
                  color: Colors.transparent, width: 0), // Hide right border
              top: BorderSide(
                  color: Colors.transparent, width: 0), // Hide top border
            ),
          ),
          barGroups: [
            BarChartGroupData(x: 0, barRods: [
              BarChartRodData(toY: 120, color: Colors.blue, width: 16),
              BarChartRodData(toY: 100, color: Colors.redAccent, width: 16),
            ]),
            BarChartGroupData(x: 1, barRods: [
              BarChartRodData(toY: 150, color: Colors.blue, width: 16),
              BarChartRodData(toY: 130, color: Colors.redAccent, width: 16),
            ]),
            BarChartGroupData(x: 2, barRods: [
              BarChartRodData(toY: 180, color: Colors.blue, width: 16),
              BarChartRodData(toY: 160, color: Colors.redAccent, width: 16),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Container(
              width: 16,
              height: 16,
              color: Colors.blue,
            ),
            SizedBox(width: 4),
            Text("Cascadora", style: GoogleFonts.karla(fontSize: 12)),
          ],
        ),
        SizedBox(width: 16),
        Row(
          children: [
            Container(
              width: 16,
              height: 16,
              color: Colors.redAccent,
            ),
            SizedBox(width: 4),
            Text("Al Manoq", style: GoogleFonts.karla(fontSize: 12)),
          ],
        ),
      ],
    );
  }
}
