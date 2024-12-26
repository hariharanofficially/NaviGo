import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart'; // Import the NumberPicker package
import '../../../../../data/models/horse_model.dart';
import '../../../../common/FormCustomWidget/textform_field.dart';
import '../../../../subscripition/manage_dashboard/singlestable_menu/bloc/singestablemenu_bloc.dart';
import '../../../../subscripition/manage_dashboard/singlestable_menu/view/singlestablemenu_view.dart';
import '../../../../nav_bar/Dashboard/bloc/Dashboard_bloc.dart';
import '../../../../nav_bar/Dashboard/view/Dashboard_view.dart';
import '../../../../common/widgets/navigation_widget.dart';
import '../../../../header/app_bar.dart';
import '../../../../home/home_screen.dart';
import '../../../../nav_bar/nav_bar.dart';
import '../../Body_dashboard/bloc/body_bloc.dart';
import '../../Body_dashboard/view/Body_Measurement.dart';
import '../bloc/body_form_bloc.dart';

class BodyForm extends StatefulWidget {
  final HorseModel horse;
  final int? bodyformId;

  BodyForm({super.key, this.bodyformId, required this.horse});

  @override
  State<BodyForm> createState() => _BodyFormState();
}

class _BodyFormState extends State<BodyForm> {
  // int _weight = 100; // Initial weight value
  // int height = 0; // Initial weight value
  // int weight = 0; // Initial weight value
  // int _height = 100; // Initial weight value
  int selectedTab = 0;
  // String _selectedMeasurement = 'Weight';
  // final TextEditingController _rideStartTimeController =
  //     TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final _dateOfBirthController = TextEditingController();

  // Future<void> _selectTime(BuildContext context) async {
  //   final TimeOfDay? picked = await showTimePicker(
  //     context: context,
  //     initialTime: TimeOfDay.now(),
  //   );
  //   if (picked != null) {
  //     setState(() {
  //       _rideStartTimeController.text = picked.format(context).toString();
  //     });
  //   }
  // }

  _selectDate(BuildContext context, String select) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateOfBirthController.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  // Future<void> _selectTimes(BuildContext context) async {
  //   final TimeOfDay? picked = await showTimePicker(
  //     context: context,
  //     initialTime: TimeOfDay.now(),
  //   );
  //   if (picked != null) {
  //     setState(() {
  //       _TimeController.text = picked.format(context).toString();
  //     });
  //   }
  // }

  // _selectDates(BuildContext context, String select) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(1900),
  //     lastDate: DateTime(2101),
  //   );
  //   if (picked != null) {
  //     setState(() {
  //       _dateController.text = DateFormat('dd-MM-yyyy').format(picked);
  //     });
  //   }
  // }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.bodyformId != null) {
      context
          .read<BodyFormBloc>()
          .add(LoadBodyformByid(id: widget.bodyformId!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BodyFormBloc, BodyFormState>(
      listener: (context, state) {
        if (state is BodyFormLoaded) {
          if (widget.bodyformId != null) {
            _weightController.text = state.body.weight.toString();
            _dateOfBirthController.text = state.body.getFormattedDate();
          }
        } else if (state is AddBodymeasurementSuccess) {
          String message = widget.bodyformId != null
              ? 'BodyMeasurement Updated Successfully'
              : 'BodyMeasurement Added Successfully';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BlocProvider(
                      create: (context) => BodyBloc(),
                      child: Body_Measurement(horse: widget.horse))));
        } else if (state is AddBodymeasurementFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('BodyMeasurement Added Failure')),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
            appBar: CustomAppBar(),
            endDrawer: NavigitionWidget(),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
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
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(
                                    0xFFE5E5FC), // Set the background color to blue
                                borderRadius: BorderRadius.circular(
                                    8.0), // Set the border radius
                              ),
                              padding:
                                  const EdgeInsets.fromLTRB(10, 10, 25, 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Measurement',
                                    style: GoogleFonts.karla(
                                      textStyle: TextStyle(
                                        color: Color(0xFF595BD4),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 25,
                                  ),
                                  Center(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        context.read<BodyFormBloc>().add(
                                            SubmitBodyMeasurement(
                                                id: widget.bodyformId,
                                                horse: widget.horse,
                                                dateOfBirth:
                                                    _dateOfBirthController.text,
                                                weight:
                                                    _weightController.text));
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xFF85449A)),
                                      child: Text(
                                        'Save',
                                        style: TextStyle(color: Colors.white),
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
                    CustomTextFormField(
                      hintText: 'Weight',
                      controller: _weightController,
                      labelText: 'Weight',
                    ),
                    TextFormField(
                      keyboardType:
                          TextInputType.phone, // Prevents keyboard from showing
                      controller: _dateOfBirthController,
                      readOnly: true, // Makes the TextFormField read-only
                      onTap: () {
                        _selectDate(context, 'start');
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Choose Date';
                        }
                        return null; // Return null if validation is successful
                      },
                      decoration: InputDecoration(
                        labelText: 'Date of Measurement ',
                        labelStyle: TextStyle(
                            fontFamily: 'Karla', color: Color(0xFF8B48DF)),
                        contentPadding: EdgeInsets.all(5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.calendar_today,
                            color: Colors.black45,
                          ),
                          onPressed: () {
                            _selectDate(context, 'start');
                            FocusScope.of(context).requestFocus(FocusNode());
                          },
                        ),
                        hintText: 'Date of Measurement ',
                      ),
                    ),
                    // SizedBox(height: 20),
                    // DropdownButton<String>(
                    //   value: _selectedMeasurement,
                    //   items: [
                    //     DropdownMenuItem(
                    //       value: 'Weight',
                    //       child: Text('Weight'),
                    //     ),
                    //     DropdownMenuItem(
                    //       value: 'Height',
                    //       child: Text('Height'),
                    //     ),
                    //   ],
                    //   onChanged: (String? newValue) {
                    //     setState(() {
                    //       _selectedMeasurement = newValue!;
                    //     });
                    //   },
                    // ),
                    // SizedBox(height: 20),
                    // if (_selectedMeasurement == 'Weight') ...[
                    //   Row(
                    //     children: [
                    //       RichText(
                    //         text: TextSpan(
                    //           text: 'Weight ', // First part
                    //           style: GoogleFonts.karla(
                    //             textStyle: TextStyle(
                    //               color: Colors
                    //                   .black, // Give this part a different color
                    //               fontSize: 14,
                    //               // fontWeight: FontWeight.w400,
                    //             ),
                    //           ),
                    //           children: [
                    //             TextSpan(
                    //               text: 'kg', // Second part
                    //               style: GoogleFonts.karla(
                    //                 textStyle: TextStyle(
                    //                   color:
                    //                       Colors.black, // Default color for this part
                    //                   fontSize: 14,
                    //                   // fontWeight: FontWeight.w400,
                    //                 ),
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),

