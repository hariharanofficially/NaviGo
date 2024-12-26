import 'package:EquineApp/utils/mixins/convert_date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import '../../../../../data/models/bloodtest_element.dart';
import '../../../../../data/models/bloodtest_result.dart';
import '../../../../../data/models/bloodtest_type.dart';
import '../../../../../data/models/horse_model.dart';
import '../../../../common/FormCustomWidget/datepickerform.dart';
import '../../../../common/widgets/dropdown_type.dart';
import '../../../../subscripition/manage_dashboard/singlestable_menu/bloc/singestablemenu_bloc.dart';
import '../../../../subscripition/manage_dashboard/singlestable_menu/view/singlestablemenu_view.dart';
import '../../../../nav_bar/Dashboard/bloc/Dashboard_bloc.dart';
import '../../../../nav_bar/Dashboard/view/Dashboard_view.dart';
import '../../../../../utils/constants/appreance_definition.dart';
import '../../../../common/widgets/navigation_widget.dart';
import '../../../../header/app_bar.dart';
import '../../../../home/home_screen.dart';
import '../../../../nav_bar/nav_bar.dart';
import '../../Blood_dashboard/bloc/blood_bloc.dart';
import '../../Blood_dashboard/view/Blood_Test.dart';
import '../bloc/blood_form_bloc.dart';

class BloodForm extends StatefulWidget {
  final HorseModel horse;
  final int? bloodId;
  const BloodForm({
    super.key,
    required this.horse,
    this.bloodId,
  });

  @override
  State<BloodForm> createState() => _BloodFormState();
}

class _BloodFormState extends State<BloodForm> {
  int selectedTab = 0;
  // String? selectedFoodType;
  final TextEditingController selectedFoodType = TextEditingController();
  // List of controllers for the 'Result' column
  // List<TextEditingController> resultControllers =
  //     List.generate(3, (index) => TextEditingController());
  List<BloodTestType> bloodtestType = [];
  // List<BloodTestElement> allTests = []; // Assuming this is the data list
  List<TextEditingController> bioChemistryResultControllers = [];
  List<TextEditingController> hematologyResultControllers = [];

  List<BloodTestElement> bioChemistryTests = [];
  List<BloodTestElement> hematologyTests = [];
  // List<BloodTestElement> hematologyTests = [];
  final _dateOfBirthController = TextEditingController();
  Logger logger = Logger();

  var foodtype;
  @override
  void dispose() {
    // Dispose Bio Chemistry controllers
    for (var controller in bioChemistryResultControllers) {
      controller.dispose();
    }
    bioChemistryResultControllers.clear();

    // Dispose Hematology controllers
    for (var controller in hematologyResultControllers) {
      controller.dispose();
    }
    hematologyResultControllers.clear();

    // Call the super dispose method
    super.dispose();
  }

  void initializeBioChemistryControllers(int count) {
    bioChemistryResultControllers = List.generate(
      count,
      (index) => TextEditingController(),
    );
  }

  void initializeHematologyControllers(int count) {
    hematologyResultControllers = List.generate(
      count,
      (index) => TextEditingController(),
    );
  }

