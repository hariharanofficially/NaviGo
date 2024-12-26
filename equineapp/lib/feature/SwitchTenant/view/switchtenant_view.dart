import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/tenant_model.dart';
import '../../subscripition/home_dashboard/Single_stable/bloc/single_stable_bloc.dart';
import '../../subscripition/home_dashboard/Single_stable/view/single_stable_view.dart';
import '../bloc/switchtenant_bloc.dart';

class Switchtenant extends StatefulWidget {
  const Switchtenant({super.key});

  @override
  State<Switchtenant> createState() => _SwitchtenantState();
}

class _SwitchtenantState extends State<Switchtenant> {
  String tenantId = "";

  @override
  void initState() {
    super.initState();
    context.read<SwitchtenantBloc>().add(LoadSwitch());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SwitchtenantBloc, SwitchtenantState>(
      listener: (BuildContext context, SwitchtenantState state) {
        if (state is SwitchError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is SwitchLoaded) {
          this.tenantId = state.tenantId;
        } else if (state is SwitchedTenant) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BlocProvider(
                      create: (context) => SingleStableDashboardBloc(),
                      child: SingleStableDashboard(),
                    )),
          );
        }
      },
      builder: (BuildContext context, SwitchtenantState state) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(56.0),
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              toolbarHeight: 56.0,
              automaticallyImplyLeading: false,
              titleSpacing: 0,
              // leading: IconButton(
              //   icon: const Icon(Icons.arrow_back),
              //   onPressed: () {
              //     Navigator.pop(context); // Navigates back when pressed
              //   },
              // ),
              title: Row(
                children: [
                  Expanded(
                    flex: 1, // Flex for the leading container
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        child: Container(
                          width: 100,
                          height: 30,
                          color: Color(0xFFD9D9D9),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(
                                      context); // Navigates to the previous screen
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Icon(
                                    Icons.arrow_back, // Back arrow icon
                                    color: Colors.black, // Adjust icon color
                                    size: 20, // Adjust icon size
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2, // Flex for the centered text
                    child: Center(
                      child: Text(
                        'Subscriptions List',
                        style: TextStyle(
                          fontFamily: 'Karla',
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1, // Flex for the trailing container
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        ),
                        child: Container(
                          width: 100,
                          height: 30,
                          color: Color(0xFFD9D9D9),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: state is SwitchLoading
                ? Center(child: CircularProgressIndicator())
                : state is SwitchLoaded
                    ? Column(
                        children: [
                          Container(
                              child: Text(
                            'My Subscriptions',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color:
                                  Color(0xFF6C14BD), // Ensure text visibility
                            ),
                          )),
                          if (state.Switch.subscriptionTenants.length == 0)
                            Container(
                                padding: EdgeInsets.all(10.0),
                                child: Text(
                                  'No Active Subscription',
                                  style: TextStyle(
                                    fontSize: 14,
                                    // Ensure text visibility
                                  ),
                                )),
                          Container(
                              child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: state.Switch.subscriptionTenants.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: SwitchCard(
                                    SwitchName: state.Switch
                                        .subscriptionTenants[index].tenantName,
                                    tenantId: state
                                        .Switch.subscriptionTenants[index].id
                                        .toString(),
                                    orgtenantId: this.tenantId,
                                    index: index + 1),
                              );
                            },
                          )),
                          Container(
                              child: Text(
                            'Shared Subscriptions',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color:
                                  Color(0xFF6C14BD), // Ensure text visibility
                            ),
                          )),
                          if (state.Switch.sharedTenants.length == 0)
                            Container(
                                padding: EdgeInsets.all(10.0),
                                child: Text(
                                  'No Shared Tenants',
                                  style: TextStyle(
                                    fontSize: 14,
                                    // Ensure text visibility
                                  ),
                                )),
                          Container(
                              child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: state.Switch.sharedTenants.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: SwitchCard(
                                    SwitchName: state
                                        .Switch.sharedTenants[index].tenantName,
                                    tenantId: state
                                        .Switch.sharedTenants[index].id
                                        .toString(),
                                    orgtenantId: this.tenantId,
                                    index: index + 1),
                              );
                            },
                          )),
                          // ...state.Switch.subscriptionTenants.asMap()
                          //     .entries
                          //     .map(
                          //       (switchName) => Padding(
                          //         padding: const EdgeInsets.only(bottom: 25.0),
                          //         child: SwitchCard(
                          //           SwitchName: switchName.value,
                          //           index: switchName.key +
                          //               1, // Start index from 1
                          //         ),
                          //       ),
                          //     )
                          //     .toList(),
                        ],
                      )
                    //  )
                    : Container(),
          ),
        );
      },
    );
  }
}

class SwitchCard extends StatelessWidget {
  final String SwitchName;
  final String tenantId;
  final String orgtenantId;
  final int index;

  const SwitchCard(
      {super.key,
      required this.SwitchName,
      required this.orgtenantId,
      required this.tenantId,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // Ensure visibility
      child: Card(
        elevation: 4,
        margin: EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: Color(0xFFF6E9E9),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Text(
                      '' + SwitchName,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6C14BD), // Ensure text visibility
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  if (tenantId != orgtenantId)
                    ElevatedButton(
                      onPressed: () {
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(
                        //       content: Text('Button pressed for $SwitchName')),
                        // );
                        context
                            .read<SwitchtenantBloc>()
                            .add(SwitchTenant(id: tenantId));
                      },
                      child: Text('Choose Tenant'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Color(0xFF8B48DF),

                        //onPrimary: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Positioned(
              //top: 8,
              left: 0,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomRight: Radius.circular(20),
                ),
                child: Container(
                  width: 50,
                  height: 30,
                  color: Color(0xFF8B48DF),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      '$index',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (tenantId == orgtenantId)
              Positioned(
                  top: 8,
                  right: 8,
                  child: Icon(Icons.verified_rounded, color: Colors.green)
                  // Text(
                  //   'Current Tenant', // Your moderate text
                  //   style: TextStyle(
                  //     fontSize: 12,
                  //     fontFamily: 'Karla',
                  //     fontWeight: FontWeight.w500,
                  //     color: Colors.black, // Adjust color if needed
                  //   ),
                  // ),
                  ),
          ],
        ),
      ),
    );
  }
}
