import 'package:EquineApp/feature/common/widgets/dropdown_type.dart';

import '../../../../../data/models/trainingType.dart';
import 'package:EquineApp/data/models/rider_model.dart';
import 'package:EquineApp/data/models/surfaceType.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../../data/models/horse_model.dart';
import '../../../../../data/models/stable_model.dart';
import '../../../../nav_bar/Dashboard/bloc/Dashboard_bloc.dart';
import '../../../../nav_bar/Dashboard/view/Dashboard_view.dart';
import '../../../../../utils/constants/appreance_definition.dart';
import '../../../../common/widgets/navigation_widget.dart';
import '../../../../header/app_bar.dart';
import '../../../../home/home_screen.dart';
import '../../../../nav_bar/nav_bar.dart';
import '../../../../subscripition/manage_dashboard/singlestable_menu/bloc/singestablemenu_bloc.dart';
import '../../../../subscripition/manage_dashboard/singlestable_menu/view/singlestablemenu_view.dart';
import '../../Training_dashboard/bloc/training_bloc.dart';
import '../../Training_dashboard/view/Training_dashboard_view.dart';
import '../bloc/training_form_bloc.dart';

class TraningForm extends StatefulWidget {
  final HorseModel horse;
  final int? TraningId;
  TraningForm({super.key, required this.horse, this.TraningId});

  @override
  State<TraningForm> createState() => _TraningFormState();
}

