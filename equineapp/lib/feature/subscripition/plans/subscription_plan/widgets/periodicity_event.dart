// import 'package:flutter/cupertino.dart';
// import 'package:EquineApp/subscription_plan/review_plan.dart';
import 'package:EquineApp/feature/subscripition/plans/review_plan/bloc/review_plan_bloc.dart';
import 'package:EquineApp/feature/subscripition/plans/subscription_plan/bloc/subscription_plan_bloc.dart';
import 'package:EquineApp/feature/subscripition/plans/subscription_plan/view/subscription_plan_view.dart';
// import 'package:EquineApp/Subscription_plan/subscription_plan.dart';
import 'package:flutter/material.dart';
import 'package:EquineApp/feature/subscripition/plans/review_plan/view/review_plan.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../data/models/paymentmodel.dart';

class MyBottomSheet extends StatefulWidget {
  const MyBottomSheet(
      {Key? key,
      required this.name,
      required this.planId,
      required this.planName,
      required this.noofEvents,
      required this.noofStables,
      required this.noofHorse,
      required this.paymentmodes})
      : super(key: key);
  final String name;
  final int planId;
  final String planName;
  final String noofStables;
  final String noofHorse;
  final String noofEvents;
  final List<Paymentmodel> paymentmodes;
  @override
  _MyBottomSheetState createState() => _MyBottomSheetState();
}

