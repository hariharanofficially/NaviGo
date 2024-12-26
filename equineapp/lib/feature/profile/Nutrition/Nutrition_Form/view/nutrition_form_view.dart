import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../../data/models/FoodUom_model.dart';
import '../../../../../data/models/foodType_model.dart';
import '../../../../../data/models/horse_model.dart';
import '../../../../../utils/constants/appreance_definition.dart';
import '../../../../common/widgets/dropdown_type.dart';
import '../../../../common/widgets/navigation_widget.dart';
import '../../../../header/app_bar.dart';
import '../../../../home/home_screen.dart';
import '../../../../nav_bar/Dashboard/bloc/Dashboard_bloc.dart';
import '../../../../nav_bar/Dashboard/view/Dashboard_view.dart';
import '../../../../nav_bar/nav_bar.dart';
import '../../../../subscripition/manage_dashboard/singlestable_menu/bloc/singestablemenu_bloc.dart';
import '../../../../subscripition/manage_dashboard/singlestable_menu/view/singlestablemenu_view.dart';
import '../../Nutrition_dashboard/bloc/nutrition_bloc.dart';
import '../../Nutrition_dashboard/view/Nutrition.dart';
import '../bloc/nutrition_form_bloc.dart';
import 'package:file_picker/file_picker.dart';

class NutritionForm extends StatefulWidget {
  final HorseModel horseid;
  final int? nutritionId;
  final bool isSave;

  const NutritionForm(
      {super.key,
      required this.horseid,
      this.nutritionId,
      required this.isSave});

  @override
  State<NutritionForm> createState() => _NutritionFormState();
}

