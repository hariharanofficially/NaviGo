import 'package:EquineApp/feature/subscripition/plans/subscription_plan/widgets/periodicity_event.dart';
import 'package:EquineApp/feature/subscripition/plans/subscription_plan/widgets/periodicity_multiple_stable.dart';
import 'package:EquineApp/feature/subscripition/plans/subscription_plan/widgets/periodicity_single_stable.dart';
import 'package:EquineApp/feature/subscripition/plans/subscription_plan/bloc/subscription_plan_bloc.dart';
import 'package:EquineApp/feature/subscripition/plans/subscription_plan/bloc/subscription_plan_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../data/models/SubscriptionPlans_model.dart';
import '../../../../common/widgets/sharecode_popup.dart';
import '../bloc/subscription_plan_event.dart';

class subs_plan extends StatefulWidget {
  const subs_plan({Key? key}) : super(key: key);

  @override
  State<subs_plan> createState() => _subs_planState();
}

class _subs_planState extends State<subs_plan> {
  late SubscriptionBloc _subscriptionBloc;
  String? chosenPlan;
  TextEditingController organizername = TextEditingController();
  TextEditingController numberOfEventsController =
      TextEditingController(text: '0');
  TextEditingController numberOfStablesController =
      TextEditingController(text: '0');
  TextEditingController numberOfHorsesController =
      TextEditingController(text: '0');
  // Multiple Stable Controller

  List<SubscriptionPlansModel>? plans;
  List<int> colors = [0xFF8B48DF, 0xFF004417, 0xFFE23A9F];
  List subFeatures = [
    [
      'Access to event management',
      'Can Organize Event',
      'Generate and share code',
    ],
    ['Access to single stable Management. ', 'Generate and share code.'],
    ['Access to multiple stable management. ', 'Generate and share code.']
  ];
  List subImages = [
    'assets/images/organizer.png',
    'assets/images/individual.png',
    'assets/images/owner.png'
  ];
  List subTexts = [
    'If you are an event organizer, this is the plan for you.',
    'If you have a single stable, this is the plan for you.',
    'If you are a stable group, this is the plan for you.'
  ];

  @override
  void initState() {
    super.initState();
    _subscriptionBloc = SubscriptionBloc();
  }

  @override
  void dispose() {
    numberOfEventsController.dispose();
    numberOfStablesController.dispose();
    numberOfHorsesController.dispose();
    _subscriptionBloc.close();
    super.dispose();
  }

