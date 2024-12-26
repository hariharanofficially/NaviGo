import 'dart:io';

import 'package:EquineApp/data/models/farrier_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../../data/models/horse_model.dart';
import '../../../../../data/models/shoeSpecification.dart';
import '../../../../../data/models/shoeType_model.dart';
import '../../../../../data/models/shoecomplement.dart';
import '../../../../../data/models/surfaceType.dart';
import '../../../../common/widgets/ProfileImage.dart';
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
import '../../Farrier_dashboard/bloc/farrier_bloc.dart';
import '../../Farrier_dashboard/view/Farrier.dart';
import '../bloc/farrier_form_bloc.dart';

class FarrierForm extends StatefulWidget {
  final HorseModel horse;
  final int? farrierId;
  final bool isSave;
  final bool isSurfaceType;

  const FarrierForm(
      {super.key,
      required this.horse,
      this.farrierId,
      required this.isSave,
      required this.isSurfaceType});

  @override
  State<FarrierForm> createState() => _FarrierFormState();
}

class _FarrierFormState extends State<FarrierForm>
    with SingleTickerProviderStateMixin {
  final horsecontroller = TextEditingController();
  // Define the controllers
  final TextEditingController foodcontroller = TextEditingController();
  final TextEditingController flsspecficationcontroller =
      TextEditingController();
  final TextEditingController flscomplimentcontroller = TextEditingController();
  final TextEditingController Hindcontroller = TextEditingController();
  final TextEditingController hlscomplimentcontroller = TextEditingController();
  final TextEditingController hlsspecficationcontroller =
      TextEditingController();
  final TextEditingController surfacetypecontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
// String? foodcontroller;
  // String? flsspecficationcontroller;
  // String? flscomplimentcontroller;
  // String? Hindcontroller;
  // String? hlscomplimentcontroller;
  // String? hlsspecficationcontroller;
  // String? surfacetypecontroller;
  int selectedTab = 0;
  DateTime selectedDate = DateTime.now();
  DateTime focusedDay = DateTime.now();
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isCalendarExpanded = false;
  List<shoeType> foreShoeType = [];
  List<shoeSpecification> foreShoeSpecf = [];
  List<shoeComplement> foreShoeComp = [];
  List<shoeType> hindShoeType = [];
  List<shoeSpecification> hindShoeSpecf = [];
  List<shoeComplement> hindShoeComp = [];
  List<SurfaceType> surfacetype = [];
  var surface;
  var food;
  var flsspec;
  var flscomp;
  var hindlimb;
  var hlsspec;
  var hlscomp;
  List<String> _fileNames = []; // List to store multiple file names
  List<String?> _filePaths = [];
  FarrierModel? FarrierName; // Change to nullable type

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

  void _showZoomableImage(BuildContext context, File? image) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                child: InteractiveViewer(
                  maxScale: 5.0,
                  minScale: 1.0,
                  child: Image.file(image!),
                ),
              ),
              SizedBox(height: 16.0), // Space between the image and the button
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('Close'),
              ),
              SizedBox(height: 16.0), // Space at the bottom of the dialog
            ],
          ),
        );
      },
    );
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
    if (widget.farrierId != null) {
      context
          .read<FarrierFormBloc>()
          .add(LoadFarrierformByid(id: widget.farrierId!));
    } else {
      context.read<FarrierFormBloc>().add(LoadFarrierform());
    }
  }

  @override
  void dispose() {
    // Dispose the controller to free up resources
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FarrierFormBloc, FarrierFormState>(
      listener: (context, state) {
        if (state is FarrierFormLoaded) {
          foreShoeType = state.allFormModel.shoetype;
          foreShoeSpecf = state.allFormModel.shoespecf;
          foreShoeComp = state.allFormModel.shoecomp;
          hindShoeType = state.allFormModel.shoetype;
          hindShoeSpecf = state.allFormModel.shoespecf;
          hindShoeComp = state.allFormModel.shoecomp;
          surfacetype = state.allFormModel.surfaceType;
          if (widget.farrierId != null) {
            final farrier = state.allFormModel.farrierDetail;

            foodcontroller.text = farrier.foreShoeType.toString();
            // surfacetypecontroller = farrier.surfacetypeId.toString();
            flsspecficationcontroller.text =
                farrier.foreShoeSpecification.toString();
            flscomplimentcontroller.text =
                farrier.foreShoeComplement.toString();
            Hindcontroller.text = farrier.hindShoeType.toString();
            hlsspecficationcontroller.text =
                farrier.hindShoeSpecification.toString();
            hlscomplimentcontroller.text =
                farrier.hindShoeComplement.toString();
            FarrierName = state.allFormModel.farrierDetail;
          }
        } else if (state is FarrierFormSuccessfully) {
          String message = widget.farrierId != null
              ? 'Farrier Updated Successfully'
              : 'Farrier Added Successfully';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => FarrierBloc(),
                  child: Farrier(
                    horse: widget.horse,
                  ), // Pass the horse id
                ),
              ));
        } else if (state is FarrierFormerror) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Farrier Add failed")),
          );
        } else if (state is FetchDocumentFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("FetchDocumentFailed")),
          );
        } else if (state is ImageUploadSuccessfully) {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text("ImageUploadSuccessfully")),
          // );
        } else if (state is foreShoeTypeCreateSuccess) {
          foreShoeType = state.types;
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) => BlocProvider(
          //             create: (context) => FarrierFormBloc(),
          //             child: FarrierForm(
          //               horse: widget.horse,
          //               isSave: true,
          //               isSurfaceType: true,
          //             ),
          //           )),
          // );
        } else if (state is foreshoeSpecfCreateSuccess) {
          foreShoeSpecf = state.types;
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) => BlocProvider(
          //             create: (context) => FarrierFormBloc(),
          //             child: FarrierForm(
          //               horse: widget.horse,
          //               isSave: true,
          //               isSurfaceType: true,
          //             ),
          //           )),
          // );
        } else if (state is foreshoecompCreateSuccess) {
          foreShoeComp = state.types;
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) => BlocProvider(
          //             create: (context) => FarrierFormBloc(),
          //             child: FarrierForm(
          //               horse: widget.horse,
          //               isSave: true,
          //               isSurfaceType: true,
          //             ),
          //           )),
          // );
        } else if (state is hindShoeTypeCreateSuccess) {
          hindShoeType = state.types;
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) => BlocProvider(
          //             create: (context) => FarrierFormBloc(),
          //             child: FarrierForm(
          //               horse: widget.horse,
          //               isSave: true,
          //               isSurfaceType: true,
          //             ),
          //           )),
          // );
        } else if (state is hindshoeSpecfCreateSuccess) {
          hindShoeSpecf = state.types;
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) => BlocProvider(
          //             create: (context) => FarrierFormBloc(),
          //             child: FarrierForm(
          //               horse: widget.horse,
          //               isSave: true,
          //               isSurfaceType: true,
          //             ),
          //           )),
          // );
        } else if (state is hindshoecompCreateSuccess) {
          hindShoeComp = state.types;
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) => BlocProvider(
          //             create: (context) => FarrierFormBloc(),
          //             child: FarrierForm(
          //               horse: widget.horse,
          //               isSave: true,
          //               isSurfaceType: true,
          //             ),
          //           )),
          // );
        } else if (state is SurfaceTypeCreateSuccess) {
          surfacetype = state.types;
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) => BlocProvider(
          //             create: (context) => FarrierFormBloc(),
          //             child: FarrierForm(
          //               horse: widget.horse,
          //               isSave: true,
          //               isSurfaceType: true,
          //             ),
          //           )),
          // );
        } else if (state is SurfaceTypeDeleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Surface Type Deleted Successfully")),
          );
          surfacetype = state.types;
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) => BlocProvider(
          //             create: (context) => FarrierFormBloc(),
          //             child: FarrierForm(
          //               horse: widget.horse,
          //               isSave: true,
          //               isSurfaceType: true,
          //             ),
          //           )),
          // );
        } else if (state is foreShoeTypeDeleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("foreShoe Type Deleted Successfully")),
          );
          foreShoeType = state.types;
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) => BlocProvider(
          //             create: (context) => FarrierFormBloc(),
          //             child: FarrierForm(
          //               horse: widget.horse,
          //               isSave: true,
          //               isSurfaceType: true,
          //             ),
          //           )),
          // );
        } else if (state is foreShoeSpecificationDeleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text("foreShoe Specification Deleted Successfully")),
          );
          foreShoeSpecf = state.types;
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) => BlocProvider(
          //             create: (context) => FarrierFormBloc(),
          //             child: FarrierForm(
          //               horse: widget.horse,
          //               isSave: true,
          //               isSurfaceType: true,
          //             ),
          //           )),
          // );
        } else if (state is foreShoeComplementDeleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("foreShoe Complement Deleted Successfully")),
          );
          foreShoeComp = state.types;
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) => BlocProvider(
          //             create: (context) => FarrierFormBloc(),
          //             child: FarrierForm(
          //               horse: widget.horse,
          //               isSave: true,
          //               isSurfaceType: true,
          //             ),
          //           )),
          // );
        } else if (state is hindShoeTypeDeleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("hindShoe Type Deleted Successfully")),
          );
          hindShoeType = state.types;
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) => BlocProvider(
          //             create: (context) => FarrierFormBloc(),
          //             child: FarrierForm(
          //               horse: widget.horse,
          //               isSave: true,
          //               isSurfaceType: true,
          //             ),
          //           )),
          // );
        } else if (state is hindShoeSpecificationDeleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text("hindShoe Specification Deleted Successfully")),
          );
          hindShoeSpecf = state.types;
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) => BlocProvider(
          //             create: (context) => FarrierFormBloc(),
          //             child: FarrierForm(
          //               horse: widget.horse,
          //               isSave: true,
          //               isSurfaceType: true,
          //             ),
          //           )),
          // );
        } else if (state is hindShoeComplementDeleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("hindShoe Complement Deleted Successfully")),
          );
          hindShoeComp = state.types;
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) => BlocProvider(
          //             create: (context) => FarrierFormBloc(),
          //             child: FarrierForm(
          //               horse: widget.horse,
          //               isSave: true,
          //               isSurfaceType: true,
          //             ),
          //           )),
          // );
        } else if (state is FileDownloadInProgress) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Download InProgress')),
          );
        } else if (state is FileDownloadSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Download Successfully')),
          );
        } else if (state is BeforeFileSelectedFarrier) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('BeforeImage Selected Successfully')),
          );
        } else if (state is AfterFileSelectedFarrier) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('AfterImage Selected Successfully')),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: CustomAppBar(),
          endDrawer: NavigitionWidget(),
          body: state is FarrierFormLoading
              ? Center(
                  child: CircularProgressIndicator(), // Show loading spinner
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0),
                    child: Form(
                      key: _formKey,
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
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color(
                                          0xFFE5E5FC), // Set the background color to blue
                                      borderRadius: BorderRadius.circular(
                                          8.0), // Set the border radius
                                    ),
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 10, 25, 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Farrier',
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
                                          Center(
                                            child: ElevatedButton(
                                              onPressed: () {
                                                if (_formKey.currentState!
                                                        .validate() ==
                                                    true) {
                                                  context
                                                      .read<FarrierFormBloc>()
                                                      .add(SubmitFormFarrier(
                                                        id: widget.farrierId,
                                                        horseId: widget.horse.id
                                                            .toString(),
                                                        shoeDatetime: selectedDate
                                                            .toIso8601String(),
                                                        surfaceType: surface,
                                                        foreShoeType: food,
                                                        foreShoeSpecification:
                                                            flsspec,
                                                        foreShoeComplement:
                                                            flscomp,
                                                        hindShoeType: hindlimb,
                                                        hindShoeSpecification:
                                                            hlsspec,
                                                        hindShoeComplement:
                                                            hlscomp,
                                                        filePath: _filePaths,
                                                        // foreShoeType: foodcontroller
                                                        //     .toString(),
                                                        // surfaceType:
                                                        //     surfacetypecontroller
                                                        //         .toString(),
                                                        // foreShoeSpecification:
                                                        //     flsspecficationcontroller
                                                        //         .toString(),
                                                        // foreShoeComplement:
                                                        //     flscomplimentcontroller
                                                        //         .toString(),
                                                        // hindShoeType:
                                                        //     Hindcontroller
                                                        //         .toString(),
                                                        // hindShoeSpecification:
                                                        //     hlsspecficationcontroller
                                                        //         .toString(),
                                                        // hindShoeComplement:
                                                        //     hlscomplimentcontroller
                                                        //         .toString()
                                                      ));
                                                }
                                                // for (var filePath in _filePaths) {
                                                //   if (filePath != null) {
                                                //     context
                                                //         .read<FarrierFormBloc>()
                                                //         .add(
                                                //           UploadImageFarrier(
                                                //               filePath: filePath),
                                                //         );
                                                //   }
                                                // }

                                                // context.read<FarrierFormBloc>().add(
                                                //     BeforeUploadImageFarrier());
                                                // context
                                                //     .read<FarrierFormBloc>()
                                                //     .add(
                                                //         AfterUploadImageFarrier());
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
                              //   flex: 3,
                              //   child: Text(
                              //     'Horse',
                              //     style: TextStyle(
                              //         fontFamily: 'Karla',
                              //         fontSize: getTextSize15Value(buttonTextSize),
                              //         color: Colors.black),
                              //   ),
                              // ),
                              // SizedBox(width: 10.0),
                              Expanded(
                                flex: 4,
                                child: Container(
                                  // width: 210, // Set desired width
                                  height: 40,
                                  child: TextFormField(
                                      readOnly: true,
                                      keyboardType: TextInputType.emailAddress,
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
                                        fillColor: Color(
                                            0xFFE5E5FC), // Background color
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
                          if (widget.isSurfaceType)
                            Row(
                              children: [
                                // Expanded(
                                //   flex: 2,
                                //   child: Text(
                                //     'Surface Type',
                                //     style: TextStyle(
                                //         fontFamily: 'Karla',
                                //         fontSize: getTextSize15Value(buttonTextSize),
                                //         color: Colors.black),
                                //   ),
                                // ),

                                // SizedBox(width: 25.0),
                                Expanded(
                                  flex: 8,
                                  child: Container(
                                    // width: 158, // Set desired width
                                    height: 40,
                                    child: TextFormField(
                                        controller: surfacetypecontroller,
                                        onChanged: (String? newValue1) {
                                          setState(() {
                                            surfacetypecontroller.text =
                                                newValue1!;
                                          });
                                        },
                                        decoration: InputDecoration(
                                            labelText: 'Surface Type',
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
                                                  color: Colors.black,
                                                  width: 2.0),
                                            ),
                                            fillColor: Color(
                                                0xFFE5E5FC), // Background color
                                            filled:
                                                true, // Enable filling with the color
                                            suffixIcon: Icon(
                                                Icons.arrow_forward_outlined)),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (context) => Dropdowntype(
                                                            title:
                                                                'Surface type',
                                                            onEdit: (int id,
                                                                String name) {
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context1) {
                                                                  String
                                                                      updatedName =
                                                                      name; // To store the input from the TextField
                                                                  return AlertDialog(
                                                                    title: Text(
                                                                        'Edit Surface'), // Title of the dialog
                                                                    content:
                                                                        TextField(
                                                                      onChanged:
                                                                          (value) {
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
                                                                        onPressed:
                                                                            () {
                                                                          // Perform save action
                                                                          print(
                                                                              'Updated Name: $updatedName'); // Example: Print the updated name
                                                                          this.context.read<FarrierFormBloc>().add(SubmitsurfaceType(
                                                                              id: id,
                                                                              name: updatedName)); // Example: Print the name to the console
                                                                          Navigator.of(context1)
                                                                              .pop(); // Close the dialog
                                                                        },
                                                                        child: Text(
                                                                            'Update'), // The save button
                                                                      ),
                                                                      TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context1)
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
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
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
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(dialogContext)
                                                                              .pop(); // Use dialogContext here to close the dialog
                                                                        },
                                                                      ),
                                                                      TextButton(
                                                                        child: Text(
                                                                            'Confirm'),
                                                                        onPressed:
                                                                            () {
                                                                          // Use the original context to access the HorseDashboardBloc
                                                                          this
                                                                              .context
                                                                              .read<FarrierFormBloc>()
                                                                              .add(DeleteSurfaceType(surfacetypeId: Id));
                                                                          print(
                                                                              'Delete selected');
                                                                          Navigator.of(dialogContext)
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
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context1) {
                                                                  String name =
                                                                      ''; // To store the input from the TextField
                                                                  return AlertDialog(
                                                                    title: Text(
                                                                      'Add New SurfaceType',
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'Karla',
                                                                          fontSize: getTextSize15Value(
                                                                              buttonTextSize),
                                                                          color:
                                                                              Colors.black),
                                                                    ), // Title of the dialog
                                                                    content:
                                                                        TextField(
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
                                                                        onPressed:
                                                                            () {
                                                                          // Perform save action
                                                                          print(
                                                                              'Name: $name'); // Example: Print the name to the console
                                                                          this
                                                                              .context
                                                                              .read<FarrierFormBloc>()
                                                                              .add(SubmitsurfaceType(name: name));

                                                                          Navigator.of(context1)
                                                                              .pop(); // Close the dialog
                                                                        },
                                                                        child: Text(
                                                                            'Save'), // The save button
                                                                      ),
                                                                      TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context1)
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
                                                                surfacetype.map(
                                                                    (surfacetype) {
                                                              return {
                                                                'id': surfacetype
                                                                    .id
                                                                    .toString(),
                                                                'name':
                                                                    surfacetype
                                                                        .name
                                                              };
                                                            }).toList(),
                                                          ))).then(
                                              (selectedValue) {
                                            // Handle the returned value from Dropdowntype
                                            if (selectedValue != null &&
                                                selectedValue
                                                    is Map<String, dynamic>) {
                                              setState(() {
                                                surfacetypecontroller.text =
                                                    selectedValue[
                                                        'name']; // Update the TextFormField with the selected training name
                                                surface = selectedValue['id'];
                                              });
                                            }
                                          });
                                        },
                                        // items:
                                        //     this.surfacetype.map((surfacetype) {
                                        //   return DropdownMenuItem<String>(
                                        //     value: surfacetype.id.toString(),
                                        //     child: Text(surfacetype.name),
                                        //   );
                                        // }).toList(),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Select SurfaceType details";
                                          }
                                        }),
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
                                //               'Add New SurfaceType',
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
                                //                       .read<FarrierFormBloc>()
                                //                       .add(SubmitsurfaceType(
                                //                           name: name));

                                //                   Navigator.of(context1)
                                //                       .pop(); // Close the dialog
                                //                 },
                                //                 child: Text(
                                //                     'Save'), // The save button
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
                          SizedBox(height: 10.0),
                          Container(
                            height: 2, // Thickness of the line
                            color: Color(0xFF595BD4), // Line color
                          ),
                          SizedBox(height: 10.0),
                          Row(
                            children: [
                              // Expanded(
                              //   flex: 2,
                              //   child: Text(
                              //     'Food Limb Shoe',
                              //     style: TextStyle(
                              //         fontFamily: 'Karla',
                              //         fontSize: getTextSize15Value(buttonTextSize),
                              //         color: Colors.black),
                              //   ),
                              // ),

                              // SizedBox(width: 25.0),
                              Expanded(
                                flex: 8,
                                child: Container(
                                  // width: 158, // Set desired width
                                  height: 40,
                                  child: TextFormField(
                                      controller: foodcontroller,
                                      onChanged: (String? newValue1) {
                                        setState(() {
                                          foodcontroller.text = newValue1!;
                                        });
                                      },
                                      decoration: InputDecoration(
                                          labelText: 'fore Limb Shoe',
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
                                                color: Colors.black,
                                                width: 2.0),
                                          ),
                                          fillColor: Color(
                                              0xFFE5E5FC), // Background color
                                          filled:
                                              true, // Enable filling with the color
                                          suffixIcon: Icon(
                                              Icons.arrow_forward_outlined)),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (context) => Dropdowntype(
                                                          title:
                                                              'fore Limb Shoe',
                                                          onEdit: (int id,
                                                              String name) {
                                                            showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context1) {
                                                                String
                                                                    updatedName =
                                                                    name; // To store the input from the TextField
                                                                return AlertDialog(
                                                                  title: Text(
                                                                    'Edit fore Limb shoe',
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'Karla',
                                                                        fontSize:
                                                                            getTextSize15Value(
                                                                                buttonTextSize),
                                                                        color: Colors
                                                                            .black),
                                                                  ), // Title of the dialog
                                                                  content:
                                                                      TextField(
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
                                                                      onPressed:
                                                                          () {
                                                                        // Perform save action
                                                                        print(
                                                                            'Updated Name: $updatedName'); // Example: Print the name to the console
                                                                        this.context.read<FarrierFormBloc>().add(SubmitforeShoeType(
                                                                            id:
                                                                                id,
                                                                            name:
                                                                                updatedName));

                                                                        Navigator.of(context1)
                                                                            .pop(); // Close the dialog
                                                                      },
                                                                      child: Text(
                                                                          'Update'), // The save button
                                                                    ),
                                                                    TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context1)
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
                                                                      'Are you sure you want to delete this foreShoeType?'),
                                                                  actions: <Widget>[
                                                                    TextButton(
                                                                      child: Text(
                                                                          'Cancel'),
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(dialogContext)
                                                                            .pop(); // Use dialogContext here to close the dialog
                                                                      },
                                                                    ),
                                                                    TextButton(
                                                                      child: Text(
                                                                          'Confirm'),
                                                                      onPressed:
                                                                          () {
                                                                        // Use the original context to access the HorseDashboardBloc
                                                                        this
                                                                            .context
                                                                            .read<FarrierFormBloc>()
                                                                            .add(DeleteforeShoeType(foreShoeTypeId: Id));
                                                                        print(
                                                                            'Delete selected');
                                                                        Navigator.of(dialogContext)
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
                                                              builder:
                                                                  (BuildContext
                                                                      context1) {
                                                                String name =
                                                                    ''; // To store the input from the TextField
                                                                return AlertDialog(
                                                                  title: Text(
                                                                    'Add New fore Limb shoe',
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'Karla',
                                                                        fontSize:
                                                                            getTextSize15Value(
                                                                                buttonTextSize),
                                                                        color: Colors
                                                                            .black),
                                                                  ), // Title of the dialog
                                                                  content:
                                                                      TextField(
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
                                                                      onPressed:
                                                                          () {
                                                                        // Perform save action
                                                                        print(
                                                                            'Name: $name'); // Example: Print the name to the console
                                                                        this
                                                                            .context
                                                                            .read<FarrierFormBloc>()
                                                                            .add(SubmitforeShoeType(name: name));

                                                                        Navigator.of(context1)
                                                                            .pop(); // Close the dialog
                                                                      },
                                                                      child: Text(
                                                                          'Save'), // The save button
                                                                    ),
                                                                    TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context1)
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
                                                              foreShoeType.map(
                                                                  (foreShoeType) {
                                                            return {
                                                              'id': foreShoeType
                                                                  .id
                                                                  .toString(),
                                                              'name':
                                                                  foreShoeType
                                                                      .name
                                                            };
                                                          }).toList(),
                                                        ))).then(
                                            (selectedValue) {
                                          // Handle the returned value from Dropdowntype
                                          if (selectedValue != null &&
                                              selectedValue
                                                  is Map<String, dynamic>) {
                                            setState(() {
                                              foodcontroller.text = selectedValue[
                                                  'name']; // Update the TextFormField with the selected training name
                                              food = selectedValue['id'];
                                            });
                                          }
                                        });
                                      },
                                      // items:
                                      //     this.foreShoeType.map((foreShoeType) {
                                      //   return DropdownMenuItem<String>(
                                      //     value: foreShoeType.id.toString(),
                                      //     child: Text(foreShoeType.name),
                                      //   );
                                      // }).toList(),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Enter Horse details";
                                        }
                                      }),
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
                              //               'Add New Food Limb shoe',
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
                              //                       .read<FarrierFormBloc>()
                              //                       .add(SubmitforeShoeType(
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
                          SizedBox(height: 10.0),
                          Row(
                            children: [
                              // Expanded(
                              //   flex: 2,
                              //   child: Text(
                              //     'FLS Specification',
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
                                  // width: 210, // Set desired width
                                  height: 40,
                                  child: TextFormField(
                                    controller: flsspecficationcontroller,
                                    // items:
                                    //     this.foreShoeSpecf.map((foreShoeSpecf) {
                                    //   return DropdownMenuItem<String>(
                                    //     value: foreShoeSpecf.id.toString(),
                                    //     child: Text(foreShoeSpecf.name),
                                    //   );
                                    // }).toList(),
                                    decoration: InputDecoration(
                                        labelText: 'FLS Specification',
                                        contentPadding: EdgeInsets.all(7),
                                        labelStyle: TextStyle(
                                            // fontSize: getTextSize20Value(buttonTextSize),
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
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Enter Horse details";
                                      }
                                    },
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Dropdowntype(
                                                    title: 'FLS Specification',
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
                                                              'Edit Fls Specification',
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
                                                                          FarrierFormBloc>()
                                                                      .add(SubmitforeShoeSpecification(
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
                                                                'Are you sure you want to delete this foreShoeSpecification?'),
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
                                                                          FarrierFormBloc>()
                                                                      .add(DeleteforeShoeSpecification(
                                                                          foreShoeSpecificationId:
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
                                                              'Add New Fls Specification',
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
                                                                          FarrierFormBloc>()
                                                                      .add(SubmitforeShoeSpecification(
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
                                                    trainingList: foreShoeSpecf
                                                        .map((foreShoeSpecf) {
                                                      return {
                                                        'id': foreShoeSpecf.id
                                                            .toString(),
                                                        'name':
                                                            foreShoeSpecf.name
                                                      };
                                                    }).toList(),
                                                  ))).then((selectedValue) {
                                        // Handle the returned value from Dropdowntype
                                        if (selectedValue != null &&
                                            selectedValue
                                                is Map<String, dynamic>) {
                                          setState(() {
                                            flsspecficationcontroller.text =
                                                selectedValue[
                                                    'name']; // Update the TextFormField with the selected training name
                                            flsspec = selectedValue['id'];
                                          });
                                        }
                                      });
                                    },
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        flsspecficationcontroller.text =
                                            newValue!;
                                      });
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
                              //               'Add New Fls Specification',
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
                              //                       .read<FarrierFormBloc>()
                              //                       .add(
                              //                           SubmitforeShoeSpecification(
                              //                               name: name));

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
                            ],
                          ),
                          SizedBox(height: 10.0),
                          Row(
                            children: [
                              // Expanded(
                              //   flex: 2,
                              //   child: Text(
                              //     'FLS Compliments',
                              //     style: TextStyle(
                              //         fontFamily: 'Karla',
                              //         fontSize: getTextSize15Value(buttonTextSize),
                              //         color: Colors.black),
                              //   ),
                              // ),

                              // SizedBox(width: 25.0),
                              Expanded(
                                flex: 8,
                                child: Container(
                                  // width: 147, // Set desired width
                                  height: 40,
                                  child: TextFormField(
                                      controller: flscomplimentcontroller,
                                      onChanged: (String? newValue2) {
                                        setState(() {
                                          flscomplimentcontroller.text =
                                              newValue2!;
                                        });
                                      },
                                      decoration: InputDecoration(
                                          labelText: 'FLS Compliments',
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
                                                color: Colors.black,
                                                width: 2.0),
                                          ),
                                          fillColor: Color(
                                              0xFFE5E5FC), // Background color
                                          filled:
                                              true, // Enable filling with the color
                                          suffixIcon: Icon(
                                              Icons.arrow_forward_outlined)),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (context) => Dropdowntype(
                                                          title:
                                                              'FLS Compliments',
                                                          onEdit: (int id,
                                                              String name) {
                                                            showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context1) {
                                                                String
                                                                    updatedName =
                                                                    name; // To store the input from the TextField
                                                                return AlertDialog(
                                                                  title: Text(
                                                                    'Edit FLS Compliments',
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'Karla',
                                                                        fontSize:
                                                                            getTextSize15Value(
                                                                                buttonTextSize),
                                                                        color: Colors
                                                                            .black),
                                                                  ), // Title of the dialog
                                                                  content:
                                                                      TextField(
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
                                                                      onPressed:
                                                                          () {
                                                                        // Perform save action
                                                                        print(
                                                                            'Updated Name: $updatedName'); // Example: Print the name to the console
                                                                        this.context.read<FarrierFormBloc>().add(SubmitforeShoeComplement(
                                                                            id:
                                                                                id,
                                                                            name:
                                                                                updatedName));

                                                                        Navigator.of(context1)
                                                                            .pop(); // Close the dialog
                                                                      },
                                                                      child: Text(
                                                                          'Update'), // The save button
                                                                    ),
                                                                    TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context1)
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
                                                                      'Are you sure you want to delete this foreShoeComplement?'),
                                                                  actions: <Widget>[
                                                                    TextButton(
                                                                      child: Text(
                                                                          'Cancel'),
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(dialogContext)
                                                                            .pop(); // Use dialogContext here to close the dialog
                                                                      },
                                                                    ),
                                                                    TextButton(
                                                                      child: Text(
                                                                          'Confirm'),
                                                                      onPressed:
                                                                          () {
                                                                        // Use the original context to access the HorseDashboardBloc
                                                                        this
                                                                            .context
                                                                            .read<FarrierFormBloc>()
                                                                            .add(DeleteforeShoeComplement(foreShoeComplementId: Id));
                                                                        print(
                                                                            'Delete selected');
                                                                        Navigator.of(dialogContext)
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
                                                              builder:
                                                                  (BuildContext
                                                                      context1) {
                                                                String name =
                                                                    ''; // To store the input from the TextField
                                                                return AlertDialog(
                                                                  title: Text(
                                                                    'Add New FLS Compliments',
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'Karla',
                                                                        fontSize:
                                                                            getTextSize15Value(
                                                                                buttonTextSize),
                                                                        color: Colors
                                                                            .black),
                                                                  ), // Title of the dialog
                                                                  content:
                                                                      TextField(
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
                                                                      onPressed:
                                                                          () {
                                                                        // Perform save action
                                                                        print(
                                                                            'Name: $name'); // Example: Print the name to the console
                                                                        this
                                                                            .context
                                                                            .read<FarrierFormBloc>()
                                                                            .add(SubmitforeShoeComplement(name: name));

                                                                        Navigator.of(context1)
                                                                            .pop(); // Close the dialog
                                                                      },
                                                                      child: Text(
                                                                          'Save'), // The save button
                                                                    ),
                                                                    TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context1)
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
                                                              foreShoeComp.map(
                                                                  (foreShoeComp) {
                                                            return {
                                                              'id': foreShoeComp
                                                                  .id
                                                                  .toString(),
                                                              'name':
                                                                  foreShoeComp
                                                                      .name
                                                            };
                                                          }).toList(),
                                                        ))).then(
                                            (selectedValue) {
                                          // Handle the returned value from Dropdowntype
                                          if (selectedValue != null &&
                                              selectedValue
                                                  is Map<String, dynamic>) {
                                            setState(() {
                                              flscomplimentcontroller.text =
                                                  selectedValue[
                                                      'name']; // Update the TextFormField with the selected training name
                                              flscomp = selectedValue['id'];
                                            });
                                          }
                                        });
                                      },
                                      // items:
                                      //     this.foreShoeComp.map((foreShoeComp) {
                                      //   return DropdownMenuItem<String>(
                                      //     value: foreShoeComp.id.toString(),
                                      //     child: Text(foreShoeComp.name),
                                      //   );
                                      // }).toList(),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Enter Horse details";
                                        }
                                      }),
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
                              //               'Add New FLS Compliments',
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
                              //                       .read<FarrierFormBloc>()
                              //                       .add(SubmitforeShoeComplement(
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
                          SizedBox(height: 10.0),
                          Container(
                            height: 2, // Thickness of the line
                            color: Color(0xFF595BD4), // Line color
                          ),
                          SizedBox(height: 10.0),
                          Row(
                            children: [
                              // Expanded(
                              //   flex: 2,
                              //   child: Text(
                              //     'Hind Limb shoe',
                              //     style: TextStyle(
                              //         fontFamily: 'Karla',
                              //         fontSize: getTextSize15Value(buttonTextSize),
                              //         color: Colors.black),
                              //   ),
                              // ),

                              // SizedBox(width: 25.0),
                              Expanded(
                                flex: 8,
                                child: Container(
                                  // width: 147, // Set desired width
                                  height: 40,
                                  child: TextFormField(
                                      controller: Hindcontroller,
                                      onChanged: (String? newValue3) {
                                        setState(() {
                                          Hindcontroller.text = newValue3!;
                                        });
                                      },
                                      decoration: InputDecoration(
                                          labelText: 'Hind Limb Shoe',
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
                                                color: Colors.black,
                                                width: 2.0),
                                          ),
                                          fillColor: Color(
                                              0xFFE5E5FC), // Background color
                                          filled:
                                              true, // Enable filling with the color
                                          suffixIcon: Icon(
                                              Icons.arrow_forward_outlined)),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (context) => Dropdowntype(
                                                          title:
                                                              'Hind Limb Shoe',
                                                          onEdit: (int id,
                                                              String name) {
                                                            showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context1) {
                                                                String
                                                                    updatedName =
                                                                    name; // To store the input from the TextField
                                                                return AlertDialog(
                                                                  title: Text(
                                                                    'Edit Hind Limb shoe',
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'Karla',
                                                                        fontSize:
                                                                            getTextSize15Value(
                                                                                buttonTextSize),
                                                                        color: Colors
                                                                            .black),
                                                                  ), // Title of the dialog
                                                                  content:
                                                                      TextField(
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
                                                                      onPressed:
                                                                          () {
                                                                        // Perform save action
                                                                        print(
                                                                            'Updated Name: $updatedName'); // Example: Print the name to the console
                                                                        this.context.read<FarrierFormBloc>().add(SubmithindShoeType(
                                                                            id:
                                                                                id,
                                                                            name:
                                                                                updatedName));

                                                                        Navigator.of(context1)
                                                                            .pop(); // Close the dialog
                                                                      },
                                                                      child: Text(
                                                                          'Update'), // The save button
                                                                    ),
                                                                    TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context1)
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
                                                                      'Are you sure you want to delete this hindShoeType?'),
                                                                  actions: <Widget>[
                                                                    TextButton(
                                                                      child: Text(
                                                                          'Cancel'),
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(dialogContext)
                                                                            .pop(); // Use dialogContext here to close the dialog
                                                                      },
                                                                    ),
                                                                    TextButton(
                                                                      child: Text(
                                                                          'Confirm'),
                                                                      onPressed:
                                                                          () {
                                                                        // Use the original context to access the HorseDashboardBloc
                                                                        this
                                                                            .context
                                                                            .read<FarrierFormBloc>()
                                                                            .add(DeletehindShoeType(hindShoeTypeId: Id));
                                                                        print(
                                                                            'Delete selected');
                                                                        Navigator.of(dialogContext)
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
                                                              builder:
                                                                  (BuildContext
                                                                      context1) {
                                                                String name =
                                                                    ''; // To store the input from the TextField
                                                                return AlertDialog(
                                                                  title: Text(
                                                                    'Add New Hind Limb shoe',
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'Karla',
                                                                        fontSize:
                                                                            getTextSize15Value(
                                                                                buttonTextSize),
                                                                        color: Colors
                                                                            .black),
                                                                  ), // Title of the dialog
                                                                  content:
                                                                      TextField(
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
                                                                      onPressed:
                                                                          () {
                                                                        // Perform save action
                                                                        print(
                                                                            'Name: $name'); // Example: Print the name to the console
                                                                        this
                                                                            .context
                                                                            .read<FarrierFormBloc>()
                                                                            .add(SubmithindShoeType(name: name));

                                                                        Navigator.of(context1)
                                                                            .pop(); // Close the dialog
                                                                      },
                                                                      child: Text(
                                                                          'Save'), // The save button
                                                                    ),
                                                                    TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context1)
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
                                                              hindShoeType.map(
                                                                  (hindShoeType) {
                                                            return {
                                                              'id': hindShoeType
                                                                  .id
                                                                  .toString(),
                                                              'name':
                                                                  hindShoeType
                                                                      .name
                                                            };
                                                          }).toList(),
                                                        ))).then(
                                            (selectedValue) {
                                          // Handle the returned value from Dropdowntype
                                          if (selectedValue != null &&
                                              selectedValue
                                                  is Map<String, dynamic>) {
                                            setState(() {
                                              Hindcontroller.text = selectedValue[
                                                  'name']; // Update the TextFormField with the selected training name
                                              hindlimb = selectedValue['id'];
                                            });
                                          }
                                        });
                                      },
                                      // items:
                                      //     this.hindShoeType.map((hindShoeType) {
                                      //   return DropdownMenuItem<String>(
                                      //     value: hindShoeType.id.toString(),
                                      //     child: Text(hindShoeType.name),
                                      //   );
                                      // }).toList(),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Enter Horse details";
                                        }
                                      }),
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
                              //               'Add New Hind Limb shoe',
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
                              //                       .read<FarrierFormBloc>()
                              //                       .add(SubmithindShoeType(
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
                          SizedBox(height: 10.0),
                          Row(
                            children: [
                              // Expanded(
                              //   flex: 2,
                              //   child: Text(
                              //     'HLS Specification',
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
                                  // width: 210, // Set desired width
                                  height: 40, // Set desired height
                                  child: TextFormField(
                                    controller: hlsspecficationcontroller,
                                    // items:
                                    //     this.hindShoeSpecf.map((hindShoeSpecf) {
                                    //   return DropdownMenuItem<String>(
                                    //     value: hindShoeSpecf.id.toString(),
                                    //     child: Text(hindShoeSpecf.name),
                                    //   );
                                    // }).toList(),
                                    decoration: InputDecoration(
                                        labelText: 'HLS Specification',
                                        contentPadding: EdgeInsets.all(7),
                                        labelStyle: TextStyle(
                                            // fontSize: getTextSize20Value(buttonTextSize),
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
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Enter Horse details";
                                      }
                                    },
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Dropdowntype(
                                                    title: 'HLS Specification',
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
                                                              'Edit Hls Specification ',
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
                                                                          FarrierFormBloc>()
                                                                      .add(SubmithindShoeSpecification(
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
                                                                'Are you sure you want to delete this hindShoeSpecification?'),
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
                                                                          FarrierFormBloc>()
                                                                      .add(DeletehindShoeSpecification(
                                                                          hindShoeSpecificationId:
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
                                                              'Add New Hls Specification ',
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
                                                                          FarrierFormBloc>()
                                                                      .add(SubmithindShoeSpecification(
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
                                                    trainingList: hindShoeSpecf
                                                        .map((hindShoeSpecf) {
                                                      return {
                                                        'id': hindShoeSpecf.id
                                                            .toString(),
                                                        'name':
                                                            hindShoeSpecf.name
                                                      };
                                                    }).toList(),
                                                  ))).then((selectedValue) {
                                        // Handle the returned value from Dropdowntype
                                        if (selectedValue != null &&
                                            selectedValue
                                                is Map<String, dynamic>) {
                                          setState(() {
                                            hlsspecficationcontroller.text =
                                                selectedValue[
                                                    'name']; // Update the TextFormField with the selected training name
                                            hlsspec = selectedValue['id'];
                                          });
                                        }
                                      });
                                    },
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        hlsspecficationcontroller.text =
                                            newValue!;
                                      });
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
                              //               'Add New Hls Specification ',
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
                              //                       .read<FarrierFormBloc>()
                              //                       .add(
                              //                           SubmithindShoeSpecification(
                              //                               name: name));

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
                            ],
                          ),
                          SizedBox(height: 10.0),
                          Row(
                            children: [
                              // Expanded(
                              //   flex: 2,
                              //   child: Text(
                              //     'HLS Compliments',
                              //     style: TextStyle(
                              //         fontFamily: 'Karla',
                              //         fontSize: getTextSize15Value(buttonTextSize),
                              //         color: Colors.black),
                              //   ),
                              // ),

                              // SizedBox(width: 25.0),
                              Expanded(
                                flex: 8,
                                child: Container(
                                  // width: 147, // Set desired width
                                  height: 40, // Set desired height
                                  child: TextFormField(
                                      controller: hlscomplimentcontroller,
                                      onChanged: (String? newValue4) {
                                        setState(() {
                                          hlscomplimentcontroller.text =
                                              newValue4!;
                                        });
                                      },
                                      decoration: InputDecoration(
                                          labelText: 'HLS Compliments',
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
                                                color: Colors.black,
                                                width: 2.0),
                                          ),
                                          fillColor: Color(
                                              0xFFE5E5FC), // Background color
                                          filled:
                                              true, // Enable filling with the color
                                          suffixIcon: Icon(
                                              Icons.arrow_forward_outlined)),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (context) => Dropdowntype(
                                                          title:
                                                              'HLS Compliments',
                                                          onEdit: (int id,
                                                              String name) {
                                                            showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context1) {
                                                                String
                                                                    updatedName =
                                                                    name; // To store the input from the TextField
                                                                return AlertDialog(
                                                                  title: Text(
                                                                    'Edit HLS Compliments',
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'Karla',
                                                                        fontSize:
                                                                            getTextSize15Value(
                                                                                buttonTextSize),
                                                                        color: Colors
                                                                            .black),
                                                                  ), // Title of the dialog
                                                                  content:
                                                                      TextField(
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
                                                                      onPressed:
                                                                          () {
                                                                        // Perform save action
                                                                        print(
                                                                            'Name: $updatedName'); // Example: Print the name to the console
                                                                        this.context.read<FarrierFormBloc>().add(SubmithindShoeComplement(
                                                                            id:
                                                                                id,
                                                                            name:
                                                                                updatedName));

                                                                        Navigator.of(context1)
                                                                            .pop(); // Close the dialog
                                                                      },
                                                                      child: Text(
                                                                          'Update'), // The save button
                                                                    ),
                                                                    TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context1)
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
                                                                      'Are you sure you want to delete this hindShoeComplement?'),
                                                                  actions: <Widget>[
                                                                    TextButton(
                                                                      child: Text(
                                                                          'Cancel'),
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(dialogContext)
                                                                            .pop(); // Use dialogContext here to close the dialog
                                                                      },
                                                                    ),
                                                                    TextButton(
                                                                      child: Text(
                                                                          'Confirm'),
                                                                      onPressed:
                                                                          () {
                                                                        // Use the original context to access the HorseDashboardBloc
                                                                        this
                                                                            .context
                                                                            .read<FarrierFormBloc>()
                                                                            .add(DeletehindShoeComplement(hindShoeComplementId: Id));
                                                                        print(
                                                                            'Delete selected');
                                                                        Navigator.of(dialogContext)
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
                                                              builder:
                                                                  (BuildContext
                                                                      context1) {
                                                                String name =
                                                                    ''; // To store the input from the TextField
                                                                return AlertDialog(
                                                                  title: Text(
                                                                    'Add New HLS Compliments',
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'Karla',
                                                                        fontSize:
                                                                            getTextSize15Value(
                                                                                buttonTextSize),
                                                                        color: Colors
                                                                            .black),
                                                                  ), // Title of the dialog
                                                                  content:
                                                                      TextField(
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
                                                                      onPressed:
                                                                          () {
                                                                        // Perform save action
                                                                        print(
                                                                            'Name: $name'); // Example: Print the name to the console
                                                                        this
                                                                            .context
                                                                            .read<FarrierFormBloc>()
                                                                            .add(SubmithindShoeComplement(name: name));

                                                                        Navigator.of(context1)
                                                                            .pop(); // Close the dialog
                                                                      },
                                                                      child: Text(
                                                                          'Save'), // The save button
                                                                    ),
                                                                    TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context1)
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
                                                              hindShoeComp.map(
                                                                  (hindShoeComp) {
                                                            return {
                                                              'id': hindShoeComp
                                                                  .id
                                                                  .toString(),
                                                              'name':
                                                                  hindShoeComp
                                                                      .name
                                                            };
                                                          }).toList(),
                                                        ))).then(
                                            (selectedValue) {
                                          // Handle the returned value from Dropdowntype
                                          if (selectedValue != null &&
                                              selectedValue
                                                  is Map<String, dynamic>) {
                                            setState(() {
                                              hlscomplimentcontroller.text =
                                                  selectedValue[
                                                      'name']; // Update the TextFormField with the selected training name
                                              hlscomp = selectedValue['id'];
                                            });
                                          }
                                        });
                                      },
                                      // items:
                                      //     this.hindShoeComp.map((hindShoeComp) {
                                      //   return DropdownMenuItem<String>(
                                      //     value: hindShoeComp.id.toString(),
                                      //     child: Text(hindShoeComp.name),
                                      //   );
                                      // }).toList(),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Enter Horse details";
                                        }
                                      }),
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
                              //               'Add New HLS Compliments',
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
                              //                       .read<FarrierFormBloc>()
                              //                       .add(SubmithindShoeComplement(
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
                          //SizedBox(height: 20.0),
                          if (_fileNames.isNotEmpty)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
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
                          if (state is FetchDocumentSuccess)
                            // Display fetched documents
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Container(
                                height:
                                    50.0, // Specify the desired height for the ListView
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
                                                  size: 20.0,
                                                  color: Colors.blue),
                                              Expanded(
                                                child: GestureDetector(
                                                  onTap: () => context
                                                      .read<FarrierFormBloc>()
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
                                              //         .read<FarrierFormBloc>()
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
                            ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "Before Shoeing",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                ),
                              ),
                              if (FarrierName == null)
                                TextButton(
                                  onPressed: () async {
                                    context
                                        .read<FarrierFormBloc>()
                                        .add(BeforeFilePickedFarrier());
                                  },
                                  child: Text(
                                    "Upload",
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        color: Color(0xFF595BD4)),
                                  ),
                                ),
                            ],
                          ),
                          // SizedBox(height: 10.0),
                          // if (state
                          //     is BeforeFileSelectedFarrier) // Check if the state is FileSelected
                          //   Image.file(
                          //     state.pickedImage1,
                          //     width: 200, // Adjust width as necessary
                          //     height: 200, // Adjust height as necessary
                          //     fit: BoxFit.cover,
                          //   ),
                          SizedBox(height: 10.0),
                          if (FarrierName != null)
                            Stack(children: [
                              Container(
                                child: Center(
                                    child: GestureDetector(
                                        onTap: () {
                                          if (state
                                                  is BeforeFileSelectedFarrier &&
                                              state.pickedImage1 != null) {
                                            _showZoomableImage(
                                                context, state.pickedImage1);
                                          }
                                        },
                                        child: CircleAvatar(
                                            radius: 50,
                                            backgroundColor: Color.fromRGBO(
                                                139, 72, 223, 0.1),
                                            backgroundImage:
                                                state is BeforeFileSelectedFarrier &&
                                                        state.pickedImage1 !=
                                                            null
                                                    ? FileImage(
                                                        state.pickedImage1!)
                                                    : null,
                                            child: state
                                                    is! BeforeFileSelectedFarrier
                                                ? ProfileImage(
                                                    recordId: FarrierName!.id
                                                        .toString(),
                                                    tableName: 'Farrier',
                                                    displayPane: 'Before',
                                                  )
                                                : null))),
                              ),
                              // Positioned(
                              //   top: 75,
                              //   left: 180,
                              //   child: CircleAvatar(
                              //     radius: 15,
                              //     backgroundColor: Colors.white,
                              //     child: IconButton(
                              //       icon: Icon(Icons.camera_alt, size: 20),
                              //       onPressed: () {
                              //         context
                              //             .read<AddHorseBloc>()
                              //             .add(PickImage());
                              //       },
                              //     ),
                              //   ),
                              // ),
                            ]),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "After Shoeing",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                ),
                              ),
                              if (FarrierName == null)
                                TextButton(
                                  onPressed: () async {
                                    context
                                        .read<FarrierFormBloc>()
                                        .add(AfterFilePickedFarrier());
                                  },
                                  child: Text(
                                    "Upload",
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        color: Color(0xFF595BD4)),
                                  ),
                                )
                            ],
                          ),
                          // if (state
                          //     is AfterFileSelectedFarrier) // Check if the state is FileSelected
                          //   Image.file(
                          //     state.pickedImage2,
                          //     width: 200, // Adjust width as necessary
                          //     height: 200, // Adjust height as necessary
                          //     fit: BoxFit.cover,
                          //   ),
                          if (FarrierName != null)
                            Stack(children: [
                              Container(
                                child: Center(
                                    child: GestureDetector(
                                        onTap: () {
                                          if (state
                                                  is AfterFileSelectedFarrier &&
                                              state.pickedImage2 != null) {
                                            _showZoomableImage(
                                                context, state.pickedImage2);
                                          }
                                        },
                                        child: CircleAvatar(
                                            radius: 50,
                                            backgroundColor: Color.fromRGBO(
                                                139, 72, 223, 0.1),
                                            backgroundImage:
                                                state is AfterFileSelectedFarrier &&
                                                        state.pickedImage2 !=
                                                            null
                                                    ? FileImage(
                                                        state.pickedImage2!)
                                                    : null,
                                            child: state
                                                    is! AfterFileSelectedFarrier
                                                ? ProfileImage(
                                                    recordId: FarrierName!.id
                                                        .toString(),
                                                    tableName: 'Farrier',
                                                    displayPane: 'After',
                                                  )
                                                : null))),
                              ),
                              // Positioned(
                              //   top: 75,
                              //   left: 180,
                              //   child: CircleAvatar(
                              //     radius: 15,
                              //     backgroundColor: Colors.white,
                              //     child: IconButton(
                              //       icon: Icon(Icons.camera_alt, size: 20),
                              //       onPressed: () {
                              //         context
                              //             .read<AddHorseBloc>()
                              //             .add(PickImage());
                              //       },
                              //     ),
                              //   ),
                              // ),
                            ]),
                        ],
                      ),
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
}