class _NutritionFormState extends State<NutritionForm>
    with SingleTickerProviderStateMixin {
  final horsecontroller = TextEditingController();
  // final foodcontroller = TextEditingController();
  // String? uomcontroller;
  final TextEditingController uomcontroller = TextEditingController();
  final valuecontroller = TextEditingController();
  int selectedTab = 0;
  DateTime selectedDate = DateTime.now();
  DateTime focusedDay = DateTime.now();
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isCalendarExpanded = false;
  // String? selectedFoodType;
  final TextEditingController selectedFoodType = TextEditingController();
  // List<String> foodTypes = ['Grain', 'Hay', 'Supplements', 'Pellets'];
  // List<String> uomTypes = ['Grain', 'Hay', 'Supplements', 'Pellets'];
  List<FoodType> foodtype = [];
  List<FoodUomType> fooduomtype = [];
  var food;
  var uom;
  List<String> _fileNames = []; // List to store multiple file names
  List<String?> _filePaths = [];

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
    _animationController = AnimationController(
      vsync: this, // Provides Ticker for animation
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    if (widget.nutritionId != null) {
      context
          .read<NutritionFormBloc>()
          .add(LoadNutritionformByid(id: widget.nutritionId!));
    } else {
      context.read<NutritionFormBloc>().add(LoadNutritionform());
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
    return BlocConsumer<NutritionFormBloc, NutritionFormState>(
      listener: (context, state) {
        if (state is NutritionFormLoaded) {
          foodtype = state.allFormModel.foodtype;
          fooduomtype = state.allFormModel.fooduomtype;
          if (widget.nutritionId != null) {
            final nutrition = state.allFormModel.nutritionDetail;
            selectedFoodType.text = nutrition.foodTypeName.toString();
            uomcontroller.text = nutrition.feeduomName.toString();
            valuecontroller.text = nutrition.servingValue.toString();
            selectedDate = nutrition.servingDatetime;
          }
        } else if (state is NutritionFormSuccessfully) {
          String message = widget.nutritionId != null
              ? 'Nutrition Updated Successfully'
              : 'Nutrition Added Successfully';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );

          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => NutritionBloc(),
                  child:
                      Nutrition(horseid: widget.horseid), // Pass the horse id
                ),
              ));
        } else if (state is NutritionFormerror) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Nutrition Add failed")),
          );
        } else if (state is FetchDocumentFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Fetch Document Failed")),
          );
        } else if (state is ImageUploadSuccessfully) {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text("Document Uploaded Successfully")),
          // );
        } else if (state is FoodTypeCreateSuccess) {
          foodtype = state.types;
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) => BlocProvider(
          //             create: (context) => NutritionFormBloc(),
          //             child: NutritionForm(
          //               horseid: widget.horseid,
          //               isSave: true,
          //             ),
          //           )),
          // );
        } else if (state is FoodUomTypeCreateSuccess) {
          fooduomtype = state.types;
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) => BlocProvider(
          //             create: (context) => NutritionFormBloc(),
          //             child: NutritionForm(
          //               horseid: widget.horseid,
          //               isSave: true,
          //             ),
          //           )),
          // );
        } else if (state is FoodTypeDeleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Food Type Deleted Successfully")),
          );
          foodtype = state.types;
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) => BlocProvider(
          //             create: (context) => NutritionFormBloc(),
          //             child: NutritionForm(
          //               horseid: widget.horseid,
          //               isSave: true,
          //             ),
          //           )),
          // );
        } else if (state is FooduomDeleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Food UoM Deleted Successfully")),
          );
          fooduomtype = state.types;
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) => BlocProvider(
          //             create: (context) => NutritionFormBloc(),
          //             child: NutritionForm(
          //               horseid: widget.horseid,
          //               isSave: true,
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
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: CustomAppBar(),
          endDrawer: NavigitionWidget(),
          body: state is NutritionFormLoading
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
                                          'Nutrition',
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
                                                      .read<NutritionFormBloc>()
                                                      .add(SubmitFormNutrition(
                                                        id: widget.nutritionId,
                                                        horseId: widget
                                                            .horseid.id
                                                            .toString(),
                                                        foodType: food,
                                                        // foodType:
                                                        //     selectedFoodType
                                                        //         .toString(),
                                                        feeduom: uom,
                                                        // feeduom: uomcontroller
                                                        //     .toString(),
                                                        servingValue:
                                                            valuecontroller
                                                                .text,
                                                        nutritiondatetime:
                                                            selectedDate
                                                                .toIso8601String(),
                                                        filePath: _filePaths,
                                                      ));
                                                  // for (var filePath
                                                  //     in _filePaths) {
                                                  //   if (filePath != null) {
                                                  //     context
                                                  //         .read<
                                                  //             NutritionFormBloc>()
                                                  //         .add(
                                                  //           UploadImageNutrition(
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
                              // Expanded(
                              //   flex: 2,
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
                                flex: 3,
                                child: Container(
                                  // width: 210, // Set desired width
                                  height: 40,
                                  child: TextFormField(
                                      readOnly: true,
                                      keyboardType: TextInputType.emailAddress,
                                      controller: TextEditingController(
                                          text: widget.horseid.name),
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
                          Row(
                            children: [
                              // Expanded(
                              //   flex: 2,
                              //   child: Text(
                              //     'Food Type',
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
                                  // width: 190, // Set desired width
                                  height: 40,
                                  child: TextFormField(
                                    controller:
                                        selectedFoodType, // Selected value
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedFoodType.text = newValue!;
                                      });
                                    },
                                    decoration: InputDecoration(
                                        labelText: 'Food Type',
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
                                        fillColor: Color(
                                            0xFFE5E5FC), // Background color
                                        filled:
                                            true, // Enable filling with the color
                                        suffixIcon:
                                            Icon(Icons.arrow_forward_outlined)),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Dropdowntype(
                                                    title: 'Food type',
                                                    onEdit:
                                                        (int id, String name) {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context1) {
                                                          String updatedName =
                                                              name; // To store the input from the TextField
                                                          String descripition =
                                                              ''; // To store the input from the TextField
                                                          return AlertDialog(
                                                            title: Text(
                                                              'Edit Food Type',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Karla',
                                                                  fontSize:
                                                                      getTextSize15Value(
                                                                          buttonTextSize),
                                                                  color: Colors
                                                                      .black),
                                                            ), // Title of the dialog
                                                            content: Column(
                                                              children: [
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
                                                                TextField(
                                                                  onChanged:
                                                                      (value1) {
                                                                    descripition =
                                                                        value1; // Save input to the name variable
                                                                  },
                                                                  decoration:
                                                                      InputDecoration(
                                                                    labelText:
                                                                        'Descripition', // Label for the input field
                                                                    border:
                                                                        OutlineInputBorder(), // Styling the TextField
                                                                  ),
                                                                ),
                                                              ],
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
                                                                          NutritionFormBloc>()
                                                                      .add(SubmitFoodType(
                                                                          id:
                                                                              id,
                                                                          name:
                                                                              updatedName,
                                                                          descripition:
                                                                              descripition));

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
                                                                'Are you sure you want to delete this FoodType?'),
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
                                                                          NutritionFormBloc>()
                                                                      .add(DeletefoodType(
                                                                          foodTypeId:
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
                                                          String descripition =
                                                              ''; // To store the input from the TextField
                                                          return AlertDialog(
                                                            title: Text(
                                                              'Add new Food Type',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Karla',
                                                                  fontSize:
                                                                      getTextSize15Value(
                                                                          buttonTextSize),
                                                                  color: Colors
                                                                      .black),
                                                            ), // Title of the dialog
                                                            content: Column(
                                                              children: [
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
                                                                TextField(
                                                                  onChanged:
                                                                      (value1) {
                                                                    descripition =
                                                                        value1; // Save input to the name variable
                                                                  },
                                                                  decoration:
                                                                      InputDecoration(
                                                                    labelText:
                                                                        'Descripition', // Label for the input field
                                                                    border:
                                                                        OutlineInputBorder(), // Styling the TextField
                                                                  ),
                                                                ),
                                                              ],
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
                                                                          NutritionFormBloc>()
                                                                      .add(SubmitFoodType(
                                                                          name:
                                                                              name,
                                                                          descripition:
                                                                              descripition));

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
                                                    trainingList: foodtype
                                                        .map((foodtypes) {
                                                      return {
                                                        'id': foodtypes.id
                                                            .toString(),
                                                        'name': foodtypes.name
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
                                            food = selectedValue['id'];
                                          });
                                        }
                                      });
                                    },
                                    // items: this.foodtype.map((foodtypes) {
                                    //   return DropdownMenuItem(
                                    //     child: Text(foodtypes.name),
                                    //     value: foodtypes.id.toString(),
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
                              //           String descripition =
                              //               ''; // To store the input from the TextField
                              //           return AlertDialog(
                              //             title: Text(
                              //               'Add new Food Type',
                              //               style: TextStyle(
                              //                   fontFamily: 'Karla',
                              //                   fontSize: getTextSize15Value(
                              //                       buttonTextSize),
                              //                   color: Colors.black),
                              //             ), // Title of the dialog
                              //             content: Column(
                              //               children: [
                              //                 TextField(
                              //                   onChanged: (value) {
                              //                     name =
                              //                         value; // Save input to the name variable
                              //                   },
                              //                   decoration: InputDecoration(
                              //                     labelText:
                              //                         'Name', // Label for the input field
                              //                     border:
                              //                         OutlineInputBorder(), // Styling the TextField
                              //                   ),
                              //                 ),
                              //                 TextField(
                              //                   onChanged: (value1) {
                              //                     descripition =
                              //                         value1; // Save input to the name variable
                              //                   },
                              //                   decoration: InputDecoration(
                              //                     labelText:
                              //                         'Descripition', // Label for the input field
                              //                     border:
                              //                         OutlineInputBorder(), // Styling the TextField
                              //                   ),
                              //                 ),
                              //               ],
                              //             ),
                              //             actions: <Widget>[
                              //               TextButton(
                              //                 onPressed: () {
                              //                   // Perform save action
                              //                   print(
                              //                       'Name: $name'); // Example: Print the name to the console
                              //                   this
                              //                       .context
                              //                       .read<NutritionFormBloc>()
                              //                       .add(SubmitFoodType(
                              //                           name: name,
                              //                           descripition:
                              //                               descripition));

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
                          Row(
                            children: [
                              // Expanded(
                              //   flex: 2,
                              //   child: Text(
                              //     'UoM',
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
                                  // width: 190, // Set desired width
                                  height: 40,
                                  child: TextFormField(
                                    controller: uomcontroller,
                                    decoration: InputDecoration(
                                        labelText: 'UoM',
                                        contentPadding: EdgeInsets.all(7),
                                        labelStyle: TextStyle(
                                            // fontSize:
                                            // getTextSize20Value(buttonTextSize),
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
                                    onChanged: (String? value) {
                                      setState(() {
                                        uomcontroller.text = value!;
                                      });
                                    },
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Dropdowntype(
                                                    title: 'UoM',
                                                    onEdit:
                                                        (int id, String name) {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context1) {
                                                          String updatedName =
                                                              name; // To store the input from the TextField
                                                          String descripition =
                                                              ''; // To store the input from the TextField
                                                          return AlertDialog(
                                                            title: Text(
                                                              'Edit Food Uom Type',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Karla',
                                                                  fontSize:
                                                                      getTextSize15Value(
                                                                          buttonTextSize),
                                                                  color: Colors
                                                                      .black),
                                                            ), // Title of the dialog
                                                            content: Column(
                                                              children: [
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
                                                              ],
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
                                                                          NutritionFormBloc>()
                                                                      .add(SubmitFoodUomType(
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
                                                                'Are you sure you want to delete this FoodUoM?'),
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
                                                                          NutritionFormBloc>()
                                                                      .add(Deletefooduom(
                                                                          FooduomId:
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
                                                          String descripition =
                                                              ''; // To store the input from the TextField
                                                          return AlertDialog(
                                                            title: Text(
                                                              'Add new Food Uom Type',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Karla',
                                                                  fontSize:
                                                                      getTextSize15Value(
                                                                          buttonTextSize),
                                                                  color: Colors
                                                                      .black),
                                                            ), // Title of the dialog
                                                            content: Column(
                                                              children: [
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
                                                              ],
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
                                                                          NutritionFormBloc>()
                                                                      .add(SubmitFoodUomType(
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
                                                    trainingList: fooduomtype
                                                        .map((fooduomtypes) {
                                                      return {
                                                        'id': fooduomtypes.id
                                                            .toString(),
                                                        'name':
                                                            fooduomtypes.name
                                                      };
                                                    }).toList(),
                                                  ))).then((selectedValue) {
                                        // Handle the returned value from Dropdowntype
                                        if (selectedValue != null &&
                                            selectedValue
                                                is Map<String, dynamic>) {
                                          setState(() {
                                            uomcontroller.text = selectedValue[
                                                'name']; // Update the TextFormField with the selected training name
                                            uom = selectedValue['id'];
                                          });
                                        }
                                      });
                                    },
                                    // items: this.fooduomtype.map((foodtypes) {
                                    //   return DropdownMenuItem(
                                    //     child: Text(foodtypes.name),
                                    //     value: foodtypes.id.toString(),
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
                              //           String descripition =
                              //               ''; // To store the input from the TextField
                              //           return AlertDialog(
                              //             title: Text(
                              //               'Add new Food Uom Type',
                              //               style: TextStyle(
                              //                   fontFamily: 'Karla',
                              //                   fontSize: getTextSize15Value(
                              //                       buttonTextSize),
                              //                   color: Colors.black),
                              //             ), // Title of the dialog
                              //             content: Column(
                              //               children: [
                              //                 TextField(
                              //                   onChanged: (value) {
                              //                     name =
                              //                         value; // Save input to the name variable
                              //                   },
                              //                   decoration: InputDecoration(
                              //                     labelText:
                              //                         'Name', // Label for the input field
                              //                     border:
                              //                         OutlineInputBorder(), // Styling the TextField
                              //                   ),
                              //                 ),
                              //               ],
                              //             ),
                              //             actions: <Widget>[
                              //               TextButton(
                              //                 onPressed: () {
                              //                   // Perform save action
                              //                   print(
                              //                       'Name: $name'); // Example: Print the name to the console
                              //                   this
                              //                       .context
                              //                       .read<NutritionFormBloc>()
                              //                       .add(SubmitFoodUomType(
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
                            ],
                          ),
                          SizedBox(height: 10.0),
                          Row(
                            children: [
                              // Expanded(
                              //   flex: 3,
                              //   child: Text(
                              //     'Value',
                              //     style: TextStyle(
                              //         fontFamily: 'Karla',
                              //         fontSize: getTextSize15Value(buttonTextSize),
                              //         color: Colors.black),
                              //   ),
                              // ),
                              Expanded(
                                flex: 4,
                                child: Container(
                                  // width: 210, // Set desired width
                                  height: 40,
                                  child: TextFormField(
                                      keyboardType: TextInputType.emailAddress,
                                      controller: valuecontroller,
                                      decoration: InputDecoration(
                                        labelText: 'Value',
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
                            child: Column(
                              children: [
                                // // Display the selected date
                                // Padding(
                                //   padding: const EdgeInsets.symmetric(vertical: 16.0),
                                //   child: Text(
                                //     selectedDate != null
                                //         ? 'Selected Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}'
                                //         : 'No date selected',
                                //     style: TextStyle(
                                //         fontSize: 16, fontWeight: FontWeight.bold),
                                //   ),
                                // ),
                                TableCalendar(
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
                              ],
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
                          ), // Display the selected image
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
                                                  size: 20.0,
                                                  color: Colors.blue),
                                              Expanded(
                                                child: GestureDetector(
                                                  onTap: () => context
                                                      .read<NutritionFormBloc>()
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
                                              //         .read<NutritionFormBloc>()
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
                        ],
                      )),
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