                    //       // Text('Weight'),
                    //       // SizedBox(width: 8),
                    //       // Text('kg'),
                    //     ],
                    //   ),
                    //   SizedBox(height: 15), // Space before the line
                    //   Container(
                    //     height: 1, // Thickness of the line
                    //     color: Colors.black, // Line color
                    //   ),
                    //   SizedBox(height: 15), // Space before the line
                    //   Row(
                    //     children: [
                    //       Expanded(
                    //         child: TextFormField(
                    //           // focusNode: _focusNode,
                    //           decoration: InputDecoration(
                    //             labelText: 'Time',
                    //             border: InputBorder.none,
                    //           ),
                    //           keyboardType: TextInputType.phone,
                    //           autocorrect: false,
                    //           controller: _rideStartTimeController,
                    //           onSaved: (value) {
                    //             _rideStartTimeController.text =
                    //                 DateFormat('dd-MM-yyyy')
                    //                     .format(DateTime.parse(value!));
                    //           },
                    //           onTap: () {
                    //             _selectTime(context);
                    //             FocusScope.of(context).requestFocus(new FocusNode());
                    //           },

                    //           validator: (value) {
                    //             if (value!.isEmpty || value!.length < 1) {
                    //               return 'Choose Time';
                    //             }
                    //           },
                    //         ),
                    //       ),
                    //       Expanded(
                    //         child: TextFormField(
                    //           decoration: InputDecoration(
                    //             labelText: 'Date',
                    //             border: InputBorder.none,
                    //           ),
                    //           keyboardType: TextInputType
                    //               .phone, // Prevents keyboard from showing
                    //           controller: _dateOfBirthController,
                    //           readOnly: true, // Makes the TextFormField read-only
                    //           onTap: () {
                    //             _selectDate(context, 'start');
                    //             FocusScope.of(context).requestFocus(FocusNode());
                    //           },
                    //           validator: (value) {
                    //             if (value == null || value.isEmpty) {
                    //               return 'Choose Date';
                    //             }
                    //             return null; // Return null if validation is successful
                    //           },
                    //         ),
                    //       ),
                    //       Expanded(child: Text('20.06')),
                    //     ],
                    //   ),
                    //   SizedBox(height: 15), // Space before the line
                    //   Container(
                    //     height: 1, // Thickness of the line
                    //     color: Colors.black, // Line color
                    //   ),
                    //   Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       NumberPicker(
                    //         value: _weight,
                    //         minValue: 0, // Minimum weight value
                    //         maxValue: 200, // Maximum weight value
                    //         step: 1,
                    //         itemHeight: 50,
                    //         axis: Axis.vertical,
                    //         onChanged: (value) {
                    //           setState(() {
                    //             _weight = value;
                    //           });
                    //         },
                    //       ),
                    //       NumberPicker(
                    //         value: weight,
                    //         minValue: 0, // Minimum weight value
                    //         maxValue: 200, // Maximum weight value
                    //         step: 1,
                    //         itemHeight: 50,
                    //         axis: Axis.vertical,
                    //         onChanged: (value) {
                    //           setState(() {
                    //             weight = value;
                    //           });
                    //         },
                    //       ),
                    //     ],
                    //   ),
                    // ]
                    //else if (_selectedMeasurement == 'Height') ...[
                    //   // Row(
                    //   //   children: [
                    //   //     RichText(
                    //   //       text: TextSpan(
                    //   //         text: 'Height ', // First part
                    //   //         style: GoogleFonts.karla(
                    //   //           textStyle: TextStyle(
                    //   //             color: Colors
                    //   //                 .black, // Give this part a different color
                    //   //             fontSize: 14,
                    //   //             // fontWeight: FontWeight.w400,
                    //   //           ),
                    //   //         ),
                    //   //         children: [
                    //   //           TextSpan(
                    //   //             text: 'cm', // Second part
                    //   //             style: GoogleFonts.karla(
                    //   //               textStyle: TextStyle(
                    //   //                 color:
                    //   //                     Colors.black, // Default color for this part
                    //   //                 fontSize: 14,
                    //   //                 // fontWeight: FontWeight.w400,
                    //   //               ),
                    //   //             ),
                    //   //           ),
                    //   //         ],
                    //   //       ),
                    //   //     ),