class _MyBottomSheetState extends State<MyBottomSheet> {
  String _selectedOption = '';
  String _selectedOptionName = '';
  DateTime? _selectedDate;
  bool monthly = false;
  bool yearly = false;
  bool unlimited = false;
  bool trail = false;
  List<int> colors = [0XFF0004FF, 0XFF478778, 0XFFCF142B, 0XFFFFC300];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.planName),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: 710,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text(
                        'Choose Periodicity',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                height: 350,
                width: 308,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xFFF6E9E9),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    /*buildButton('Monthly', 'Billed Monthly', Color(0XFF0004FF), () {
                      _selectDate(context);
                      setState(() {
                        _selectedOption = 'Monthly';
                      });
                    }),*/
                    /*      buildButton('Yearly', 'Billed Yearly', Color(0XFFCDFE07), () {
                      _selectDate(context);
                      setState(() {
                        _selectedOption = 'Yearly';
                      });
                    }),
                    buildButton('Unlimited', 'Billed Once', Color(0XFFCF142B), () {
                      setState(() {
                        _selectedOption = 'Unlimited';
                        _selectedDate = null;
                      });
                    }),
                    buildButton('Trial', '15 days Trial', Color(0XFF2FFEF1), () {
                      setState(() {
                        _selectedOption = 'Trial';
                        _selectedDate = null;
                      });
                    }),*/
                    // Container(
                    //     width: double.infinity,
                    //     height: 350,
                    //     margin: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                    //     child: ListView.builder(
                    //         itemCount: widget.paymentmodes?.length,
                    //         itemBuilder: (BuildContext context, int index) {
                    //           //if (plans?[index].id == 3)
                    //           return Padding(
                    //             padding:
                    //                 const EdgeInsets.symmetric(vertical: 5.0),
                    //             child: Container(
                    //               height: 70,
                    //               width: 269,
                    //               decoration: BoxDecoration(
                    //                   borderRadius: BorderRadius.circular(10),
                    //                   color: Color(int.parse(
                    //                           widget.paymentmodes[index].color))
                    //                       .withOpacity(0.4),
                    //                   border: Border.all(
                    //                       color: Color(int.parse(widget
                    //                           .paymentmodes[index].color)),
                    //                       width: 2)),
                    //               child: RadioListTile(
                    //                 controlAffinity:
                    //                     ListTileControlAffinity.trailing,
                    //                 activeColor: Colors.black,
                    //                 title: Text(
                    //                   widget.paymentmodes[index].name,
                    //                   style: TextStyle(color: Colors.black),
                    //                 ), // Display the title for option 1
                    //                 subtitle: Text(
                    //                   widget.paymentmodes[index].description,
                    //                   style: TextStyle(color: Colors.black),
                    //                 ), // Display a subtitle for option 1
                    //                 value: widget.paymentmodes[index].id
                    //                     .toString(), // Assign a value of 1 to this option
                    //                 groupValue:
                    //                     _selectedOption, // Use _selectedValue to track the selected option
                    //                 onChanged: (value) {
                    //                   //_selectDate(context);
                    //                   setState(() {
                    //                     _selectedOption = value.toString();
                    //                     _selectedOptionName =
                    //                         widget.paymentmodes[index].name;
                    //                   });
                    //                 },
                    //                 selected: _selectedOption ==
                    //                     widget.paymentmodes[index].id
                    //                         .toString(),
                    //               ),
                    //             ),
                    //           );
                    //         })),
                    Container(
                      width: double.infinity,
                      height: 320,
                      margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ListView.builder(
                        itemCount: widget.paymentmodes.length,
                        itemBuilder: (BuildContext context, int index) {
                          bool isSelected = _selectedOption ==
                              widget.paymentmodes[index].id.toString();
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Container(
                              height: 70,
                              width: 269,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: isSelected
                                    ? Color(int.parse(
                                            widget.paymentmodes[index].color))
                                        .withOpacity(0.4)
                                    : Colors.white,
                                border: Border.all(
                                  color: Color(int.parse(
                                      widget.paymentmodes[index].color)),
                                  width: 2,
                                ),
                              ),
                              child: RadioListTile(
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
                                activeColor: Colors.black,
                                title: Text(
                                  widget.paymentmodes[index].name,
                                  style: TextStyle(color: Colors.black),
                                ),
                                subtitle: Text(
                                  widget.paymentmodes[index].description,
                                  style: TextStyle(color: Colors.black),
                                ),
                                value: widget.paymentmodes[index].id.toString(),
                                groupValue: _selectedOption,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedOption = value.toString();
                                    _selectedOptionName =
                                        widget.paymentmodes[index].name;
                                  });
                                },
                                selected: isSelected,
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // Padding(
                    //   padding: const EdgeInsets.symmetric(vertical: 5.0),
                    //   child: Container(
                    //     height: 70,
                    //     width: 269,
                    //     decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(10),
                    //         color:_selectedOption == 'Monthly'?Color(0XFF0004FF):Colors.white,
                    //         border: Border.all(color:Color(0XFF0004FF))
                    //     ),
                    //
                    //     child:  RadioListTile(
                    //       controlAffinity: ListTileControlAffinity.trailing,
                    //       activeColor: Colors.white,
                    //       title: Text('Monthly',style: TextStyle(color: _selectedOption == 'Monthly'?Colors.white:Colors.black),), // Display the title for option 1
                    //       subtitle: Text(
                    //           'Billed Monthly',style: TextStyle(color: _selectedOption == 'Monthly'?Colors.white:Colors.black),), // Display a subtitle for option 1
                    //       value: 'Monthly', // Assign a value of 1 to this option
                    //       groupValue:
                    //       _selectedOption, // Use _selectedValue to track the selected option
                    //       onChanged: (value) {
                    //         _selectDate(context);
                    //         setState(() {
                    //           _selectedOption = 'Monthly';
                    //
                    //         });
                    //       },
                    //     ),
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(vertical: 5.0),
                    //   child: Container(
                    //     height: 70,
                    //     width: 269,
                    //     decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(10),
                    //         color:_selectedOption == 'Yearly'? Color(0XFF478778):Colors.white,
                    //         border: Border.all(color :Color(0XFF478778))
                    //     ),
                    //
                    //     child:  RadioListTile(
                    //       controlAffinity: ListTileControlAffinity.trailing,
                    //      activeColor: Colors.white,
                    //       title: Text('Yearly',style: TextStyle(color: _selectedOption == 'Yearly'?Colors.white:Colors.black),), // Display the title for option 1
                    //       subtitle: Text(
                    //           'Billed Yearly',style: TextStyle(color: _selectedOption == 'Yearly'?Colors.white:Colors.black),), // Display a subtitle for option 1
                    //       value: 'Yearly', // Assign a value of 1 to this option
                    //       groupValue:
                    //       _selectedOption, // Use _selectedValue to track the selected option
                    //       onChanged: (value) {
                    //         _selectDate(context);
                    //         setState(() {
                    //           _selectedOption = 'Yearly';
                    //
                    //         });
                    //       },
                    //     ),
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(vertical: 5.0),
                    //   child: Container(
                    //     height: 70,
                    //     width: 269,
                    //     decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(10),
                    //         color:_selectedOption == 'Unlimited'?Color(0XFFCF142B):Colors.white,
                    //         border: Border.all(color:Color(0XFFCF142B))
                    //     ),
                    //
                    //     child:  RadioListTile(
                    //       activeColor: Colors.white,
                    //       controlAffinity: ListTileControlAffinity.trailing,
                    //       title: Text('Unlimited',style: TextStyle(color: _selectedOption == 'Unlimited'?Colors.white:Colors.black),), // Display the title for option 1
                    //       subtitle: Text(
                    //           'Billed Once',style: TextStyle(color: _selectedOption == 'Unlimited'?Colors.white:Colors.black),), // Display a subtitle for option 1
                    //       value: 'Unlimited', // Assign a value of 1 to this option
                    //       groupValue:
                    //       _selectedOption, // Use _selectedValue to track the selected option
                    //       onChanged: (value) {
                    //         print('changing');
                    //         setState(() {
                    //           _selectedOption = 'Unlimited';
                    //           _selectedDate = null;
                    //         });
                    //       },
                    //     ),
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(vertical: 5.0),
                    //   child: Container(
                    //     height: 70,
                    //     width: 269,
                    //     decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(10),
                    //         color:_selectedOption == 'Trial'?Color(0XFFFFC300):Colors.white,
                    //         border: Border.all(color:Color(0XFFFFC300 ))
                    //     ),
                    //
                    //     child:  RadioListTile(
                    //       activeColor: Colors.white,
                    //       controlAffinity: ListTileControlAffinity.trailing,
                    //       title: Text('Trial',style: TextStyle(color: _selectedOption == 'Trial'?Colors.white:Colors.black),), // Display the title for option 1
                    //       subtitle: Text(
                    //           '15 days Trial',style: TextStyle(color: _selectedOption == 'Trial'?Colors.white:Colors.black),), // Display a subtitle for option 1
                    //       value: 'Trial', // Assign a value of 1 to this option
                    //       groupValue:
                    //       _selectedOption, // Use _selectedValue to track the selected option
                    //       onChanged: (value) {
                    //         print('changing');
                    //         setState(() {
                    //           _selectedOption = 'Trial';
                    //           _selectedDate = null;
                    //         });
                    //       },
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              ),
              buildContinueButton(context),
              SizedBox(
                height: 20,
              ),
              buildChangePlanButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButton(
      String text, String details, Color color, VoidCallback onPressed) {
    return Container();
    /* return Center(
      child: SizedBox(
        height: 60,
        width: 269,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: _selectedOption == text ? color : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: color),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5,bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      text,
                      style: TextStyle(color: _selectedOption == text ? Colors.white : Colors.black),
                    ),
                    Icon(Icons.check_circle, color: _selectedOption == text ? Colors.white : color),
                  ],
                ),
              ),
              Row(
                children: [
                  Text(
                    details,
                    style: TextStyle(color: _selectedOption == text ? Colors.white : Colors.black),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );*/
  }

  void _selectDate(BuildContext context) async {
    print('date click');
    if (_selectedOption != 'Unlimited' && _selectedOption != 'Trial') {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2101),
      );
      if (picked != null) {
        setState(() {
          _selectedDate = picked;
        });
      }
    } else {
      _selectedDate = null; // Reset selectedDate for Unlimited and Trial plans
    }
  }

  Widget buildContinueButton(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 44,
        width: 308,
        child: ElevatedButton(
          onPressed: () {
            if (_selectedOption.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                      create: (context) => ReviewPageBloc(),
                      child: ReviewPage(
                        name: widget.name,
                        planId: widget.planId,
                        planName: widget.planName,
                        noOfEvents: widget.noofEvents,
                        noOfHorses: widget.noofHorse,
                        noOfStables: widget.noofStables,
                        selectedSubscription: _selectedOption,
                        selectedSubName: _selectedOptionName,
                      )),
                  //  builder: (context) => ReviewPage(subPlan: 'Multiple Stable Group',
                  //  selectedDate: _selectedDate,
                  //  selectedOption: _selectedOption,
                  //  noofStables: widget.noofStables,
                  //  noofHorse: widget.noofHorse,noofEvents: '',),
                ),
              );
            } else {
              // Show error message or handle empty selection
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: Colors.orange),
            ),
          ),
          child: Text(
            'Continue',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget buildChangePlanButton(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 44,
        width: 308,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                    create: (context) => SubscriptionBloc(),
                    child: subs_plan()),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: Colors.orange),
            ),
          ),
          child: Text(
            'Change Plan',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
