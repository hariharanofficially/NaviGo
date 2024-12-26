// import 'package:EquineApp/subscription_plan/review_plan.dart';
import 'package:EquineApp/feature/subscripition/plans/review_plan/bloc/review_plan_bloc.dart';
import 'package:EquineApp/feature/subscripition/plans/review_plan/view/review_plan.dart';
import 'package:EquineApp/feature/subscripition/plans/subscription_plan/bloc/subscription_plan_bloc.dart';
import 'package:EquineApp/feature/subscripition/plans/subscription_plan/view/subscription_plan_view.dart';
// import 'package:EquineApp/Subscription_plan/subscription_plan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyBottomSheet2 extends StatefulWidget {
  const MyBottomSheet2(
      {Key? key, required this.noofStables, required this.noofHorse})
      : super(key: key);
  final String noofStables;
  final String noofHorse;
  @override
  State<MyBottomSheet2> createState() => _MyBottomSheet2State();
}

class _MyBottomSheet2State extends State<MyBottomSheet2> {
  String _selectedOption = '';
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Multiple Stable (Group)'),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Container(
                        height: 70,
                        width: 269,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: _selectedOption == 'Monthly'
                                ? Color(0XFF0004FF)
                                : Colors.white,
                            border: Border.all(color: Color(0XFF0004FF))),
                        child: RadioListTile(
                          controlAffinity: ListTileControlAffinity.trailing,
                          activeColor: Colors.white,
                          title: Text(
                            'Monthly',
                            style: TextStyle(
                                color: _selectedOption == 'Monthly'
                                    ? Colors.white
                                    : Colors.black),
                          ), // Display the title for option 1
                          subtitle: Text(
                            'Billed Monthly',
                            style: TextStyle(
                                color: _selectedOption == 'Monthly'
                                    ? Colors.white
                                    : Colors.black),
                          ), // Display a subtitle for option 1
                          value:
                              'Monthly', // Assign a value of 1 to this option
                          groupValue:
                              _selectedOption, // Use _selectedValue to track the selected option
                          onChanged: (value) {
                            _selectDate(context);
                            setState(() {
                              _selectedOption = 'Monthly';
                            });
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Container(
                        height: 70,
                        width: 269,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: _selectedOption == 'Yearly'
                                ? Color(0XFF478778)
                                : Colors.white,
                            border: Border.all(color: Color(0XFF478778))),
                        child: RadioListTile(
                          controlAffinity: ListTileControlAffinity.trailing,
                          activeColor: Colors.white,
                          title: Text(
                            'Yearly',
                            style: TextStyle(
                                color: _selectedOption == 'Yearly'
                                    ? Colors.white
                                    : Colors.black),
                          ), // Display the title for option 1
                          subtitle: Text(
                            'Billed Yearly',
                            style: TextStyle(
                                color: _selectedOption == 'Yearly'
                                    ? Colors.white
                                    : Colors.black),
                          ), // Display a subtitle for option 1
                          value: 'Yearly', // Assign a value of 1 to this option
                          groupValue:
                              _selectedOption, // Use _selectedValue to track the selected option
                          onChanged: (value) {
                            _selectDate(context);
                            setState(() {
                              _selectedOption = 'Yearly';
                            });
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Container(
                        height: 70,
                        width: 269,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: _selectedOption == 'Unlimited'
                                ? Color(0XFFCF142B)
                                : Colors.white,
                            border: Border.all(color: Color(0XFFCF142B))),
                        child: RadioListTile(
                          activeColor: Colors.white,
                          controlAffinity: ListTileControlAffinity.trailing,
                          title: Text(
                            'Unlimited',
                            style: TextStyle(
                                color: _selectedOption == 'Unlimited'
                                    ? Colors.white
                                    : Colors.black),
                          ), // Display the title for option 1
                          subtitle: Text(
                            'Billed Once',
                            style: TextStyle(
                                color: _selectedOption == 'Unlimited'
                                    ? Colors.white
                                    : Colors.black),
                          ), // Display a subtitle for option 1
                          value:
                              'Unlimited', // Assign a value of 1 to this option
                          groupValue:
                              _selectedOption, // Use _selectedValue to track the selected option
                          onChanged: (value) {
                            print('changing');
                            setState(() {
                              _selectedOption = 'Unlimited';
                              _selectedDate = null;
                            });
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Container(
                        height: 70,
                        width: 269,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: _selectedOption == 'Trial'
                                ? Color(0XFFFFC300)
                                : Colors.white,
                            border: Border.all(color: Color(0XFFFFC300))),
                        child: RadioListTile(
                          activeColor: Colors.white,
                          controlAffinity: ListTileControlAffinity.trailing,
                          title: Text(
                            'Trial',
                            style: TextStyle(
                                color: _selectedOption == 'Trial'
                                    ? Colors.white
                                    : Colors.black),
                          ), // Display the title for option 1
                          subtitle: Text(
                            '15 days Trial',
                            style: TextStyle(
                                color: _selectedOption == 'Trial'
                                    ? Colors.white
                                    : Colors.black),
                          ), // Display a subtitle for option 1
                          value: 'Trial', // Assign a value of 1 to this option
                          groupValue:
                              _selectedOption, // Use _selectedValue to track the selected option
                          onChanged: (value) {
                            print('changing');
                            setState(() {
                              _selectedOption = 'Trial';
                              _selectedDate = null;
                            });
                          },
                        ),
                      ),
                    ),
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
    return Center(
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
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      text,
                      style: TextStyle(
                          color: _selectedOption == text
                              ? Colors.white
                              : Colors.black),
                    ),
                    Icon(Icons.check_circle,
                        color: _selectedOption == text ? Colors.white : color),
                  ],
                ),
              ),
              Row(
                children: [
                  Text(
                    details,
                    style: TextStyle(
                        color: _selectedOption == text
                            ? Colors.white
                            : Colors.black),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _selectDate(BuildContext context) async {
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
    }
  }

  Widget buildContinueButton(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 44,
        width: 308,
        child: ElevatedButton(
          onPressed: () {
            if (_selectedOption.isNotEmpty &&
                (_selectedDate != null ||
                    _selectedOption == 'Unlimited' ||
                    _selectedOption == 'Trial')) {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) =>BlocProvider(create: (context) => ReviewPageBloc(),child: ReviewPage()),
              //    // builder: (context) => ReviewPage(subPlan: 'Multiple Stable Group',selectedDate: _selectedDate,selectedOption: _selectedOption,noofStables: widget.noofStables,noofHorse: widget.noofHorse,noofEvents: '',),
              //   ),
              // );
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
