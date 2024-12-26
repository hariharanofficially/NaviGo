import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../../data/models/horse_model.dart';
import '../../../../../data/models/treatment_type.dart';
import '../../../../common/widgets/dropdown_type.dart';
import '../../../../nav_bar/Dashboard/bloc/Dashboard_bloc.dart';
import '../../../../nav_bar/Dashboard/view/Dashboard_view.dart';
import '../../../../../utils/constants/appreance_definition.dart';
import '../../../../common/widgets/navigation_widget.dart';
import '../../../../header/app_bar.dart';
import '../../../../home/home_screen.dart';
import '../../../../nav_bar/nav_bar.dart';
import '../../../../subscripition/manage_dashboard/singlestable_menu/bloc/singestablemenu_bloc.dart';
import '../../../../subscripition/manage_dashboard/singlestable_menu/view/singlestablemenu_view.dart';
import '../../Treatment_dashboard/bloc/treatment_bloc.dart';
import '../../Treatment_dashboard/view/Treatment.dart';
import '../bloc/treatment_form_bloc.dart';
import 'package:flutter/gestures.dart';

class TreatmentForm extends StatefulWidget {
  final HorseModel horse;
  final int? treatmentId;
  final bool isSave;

  const TreatmentForm(
      {super.key, required this.horse, this.treatmentId, required this.isSave});

  @override
  State<TreatmentForm> createState() => _TreatmentFormState();
}