  void clearControllers(List<TextEditingController> controllers) {
    for (var controller in controllers) {
      controller.dispose();
    }
    controllers.clear();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // resultControllers =
    //     bioChemistryTests.map((_) => TextEditingController()).toList();
    if (widget.bloodId != null) {
      context
          .read<BloodFormBloc>()
          .add(LoadBloodTestResultsById(id: widget.bloodId!));
    } else {
      context.read<BloodFormBloc>().add(LoadBloodform());
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BloodFormBloc, BloodFormState>(
      listener: (context, state) {
        if (state is BloodFormLoaded) {
          bloodtestType = state.allFormModel.bloodtestType;
          // Filter tests by category
          // bioChemistryTests = state.allFormModel.bloodtestelement;
          // Filter Bio Chemistry Tests
          bioChemistryTests = state.allFormModel.bloodtestelement
              .where((test) =>
                  test.category.toUpperCase().trim() == 'BIOCHEMISTRY')
              .toList();

          // // Filter Hematology Tests
          hematologyTests = state.allFormModel.bloodtestelement
              .where(
                  (test) => test.category.toUpperCase().trim() == 'HAEMATOLOGY')
              .toList();

          logger.d('Bio Chemistry Tests: ${bioChemistryTests.length}');
          logger.d('Hematology Tests: ${hematologyTests.length}');

          // Initialize controllers
          initializeBioChemistryControllers(bioChemistryTests.length);
          initializeHematologyControllers(hematologyTests.length);
          // Populate form data if bloodId is provided
          if (widget.bloodId != null) {
            final bloodtestresult = state.allFormModel.bloodtestDetails;
            selectedFoodType.text = bloodtestresult.typeName;
            _dateOfBirthController.text =
                formatDate(bloodtestresult.testDateTime);
            logger.d(widget.bloodId);
            logger.d('Bio Chemistry Tests: ${bioChemistryTests.length}');
            logger.d(
                'Hematology Tests: ${hematologyTests.length}'); // Populate the result for BioChemistry and Hematology
            final testElementId = bloodtestresult.elementId;
            final resultValue =
                bloodtestresult.result; // Log the fetched values
            logger.d('Test Element ID: $testElementId');
            logger.d('Result Value: $resultValue');
            // Map results to the respective tests

            for (int i = 0; i < bioChemistryTests.length; i++) {
              final test = bioChemistryTests[i];
              if (test.id == testElementId) {
                bioChemistryResultControllers[i].text =
                    resultValue?.toString() ?? '';
                logger.d('BioChemistry Test ${test.id}: $resultValue');
              }
            }

            for (int i = 0; i < hematologyTests.length; i++) {
              final test = hematologyTests[i];
              if (test.id == testElementId) {
                hematologyResultControllers[i].text =
                    resultValue?.toString() ?? '';
                logger.d('Hematology Test ${test.id}: $resultValue');
              }
            }
          }
        } else if (state is BloodtestFormSuccessfully) {
          String message = widget.bloodId != null
              ? 'BloodTest Updated Successfully'
              : 'BloodTest Added Successfully';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => BloodBloc(),
                  child: BloodTest(horse: widget.horse), // Pass the horse id
                ),
              ));
        } else if (state is BloodFormFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("BloodTest Add Failed")),
          );
        } else if (state is BloodTestTypeCreateSuccess) {
          bloodtestType = state.types;
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => BloodFormBloc(),
                  child: BloodForm(horse: widget.horse), // Pass the horse id
                ),
              ));
        } else if (state is BloodTestTypeDeleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("BloodTestType Deleted Successfully")),
          );
          bloodtestType = state.types;
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => BloodFormBloc(),
                  child: BloodForm(horse: widget.horse), // Pass the horse id
                ),
              ));
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: CustomAppBar(),
          endDrawer: NavigitionWidget(),
          body: state is BloodFormLoading
              ? Center(
                  child: CircularProgressIndicator(), // Show loading spinner
                )
              : SingleChildScrollView(
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
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
                                        'Blood Test',
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
                                      GestureDetector(
                                        onTap: () {},
                                        child: Center(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              // Loop through each Bio Chemistry test and get its ID and corresponding result
                                              for (int i = 0;
                                                  i < bioChemistryTests.length;
                                                  i++) {
                                                final bloodTestElementId =
                                                    bioChemistryTests[i]
                                                        .id
                                                        .toString();
                                                final result =
                                                    bioChemistryResultControllers[
                                                            i]
                                                        .text; // Get the result for Bio Chemistry test
                                                if (result != null &&
                                                    result != '') {
                                                  context
                                                      .read<BloodFormBloc>()
                                                      .add(
                                                        SubmitFormBlood(
                                                          id: widget.bloodId,
                                                          horseId: widget
                                                              .horse.id
                                                              .toString(),
                                                          dateOfBirth:
                                                              _dateOfBirthController
                                                                  .text,
                                                          BloodtestElementId:
                                                              bloodTestElementId,
                                                          BloodtestTypeId:
                                                              foodtype,
                                                          // Adjust as needed
                                                          result: result,
                                                        ),
                                                      );
                                                }
                                              }
                                              // Loop through each Hematology test and get its ID and corresponding result
                                              for (int i = 0;
                                                  i < hematologyTests.length;
                                                  i++) {
                                                final bloodTestElementId =
                                                    hematologyTests[i]
                                                        .id
                                                        .toString();
                                                final result =
                                                    hematologyResultControllers[
                                                            i]
                                                        .text; // Get the result for Hematology test
                                                if (result != null &&
                                                    result != '') {
                                                  context
                                                      .read<BloodFormBloc>()
                                                      .add(
                                                        SubmitFormBlood(
                                                          id: widget.bloodId,
                                                          horseId: widget
                                                              .horse.id
                                                              .toString(),
                                                          dateOfBirth:
                                                              _dateOfBirthController
                                                                  .text,
                                                          BloodtestElementId:
                                                              bloodTestElementId,
                                                          BloodtestTypeId:
                                                              foodtype,
                                                          // Adjust as needed
                                                          result: result,
                                                        ),
                                                      );
                                                }
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Color(0xFF85449A)),
                                            child: Text(
                                              'Save',
                                              style: TextStyle(
                                                  color: Colors.white),
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
                        // List 1
                        buildListWithTitle(
                          widget.horse.name,
                          'Horse',
                        ),

                        // // List 2
                        // buildListWithTitle(
                        //   '',
                        //   'Age',
                        // ),
                        //
                        // // List 3
                        // buildListWithTitle(
                        //   widget.horse.gender,
                        //   'Gender',
                        // ),
                        //
                        // // List 4
                        // buildListWithTitle(
                        //   '',
                        //   'Sex',
                        // ),
                        //
                        // // List 5
                        // buildListWithTitle(
                        //   '',
                        //   'Trainer',
                        // ),
                        //
                        // // List 6
                        // buildListWithTitle(
                        //   '',
                        //   'Date',
                        // ),
                        CustomDatePickerFormField(
                          controller: _dateOfBirthController,
                          hintText: 'Date of Test',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Choose Date';
                            }
                            return null;
                          },
                          onDateTap: (BuildContext context) {
                            _selectDate(context, 'start');
                          },
                          labelText: 'Date of Test',
                        ),
                        Row(
                          children: [
                            // Expanded(
                            //   flex: 2,
                            //   child: Text(
                            //     'Test Purpose',
                            //     style: TextStyle(
                            //         fontFamily: 'Karla',
                            //         fontSize: getTextSize15Value(buttonTextSize),
                            //         color: Colors.black),
                            //   ),
                            // ),

                            // SizedBox(width: 25.0),
                            Expanded(
                              flex: 9,
                              child: Container(
                                // width: 140, // Set desired width
                                height: 50,
                                child: TextFormField(
                                  controller:
                                      selectedFoodType, // Selected value
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedFoodType.text = newValue!;
                                    });
                                  },
                                  decoration: InputDecoration(
                                      labelText: 'Test Purpose',
                                      contentPadding: EdgeInsets.all(5),
                                      labelStyle: TextStyle(
                                        // fontSize: getTextSize20Value(buttonTextSize),
                                        fontFamily: 'Karla',
                                        // fontWeight: FontWeight.w100,
                                        color: Color(0xFF8B48DF),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        borderSide: const BorderSide(
                                            color: Colors.black, width: 2.0),
                                      ),
                                      fillColor:
                                          Color(0xFFE5E5FC), // Background color
                                      filled:
                                          true, // Enable filling with the color
                                      suffixIcon:
                                          Icon(Icons.arrow_forward_outlined)),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Dropdowntype(
                                                  title: 'Test Purpose',
                                                  onEdit:
                                                      (int id, String name) {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        String updatedName =
                                                            name; // To store the input from the TextField
                                                        return AlertDialog(
                                                          title: Text(
                                                              'Edit Test Purpose'), // Title of the dialog
                                                          content: TextField(
                                                            onChanged: (value) {
                                                              updatedName =
                                                                  value; // Save input to the name variable
                                                            },
                                                            controller:
                                                                TextEditingController(
                                                                    text: name),
                                                            decoration:
                                                                InputDecoration(
                                                              labelText:
                                                                  'Name', // Label for the input field
                                                              border:
                                                                  OutlineInputBorder(), // Styling the TextField
                                                            ),
                                                          ),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              onPressed: () {
                                                                // Perform save action
                                                                print(
                                                                    'Updated Name: $updatedName'); // Example: Print the name to the console
                                                                this
                                                                    .context
                                                                    .read<
                                                                        BloodFormBloc>()
                                                                    .add(SubmitBloodTestType(
                                                                        id: id,
                                                                        name:
                                                                            updatedName));
                                                              },
                                                              child: Text(
                                                                  'Update'), // The save button
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop(); // Close the dialog without saving
                                                              },
                                                              child: Text(
                                                                  'Cancel'), // The cancel button
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },
                                                  onDelete: (Id) {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          dialogContext) {
                                                        // Use a new context variable here
                                                        return AlertDialog(
                                                          title: Text(
                                                              'Confirm Delete'),
                                                          content: Text(
                                                              'Are you sure you want to delete this Test Purpose ?'),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              child: Text(
                                                                  'Cancel'),
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        dialogContext)
                                                                    .pop(); // Use dialogContext here to close the dialog
                                                              },
                                                            ),
                                                            TextButton(
                                                              child: Text(
                                                                  'Confirm'),
                                                              onPressed: () {
                                                                // Use the original context to access the HorseDashboardBloc
                                                                this
                                                                    .context
                                                                    .read<
                                                                        BloodFormBloc>()
                                                                    .add(DeleteBloodTestType(
                                                                        BloodTestTypeId:
                                                                            Id));
                                                                print(
                                                                    'Delete selected');
                                                              },
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },
                                                  onTap: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        String name =
                                                            ''; // To store the input from the TextField
                                                        return AlertDialog(
                                                          title: Text(
                                                              'Add new Test Purpose'), // Title of the dialog
                                                          content: TextField(
                                                            onChanged: (value) {
                                                              name =
                                                                  value; // Save input to the name variable
                                                            },
                                                            decoration:
                                                                InputDecoration(
                                                              labelText:
                                                                  'Name', // Label for the input field
                                                              border:
                                                                  OutlineInputBorder(), // Styling the TextField
                                                            ),
                                                          ),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              onPressed: () {
                                                                // Perform save action
                                                                print(
                                                                    'Name: $name'); // Example: Print the name to the console
                                                                this
                                                                    .context
                                                                    .read<
                                                                        BloodFormBloc>()
                                                                    .add(SubmitBloodTestType(
                                                                        name:
                                                                            name));
                                                              },
                                                              child: Text(
                                                                  'Save'), // The save button
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop(); // Close the dialog without saving
                                                              },
                                                              child: Text(
                                                                  'Cancel'), // The cancel button
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },
                                                  trainingList: bloodtestType
                                                      .map((bloodtestType) {
                                                    return {
                                                      'id': bloodtestType.id
                                                          .toString(),
                                                      'name': bloodtestType.name
                                                    };
                                                  }).toList(),
                                                ))).then((selectedValue) {
                                      // Handle the returned value from Dropdowntype
                                      if (selectedValue != null &&
                                          selectedValue
                                              is Map<String, dynamic>) {
                                        setState(() {
                                          selectedFoodType.text = selectedValue[
                                              'name']; // Update the TextFormField with the selected training name
                                          foodtype = selectedValue['id'];
                                        });
                                      }
                                    });
                                  },
                                  // items: this.bloodtestType.map((bloodtestType) {
                                  //   return DropdownMenuItem<String>(
                                  //     value: bloodtestType.id.toString(),
                                  //     child: Text(bloodtestType.name),
                                  //   );
                                  // }).toList(),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please select a food type";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            // Expanded(
                            //   flex: 1,
                            //   child: GestureDetector(
                            //     onTap: () {
                            //       showDialog(
                            //         context: context,
                            //         builder: (BuildContext context) {
                            //           String name =
                            //               ''; // To store the input from the TextField
                            //           return AlertDialog(
                            //             title: Text(
                            //                 'Add new Test Purpose'), // Title of the dialog
                            //             content: TextField(
                            //               onChanged: (value) {
                            //                 name =
                            //                     value; // Save input to the name variable
                            //               },
                            //               decoration: InputDecoration(
                            //                 labelText:
                            //                     'Name', // Label for the input field
                            //                 border:
                            //                     OutlineInputBorder(), // Styling the TextField
                            //               ),
                            //             ),
                            //             actions: <Widget>[
                            //               TextButton(
                            //                 onPressed: () {
                            //                   // Perform save action
                            //                   print(
                            //                       'Name: $name'); // Example: Print the name to the console
                            //                   this
                            //                       .context
                            //                       .read<BloodFormBloc>()
                            //                       .add(SubmitBloodTestType(
                            //                           name: name));
                            //                   Navigator.of(context)
                            //                       .pop(); // Close the dialog
                            //                 },
                            //                 child:
                            //                     Text('Save'), // The save button
                            //               ),
                            //               TextButton(
                            //                 onPressed: () {
                            //                   Navigator.of(context)
                            //                       .pop(); // Close the dialog without saving
                            //                 },
                            //                 child: Text(
                            //                     'Cancel'), // The cancel button
                            //               ),
                            //             ],
                            //           );
                            //         },
                            //       );
                            //     },
                            //     child: Container(
                            //       width: 30, // Adjust width to fit the icon
                            //       // height: 50, // Adjust height to fit the icon
                            //       decoration: BoxDecoration(
                            //         color: Color(0xFF595BD4),
                            //         shape: BoxShape.circle, // Circular shape
                            //       ),
                            //       child: Center(
                            //         child: Icon(
                            //           Icons.add, // Plus icon
                            //           color: Colors.white,
                            //           size: 24, // Icon size
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            // SizedBox(width: 10.0),
                          ],
                        ),
                        SizedBox(height: 20.0),

                        SizedBox(height: 10.0),
                        Container(
                          height: 2, // Thickness of the line
                          color: Color(0xFF595BD4), // Line color
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          'Bio Chemistry',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Display Bio Chemistry tests
                        buildBioChemistryTable(bioChemistryTests),
                        // Add the table here
                        Text(
                          'Hematology',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Display Hematology tests
                        buildHematologyTable(hematologyTests),
                        // Table(
                        //   border: TableBorder.all(
                        //     color: Colors.black,
                        //     width: 1.0,
                        //   ),
                        //   children: [
                        //     // Table Header Row with Custom Color
                        //     TableRow(
                        //       decoration: BoxDecoration(
                        //         color: Color(
                        //             0xFF8B48DF), // Header background color
                        //       ),
                        //       children: [
                        //         tableHeaderCell('Test Name'),
                        //         tableHeaderCell('Unit'),
                        //         tableHeaderCell('Normal Range'),
                        //         tableHeaderCell('Result'),
                        //       ],
                        //     ),
                        //     // Table Rows with editable Result column
                        //     buildTableRow('Hemoglobin', 'g/dL', '12-16', 0),
                        //     buildTableRow('Platelets', '10^9/L', '150-450', 1),
                        //     buildTableRow(
                        //         'White Blood Cells', '10^9/L', '4-11', 2),
                        //   ],
                        // ),
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
          ),
        );
      },
    );
  }

  /// Helper method to build the table for tests (Bio Chemistry or Hematology)
  Widget buildBioChemistryTable(List<BloodTestElement> tests) {
    initializeBioChemistryControllers(tests.length);

    // Add listeners to synchronize the result across all controllers
    // for (int i = 0; i < bioChemistryResultControllers.length; i++) {
    //   bioChemistryResultControllers[i].addListener(() {
    //     String text = bioChemistryResultControllers[i].text;
    //     // Propagate the result entered to other controllers in the same table
    //     for (var controller in bioChemistryResultControllers) {
    //       if (controller.text != text) {
    //         controller.text = text;
    //         controller.selection = TextSelection.collapsed(offset: text.length);
    //       }
    //     }
    //   });
    // }

    return Table(
      border: TableBorder.all(color: Colors.black, width: 1.0),
      children: [
        TableRow(
          decoration: BoxDecoration(color: Color(0xFF8B48DF)),
          children: [
            tableHeaderCell('Test Name'),
            tableHeaderCell('Unit'),
            tableHeaderCell('Normal Range'),
            tableHeaderCell('Result'),
          ],
        ),
        for (int i = 0; i < tests.length; i++)
          buildTableRow(
            tests[i].name,
            tests[i].unit,
            tests[i].normalRange,
            i,
            bioChemistryResultControllers,
          ),
      ],
    );
  }

  Widget buildHematologyTable(List<BloodTestElement> tests) {
    initializeHematologyControllers(tests.length);

    // Add listeners to synchronize the result across all controllers
    // for (int i = 0; i < hematologyResultControllers.length; i++) {
    //   hematologyResultControllers[i].addListener(() {
    //     String text = hematologyResultControllers[i].text;
    //     // Propagate the result entered to other controllers in the same table
    //     for (var controller in hematologyResultControllers) {
    //       if (controller.text != text) {
    //         controller.text = text;
    //         controller.selection = TextSelection.collapsed(offset: text.length);
    //       }
    //     }
    //   });
    // }

    return Table(
      border: TableBorder.all(color: Colors.black, width: 1.0),
      children: [
        TableRow(
          decoration: BoxDecoration(color: Color(0xFF8B48DF)),
          children: [
            tableHeaderCell('Test Name'),
            tableHeaderCell('Unit'),
            tableHeaderCell('Normal Range'),
            tableHeaderCell('Result'),
          ],
        ),
        for (int i = 0; i < tests.length; i++)
          buildTableRow(
            tests[i].name,
            tests[i].unit,
            tests[i].normalRange,
            i,
            hematologyResultControllers,
          ),
      ],
    );
  }

  // Helper method for header cells
  Widget tableHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white, // Header text color
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  } // Helper method for normal cells

  Widget tableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Text(text),
      ),
    );
  }

  // Helper method to build each TableRow with editable Result column
  // Helper method to build each TableRow with editable Result column
  TableRow buildTableRow(
    String testName,
    String unit,
    String normalRange,
    int index,
    List<TextEditingController> controllers,
  ) {
    return TableRow(
      children: [
        tableCell(testName),
        tableCell(unit),
        tableCell(normalRange),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: controllers[index],
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter result',
            ),
          ),
        ),
      ],
    );
  }

  // Helper method to build a ListView with a title
  Widget buildListWithTitle(String subtitle, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Expanded(
            //   child: Text(
            //     title,
            //     style: TextStyle(
            //         fontFamily: 'Karla',
            //         fontSize: getTextSize15Value(buttonTextSize),
            //         color: Colors.black),
            //   ),
            // ),
            // Expanded(child: Text(subtitle)),
            Expanded(
              flex: 8, // Set desired width
              child: Container(
                height: 57, // Set desired height
                child: Align(
                  alignment: Alignment.center,
                  child: TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: title,
                      contentPadding: EdgeInsets.all(7),
                      labelStyle: TextStyle(
                        // fontSize:
                        //     getTextSize20Value(buttonTextSize),
                        fontFamily: 'Karla',
                        // fontWeight: FontWeight.w100,
                        color: Color(0xFF8B48DF),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide:
                            const BorderSide(color: Colors.black, width: 2.0),
                      ),
                      fillColor: Color(0xFFE5E5FC),
                      filled: true,
                    ),
                    style: TextStyle(
                      fontFamily: 'Karla',
                      fontSize: getTextSize15Value(buttonTextSize),
                      color: Colors.black,
                    ),
                    controller: TextEditingController(text: subtitle),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