  bool _validateForm() {
    if (numberOfEventsController.text.isEmpty ||
        numberOfEventsController.text == '0' ||
        numberOfEventsController.text == null) {
      // Show error message for empty field
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please enter the details'),
      ));
      return false;
    }
    // Add similar validation for other fields if needed
    return true;
  }

  bool _validateForm_Single() {
    if (numberOfStablesController.text.isEmpty ||
        numberOfHorsesController.text.isEmpty ||
        numberOfStablesController.text == '0' ||
        numberOfHorsesController.text == '0') {
      // Show error message for empty field
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please enter the details'),
      ));
      return false;
    }
    // Add similar validation for other fields if needed
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      //create: (context) => _subscriptionBloc,
      create: (_) => _subscriptionBloc..add(PlanInitialEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Subscription Plan')),
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: BlocConsumer<SubscriptionBloc, SubscriptionState>(
            listener: (context, state) {
              if (state is SubscriptionSuccessState) {
                plans = state.plans;
              } else if (state is SubscriptionFailureState) {
              } else if (state is SubscriptionComponentSuccessState) {
                if (state.planId == 1) {
                  _showEventOrganizerAlertDialog(
                      context, state.planId, state.planName);
                } else if (state.planId == 3) {
                  this.numberOfStablesController.text = '1';
                  _showSingleStableAlertDialog(
                      context, state.planId, state.planName);
                } else if (state.planId == 2) {
                  _showMultipleStableAlertDialog(
                      context, state.planId, state.planName);
                }
              } else if (state is SubscriptionPaymentsSuccessState) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyBottomSheet(
                            name: organizername.text,
                            planId: state.planId,
                            planName: state.planName,
                            noofEvents: numberOfEventsController.text,
                            noofStables: numberOfStablesController.text,
                            noofHorse: numberOfHorsesController.text,
                            paymentmodes: state.paymentmodes)));
              }
            },
            builder: (context, state) {
              return _buildPlans();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPlans() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Available Plans',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Image.asset(
                'assets/images/video_tutorial.png', // Replace with your image path
                width: 40, // Adjust size as needed
                height: 40,
                fit: BoxFit.cover,
              ),
              // Replace with your icon or widget
              // Icon(Icons.info_outline),
              Container(
                height: 40,
                width: 105,
                decoration: BoxDecoration(
                  color: Colors.blueGrey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => SharecodePopup(
                          showGenerateOnly:
                              true, showlogin: false, // Only show "Generate & Share Code" button
                        ),
                      );
                    },
                    child: const Text(
                      'Skip plan',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          width: double.infinity,
          height: 670,
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: ListView.builder(
            itemCount: plans?.length ?? 0, // Ensure itemCount is valid
            itemBuilder: (BuildContext context, int index) {
              // Check if index is valid for accessing the lists
              if (index < subFeatures.length &&
                  index < subImages.length &&
                  index < subTexts.length &&
                  index < colors.length) {
                return SubscriptionButton(
                  planType: plans?[index].name ?? "",
                  features: subFeatures[index],
                  colors: Color(colors[index]),
                  text: subTexts[index],
                  assetImage: subImages[index],
                  buttonColor: Color(colors[index]),
                  planId: plans?[index].id ?? -1,
                  planName: plans?[index].name ?? "",
                );
              } else {
                // Handle the case where index is out of range
                return SizedBox(); // Or any other widget to indicate an empty or invalid item
              }
            },
          ),
        ),
      ],
    );
  }

  void _showEventOrganizerAlertDialog(
      BuildContext context, int planId, String planName) {
    showDialog(
      context: context,
      builder: (BuildContext context1) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(planName, style: TextStyle()),
          content: Text('You have chosen ${planName}.'),
          actions: [
            Column(
              children: [
                Center(
                  child: Container(
                    width: 370,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFFF6E9E9), // Set opacity here
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Text('Name'),
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Container(
                                  width: 80,
                                  height: 30,
                                  color: Colors.white,
                                  child: TextFormField(
                                    controller: organizername,
                                    style: TextStyle(fontSize: 10),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide:
                                        BorderSide(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Text('Number of Events'),
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Container(
                                  width: 80,
                                  height: 30,
                                  color: Colors.white,
                                  child: TextFormField(
                                    controller: numberOfEventsController,
                              
                                    style: TextStyle(fontSize: 10),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                      ),
                                    ),
                                    // validator: (value) {
                                    //   if (value == null || value.isEmpty) {
                                    //     return 'Please enter a value';
                                    //   }
                                    //   return null;
                                    // },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: SizedBox(
                            height: 24,
                            width: 150,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_validateForm()) {
                                  context.read<SubscriptionBloc>().add(
                                      GetSubscriptionPaymentModeEvent(
                                          name: organizername.text,
                                          planId: planId,
                                          planName: planName,
                                          noOfEvents:
                                              numberOfEventsController.text,
                                          noOfStables:
                                              numberOfStablesController.text,
                                          noOfHorses:
                                              numberOfHorsesController.text));

                                  // Navigator.pushReplacement(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             MyBottomSheet(
                                  //               planId: planId,
                                  //               planName: planName,
                                  //               noofEvents: numberOfEventsController.text,
                                  //               noofStables: numberOfStablesController.text,
                                  //               noofHorse: numberOfHorsesController.text,)));
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                              ),
                              child: Text('Continue',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: SizedBox(
                            height: 24,
                            width: 150,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => subs_plan()));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                              ),
                              child: Text('Change Plan',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _showSingleStableAlertDialog(
      BuildContext context, int planId, String planName) {
    showDialog(
      context: context,
      builder: (BuildContext context1) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(planName, style: TextStyle()),
          content: Text('You have chosen ${planName}.'),
          actions: [
            Container(
              width: 400,
              height: 280,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xFFF6E9E9), // Set opacity here
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 5.0, top: 15),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Text('Name'),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Container(
                              width: 80,
                              height: 30,
                              color: Colors.white,
                              child: TextFormField(
                                controller: organizername,
                                style: TextStyle(fontSize: 10),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                     SizedBox(height: 16.0),

                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 0),
                            child: Text('Number of Stables'),
                          ),
                        ),
                        SizedBox(width: 20,),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 0),
                            child: Container(
                              width: 80,
                              height: 30,
                              color: Colors.white,
                              child: TextFormField(
                                controller: numberOfStablesController,
                                style: TextStyle(fontSize: 10),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                ),
                                // validator: (value) {
                                //   if (value == null || value.isEmpty) {
                                //     return 'Please enter a value';
                                //   }
                                //   return null;
                                // },
                                enabled: false,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(child: Text('Number of Horses')),
                        SizedBox(width: 22),
                        Expanded(
                          child: Container(
                            width: 80,
                            height: 30,
                            color: Colors.white,
                            child: TextFormField(
                              controller: numberOfHorsesController,
                              style: TextStyle(fontSize: 10),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                              ),
                              // validator: (value) {
                              //   if (value == null || value.isEmpty) {
                              //     return 'Please enter a value';
                              //   }
                              //   return null;
                              // },
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20),
                    Center(
                      child: SizedBox(
                        height: 24,
                        width: 150,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_validateForm_Single()) {
                              context.read<SubscriptionBloc>().add(
                                  GetSubscriptionPaymentModeEvent(
                                      name: organizername.text,
                                      planId: planId,
                                      planName: planName,
                                      noOfEvents: numberOfEventsController.text,
                                      noOfStables:
                                          numberOfStablesController.text,
                                      noOfHorses:
                                          numberOfHorsesController.text));
                              // Navigator.push(context,  MaterialPageRoute(
                              //     builder: (context) =>
                              //         MyBottomSheet(
                              //           planId: planId,
                              //           planName: planName,
                              //           noofEvents: numberOfEventsController.text,
                              //           noofStables: numberOfStablesController.text,
                              //           noofHorse: numberOfHorsesController.text,)));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                          ),
                          child: Text('Continue',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: SizedBox(
                        height: 24,
                        width: 150,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => subs_plan()));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                          ),
                          child: Text('Change Plan',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }

  void _showMultipleStableAlertDialog(
      BuildContext context, int planId, String planName) {
    showDialog(
      context: context,
      builder: (BuildContext context1) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(planName, style: TextStyle()),
          content: Text('You have chosen ${planName}.'),
          actions: [
            Center(
              child: Container(
                width: 390,
                height: 280,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xFFF6E9E9), // Set opacity here
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 5.0, top: 15),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Text('Name'),
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Container(
                                width: 80,
                                height: 30,
                                color: Colors.white,
                                child: TextFormField(
                                  controller: organizername,
                                  style: TextStyle(fontSize: 10),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0),
                      Row(
                        children: [
                          Expanded(child: Text('Number of Stables')),
                          SizedBox(width: 20),
                          Expanded(
                            child: Container(
                              width: 80,
                              height: 30,
                              color: Colors.white,
                              child: TextFormField(
                                controller: numberOfStablesController,
                                style: TextStyle(fontSize: 10),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                ),
                                // validator: (value) {
                                //   if (value == null || value.isEmpty) {
                                //     return 'Please enter a value';
                                //   }
                                // },
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(child: Text('Number of Horses')),
                          SizedBox(width: 22),
                          Expanded(
                            child: Container(
                              width: 80,
                              height: 30,
                              color: Colors.white,
                              child: TextFormField(
                                controller: numberOfHorsesController,
                                style: TextStyle(fontSize: 10),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                ),
                                // validator: (value) {
                                //   if (value == null || value.isEmpty) {
                                //     return 'Please enter a value';
                                //   }
                                //   return null;
                                // },
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 20),
                      Center(
                        child: SizedBox(
                          height: 24,
                          width: 150,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_validateForm_Single()) {
                                context.read<SubscriptionBloc>().add(
                                    GetSubscriptionPaymentModeEvent(
                                        name: organizername.text,
                                        planId: planId,
                                        planName: planName,
                                        noOfEvents:
                                            numberOfEventsController.text,
                                        noOfStables:
                                            numberOfStablesController.text,
                                        noOfHorses:
                                            numberOfHorsesController.text));
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) =>
                                //             MyBottomSheet(
                                //               planId: planId,
                                //               planName: planName,
                                //               noofEvents: numberOfEventsController.text,
                                //               noofStables: numberOfStablesController.text,
                                //               noofHorse: numberOfHorsesController.text,
                                //               paymentmodes: )));
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                            ),
                            child: Text('Continue',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: SizedBox(
                          height: 24,
                          width: 150,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => subs_plan()));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                            ),
                            child: Text('Change Plan',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class SubscriptionButton extends StatelessWidget {
  final String planType;
  final List<String> features;
  final Color buttonColor;
  //final VoidCallback onTap;
  final String assetImage;
  final String text;
  final Color colors;
  //final VoidCallback alertDialog;
  final int planId;
  final String planName;

  SubscriptionButton({
    required this.planType,
    required this.features,
    required this.buttonColor,
    required this.assetImage,
    required this.text,
    //required this.onTap,
    required this.colors,
    //required this.alertDialog,
    required this.planId,
    required this.planName,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: GestureDetector(
        //onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Container(
            height: 225,
            width: 320,
            decoration: BoxDecoration(
              color: Color(0xFFF6E9E9),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Color(0x40000000),
                  offset: Offset(0, 4),
                  blurRadius: 4,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 37,
                  width: (planType == 'Event Organizer') ? 180 : 240,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.only(bottomRight: Radius.circular(100)),
                    color: colors,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Container(
                          width: 25,
                          height: 25,
                          child: Image.asset(
                            assetImage,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          planType,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, bottom: 10),
                  child: Text(
                    text,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: features
                        .map(
                          (feature) => Text(
                            '. $feature',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: SizedBox(
                    width: 269,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<SubscriptionBloc>().add(
                            SelectedSubscriptionEvent(
                                planId: planId, planName: planName));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            buttonColor, // Change button color here
                      ),
                      child: Text('Choose Plan',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