                    //   //     // Text('Height'),
                    //   //     // SizedBox(width: 8),
                    //   //     // Text('cm'),
                    //   //   ],
                    //   // ),
                    //   SizedBox(height: 15), // Space before the line
                    //   Container(
                    //     height: 1, // Thickness of the line
                    //     color: Colors.black, // Line color
                    //   ),
                    //   SizedBox(height: 15), // Space before the line
                    //   Row(
                    //     children: [
                    //       Expanded(
                    //         child: TextFormField(
                    //           // focusNode: _focusNode,
                    //           decoration: InputDecoration(
                    //             labelText: 'Time',
                    //             border: InputBorder.none,
                    //           ),

                    //           keyboardType: TextInputType.phone,
                    //           autocorrect: false,
                    //           controller: _TimeController,
                    //           onSaved: (value) {
                    //             _TimeController.text = DateFormat('dd-MM-yyyy')
                    //                 .format(DateTime.parse(value!));
                    //           },
                    //           onTap: () {
                    //             _selectTimes(context);
                    //             FocusScope.of(context).requestFocus(new FocusNode());
                    //           },

                    //           validator: (value) {
                    //             if (value!.isEmpty || value!.length < 1) {
                    //               return 'Choose Time';
                    //             }
                    //           },
                    //         ),
                    //       ),
                    //       Expanded(
                    //         child: TextFormField(
                    //           decoration: InputDecoration(
                    //             labelText: 'Date',
                    //             border: InputBorder.none,
                    //           ),
                    //           keyboardType: TextInputType
                    //               .phone, // Prevents keyboard from showing
                    //           controller: _dateController,
                    //           readOnly: true, // Makes the TextFormField read-only
                    //           onTap: () {
                    //             _selectDates(context, 'start');
                    //             FocusScope.of(context).requestFocus(FocusNode());
                    //           },
                    //           validator: (value) {
                    //             if (value == null || value.isEmpty) {
                    //               return 'Choose Date';
                    //             }
                    //             return null; // Return null if validation is successful
                    //           },
                    //         ),
                    //       ),
                    //       Expanded(child: Text('20.06')),
                    //     ],
                    //   ),
                    //   SizedBox(height: 15), // Space before the line
                    //   Container(
                    //     height: 1, // Thickness of the line
                    //     color: Colors.black, // Line color
                    //   ),
                    //   SizedBox(height: 15), // Space before the line
                    //   Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       NumberPicker(
                    //         value: _height,
                    //         minValue: 0, // Minimum weight value
                    //         maxValue: 200, // Maximum weight value
                    //         step: 1,
                    //         itemHeight: 50,
                    //         axis: Axis.vertical,
                    //         onChanged: (value) {
                    //           setState(() {
                    //             _height = value;
                    //           });
                    //         },
                    //       ),
                    //       NumberPicker(
                    //         value: height,
                    //         minValue: 0, // Minimum weight value
                    //         maxValue: 200, // Maximum weight value
                    //         step: 1,
                    //         itemHeight: 50,
                    //         axis: Axis.vertical,
                    //         onChanged: (value) {
                    //           setState(() {
                    //             height = value;
                    //           });
                    //         },
                    //       ),
                    //     ],
                    //   ),
                    // ],
                  ],
                ),
              ),
            ),
            // floatingActionButtonLocation:
            //     FloatingActionButtonLocation.centerDocked,
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
            ));
      },
    );
  }
}