class _TraningFormState extends State<TraningForm>
    with SingleTickerProviderStateMixin {
  // Controllers to track each PIN input field
  // final List<TextEditingController> _pinControllers =
  //     List.generate(3, (_) => TextEditingController());
  final TextEditingController _rideStartTimeController =
      TextEditingController(); // Focus nodes to focus on each field sequentially
  // final List<FocusNode> _focusNodes = List.generate(3, (_) => FocusNode());
  String? horsecontroller;
  String? ridercontroller;
  // String? typecontroller;
  String? stablecontroller;
  // String? surfacecontroller;
  var type;
  var surface;
  final TextEditingController typecontroller = TextEditingController();
  final TextEditingController surfacecontroller = TextEditingController();

  final TextEditingController distanceController = TextEditingController();
  final TextEditingController walkController = TextEditingController();
  final TextEditingController trotController = TextEditingController();
  final TextEditingController canterController = TextEditingController();
  final TextEditingController gallopController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  DateTime focusedDay = DateTime.now();
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isCalendarExpanded = false;
  int selectedTab = 0;
  List<StableModel> stables = [];
  List<HorseModel> horses = [];
  List<RiderModel> riders = [];
  List<TrainingType> trainings = [];
  List<SurfaceType> surfaces = [];

  @override
  void dispose() {
    // Dispose controllers and focus nodes when not needed
    // _pinControllers.forEach((controller) => controller.dispose());
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // Initialize AnimationController for dropdown animation
    _animationController = AnimationController(
      vsync: this, // Provides Ticker for animation
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    if (widget.TraningId != null) {
      context
          .read<TraningFormBloc>()
          .add(LoadFetchtrainingByid(id: widget.TraningId!));
    } else {
      context.read<TraningFormBloc>().add(LoadFetchtraining());
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!);
      },
    );
    if (picked != null) {
      setState(() {
        // Convert to 24-hour format
        final now = DateTime.now();
        final selectedTime =
            DateTime(now.year, now.month, now.day, picked.hour, picked.minute);

        // Format the selected time to a 24-hour string without AM/PM
        _rideStartTimeController.text = DateFormat('HH:mm')
            .format(selectedTime); // "HH:mm" gives 24-hour format
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TraningFormBloc, TraningFormState>(
      listener: (context, state) {
        if (state is TrainingLoaded) {
          //final training = state.allFormModel.trainingDetail;

          // ridercontroller = training!.riderId.toString();
          // stablecontroller = training!.stableId.toString();
          // surfacecontroller = training!.surfaceTypeId.toString();
          // typecontroller = training!.trainingType.toString();
          // horsecontroller = training!.horseId.toString();

          stables = state.allFormModel.stable;
          horses = state.allFormModel.horse;
          riders = state.allFormModel.rider;
          surfaces = state.allFormModel.surfaceType;
          trainings = state.allFormModel.trainingType;
          if (widget.TraningId != null) {
            final training = state.allFormModel.trainingDetail!;
            stablecontroller = training.stableId?.toString();
            ridercontroller = training.riderId?.toString(); // Use riderId here
            typecontroller.text = training.trainingTypeName.toString();
            surfacecontroller.text = training.surfaceTypeName!;
            distanceController.text = training.distance.toString();
            selectedDate = training.trainingDatetime;
            _rideStartTimeController.text = training.formattedDuration;
            walkController.text = training.walk!;
            trotController.text = training.trot!;
            canterController.text = training.canter!;
            gallopController.text = training.gallop!;
          }
        } else if (state is TraningFormSuccessfully) {
          String message = widget.TraningId != null
              ? "Training Updated Successfully"
              : "Training Added Successfully";
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => TraningBloc(),
                  child: TraningDashboard(
                      horse: widget.horse), // Pass the horse id
                ),
              ));
        } else if (state is TraningFormFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Training Add failed")),
          );
        } else if (state is TrainingTypeCreateSuccess) {
          trainings = state.types;
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => BlocProvider(
          //         create: (context) => TraningFormBloc(),
          //         child: TraningForm(horse: widget.horse), // Pass the horse id
          //       ),
          //     ));
        } else if (state is SurfaceTypeCreateSuccess) {
          surfaces = state.types;
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => BlocProvider(
          //         create: (context) => TraningFormBloc(),
          //         child: TraningForm(horse: widget.horse), // Pass the horse id
          //       ),
          //     ));
        } else if (state is TrainingTypeDeleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Training Type Deleted Successfully")),
          );
          trainings = state.types;
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => BlocProvider(
          //         create: (context) => TraningFormBloc(),
          //         child: TraningForm(horse: widget.horse), // Pass the horse id
          //       ),
          //     ));
        } else if (state is SurfaceTypeDeleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Surface Type Deleted Successfully")),
          );
          surfaces = state.types;
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => BlocProvider(
          //         create: (context) => TraningFormBloc(),
          //         child: TraningForm(horse: widget.horse), // Pass the horse id
          //       ),
          //     ));
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: CustomAppBar(),
          endDrawer: NavigitionWidget(),
          body: state is TrainingLoading
              ? Center(
                  child: CircularProgressIndicator(), // Show loading spinner
                )
              : SingleChildScrollView(
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.0),
                      child: Column(children: [
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
                                        'Training',
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
                                      // GestureDetector(
                                      //   onTap: () async {
                                      //
                                      //   },
                                      //   child:
                                      Center(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            print(
                                                "Submitting form for training");
                                            context.read<TraningFormBloc>().add(
                                                SubmitFormTraining(
                                                    id: widget.TraningId,
                                                    horseId: widget.horse.id
                                                        .toString(),
                                                    stableId: stablecontroller
                                                        .toString(),
                                                    riderId: ridercontroller
                                                        .toString(),
                                                    trainingId: type,
                                                    surfaceId: surface,
                                                    // trainingId:
                                                    //     typecontroller.text,
                                                    // surfaceId:
                                                    //     surfacecontroller.text,
                                                    distance:
                                                        distanceController.text,
                                                    trainingDatetime:
                                                        selectedDate
                                                            .toIso8601String(),
                                                    duration:
                                                        _rideStartTimeController
                                                            .text,
                                                    walk: walkController.text,
                                                    trot: trotController.text,
                                                    canter:
                                                        canterController.text,
                                                    gallop:
                                                        gallopController.text));
                                          },
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Color(0xFF85449A)),
                                          child: Text(
                                            'Save',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      //),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            // Expanded(
                            //   flex: 1,
                            //   child: Text(
                            //     '',
                            //     style: TextStyle(
                            //         fontFamily: 'Karla',
                            //         fontSize: getTextSize15Value(buttonTextSize),
                            //         color: Colors.black),
                            //   ),
                            // ),
                            //SizedBox(width: 10.0),
                            Expanded(
                              flex: 8, // Set desired width
                              child: Container(
                                height: 57, // Set desired height
                                child: Align(
                                  alignment: Alignment.center,
                                  child: TextFormField(
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      labelText: 'Horse',
                                      contentPadding: EdgeInsets.all(7),
                                      labelStyle: TextStyle(
                                        // fontSize:
                                        //     getTextSize20Value(buttonTextSize),
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
                                      fillColor: Color(0xFFE5E5FC),
                                      filled: true,
                                    ),
                                    style: TextStyle(
                                      fontFamily: 'Karla',
                                      fontSize:
                                          getTextSize15Value(buttonTextSize),
                                      color: Colors.black,
                                    ),
                                    controller: TextEditingController(
                                        text: widget.horse.name),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            // Expanded(
                            //   flex: 1,
                            //   child: Text(
                            //     '',
                            //     style: TextStyle(
                            //         fontFamily: 'Karla',
                            //         fontSize: getTextSize15Value(buttonTextSize),
                            //         color: Colors.black),
                            //   ),
                            // ),
                            // SizedBox(width: 10.0),
                            Expanded(
                              flex: 8,
                              child: Container(
                                //width: 221, // Set desired width
                                height: 57, // Set desired height
                                child: DropdownButtonFormField<String>(
                                  value: ridercontroller,
                                  icon: Icon(Icons.keyboard_arrow_down),
                                  decoration: InputDecoration(
                                    labelText: 'Rider',
                                    contentPadding: EdgeInsets.all(7),
                                    labelStyle: TextStyle(
                                        // fontSize:
                                        //     getTextSize20Value(buttonTextSize),
                                        fontFamily: 'Karla',
                                        // fontWeight: FontWeight.w100,
                                        color: Color(0xFF8B48DF)),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(
                                          color: Colors.black, width: 2.0),
                                    ),
                                    fillColor:
                                        Color(0xFFE5E5FC), // Background color
                                    filled:
                                        true, // Enable filling with the color
                                  ),
                                  // validator: (value) {
                                  //   if (value!.isEmpty) {
                                  //     return "Enter Rider details";
                                  //   }
                                  // },
                                  items: this.riders.map((trainings) {
                                    return DropdownMenuItem(
                                      child: Text(trainings.name),
                                      value: trainings.id.toString(),
                                    );
                                  }).toList(),
                                  onChanged: (String? value) {
                                    setState(() {
                                      ridercontroller = value;
                                    });
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            // Expanded(
                            //   flex: 1,
                            //   child: Text(
                            //     'Training Type',
                            //     style: TextStyle(
                            //         fontFamily: 'Karla',
                            //         fontSize: getTextSize15Value(buttonTextSize),
                            //         color: Colors.black),
                            //   ),
                            // ),
                            //SizedBox(width: 10.0),

                            Expanded(
                              flex: 8,
                              child: Container(
                                  //width: 221, // Set desired width
                                  height: 59, // Set desired height
                                  child: TextFormField(
                                    controller:
                                        typecontroller, // Use a controller to manage the input
                                    // icon: Icon(Icons.keyboard_arrow_down),
                                    decoration: InputDecoration(
                                        labelText: 'Training Type',
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
                                        fillColor: Color(
                                            0xFFE5E5FC), // Background color
                                        filled:
                                            true, // Enable filling with the color
                                        suffixIcon:
                                            Icon(Icons.arrow_forward_outlined)),
                                    // validator: (value) {
                                    //   if (value!.isEmpty) {
                                    //     return "Select Training type";
                                    //   }
                                    // },
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Dropdowntype(
                                                    title: 'Training type',
                                                    onEdit:
                                                        (int id, String name) {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context1) {
                                                          String updatedName =
                                                              name; // To store the input from the TextField
                                                          return AlertDialog(
                                                            title: Text(
                                                              'Edit Training Type',
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
                                                              onChanged:
                                                                  (value) {
                                                                updatedName =
                                                                    value; // Save input to the name variable
                                                              },
                                                              controller:
                                                                  TextEditingController(
                                                                      text:
                                                                          name),
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
                                                                          TraningFormBloc>()
                                                                      .add(SubmitTrainingType(
                                                                          id:
                                                                              id,
                                                                          name:
                                                                              updatedName));

                                                                  Navigator.of(
                                                                          context1)
                                                                      .pop(); // Close the dialog
                                                                },
                                                                child: Text(
                                                                    'Update'), // The save button
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
                                                                'Are you sure you want to delete this TrainingType?'),
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
                                                                          TraningFormBloc>()
                                                                      .add(DeleteTrainingType(
                                                                          trainingtypeId:
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
                                                              'Add new Training Type',
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
                                                              onChanged:
                                                                  (value) {
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
                                                                          TraningFormBloc>()
                                                                      .add(SubmitTrainingType(
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
                                                    trainingList: trainings
                                                        .map((training) {
                                                      return {
                                                        'id': training.id
                                                            .toString(),
                                                        'name': training.name
                                                      };
                                                    }).toList(),
                                                  ))).then((selectedValue) {
                                        // Handle the returned value from Dropdowntype
                                        if (selectedValue != null &&
                                            selectedValue
                                                is Map<String, dynamic>) {
                                          setState(() {
                                            typecontroller.text = selectedValue[
                                                'name']; // Update the TextFormField with the selected training name
                                            type = selectedValue['id'];
                                          });
                                        }
                                      });
                                    },
                                    onChanged: (String? value) {
                                      setState(() {
                                        typecontroller.text = value!;
                                      });
                                    },
                                    // items: this.trainings.map((trainings) {
                                    //   return DropdownMenuItem(
                                    //     child: Text(trainings.name),
                                    //     value: trainings.id.toString(),
                                    //   );
                                    // }).toList(),
                                  )),
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
                            //               'Add new Training Type',
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
                            //                       .read<TraningFormBloc>()
                            //                       .add(SubmitTrainingType(
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
                            //       width: 30,
                            //       //height: 50,
                            //       decoration: BoxDecoration(
                            //         color: Color(0xFF595BD4),
                            //         shape: BoxShape.circle,
                            //       ),
                            //       child: Center(
                            //         child: Icon(
                            //           Icons.add,
                            //           color: Colors.white,
                            //           size: 24,
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            //SizedBox(width: 10.0),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            //SizedBox(width: 10.0),
                            Expanded(
                              flex: 8,
                              child: Container(
                                //width: 221, // Set desired width
                                height: 57, // Set desired height

                                child: DropdownButtonFormField<String>(
                                  //hint: Text('Stable'),
                                  value: stablecontroller,
                                  icon: Icon(Icons.keyboard_arrow_down),
                                  decoration: InputDecoration(
                                    labelText: 'Stable',
                                    contentPadding: EdgeInsets.all(7),
                                    labelStyle: TextStyle(
                                        // fontSize:
                                        //     getTextSize20Value(buttonTextSize),
                                        fontFamily: 'Karla',
                                        // fontWeight: FontWeight.w100,
                                        color: Color(0xFF8B48DF)),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(
                                          color: Colors.black, width: 2.0),
                                    ),
                                    fillColor:
                                        Color(0xFFE5E5FC), // Background color
                                    filled:
                                        true, // Enable filling with the color
                                  ),
                                  // validator: (value) {
                                  //   if (value!.isEmpty) {
                                  //     return "Select Stable details";
                                  //   }
                                  // },
                                  items: this.stables.map((stables) {
                                    return DropdownMenuItem<String>(
                                      child: Text(stables.name),
                                      value: stables.id.toString(),
                                    );
                                  }).toList(),
                                  onChanged: (String? value) {
                                    setState(() {
                                      print("selected value : " + value!);
                                      stablecontroller = value;
                                    });
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            // Expanded(
                            //   flex: 2,
                            //   child: Text(
                            //     'Surface',
                            //     style: TextStyle(
                            //         fontFamily: 'Karla',
                            //         fontSize: getTextSize15Value(buttonTextSize),
                            //         color: Colors.black),
                            //   ),
                            // ),
                            //SizedBox(width: 25.0),

                            Expanded(
                              flex: 8,
                              child: Container(
                                //width: 210, // Set desired width
                                height: 57, // Set desired height
                                child: TextFormField(
                                  controller: surfacecontroller,
                                  // icon: Icon(Icons.keyboard_arrow_down),
                                  decoration: InputDecoration(
                                      labelText: 'Surface',
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
                                      suffixIcon:
                                          Icon(Icons.arrow_forward_outlined)),
                                  // validator: (value) {
                                  //   if (value!.isEmpty) {
                                  //     return "Select Surface Type";
                                  //   }
                                  // },
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Dropdowntype(
                                                  title: 'Surface type',
                                                  onEdit:
                                                      (int id, String name) {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context1) {
                                                        String updatedName =
                                                            name; // To store the input from the TextField
                                                        return AlertDialog(
                                                          title: Text(
                                                              'Edit Surface'), // Title of the dialog
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
                                                                    'Updated Name: $updatedName'); // Example: Print the updated name
                                                                this
                                                                    .context
                                                                    .read<
                                                                        TraningFormBloc>()
                                                                    .add(SubmitSurfaceType(
                                                                        id: id,
                                                                        name:
                                                                            updatedName)); // Example: Print the name to the console
                                                                Navigator.of(
                                                                        context1)
                                                                    .pop(); // Close the dialog
                                                              },
                                                              child: Text(
                                                                  'Update'), // The save button
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
                                                              'Are you sure you want to delete this SurfaceType?'),
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
                                                                        TraningFormBloc>()
                                                                    .add(DeleteSurfaceType(
                                                                        surfacetypeId:
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
                                                              'Add new surface'), // Title of the dialog
                                                          content: TextField(
                                                            onChanged: (value) {
                                                              name =
                                                                  value; // Save input to the name variable
                                                            },
                                                            decoration:
                                                                InputDecoration(
                                                              labelText:
                                                                  '', // Label for the input field
                                                              border:
                                                                  OutlineInputBorder(), // Styling the TextField
                                                            ),
                                                          ),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              onPressed: () {
                                                                // Perform save action
                                                                print(
                                                                    'Name: $name');
                                                                this
                                                                    .context
                                                                    .read<
                                                                        TraningFormBloc>()
                                                                    .add(SubmitSurfaceType(
                                                                        name:
                                                                            name)); // Example: Print the name to the console
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
                                                  trainingList:
                                                      surfaces.map((surfaces) {
                                                    return {
                                                      'id': surfaces.id
                                                          .toString(),
                                                      'name': surfaces.name
                                                    };
                                                  }).toList(),
                                                ))).then((selectedValue) {
                                      // Handle the returned value
                                      if (selectedValue != null &&
                                          selectedValue
                                              is Map<String, dynamic>) {
                                        setState(() {
                                          surfacecontroller.text = selectedValue[
                                              'name']; // Update the TextFormField with the selected value
                                          surface = selectedValue['id'];
                                        });
                                      }
                                    });
                                  },
                                  onChanged: (String? newvalue) {
                                    setState(() {
                                      surfacecontroller.text = newvalue!;
                                    });
                                  },
                                  // items: this.surfaces.map((surfaces) {
                                  //   return DropdownMenuItem(
                                  //     child: Text(surfaces.name),
                                  //     value: surfaces.id.toString(),
                                  //   );
                                  // }).toList(),
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
                            //                 'Add new surface'), // Title of the dialog
                            //             content: TextField(
                            //               onChanged: (value) {
                            //                 name =
                            //                     value; // Save input to the name variable
                            //               },
                            //               decoration: InputDecoration(
                            //                 labelText:
                            //                     '', // Label for the input field
                            //                 border:
                            //                     OutlineInputBorder(), // Styling the TextField
                            //               ),
                            //             ),
                            //             actions: <Widget>[
                            //               TextButton(
                            //                 onPressed: () {
                            //                   // Perform save action
                            //                   print('Name: $name');
                            //                   this
                            //                       .context
                            //                       .read<TraningFormBloc>()
                            //                       .add(SubmitSurfaceType(
                            //                           name:
                            //                               name)); // Example: Print the name to the console
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
                            //       width: 30,
                            //       //height: 50,
                            //       decoration: BoxDecoration(
                            //         color: Color(0xFF595BD4),
                            //         shape: BoxShape.circle,
                            //       ),
                            //       child: Center(
                            //         child: Icon(
                            //           Icons.add,
                            //           color: Colors.white,
                            //           size: 24,
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            //SizedBox(width: 10.0),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Container(
                          height: 2, // Thickness of the line
                          color: Color(0xFF595BD4), // Line color
                        ),
                        SizedBox(height: 10.0),
                        _buildCustomCalendarHeader(),
                        SizedBox(height: 10.0),
                        SizeTransition(
                          sizeFactor: _animation,
                          axisAlignment: -1.0,
                          child: TableCalendar(
                            focusedDay: focusedDay,
                            // focusedDay: DateTime.now(),
                            firstDay: DateTime.utc(2010, 10, 16),
                            lastDay: DateTime.utc(2030, 3, 14),
                            selectedDayPredicate: (day) =>
                                isSameDay(selectedDate, day),
                            onDaySelected: (selectedDay, focusedDay) {
                              setState(() {
                                selectedDate = selectedDay;
                                this.focusedDay =
                                    focusedDay; // Update the focusedDay as well
                                _toggleCalendar(); // Automatically close calendar after selecting a date
                                // Handle the selected date here
                              });
                            },
                            calendarFormat: CalendarFormat.month,
                            headerVisible: false,
                            calendarStyle: CalendarStyle(
                              selectedDecoration: BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                              todayDecoration: BoxDecoration(
                                color: Colors.orange,
                                shape: BoxShape.circle,
                              ),
                              defaultDecoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                            ),
                            onPageChanged: (newFocusedDay) {
                              setState(() {
                                focusedDay =
                                    newFocusedDay; // Update focusedDay whenever the page changes
                              });
                            },
                          ),
                        ),
                        Container(
                          height: 2, // Thickness of the line
                          color: Color(0xFF595BD4), // Line color
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          children: [
                            // Expanded(
                            //   flex: 1,
                            //   child: Text(
                            //     '',
                            //     style: TextStyle(
                            //         fontFamily: 'Karla',
                            //         fontSize: getTextSize15Value(buttonTextSize),
                            //         color: Colors.black),
                            //   ),
                            // ),
                            Expanded(
                              flex: 8,
                              child: TextFormField(
                                // focusNode: _focusNode,

                                keyboardType: TextInputType.phone,
                                autocorrect: false,
                                controller: _rideStartTimeController,
                                onSaved: (value) {
                                  _rideStartTimeController.text =
                                      DateFormat('dd-MM-yyyy')
                                          .format(DateTime.parse(value!));
                                },
                                onTap: () {
                                  _selectTime(context);
                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());
                                },
                                maxLines: 1,
                                //initialValue: 'Aseem Wangoo',
                                // validator: (value) {
                                //   if (value!.isEmpty || value!.length < 1) {
                                //     return 'Choose Duration';
                                //   }
                                // },

                                decoration: InputDecoration(
                                  labelText: 'Duration',
                                  contentPadding: EdgeInsets.all(7),
                                  labelStyle: TextStyle(
                                      // fontSize: getTextSize20Value(buttonTextSize),
                                      fontFamily: 'Karla',
                                      // fontWeight: FontWeight.w100,
                                      color: Color(0xFF8B48DF)),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(
                                        color: Colors.black, width: 2.0),
                                  ),
                                  fillColor:
                                      Color(0xFFE5E5FC), // Background color
                                  filled: true, // Enable filling with the color
                                  suffixIcon: IconButton(
                                    icon: const Icon(
                                      Icons.watch_later_outlined,
                                      color: Colors.black45,
                                    ),
                                    onPressed: () {
                                      _selectTime(context);
                                      FocusScope.of(context)
                                          .requestFocus(new FocusNode());
                                    },
                                  ),
                                  hintText: 'Duration',
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            // Expanded(
                            //   flex: 1,
                            //   child: Text(
                            //     '',
                            //     style: TextStyle(
                            //         fontFamily: 'Karla',
                            //         fontSize: getTextSize15Value(buttonTextSize),
                            //         color: Colors.black),
                            //   ),
                            // ),
                            Expanded(
                              flex: 4,
                              child: Container(
                                //width: 221, // Set desired width
                                height: 40,
                                child: TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  controller: distanceController,
                                  decoration: InputDecoration(
                                    labelText: 'Distance',
                                    contentPadding: EdgeInsets.all(7),
                                    labelStyle: TextStyle(
                                        // fontSize:
                                        //     getTextSize20Value(buttonTextSize),
                                        fontFamily: 'Karla',
                                        // fontWeight: FontWeight.w100,
                                        color: Color(0xFF8B48DF)),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(
                                          color: Colors.black, width: 2.0),
                                    ),
                                    fillColor:
                                        Color(0xFFE5E5FC), // Background color
                                    filled:
                                        true, // Enable filling with the color
                                  ),
                                  // validator: (value) {
                                  //   if (value!.isEmpty) {
                                  //     return "Enter Distance details";
                                  //   }
                                  // },
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 0,
                              child: Text(
                                '  km',
                                //textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'Karla',
                                    fontSize:
                                        getTextSize15Value(buttonTextSize),
                                    color: Colors.black),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Container(
                          height: 2, // Thickness of the line
                          color: Color(0xFF595BD4), // Line color
                        ),
                        SizedBox(height: 10.0),
                        Row(children: [
                          Expanded(
                            //color: Colors.red,
                            flex: 1,
                            child: Text(
                              'Gait Distribution',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontFamily: 'Karla',
                                  //fontWeight: FontWeight.bold,
                                  fontSize: getTextSize15Value(buttonTextSize),
                                  color: Colors.black),
                            ),
                          ),
                        ]),
                        SizedBox(height: 10),
                        // First Row: Walk
                        _buildHorseDetailRow(
                          label: '',
                          controller: walkController,
                          labelText: 'Walk',
                        ),
                        SizedBox(height: 10.0),
                        // Second Row: Trot
                        _buildHorseDetailRow(
                          label: '',
                          controller: trotController,
                          labelText: 'Trot',
                        ),
                        SizedBox(height: 10.0),
                        // Third Row: Canter
                        _buildHorseDetailRow(
                          label: '',
                          controller: canterController,
                          labelText: 'Canter',
                        ),
                        SizedBox(height: 10.0),
                        // Fourth Row: Gallop
                        _buildHorseDetailRow(
                          label: '',
                          controller: gallopController,
                          labelText: 'Gallop',
                        ),
                        SizedBox(height: 10.0),
                        Container(
                          height: 2, // Thickness of the line
                          color: Color(0xFF595BD4), // Line color
                        ),
                        SizedBox(height: 10.0),
                      ]))),
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

  Widget _buildCustomCalendarHeader() {
    return Card(
      color: Color(0xFFE5E5FC),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0), // Optional: Rounded corners
      ),
      elevation: 2.0, // Optional: Adds shadow effect
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
              onPressed: () {
                setState(() {
                  focusedDay = DateTime(
                    focusedDay.year,
                    focusedDay.month - 1,
                  );
                });
              },
            ),
            GestureDetector(
              onTap: () => _toggleCalendar(),
              child: Text(
                DateFormat('EEE MMM d yyyy').format(focusedDay),
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
            // IconButton(
            //   icon: const Icon(Icons.chevron_right),
            //   onPressed: () {
            //     setState(() {
            //       focusedDay = DateTime(
            //         focusedDay.year,
            //         focusedDay.month + 1,
            //       );
            //     });
            //   },
            // ),
          ],
        ),
      ),
    );
  }

  void _toggleCalendar() {
    setState(() {
      _isCalendarExpanded = !_isCalendarExpanded;
      _isCalendarExpanded
          ? _animationController.forward()
          : _animationController.reverse();
    });
  }
  // Helper function to build a row with a label and a TextFormField

  Widget _buildHorseDetailRow({
    required String label,
    required String labelText,
    required TextEditingController controller,
  }) {
    return Row(
      children: [
        // Expanded(
        //   flex: 1,
        //   child: Text(
        //     label,
        //     style: TextStyle(
        //       fontFamily: 'Karla',
        //       fontSize: 16, // Adjust as per your preference
        //       color: Colors.black,
        //     ),
        //   ),
        // ),
        // SizedBox(width: 10.0),
        Expanded(
          flex: 4,
          child: TextFormField(
            keyboardType: TextInputType.text,
            controller: controller,
            // textAlign: TextAlign.center,
            decoration: InputDecoration(
              labelText: labelText,
              contentPadding: EdgeInsets.all(7),
              labelStyle: TextStyle(
                // fontSize: 18, // Adjust as per your preference
                fontFamily: 'Karla',
                // fontWeight: FontWeight.w100,
                color: Color(0xFF8B48DF),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: Colors.black, width: 2.0),
              ),
              fillColor: Color(0xFFE5E5FC), // Background color
              filled: true, // Enable filling with the color
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return "Enter $label details";
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