class _TreatmentFormState extends State<TreatmentForm>
    with TickerProviderStateMixin {
  final horsecontroller = TextEditingController();
  // String? selectedTreatmentType;
  final TextEditingController selectedTreatmentType = TextEditingController();

  final notesController = TextEditingController();
  int selectedTab = 0;
  DateTime _selectedDateCalendar1 = DateTime.now();
  DateTime focusedDayCalendar1 = DateTime.now();

  DateTime _selectedDateCalendar2 = DateTime.now();
  DateTime focusedDayCalendar2 = DateTime.now();

  late AnimationController _animationController1;
  late AnimationController _animationController2;
  late Animation<double> _animation1;
  late Animation<double> _animation2;

  bool _isCalendarExpanded1 = false;
  bool _isCalendarExpanded2 = false;
  List<TreatmentType> treatment = [];
  var treatmenttype;
  List<String> _fileNames = []; // List to store multiple file names
  List<String?> _filePaths = [];
  bool _isLink = false;

  Future<void> _selectAndUploadFiles(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true, // Allow multiple file selection
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt'], // Supported types
      );

      if (result != null) {
        setState(() {
          _fileNames = result.files
              .map((file) => file.name)
              .toList(); // Extract file names
          _filePaths = result.files
              .map((file) => file.path)
              .toList(); // Extract file paths
        });

        // // Upload each file
        // for (var filePath in _filePaths) {
        //   if (filePath != null) {
        //     context.read<TreatmentFormBloc>().add(
        //           UploadTreatmentFile(filePath: filePath),
        //         );
        //   }
        // }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error selecting files: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    // Initialize AnimationController for dropdown animation
    _animationController1 = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation1 = CurvedAnimation(
      parent: _animationController1,
      curve: Curves.easeInOut,
    );

    _animationController2 = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation2 = CurvedAnimation(
      parent: _animationController2,
      curve: Curves.easeInOut,
    );
    if (widget.treatmentId != null) {
      context
          .read<TreatmentFormBloc>()
          .add(LoadTreatmentformByid(id: widget.treatmentId!));
    } else {
      context.read<TreatmentFormBloc>().add(LoadTreatmentform());
    }
  }

  @override
  void dispose() {
    // Dispose the controller to free up resources
    _animationController1.dispose();
    _animationController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TreatmentFormBloc, TreatmentFormState>(
      listener: (context, state) {
        if (state is TreatmentFormLoaded) {
          treatment = state.allFormModel.treatmentType;
          print('treatment');
          for (var treatmentType in treatment) {
            print('ID: ${treatmentType.id}, Name: ${treatmentType.name}');
          }
          if (widget.treatmentId != null) {
            final gettreatment = state.allFormModel.treatmentDetail;
            selectedTreatmentType.text =
                gettreatment.treatmentTypeName.toString();
            notesController.text = gettreatment.notes!;
          }
        } else if (state is TreatmentFormSuccessfully) {
          String message = widget.treatmentId != null
              ? 'Treatment Updated Successfully'
              : 'Treatment Added Successfully';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => TreatmentBloc(),
                  child: Treatment(horse: widget.horse), // Pass the horse id
                ),
              ));
        } else if (state is TreatmentFormerror) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Treatment Add failed")),
          );
        } else if (state is FetchDocumentFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("FetchDocumentFailed")),
          );
        } else if (state is TreatmentTypeCreateSuccess) {
          treatment = state.types;
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => BlocProvider(
          //         create: (context) => TreatmentFormBloc(),
          //         child: TreatmentForm(
          //           horse: widget.horse,
          //           isSave: true,
          //         ), // Pass the horse id
          //       ),
          //     ));
        } else if (state is DeleteTreatmentType) {
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => BlocProvider(
          //         create: (context) => TreatmentFormBloc(),
          //         child: TreatmentForm(
          //           horse: widget.horse,
          //           isSave: true,
          //         ), // Pass the horse id
          //       ),
          //     ));
        } else if (state is FileUploadSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is FileUploadError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.error}')),
          );
        } else if (state is TreatmentTypeDeleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Treatment Type Deleted Successfully')),
          );
          treatment = state.types;
        } else if (state is FileDownloadInProgress) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Download InProgress')),
          );
        } else if (state is FileDownloadSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Download Successfully')),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: CustomAppBar(),
          endDrawer: NavigitionWidget(),
          body: state is TreatmentFormLoading
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
                                        'Treatment',
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
                                      if (widget.isSave)
                                        GestureDetector(
                                          onTap: () {},
                                          child: Center(
                                            child: ElevatedButton(
                                              onPressed: () {
                                                context
                                                    .read<TreatmentFormBloc>()
                                                    .add(SubmitFormTreatment(
                                                      id: widget.treatmentId,
                                                      horseId: widget.horse.id
                                                          .toString(),
                                                      notes:
                                                          notesController.text,
                                                      treatmentDatetime:
                                                          _selectedDateCalendar1
                                                              .toIso8601String(),
                                                      nextCheckupDatetime:
                                                          _selectedDateCalendar2
                                                              .toIso8601String(),
                                                      treatmenttypeid:
                                                          treatmenttype,
                                                      filePath:
                                                          _filePaths, // treatmenttypeid:
                                                      //     selectedTreatmentType
                                                      //         .toString(),
                                                    ));
                                                // for (var filePath
                                                //     in _filePaths) {
                                                //   if (filePath != null) {
                                                //     context
                                                //         .read<
                                                //             TreatmentFormBloc>()
                                                //         .add(
                                                //           UploadTreatmentFile(
                                                //               filePath:
                                                //                   filePath),
                                                //         );
                                                //   }
                                                // }
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
                        Row(
                          children: [
                            Expanded(
                              flex: 0,
                              child: Text(
                                '',
                                style: TextStyle(
                                    fontFamily: 'Karla',
                                    fontSize:
                                        getTextSize15Value(buttonTextSize),
                                    color: Colors.black),
                              ),
                            ),
                            // SizedBox(width: 10.0),
                            Expanded(
                              flex: 8,
                              child: Container(
                                // width: 210, // Set desired width
                                height: 40,
                                child: TextFormField(
                                    readOnly: true,
                                    //keyboardType: TextInputType.emailAddress,
                                    controller: TextEditingController(
                                        text: widget.horse.name),
                                    decoration: InputDecoration(
                                      labelText: 'Horse',
                                      contentPadding: EdgeInsets.all(7),
                                      labelStyle: TextStyle(
                                          // fontSize:
                                          //     getTextSize20Value(buttonTextSize),
                                          fontFamily: 'Karla',
                                          // fontWeight: FontWeight.w100,
                                          color: Color(0xFF8B48DF)),
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
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Enter Horse details";
                                      }
                                    }),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          children: [
                            // Expanded(
                            //   flex: 1,
                            //   child: Text(
                            //     'Treatment Type',
                            //     style: TextStyle(
                            //       fontFamily: 'Karla',
                            //       fontSize: getTextSize15Value(buttonTextSize),
                            //       color: Colors.black,
                            //     ),
                            //   ),
                            // ),

                            // SizedBox(width: 25.0),
                            Expanded(
                              flex: 8,
                              child: Container(
                                // width: 160, // Set desired width
                                height: 40,
                                child: TextFormField(
                                  controller:
                                      selectedTreatmentType, // Selected value
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedTreatmentType.text = newValue!;
                                    });
                                  },
                                  decoration: InputDecoration(
                                      labelText: 'Treatment Type',
                                      contentPadding: EdgeInsets.all(7),
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
                                                  title: 'Treatment type',
                                                  onEdit:
                                                      (int id, String name) {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context1) {
                                                        String updatedName =
                                                            name; // Pre-fill with the current name
                                                        return AlertDialog(
                                                          title: Text(
                                                            'Edit Treatment Type',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Karla',
                                                              fontSize:
                                                                  15, // Adjust the font size as per your requirement
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                          content: TextField(
                                                            onChanged: (value) {
                                                              updatedName =
                                                                  value; // Update the name as user types
                                                            },
                                                            controller:
                                                                TextEditingController(
                                                                    text:
                                                                        name), // Show current name
                                                            decoration:
                                                                InputDecoration(
                                                              labelText: 'Name',
                                                              border:
                                                                  OutlineInputBorder(),
                                                            ),
                                                          ),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              onPressed: () {
                                                                // Perform save action
                                                                print(
                                                                    'Updated Name: $updatedName'); // Example: Print the updated name
                                                                context
                                                                    .read<
                                                                        TreatmentFormBloc>()
                                                                    .add(
                                                                      SubmitTreatmentType(
                                                                        id: id,
                                                                        name:
                                                                            updatedName,
                                                                      ),
                                                                    );

                                                                Navigator.of(
                                                                        context1)
                                                                    .pop(); // Close the dialog
                                                              },
                                                              child: Text(
                                                                  'Update'),
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context1)
                                                                    .pop(); // Close the dialog without saving
                                                              },
                                                              child: Text(
                                                                  'Cancel'),
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
                                                              'Are you sure you want to delete this TreatmentType?'),
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
                                                                        TreatmentFormBloc>()
                                                                    .add(DeleteTreatmentType(
                                                                        treatmenttypeId:
                                                                            Id));
                                                                print(
                                                                    'Delete selected');
                                                                Navigator.of(
                                                                        dialogContext)
                                                                    .pop(); // Use dialogContext here to close the dialog after confirming
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
                                                          context1) {
                                                        String name =
                                                            ''; // To store the input from the TextField
                                                        return AlertDialog(
                                                          title: Text(
                                                            'Add New Treatment Type',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Karla',
                                                                fontSize:
                                                                    getTextSize15Value(
                                                                        buttonTextSize),
                                                                color: Colors
                                                                    .black),
                                                          ), // Title of the dialog
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
                                                                        TreatmentFormBloc>()
                                                                    .add(SubmitTreatmentType(
                                                                        name:
                                                                            name));

                                                                Navigator.of(
                                                                        context1)
                                                                    .pop(); // Close the dialog
                                                              },
                                                              child: Text(
                                                                  'Save'), // The save button
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context1)
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
                                                  trainingList: treatment
                                                      .map((treatment) {
                                                    return {
                                                      'id': treatment.id
                                                          .toString(),
                                                      'name': treatment.name
                                                    };
                                                  }).toList(),
                                                ))).then((selectedValue) {
                                      // Handle the returned value from Dropdowntype
                                      if (selectedValue != null &&
                                          selectedValue
                                              is Map<String, dynamic>) {
                                        setState(() {
                                          selectedTreatmentType.text =
                                              selectedValue[
                                                  'name']; // Update the TextFormField with the selected training name
                                          treatmenttype = selectedValue['id'];
                                        });
                                      }
                                    });
                                  },
                                  // items: this.treatment.map((treatment) {
                                  //   return DropdownMenuItem<String>(
                                  //     value: treatment.id.toString(),
                                  //     child: Text(treatment.name),
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
                            //         builder: (BuildContext context1) {
                            //           String name =
                            //               ''; // To store the input from the TextField
                            //           return AlertDialog(
                            //             title: Text(
                            //               'Add New Treatment Type',
                            //               style: TextStyle(
                            //                   fontFamily: 'Karla',
                            //                   fontSize: getTextSize15Value(
                            //                       buttonTextSize),
                            //                   color: Colors.black),
                            //             ), // Title of the dialog
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
                            //                       .read<TreatmentFormBloc>()
                            //                       .add(SubmitTreatmentType(
                            //                           name: name));

                            //                   Navigator.of(context1)
                            //                       .pop(); // Close the dialog
                            //                 },
                            //                 child:
                            //                     Text('Save'), // The save button
                            //               ),
                            //               TextButton(
                            //                 onPressed: () {
                            //                   Navigator.of(context1)
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
                            //       width: 27, // Adjust width to fit the icon
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
                        SizedBox(height: 10.0),
                        Container(
                          height: 2, // Thickness of the line
                          color: Color(0xFF595BD4), // Line color
                        ),
                        SizedBox(height: 10.0),
                        _buildCustomCalendarHeader(
                          focusedDay: focusedDayCalendar1,
                          onPreviousPressed: () {
                            setState(() {
                              focusedDayCalendar1 = DateTime(
                                focusedDayCalendar1.year,
                                focusedDayCalendar1.month - 1,
                              );
                            });
                          },
                          onHeaderTap: _toggleCalendar1, // Toggle calendar 1
                        ),
                        // First calendar here
                        SizeTransition(
                          sizeFactor: _animation1,
                          axisAlignment: -1.0,
                          child: TableCalendar(
                            focusedDay: focusedDayCalendar1,
                            firstDay: DateTime.utc(2010, 10, 16),
                            lastDay: DateTime.utc(2030, 3, 14),
                            selectedDayPredicate: (day) =>
                                isSameDay(_selectedDateCalendar1, day),
                            onDaySelected: (selectedDay, focusedDay) {
                              setState(() {
                                _selectedDateCalendar1 = selectedDay;
                                focusedDayCalendar1 = focusedDay;
                                _toggleCalendar1(); // Close calendar 1
                              });
                            },
                            calendarFormat: CalendarFormat.month,
                            headerVisible: false,
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          height: 2, // Thickness of the line
                          color: Color(0xFF595BD4), // Line color
                        ),
                        SizedBox(height: 10.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Notes',
                              style: TextStyle(
                                fontFamily: 'Karla',
                                fontSize: getTextSize15Value(buttonTextSize),
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                                height:
                                    10.0), // Add spacing between label and notes box
                            TextFormField(
                              controller:
                                  notesController, // Define this controller in your state
                              maxLines:
                                  5, // Set this to control the height of the box
                              decoration: InputDecoration(
                                fillColor: Colors
                                    .white, // Background color for the notes box
                                filled: true, // Enable filling with the color
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                      color: Colors.black, width: 2.0),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter some notes";
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Container(
                          height: 2, // Thickness of the line
                          color: Color(0xFF595BD4), // Line color
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          'Current Treatment Date',
                          style: GoogleFonts.karla(
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        _buildCustomCalendarHeader(
                          focusedDay: focusedDayCalendar2,
                          onPreviousPressed: () {
                            setState(() {
                              focusedDayCalendar2 = DateTime(
                                focusedDayCalendar2.year,
                                focusedDayCalendar2.month - 1,
                              );
                            });
                          },
                          onHeaderTap: _toggleCalendar2, // Toggle calendar 2
                        ),
                        // Second calendar here
                        SizeTransition(
                          sizeFactor: _animation2,
                          axisAlignment: -1.0,
                          child: TableCalendar(
                            focusedDay: focusedDayCalendar2,
                            firstDay: DateTime.utc(2010, 10, 16),
                            lastDay: DateTime.utc(2030, 3, 14),
                            selectedDayPredicate: (day) =>
                                isSameDay(_selectedDateCalendar2, day),
                            onDaySelected: (selectedDay, focusedDay) {
                              setState(() {
                                _selectedDateCalendar2 = selectedDay;
                                focusedDayCalendar2 = focusedDay;
                                _toggleCalendar2(); // Close calendar 2
                              });
                            },
                            calendarFormat: CalendarFormat.month,
                            headerVisible: false,
                          ),
                        ),
                        Container(
                          height: 2, // Thickness of the line
                          color: Color(0xFF595BD4), // Line color
                        ),
                        GestureDetector(
                          onTap: () async {
                            await _selectAndUploadFiles(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.attach_file, // Attachment icon
                                  size: 50.0,
                                  color: Color(0xFF595BD4)),
                              SizedBox(width: 8.0),
                              Text(
                                "Attachment",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (_fileNames.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Loop through each selected file and display its name
                                for (int i = 0; i < _fileNames.length; i++)
                                  Row(
                                    children: [
                                      Icon(Icons.description,
                                          size: 20.0, color: Colors.green),
                                      SizedBox(width: 8.0),
                                      Expanded(
                                        child: Text(
                                          _fileNames[i],
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.black87),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      if (state is FileUploadInProgress &&
                                          state.fileIndex == i)
                                        CircularProgressIndicator(
                                            strokeWidth: 2.0),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        // if (state is FetchDocumentSuccess)
                        //   // Display fetched documents
                        //   Padding(
                        //     padding: const EdgeInsets.symmetric(vertical: 8.0),
                        //     child: Column(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         Row(
                        //           children: [
                        //             Icon(Icons.description,
                        //                 size: 20.0, color: Colors.blue),
                        //             SizedBox(width: 8.0),
                        //             Expanded(
                        //               child: Text(
                        //                 state.documentName,
                        //                 style: TextStyle(
                        //                     fontSize: 14.0,
                        //                     color: Colors.black87),
                        //                 overflow: TextOverflow.ellipsis,
                        //               ),
                        //             ),
                        //             IconButton(
                        //               icon: Icon(Icons.download,
                        //                   color: Colors.green),
                        //               onPressed: () {
                        //                 // Implement the download action
                        //               },
                        //             ),
                        //             IconButton(
                        //               icon: Icon(Icons.delete),
                        //               onPressed: () {},
                        //               color: Colors.red,
                        //               iconSize: 30.0,
                        //             )
                        //           ],
                        //         ),
                        //       ],
                        //     ),
                        //   )
                        // if (state is FetchDocumentSuccess)
                        //   // Display fetched documents
                        //   Padding(
                        //     padding: const EdgeInsets.symmetric(vertical: 8.0),
                        //     child: ListView.builder(
                        //       itemCount: state.documentsList
                        //           .length, // The length of the documents list
                        //       itemBuilder: (context, index) {
                        //         var document = state.documentsList[
                        //             index]; // Access each document
                        //         return Padding(
                        //           padding:
                        //               const EdgeInsets.symmetric(vertical: 8.0),
                        //           child: Column(
                        //             crossAxisAlignment:
                        //                 CrossAxisAlignment.start,
                        //             children: [
                        //               Row(
                        //                 children: [
                        //                   Icon(Icons.description,
                        //                       size: 20.0, color: Colors.blue),
                        //                   Expanded(
                        //                     child: Text(
                        //                       document['documentName'] ??
                        //                           'No Name',
                        //                       style: TextStyle(
                        //                           fontSize: 14.0,
                        //                           color: Colors.black87),
                        //                       overflow: TextOverflow.ellipsis,
                        //                     ),
                        //                   ),
                        //                   IconButton(
                        //                     icon: Icon(Icons.download,
                        //                         color: Colors.green),
                        //                     onPressed: () {
                        //                       // Implement the download action for this document
                        //                     },
                        //                   ),
                        //                   IconButton(
                        //                     icon: Icon(Icons.delete,
                        //                         color: Colors.red),
                        //                     iconSize: 30.0,
                        //                     onPressed: () {
                        //                       // Implement the delete action for this document
                        //                     },
                        //                   )
                        //                 ],
                        //               ),
                        //             ],
                        //           ),
                        //         );
                        //       },
                        //     ),
                        //   )
                        if (state is FetchDocumentSuccess)
                          // Display fetched documents
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Container(
                              height:
                                  300.0, // Specify the desired height for the ListView
                              child: ListView.builder(
                                itemCount: state.documentsList
                                    .length, // Length of the documents list
                                itemBuilder: (context, index) {
                                  var document = state.documentsList[
                                      index]; // Access each document
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.description,
                                                size: 20.0, color: Colors.blue),
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: () => context
                                                    .read<TreatmentFormBloc>()
                                                    .add(GetDownloadDocs(
                                                      documentId: document[
                                                              'documentId'] ??
                                                          'No Id',
                                                    )),
                                                child: Text(
                                                  document['documentName'] ??
                                                      'No Name',
                                                  style: TextStyle(
                                                      fontSize: 14.0,
                                                      color: Colors.black87),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                            // IconButton(
                                            //   icon: Icon(Icons.download,
                                            //       color: Colors.green),
                                            //   onPressed: () {
                                            //     context
                                            //         .read<TreatmentFormBloc>()
                                            //         .add(GetDownloadDocs(
                                            //           documentId: document[
                                            //                   'documentId'] ??
                                            //               'No Id',
                                            //         ));
                                            //   },
                                            // ),
                                            IconButton(
                                              icon: Icon(Icons.delete,
                                                  color: Colors.red),
                                              iconSize: 30.0,
                                              onPressed: () {
                                                // Implement the delete action for this document
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          )
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

  Widget _buildCustomCalendarHeader({
    required DateTime focusedDay,
    required VoidCallback onPreviousPressed,
    required VoidCallback onHeaderTap,
  }) {
    return Card(
      color: Color(0xFFE5E5FC),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Image.asset(
                'assets/images/clock_time.png',
                width: 24,
              ),
              onPressed:
                  onPreviousPressed, // Trigger passed action for previous
            ),
            GestureDetector(
              onTap: onHeaderTap, // Trigger passed action for toggling calendar
              child: Text(
                DateFormat('EEE MMM d yyyy').format(focusedDay),
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleCalendar1() {
    setState(() {
      _isCalendarExpanded1 = !_isCalendarExpanded1;
      if (_isCalendarExpanded1) {
        _animationController1.forward();
        // Ensure the second calendar is closed
        if (_isCalendarExpanded2) {
          _isCalendarExpanded2 = false;
          _animationController2.reverse();
        }
      } else {
        _animationController1.reverse();
      }
    });
  }

  void _toggleCalendar2() {
    setState(() {
      _isCalendarExpanded2 = !_isCalendarExpanded2;
      if (_isCalendarExpanded2) {
        _animationController2.forward();
        // Ensure the first calendar is closed
        if (_isCalendarExpanded1) {
          _isCalendarExpanded1 = false;
          _animationController1.reverse();
        }
      } else {
        _animationController2.reverse();
      }
    });
  }
}
