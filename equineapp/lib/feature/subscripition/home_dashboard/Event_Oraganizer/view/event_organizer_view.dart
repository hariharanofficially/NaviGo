import 'package:EquineApp/feature/subscripition/add_forms/Event/bloc/AddEvent_bloc.dart';
import 'package:EquineApp/feature/subscripition/add_forms/Event/view/add_event.dart';
import 'package:EquineApp/feature/common/widgets/navigation_widget.dart';
import 'package:EquineApp/feature/header/app_bar.dart';
import 'package:EquineApp/feature/nav_bar/event_nav_bar.dart';
import 'package:EquineApp/feature/subscripition/manage_dashboard/cards/events_dashboard/bloc/events_dashboard_bloc.dart';
import 'package:EquineApp/feature/subscripition/manage_dashboard/cards/events_dashboard/view/events_dashboard_view.dart';
import 'package:EquineApp/feature/subscripition/home_dashboard/Event_Oraganizer/EventWidget.dart';
import 'package:EquineApp/feature/subscripition/home_dashboard/Event_Oraganizer/bloc/Event_oraganizer_event.dart';
import 'package:EquineApp/feature/subscripition/home_dashboard/Event_Oraganizer/bloc/event_oraganizer_bloc.dart';
import 'package:EquineApp/utils/constants/icons.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

import '../../../../../data/models/event_model.dart';
import '../../../../../data/models/roles.dart';
import '../../../../nav_bar/nav_bar.dart';
import '../../../manage_dashboard/cards/horse_dashboard/bloc/horse_dashboard_bloc.dart';
import '../../../manage_dashboard/cards/horse_dashboard/view/horse_dashboard_view.dart';
import '../../../manage_dashboard/cards/stable_dashboard/bloc/stable_dashboard_bloc.dart';
import '../../../manage_dashboard/cards/stable_dashboard/view/stable_dashboard_view.dart';
import '../bloc/event_oraganizer_state.dart';

class EventsOrganizerDashboard extends StatefulWidget {
  const EventsOrganizerDashboard({super.key});

  @override
  State<EventsOrganizerDashboard> createState() =>
      _EventsOrganizerDashboardState();
}

class _EventsOrganizerDashboardState extends State<EventsOrganizerDashboard> {
  late EventsOrganizerBloc _bloc;
  int selectedTab = 0;

  int eventCount = 0;
  int horseCount = 0;
  int stableCount = 0;
  List<EventModel> events = [];
  RolesModel role = new RolesModel(id: 1, name: "test", level: 1);
  @override
  void initState() {
    super.initState();
    _bloc = EventsOrganizerBloc();
    _bloc.add(EventsOrganizerLoadInitialDataEvent());
  }

  Future<void> _refreshData() async {
    _bloc.add(EventsOrganizerLoadInitialDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      endDrawer: const NavigitionWidget(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 25),
        child: SingleChildScrollView(
          child: Container(
            child: BlocConsumer<EventsOrganizerBloc, EventsOrganizerState>(
                bloc: _bloc,
                listener: (context, state) {
                  if (state is EventsOrganizerInitLoaded) {
                    this.eventCount = state.eventCount;
                    this.horseCount = state.horseCount;
                    this.stableCount = state.stableCount;
                    this.events = state.events;
                    this.role = state.role;
                  }
                },
                builder: (context, state) {
                  if (state is EventOrganizerLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is EventsOrganizerInitLoaded) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        FadeInRight(
                          child: Column(
                            children: [
                              baseContainer('Stables', this.stableCount),
                              SizedBox(height: 25),
                              baseContainer('Horses', this.horseCount),
                              SizedBox(height: 25),
                              baseContainer('Events', this.eventCount),
                            ],
                          ),
                        ),
                        this.events.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 50),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.event_busy,
                                        color: Colors.grey,
                                        size: 80,
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'No Data available',
                                        style: GoogleFonts.karla(
                                          textStyle: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : EventWidgetList(
                                events: this.events, role: this.role),
                      ],
                    );
                  } else if (state is EventsOrganizerInitLoadedFailed) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 80,
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Error loading data',
                            style: GoogleFonts.karla(
                              textStyle: TextStyle(
                                color: Colors.red,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: _refreshData,
                            child: Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Center(child: Text('Unknown State'));
                  }
                }),
          ),
        ),
      ),
      bottomNavigationBar: NavBar(
        pageIndex: selectedTab,
      ),
    );
  }

  Widget baseContainer(String title, int count) {
    return FadeInUp(
      duration: Duration(milliseconds: 1000),
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          color: (title == 'Stables')
              ? Color.fromRGBO(109, 197, 209, 1)
              : (title == 'Horses')
                  ? Color.fromRGBO(253, 217, 163, 1)
                  : Color.fromRGBO(221, 118, 28, 1),
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.white,
                    child: Image.asset(
                      'assets/images/${title}.png',
                      height: 22,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    width: 100,
                    child: Text(
                      title,
                      style: GoogleFonts.karla(
                        textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2),
                      ),
                    ),
                  ),
                  Iconify(
                    divider,
                    color: Colors.white,
                    size: 28,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    '$count',
                    style: GoogleFonts.karla(
                      textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 2),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  if (title == 'Stables')
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                              create: (context) => StableBloc(),
                              child: StableDashboard()),
                        ));
                  else if (title == 'Horses')
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) => HorseDashboardBloc(),
                            child: HorseDashboard(
                              title: 'Horses',
                              isProfile: false,
                              showActions: true,
                            ),
                          ),
                        ));
                  else
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                              create: (context) => EventsDashboardBloc(),
                              child: EventsDashboard()),
                        ));
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Iconify(
                    moreHorizondal,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
