import 'package:flutter/material.dart';

import '../../app/route/routes/route_path.dart';
import '../../app/route/routes/router.dart';
import '../common/widgets/custom_app_bar_widget.dart';
import '../common/widgets/navigation_widget.dart';

class button_api extends StatefulWidget {
  const button_api({super.key});

  @override
  State<button_api> createState() => _button_apiState();
}

class _button_apiState extends State<button_api> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const NavigitionWidget(),
      appBar: CustomAppBarWidget(),
      body: Padding(padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Container(
                  width: 150,
                  child: ElevatedButton(onPressed: ()
                  {
                    router.go(RoutePath.division);
                    },
                      child: Text('Division')),
                ),
                SizedBox(
                  width: 20,
                ),
                Container(
                  width: 150,
                    child: ElevatedButton(onPressed: ()
                    {
                      router.go(RoutePath.eventgroup);
                      },
                        child: Text('Event Group'))),

              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Container(
                  width: 150,
                  child: ElevatedButton(onPressed: ()
                  {
                    router.go(RoutePath.eventstate);
                  },
                      child: Text('Event State')),
                ),
                SizedBox(
                  width: 20,
                ),
                Container(
                    width: 150,
                    child: ElevatedButton(onPressed: ()
                    {
                      router.go(RoutePath.eventtype);
                    },
                        child: Text('Event Type'))),

              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Container(
                  width: 150,
                  child: ElevatedButton(onPressed: ()
                  {
                    router.go(RoutePath.event);
                  },
                      child: Text('Event')),
                ),
                SizedBox(
                  width: 20,
                ),
                Container(
                    width: 150,
                    child: ElevatedButton(onPressed: ()
                    {
                      router.go(RoutePath.breed);
                    },
                        child: Text('Bread'))),

              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Container(
                  width: 150,
                  child: ElevatedButton(onPressed: ()
                  {
                    router.go(RoutePath.breeder);
                  },
                      child: Text('Breeder')),
                ),
                SizedBox(
                  width: 20,
                ),
                Container(
                    width: 150,
                    child: ElevatedButton(onPressed: ()
                    {
                      router.go(RoutePath.horsecolor);
                    },
                        child: Text('Horse Color'))),

              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Container(
                  width: 150,
                  child: ElevatedButton(onPressed: ()
                  {
                    router.go(RoutePath.horsegender);
                  },
                      child: Text('Horse Gender')),
                ),
                SizedBox(
                  width: 20,
                ),
                Container(
                    width: 150,
                    child: ElevatedButton(onPressed: ()
                    {
                      router.go(RoutePath.owner);
                    },
                        child: Text('Owner'))),

              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Container(
                  width: 150,
                  child: ElevatedButton(onPressed: ()
                  {
                    router.go(RoutePath.rider);
                  },
                      child: Text('Rider')),
                ),
                SizedBox(
                  width: 20,
                ),
                Container(
                    width: 150,
                    child: ElevatedButton(onPressed: ()
                    {
                      router.go(RoutePath.trackerdevice);
                    },
                        child: Text('Tracker device'))),

              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Container(
                  width: 150,
                  child: ElevatedButton(onPressed: ()
                  {
                    router.go(RoutePath.participant);
                  },
                      child: Text('Participant')),
                ),
                SizedBox(
                  width: 20,
                ),
                Container(
                    width: 150,
                    child: ElevatedButton(onPressed: ()
                    {
                      router.go(RoutePath.trackerfeed);
                    },
                        child: Text('Tracker Feed'))),

              ],
            ),
          ),
        ],
      )
        ),
    );
  }
}
