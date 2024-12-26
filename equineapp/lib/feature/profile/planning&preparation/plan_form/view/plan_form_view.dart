import 'package:EquineApp/feature/common/FormCustomWidget/datepickerform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../../data/service/service.dart';
import '../../../../common/FormCustomWidget/textform_field.dart';
import '../../plan_dashboard/bloc/plan_bloc.dart';
import '../../../../../data/models/bloodtest_element.dart';
import '../../../../../data/models/foodType_model.dart';
import '../../../../../data/models/horse_model.dart';
import '../../../../../data/models/shoeSpecification.dart';
import '../../../../../data/models/shoeType_model.dart';
import '../../../../../data/models/shoecomplement.dart';
import '../../../../../data/models/treatment_type.dart';
import '../../../../common/FormCustomWidget/customtextform.dart';
import '../../../../common/widgets/dropdown_type.dart';
import '../../../../common/widgets/navigation_widget.dart';
import '../../../../header/app_bar.dart';
import '../../plan_dashboard/view/plan_view.dart';
import '../bloc/plan_form_bloc.dart';
import '../../../../../utils/constants/appreance_definition.dart';
import '../../../../subscripition/manage_dashboard/singlestable_menu/bloc/singestablemenu_bloc.dart';
import '../../../../subscripition/manage_dashboard/singlestable_menu/view/singlestablemenu_view.dart';
import '../../../../nav_bar/Dashboard/bloc/Dashboard_bloc.dart';
import '../../../../nav_bar/Dashboard/view/Dashboard_view.dart';
import '../../../../home/home_screen.dart';
import '../../../../nav_bar/nav_bar.dart';

class PlanForn extends StatefulWidget {
  final HorseModel horse;

  const PlanForn({super.key, required this.horse});

  @override
  State<PlanForn> createState() => _PlanFornState();
}

class _PlanFornState extends State<PlanForn> {
  var tenantId;
  final weightcontroller = TextEditingController();
  final walkcontroller = TextEditingController();
  final cantercontroller = TextEditingController();
  final trotcontroller = TextEditingController();
  final gallopcontroller = TextEditingController();
  String? treatmenttypecontroller;
  final checkupdatecontroller = TextEditingController();
  String? foogtypecontroller;
  final valuecontroller = TextEditingController();
  String? forelimbcontroller;
  String? flscontroller;
  String? flsspecification;
  String? hindlimbcontroller;
  String? hlsspecificaition;
  String? hlscontroller;

  String? type1controller;
  final type2controller = TextEditingController();
  final value1controller = TextEditingController();
  final value2controller = TextEditingController();
  int selectedTab = 0;
  final startdatecontroller = TextEditingController();
  final enddatecontroller = TextEditingController();

  // DateTime startDate = DateTime.now();
  // DateTime endDate = DateTime.now();
  List<TreatmentType> treatment = [];
  List<FoodType> foodtype = [];
  List<BloodTestElement> bloodtestelement = [];
  List<shoeType> foreShoeType = [];
  List<shoeSpecification> foreShoeSpecf = [];
  List<shoeComplement> foreShoeComp = [];
  List<shoeType> hindShoeType = [];
  List<shoeSpecification> hindShoeSpecf = [];
  List<shoeComplement> hindShoeComp = [];
  List<Map<String, dynamic>> treatmentList = [];
  List<Map<String, dynamic>> nutritionList = [];
  List<Map<String, dynamic>> bloodtestList = [];
  final _formKey = GlobalKey<FormState>();

  // Function to add a new set of fields

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Pre-fill the treatment list with default values
    treatmentList.add({
      "treatmentType": TextEditingController(), // Replace with actual data
      "checkupDate": TextEditingController(), // Replace with actual date
    });

    nutritionList.add({
      "foodtype": TextEditingController(),
      "value": TextEditingController(),
      "servingDate": TextEditingController()
    });
    bloodtestList.add({
      "type": TextEditingController(),
      "value": TextEditingController(),
      "testDate": TextEditingController()
    });

    getTenantId();
    context.read<PlanFormBloc>().add(LoadPlanForm());
  }

  Future<void> getTenantId() async {
    tenantId = await cacheService.getString(name: 'tenantId');
  }

  void addNewField() {
    setState(() {
      treatmentList.add({
        "treatmentType": TextEditingController(),
        "checkupDate": TextEditingController(),
      });
    });
  }

  void addNewNutrtion() {
    setState(() {
      nutritionList.add({
        "foodtype": TextEditingController(),
        "value": TextEditingController(),
        "servingDate": TextEditingController()
      });
    });
  }

  void addNewBloodtest() {
    setState(() {
      bloodtestList.add({
        "type": TextEditingController(),
        "value": TextEditingController(),
        "testDate": TextEditingController()
      });
    });
  }

  void removeField() {
    if (treatmentList.isNotEmpty) {
      setState(() {
        var removedEntry = treatmentList.removeLast();
        removedEntry["treatmentType"].dispose();
        removedEntry["checkupDate"].dispose();
      });
    }
  }

  void removeNutrition() {
    if (nutritionList.isNotEmpty) {
      setState(() {
        // nutritionList.removeLast(); // Remove the last entry
        var removedEntry = nutritionList.removeLast();
        removedEntry["foodtype"].dispose();
        removedEntry["value"].dispose();
        removedEntry["servingDate"].dispose();
      });
    }
  }

  void removeBloodtest() {
    if (bloodtestList.isNotEmpty) {
      setState(() {
        // bloodtestList.removeLast(); // Remove the last entry
        var removedEntry = bloodtestList.removeLast();
        removedEntry["type"].dispose();
        removedEntry["value"].dispose();
        removedEntry["testDate"].dispose();
      });
    }
  }

  _checkupdate(BuildContext context, String select, int index) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        treatmentList[index]["checkupDate"].text =
            DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  _servingdate(BuildContext context, String select, int index) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        nutritionList[index]["servingDate"].text =
            DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  _testdate(BuildContext context, String select, int index) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        bloodtestList[index]["testDate"].text =
            DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  _startdate(BuildContext context, String select) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        startdatecontroller.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  _enddate(BuildContext context, String select) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        enddatecontroller.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  final DateFormat _inputDateFormat = DateFormat('dd-MM-yyyy');
  final DateFormat _serverDateFormat = DateFormat('yyyy-MM-ddTHH:mm:ss');
  final DateFormat _serverDateOnlyFormat = DateFormat('yyyy-MM-dd');
  String convertDateToServerFormat(String date) {
    try {
      final DateTime parsedDate = _inputDateFormat.parse(date);
      final DateTime now = DateTime.now();
      final DateTime dateWithCurrentTime = DateTime(
        parsedDate.year,
        parsedDate.month,
        parsedDate.day,
        now.hour,
        now.minute,
        now.second,
      );
      return _serverDateFormat.format(dateWithCurrentTime);
    } catch (e) {
      // Handle parsing error
      //logger.e("Date parsing error: $e");
      return '';
    }
  }

  String convertDateToServerDateFormat(String date) {
    try {
      final DateTime parsedDate = _inputDateFormat.parse(date);
      final DateTime now = DateTime.now();
      final DateTime dateWithCurrentTime = DateTime(
        parsedDate.year,
        parsedDate.month,
        parsedDate.day,
        now.hour,
        now.minute,
        now.second,
      );
      return _serverDateOnlyFormat.format(dateWithCurrentTime);
    } catch (e) {
      // Handle parsing error
      //logger.e("Date parsing error: $e");
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlanFormBloc, PlanFormState>(
      listener: (context, state) {
        if (state is PlanFormLoaded) {
          treatment = state.allFormModel.treatmentType;
          foodtype = state.allFormModel.foodtype;
          bloodtestelement = state.allFormModel.bloodtestelement;
          foreShoeType = state.allFormModel.shoetype;
          foreShoeSpecf = state.allFormModel.shoespecf;
          foreShoeComp = state.allFormModel.shoecomp;
          hindShoeType = state.allFormModel.shoetype;
          hindShoeSpecf = state.allFormModel.shoespecf;
          hindShoeComp = state.allFormModel.shoecomp;
        } else if (state is PlanFormSuccessfully) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Planning Added Successfully")),
          );
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => PlanBloc(),
                  child:
                      PlanDashboard(horse: widget.horse), // Pass the horse id
                ),
              ));
        } else if (state is PlanFormerror) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Planning Add failed")),
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
                  child: Form(
                    key: _formKey,
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
                                    const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Planning',
                                      style: GoogleFonts.karla(
                                        textStyle: TextStyle(
                                          color: Color(0xFF595BD4),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          // Map the treatment data
                                          List<Map<String, dynamic>>
                                              treatments =
                                              treatmentList.map((entry) {
                                            return {
                                              'treatmentTypeId':
                                                  entry['treatmentType']
                                                          .text
                                                          .isNotEmpty
                                                      ? entry['treatmentType']
                                                          .text
                                                      : null,
                                              'checkupDate':
                                                  entry['checkupDate']
                                                          .text
                                                          .isNotEmpty
                                                      ? entry['checkupDate']
                                                          .text
                                                      : null,
                                            };
                                          }).toList();

                                          // Map the nutrition data
                                          List<Map<String, dynamic>>
                                              nutritions =
                                              nutritionList.map((entry) {
                                            return {
                                              'foodTypeId': entry['foodtype']
                                                      .text
                                                      .isNotEmpty
                                                  ? entry['foodtype'].text
                                                  : null,
                                              'servingValue':
                                                  entry['value'].text.isNotEmpty
                                                      ? entry['value'].text
                                                      : null,
                                            };
                                          }).toList();

                                          // Map the blood test data
                                          List<Map<String, dynamic>>
                                              bloodTests =
                                              bloodtestList.map((entry) {
                                            return {
                                              'bloodTestElementId':
                                                  entry['type'].text.isNotEmpty
                                                      ? entry['type'].text
                                                      : null,
                                              'resultValue':
                                                  entry['value'].text.isNotEmpty
                                                      ? entry['value'].text
                                                      : null,
                                            };
                                          }).toList();
                                          if (_formKey.currentState!
                                              .validate()) {
                                            context
                                                .read<PlanFormBloc>()
                                                .add(SubmitFormPlan(
                                                  horseId: widget.horse.id
                                                      .toString(),
                                                  planStartDate:
                                                      startdatecontroller.text,
                                                  planEndDate:
                                                      enddatecontroller.text,
                                                  bodyweight:
                                                      weightcontroller.text,
                                                  walk: walkcontroller.text,
                                                  trot: trotcontroller.text,
                                                  canter: cantercontroller.text,
                                                  gallop: gallopcontroller.text,
                                                  foreShoeTypeId:
                                                      forelimbcontroller
                                                              .toString() ??
                                                          "1",
                                                  foreShoeSpecificationId:
                                                      flsspecification
                                                              .toString() ??
                                                          "!",
                                                  foreShoeComplementId:
                                                      flscontroller
                                                              .toString() ??
                                                          "1",
                                                  hindShoeTypeId:
                                                      hindlimbcontroller
                                                              .toString() ??
                                                          "1",
                                                  hindShoeSpecificationId:
                                                      hlsspecificaition
                                                              .toString() ??
                                                          "1",
                                                  hindShoeComplementId:
                                                      hlscontroller
                                                              .toString() ??
                                                          "1",
                                                  treatments: treatments,
                                                  nutritions: nutritions,
                                                  bloodTest: bloodTests,
                                                  // Ensure the maps are non-nullable by replacing any nullable values with defaults
                                                  // treatments: [
                                                  //   {
                                                  //     'treatmentTypeId':
                                                  //         treatmenttypecontroller ??
                                                  //             "1", // Default value if null
                                                  //     'checkupDate':
                                                  //         checkupdatecontroller
                                                  //                 .text ??
                                                  //             "", // Default value if null
                                                  //   }
                                                  // ],
                                                  // nutritions: [
                                                  //   {
                                                  //     'foodTypeId':
                                                  //         foogtypecontroller ??
                                                  //             "1", // Default value if null
                                                  //     'servingValue': valuecontroller
                                                  //             .text ??
                                                  //         "0", // Default value if null
                                                  //   }
                                                  // ],
                                                  // bloodTest: [
                                                  //   {
                                                  //     'bloodTestElementId':
                                                  //         type1controller ??
                                                  //             "1", // Default value if null
                                                  //     'resultValue': value2controller
                                                  //             .text ??
                                                  //         "0", // Default value if null
                                                  //   }
                                                  // ],
                                                  // treatmentTypeId:
                                                  //     treatmenttypecontroller
                                                  //             .toString() ??
                                                  //         "1",
                                                  // checkupDate:
                                                  //     checkupdatecontroller.text,
                                                  // foodTypeId: foogtypecontroller
                                                  //         .toString() ??
                                                  //     "1",
                                                  // servingvalue:
                                                  //     valuecontroller.text,
                                                  // bloodTestElementId:
                                                  //     type1controller.toString() ??
                                                  //         "1",
                                                  // resultvalue:
                                                  //     value2controller.text,
                                                ));
                                          }
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
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Set Target Date',
                          style: GoogleFonts.karla(
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          // border: Border.all(
                          //   color: Colors.black, // Set border color
                          //   width: 1.0, // Set border width
                          // ),
                          borderRadius: BorderRadius.circular(
                              10.0), // Optional: round the corners
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Color(
                          //         0x40000000), // Shadow color (with transparency)
                          //     offset: Offset(0, 0), // Shadow offset
                          //     blurRadius: 7, // Blur radius
                          //     spreadRadius: 0, // Spread radius
                          //   ),
                          // ],
                        ),
                        child: Card(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(
                                5.0), // Add padding for better spacing
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Start Date Picker
                                CustomDatePickerFormField(
                                  controller: startdatecontroller,
                                  hintText: 'Start Date',
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Choose Date';
                                    }
                                    return null;
                                  },
                                  onDateTap: (BuildContext context) {
                                    _startdate(context, 'start');
                                  },
                                  labelText: 'Start Date',
                                ),
                                CustomDatePickerFormField(
                                  controller: enddatecontroller,
                                  hintText: 'End Date',
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Choose Date';
                                    }
                                    return null;
                                  },
                                  onDateTap: (BuildContext context) {
                                    _enddate(context, 'end');
                                  },
                                  labelText: 'End Date',
                                ),
                                // Row(
                                //   mainAxisAlignment:
                                //       MainAxisAlignment.spaceBetween,
                                //   children: [
                                //     Text(
                                //       'Start Date:',
                                //       style: GoogleFonts.karla(
                                //         textStyle: TextStyle(
                                //           color: Colors.black,
                                //           fontSize: 15,
                                //           fontWeight: FontWeight.w700,
                                //         ),
                                //       ),
                                //     ),
                                //     TextButton(
                                //       onPressed: () async {
                                //         DateTime? selected = await showDatePicker(
                                //           context: context,
                                //           initialDate:
                                //               startDate ?? DateTime.now(),
                                //           firstDate: DateTime(2000),
                                //           lastDate: DateTime(2100),
                                //         );
                                //         if (selected != null) {
                                //           setState(() {
                                //             startDate = selected;
                                //           });
                                //         }
                                //       },
                                //       child: Text(
                                //         startDate == null
                                //             ? 'Select Date'
                                //             : DateFormat('yyyy-MM-dd')
                                //                 .format(startDate!),
                                //         style: TextStyle(color: Colors.black),
                                //       ),
                                //     ),
                                //   ],
                                // ),

                                // End Date Picker
                                // Row(
                                //   mainAxisAlignment:
                                //       MainAxisAlignment.spaceBetween,
                                //   children: [
                                //     Text(
                                //       'End Date:',
                                //       style: GoogleFonts.karla(
                                //         textStyle: TextStyle(
                                //           color: Colors.black,
                                //           fontSize: 15,
                                //           fontWeight: FontWeight.w700,
                                //         ),
                                //       ),
                                //     ),
                                //     TextButton(
                                //       onPressed: () async {
                                //         DateTime? selected = await showDatePicker(
                                //           context: context,
                                //           initialDate: endDate ?? DateTime.now(),
                                //           firstDate: DateTime(2000),
                                //           lastDate: DateTime(2100),
                                //         );
                                //         if (selected != null) {
                                //           setState(() {
                                //             endDate = selected;
                                //           });
                                //         }
                                //       },
                                //       child: Text(
                                //         endDate == null
                                //             ? 'Select Date'
                                //             : DateFormat('yyyy-MM-dd')
                                //                 .format(endDate!),
                                //         style: TextStyle(color: Colors.black),
                                //       ),
                                //     ),
                                //   ],
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xFF0000004D), // Set border color
                            width: 0.0, // Set border width
                          ),
                          borderRadius: BorderRadius.circular(
                              10.0), // Optional: round the corners
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Color(
                          //         0x40000000), // Shadow color (with transparency)
                          //     offset: Offset(0, 0), // Shadow offset
                          //     blurRadius: 7, // Blur radius
                          //     spreadRadius: 0, // Spread radius
                          //   ),
                          // ],
                        ),
                        child: Card(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image.asset('assets/images/Weight.png'),
                                    SizedBox(width: 10, height: 10),
                                    Expanded(
                                      child: Text(
                                        'Body Measurement',
                                        style: TextStyle(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    // TextButton(
                                    //   onPressed: () {},
                                    //   child: Text(
                                    //     'Set Target',
                                    //     style: GoogleFonts.karla(
                                    //       textStyle: TextStyle(
                                    //         color: Color(0xFFC100FF),
                                    //         fontSize: 13,
                                    //         fontWeight: FontWeight.w700,
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Expanded(
                                    //   child: Text(
                                    //     'Weight',
                                    //     style: TextStyle(
                                    //       fontFamily: 'Karla',
                                    //       fontSize:
                                    //           getTextSize15Value(buttonTextSize),
                                    //       color: Colors.black,
                                    //     ),
                                    //   ),
                                    // ),

                                    // Container to control width, height, and styling
                                    Expanded(
                                      child: CustomTextFormField(
                                        hintText: 'Target Weight',
                                        controller: weightcontroller,
                                        labelText: 'Weight',
                                      ),
                                      // CustomTextFormFields(
                                      //   controller: weightcontroller,
                                      //   validator: (value) {
                                      //     if (value!.isEmpty) {
                                      //       return "Enter Target Weight";
                                      //     }
                                      //     return null;
                                      //   },
                                      //   width: 163,
                                      //   height: 29,
                                      //   labelText: 'Weight',
                                      // ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xFF0000004D), // Set border color
                            width: 0.0, // Set border width
                          ),
                          borderRadius: BorderRadius.circular(
                              10.0), // Optional: round the corners
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Color(
                          //         0x40000000), // Shadow color (with transparency)
                          //     offset: Offset(0, 0), // Shadow offset
                          //     blurRadius: 7, // Blur radius
                          //     spreadRadius: 0, // Spread radius
                          //   ),
                          // ],
                        ),
                        child: Card(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image.asset('assets/images/Training.png'),
                                    SizedBox(width: 10, height: 10),
                                    Expanded(
                                      child: Text(
                                        'Training',
                                        style: TextStyle(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    // TextButton(
                                    //   onPressed: () {},
                                    //   child: Text(
                                    //     'Set Target',
                                    //     style: GoogleFonts.karla(
                                    //       textStyle: TextStyle(
                                    //         color: Color(0xFFC100FF),
                                    //         fontSize: 13,
                                    //         fontWeight: FontWeight.w700,
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: CustomTextFormField(
                                        hintText: '',
                                        controller: walkcontroller,
                                        labelText: 'Walk',
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      flex: 1,
                                      child: CustomTextFormField(
                                        hintText: '',
                                        controller: cantercontroller,
                                        labelText: 'Canter',
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: CustomTextFormField(
                                        hintText: '',
                                        controller: trotcontroller,
                                        labelText: 'Trot',
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      flex: 1,
                                      child: CustomTextFormField(
                                        hintText: '',
                                        controller: gallopcontroller,
                                        labelText: 'Gallop',
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xFF0000004D), // Set border color
                            width: 0.0, // Set border width
                          ),
                          borderRadius: BorderRadius.circular(
                              10.0), // Optional: round the corners
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Color(
                          //         0x40000000), // Shadow color (with transparency)
                          //     offset: Offset(0, 0), // Shadow offset
                          //     blurRadius: 7, // Blur radius
                          //     spreadRadius: 0, // Spread radius
                          //   ),
                          // ],
                        ),
                        child: Card(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image.asset('assets/images/Treatment.png'),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        'Treatment',
                                        style: TextStyle(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap:
                                          addNewField, // Add a new set of fields
                                      child: Icon(
                                        Icons.add,
                                        color: Color(0xFFC100FF),
                                        size: 18,
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    GestureDetector(
                                      onTap:
                                          removeField, // Remove the last set of fields
                                      child: Icon(
                                        Icons.remove,
                                        color: Colors.red,
                                        size: 18,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20.0),
                                // Display dynamic fields for each treatment entry
                                Column(
                                  children: treatmentList.map((entry) {
                                    final treatmentTypeController =
                                        entry["treatmentType"];
                                    final checkupDateController =
                                        entry["checkupDate"];

                                    // Ensure controllers exist
                                    if (treatmentTypeController == null ||
                                        checkupDateController == null) {
                                      return SizedBox(); // Skip rendering if controllers are missing
                                    }

                                    return Container(
                                        padding: const EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color:
                                                  Colors.grey, // Border color
                                              width: 1.0, // Border width
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        child: Column(
                                          children: [
                                            // Dropdown for Treatment Type
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  flex: 8,
                                                  child: Container(
                                                    height: 40,
                                                    child:
                                                        DropdownButtonFormField<
                                                            String>(
                                                      value: treatmentTypeController
                                                              .text.isNotEmpty
                                                          ? treatmentTypeController
                                                              .text
                                                          : null,
                                                      onChanged:
                                                          (String? newValue) {
                                                        setState(() {
                                                          treatmentTypeController
                                                                  .text =
                                                              newValue ?? '';
                                                        });
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        labelText:
                                                            'Treatment Type',
                                                        contentPadding:
                                                            EdgeInsets.all(7),
                                                        labelStyle: TextStyle(
                                                          color:
                                                              Color(0xFF8B48DF),
                                                        ),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                          borderSide:
                                                              const BorderSide(
                                                            color: Colors.black,
                                                            width: 2.0,
                                                          ),
                                                        ),
                                                        fillColor:
                                                            Color(0xFFE5E5FC),
                                                        filled: true,
                                                      ),
                                                      items: this
                                                          .treatment
                                                          .map((treatment) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: treatment.id
                                                              .toString(),
                                                          child: Text(
                                                              treatment.name),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 20.0),

                                            // Date Picker for Checkup Date
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child:
                                                      CustomDatePickerFormField(
                                                    controller:
                                                        checkupDateController,
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return "Enter Checkup Date";
                                                      }
                                                      return null;
                                                    },
                                                    onDateTap: (BuildContext
                                                        context) async {
                                                      final picked =
                                                          await showDatePicker(
                                                        context: context,
                                                        initialDate:
                                                            DateTime.now(),
                                                        firstDate:
                                                            DateTime(2000),
                                                        lastDate:
                                                            DateTime(2101),
                                                      );
                                                      if (picked != null) {
                                                        setState(() {
                                                          checkupDateController
                                                              .text = DateFormat(
                                                                  'yyyy-MM-dd')
                                                              .format(picked);
                                                        });
                                                      }
                                                    },
                                                    hintText: 'Checkup Date',
                                                    labelText: 'Checkup Date',
                                                  ),
                                                ),
                                              ],
                                            ),
                                            //SizedBox(height: 20.0),
                                          ],
                                        ));
                                  }).toList(),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xFF0000004D), // Set border color
                            width: 0.0, // Set border width
                          ),
                          borderRadius: BorderRadius.circular(
                              10.0), // Optional: round the corners
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Color(
                          //         0x40000000), // Shadow color (with transparency)
                          //     offset: Offset(0, 0), // Shadow offset
                          //     blurRadius: 7, // Blur radius
                          //     spreadRadius: 0, // Spread radius
                          //   ),
                          // ],
                        ),
                        child: Card(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image.asset('assets/images/Nutrition.png'),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Nutrition',
                                        style: TextStyle(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: addNewNutrtion,
                                      child: Icon(
                                        Icons.add,
                                        color: Color(0xFFC100FF),
                                        size: 18, // Adjust the size as needed
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    GestureDetector(
                                      onTap:
                                          removeNutrition, // Remove the last set of fields
                                      child: Icon(
                                        Icons.remove,
                                        color: Colors.red,
                                        size: 18,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20.0),
                                Column(
                                  children: nutritionList.map((entry) {
                                    final foogtypecontroller =
                                        entry["foodtype"];
                                    final valuecontroller = entry["value"];
                                    final servingDatecontroller =
                                        entry["servingDate"];
                                    // Ensure controllers exist
                                    if (foogtypecontroller == null ||
                                        valuecontroller == null) {
                                      return SizedBox(); // Skip rendering if controllers are missing
                                    }

                                    return Container(
                                        padding: const EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color:
                                                  Colors.grey, // Border color
                                              width: 1.0, // Border width
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  flex: 8,
                                                  child: Container(
                                                    // width: 190, // Set desired width
                                                    height: 40,
                                                    child:
                                                        DropdownButtonFormField<
                                                            String>(
                                                      value: foogtypecontroller
                                                              .text.isNotEmpty
                                                          ? foogtypecontroller
                                                              .text
                                                          : null, // Selected value
                                                      onChanged:
                                                          (String? newValue) {
                                                        setState(() {
                                                          foogtypecontroller
                                                                  .text =
                                                              newValue ?? '';
                                                        });
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        labelText: 'Food Type',
                                                        contentPadding:
                                                            EdgeInsets.all(7),
                                                        labelStyle: TextStyle(
                                                          // fontSize: getTextSize20Value(buttonTextSize),
                                                          fontFamily: 'Karla',
                                                          // fontWeight: FontWeight.w100,
                                                          color:
                                                              Color(0xFF8B48DF),
                                                        ),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                          borderSide:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .black,
                                                                  width: 2.0),
                                                        ),
                                                        fillColor: Color(
                                                            0xFFE5E5FC), // Background color
                                                        filled:
                                                            true, // Enable filling with the color
                                                      ),

                                                      items: this
                                                          .foodtype
                                                          .map((foodtypes) {
                                                        return DropdownMenuItem(
                                                          child: Text(
                                                              foodtypes.name),
                                                          value: foodtypes.id
                                                              .toString(),
                                                        );
                                                      }).toList(),
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return "Please select a food type";
                                                        }
                                                        return null;
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10.0),

                                            // Date Picker for Checkup Date
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child:
                                                      CustomDatePickerFormField(
                                                    controller:
                                                        servingDatecontroller,
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return "Enter Serving Date";
                                                      }
                                                      return null;
                                                    },
                                                    onDateTap: (BuildContext
                                                        context) async {
                                                      final picked =
                                                          await showDatePicker(
                                                        context: context,
                                                        initialDate:
                                                            DateTime.now(),
                                                        firstDate:
                                                            DateTime(2000),
                                                        lastDate:
                                                            DateTime(2101),
                                                      );
                                                      if (picked != null) {
                                                        setState(() {
                                                          servingDatecontroller
                                                              .text = DateFormat(
                                                                  'yyyy-MM-dd')
                                                              .format(picked);
                                                        });
                                                      }
                                                    },
                                                    hintText: 'Serving Date',
                                                    labelText: 'Serving Date',
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10.0),

                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                // Container to control width, height, and styling
                                                Expanded(
                                                  child: CustomTextFormField(
                                                    hintText: '',
                                                    controller: valuecontroller,
                                                    labelText: 'Value',
                                                  ),

                                                  // CustomTextFormFields(
                                                  //   controller: valuecontroller,
                                                  //   validator: (value) {
                                                  //     if (value!.isEmpty) {
                                                  //       return "Enter Horse details";
                                                  //     }
                                                  //     return null;
                                                  //   },
                                                  //   width: 163,
                                                  //   height: 29,
                                                  //   labelText: 'value',
                                                  // ),
                                                ),
                                              ],
                                            ),
                                            //SizedBox(height: 10.0),
                                          ],
                                        ));
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xFF0000004D), // Set border color
                            width: 0.0, // Set border width
                          ),
                          borderRadius: BorderRadius.circular(
                              10.0), // Optional: round the corners
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Color(
                          //         0x40000000), // Shadow color (with transparency)
                          //     offset: Offset(0, 0), // Shadow offset
                          //     blurRadius: 7, // Blur radius
                          //     spreadRadius: 0, // Spread radius
                          //   ),
                          // ],
                        ),
                        child: Card(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image.asset('assets/images/BloodTest.png'),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Blood Test',
                                        style: TextStyle(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: addNewBloodtest,
                                      child: Icon(
                                        Icons.add,
                                        color: Color(0xFFC100FF),
                                        size: 18, // Adjust the size as needed
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    GestureDetector(
                                      onTap:
                                          removeBloodtest, // Remove the last set of fields
                                      child: Icon(
                                        Icons.remove,
                                        color: Colors.red,
                                        size: 18,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10.0),
                                // Row(
                                //   children: [
                                //     Text("blood test length : " + bloodtestList.length.toString())
                                //   ]
                                // ),
                                Column(
                                  children: bloodtestList.map((entry) {
                                    final type1controller = entry["type"];
                                    final value2controller = entry["value"];
                                    final testingdatecontroller =
                                        entry["testDate"];
                                    // Ensure controllers exist
                                    if (type1controller == null ||
                                        value2controller == null ||
                                        testingdatecontroller == null) {
                                      return SizedBox(); // Skip rendering if controllers are missing
                                    }

                                    return Container(
                                        padding: const EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color:
                                                  Colors.grey, // Border color
                                              width: 1.0, // Border width
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                // Container to control width, height, and styling
                                                Expanded(
                                                  // flex: 8,
                                                  child: Container(
                                                    // width: 190, // Set desired width
                                                    height: 40,
                                                    child:
                                                        DropdownButtonFormField<
                                                            String>(
                                                      value: type1controller
                                                              .text.isNotEmpty
                                                          ? type1controller.text
                                                          : null, // Selected value
                                                      onChanged:
                                                          (String? newValue) {
                                                        setState(() {
                                                          type1controller.text =
                                                              newValue!;
                                                        });
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        labelText: ' Type',
                                                        contentPadding:
                                                            EdgeInsets.all(7),
                                                        labelStyle: TextStyle(
                                                          // fontSize: getTextSize20Value(buttonTextSize),
                                                          fontFamily: 'Karla',
                                                          // fontWeight: FontWeight.w100,
                                                          color:
                                                              Color(0xFF8B48DF),
                                                        ),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                          borderSide:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .black,
                                                                  width: 2.0),
                                                        ),
                                                        fillColor: Color(
                                                            0xFFE5E5FC), // Background color
                                                        filled:
                                                            true, // Enable filling with the color
                                                      ),
                                                      items: this
                                                          .bloodtestelement
                                                          .map(
                                                              (bloodtestelement) {
                                                        return DropdownMenuItem(
                                                          child: Text(
                                                              bloodtestelement
                                                                  .name),
                                                          value:
                                                              bloodtestelement
                                                                  .id
                                                                  .toString(),
                                                        );
                                                      }).toList(),
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return "Please select a type";
                                                        }
                                                        return null;
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10.0),
                                            // Date Picker for Checkup Date
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child:
                                                      CustomDatePickerFormField(
                                                    controller:
                                                        testingdatecontroller,
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return "Enter Testing Date";
                                                      }
                                                      return null;
                                                    },
                                                    onDateTap: (BuildContext
                                                        context) async {
                                                      final picked =
                                                          await showDatePicker(
                                                        context: context,
                                                        initialDate:
                                                            DateTime.now(),
                                                        firstDate:
                                                            DateTime(2000),
                                                        lastDate:
                                                            DateTime(2101),
                                                      );
                                                      if (picked != null) {
                                                        setState(() {
                                                          testingdatecontroller
                                                              .text = DateFormat(
                                                                  'yyyy-MM-dd')
                                                              .format(picked);
                                                        });
                                                      }
                                                    },
                                                    hintText: 'Test Date',
                                                    labelText: 'Test Date',
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10.0),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: CustomTextFormField(
                                                    hintText: '',
                                                    controller:
                                                        value2controller,
                                                    labelText: 'Value',
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10.0),
                                          ],
                                        ));
                                  }).toList(),
                                ),
                                //SizedBox(height: 10.0),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xFF0000004D), // Set border color
                            width: 0.0, // Set border width
                          ),
                          borderRadius: BorderRadius.circular(
                              10.0), // Optional: round the corners
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Color(
                          //         0x40000000), // Shadow color (with transparency)
                          //     offset: Offset(0, 0), // Shadow offset
                          //     blurRadius: 7, // Blur radius
                          //     spreadRadius: 0, // Spread radius
                          //   ),
                          // ],
                        ),
                        child: Card(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image.asset('assets/images/Farrier.png'),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Farrier',
                                        style: TextStyle(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    // TextButton(
                                    //   onPressed: () {},
                                    //   child: Text(
                                    //     'Set Target',
                                    //     style: GoogleFonts.karla(
                                    //       textStyle: TextStyle(
                                    //         color: Color(0xFFC100FF),
                                    //         fontSize: 13,
                                    //         fontWeight: FontWeight.w700,
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 8,
                                      child: Container(
                                        // width: 190, // Set desired width
                                        height: 40,
                                        child: DropdownButtonFormField<String>(
                                          value:
                                              forelimbcontroller, // Selected value
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              forelimbcontroller = newValue!;
                                            });
                                          },
                                          decoration: InputDecoration(
                                            labelText: 'Fore Limb Shoe',
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
                                                  color: Colors.black,
                                                  width: 2.0),
                                            ),
                                            fillColor: Color(
                                                0xFFE5E5FC), // Background color
                                            filled:
                                                true, // Enable filling with the color
                                          ),
                                          items: this
                                              .foreShoeType
                                              .map((foreShoeType) {
                                            return DropdownMenuItem(
                                              child: Text(foreShoeType.name),
                                              value: foreShoeType.id.toString(),
                                            );
                                          }).toList(),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Please select a Fore Limb Shoe";
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ),
                                    // Container to control width, height, and styling
                                    // Expanded(
                                    //   child: CustomTextFormFields(
                                    //     controller: forelimbcontroller,
                                    //     validator: (value) {
                                    //       if (value!.isEmpty) {
                                    //         return "Enter Horse details";
                                    //       }
                                    //       return null;
                                    //     },
                                    //     width: 163,
                                    //     height: 29,
                                    //     labelText: 'Fore Limb Shoe',
                                    //   ),
                                    // ),
                                  ],
                                ),
                                SizedBox(height: 10.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 8,
                                      child: Container(
                                        // width: 190, // Set desired width
                                        height: 40,
                                        child: DropdownButtonFormField<String>(
                                          value:
                                              flsspecification, // Selected value
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              flsspecification = newValue!;
                                            });
                                          },
                                          decoration: InputDecoration(
                                            labelText: 'FLS Specification',
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
                                                  color: Colors.black,
                                                  width: 2.0),
                                            ),
                                            fillColor: Color(
                                                0xFFE5E5FC), // Background color
                                            filled:
                                                true, // Enable filling with the color
                                          ),
                                          items: this
                                              .foreShoeSpecf
                                              .map((foreShoeSpecf) {
                                            return DropdownMenuItem(
                                              child: Text(foreShoeSpecf.name),
                                              value:
                                                  foreShoeSpecf.id.toString(),
                                            );
                                          }).toList(),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Please select a FLS Specification";
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ),

                                    // Container to control width, height, and styling
                                    // Expanded(
                                    //   child: CustomTextFormFields(
                                    //     controller: flscontroller,
                                    //     validator: (value) {
                                    //       if (value!.isEmpty) {
                                    //         return "Enter Horse details";
                                    //       }
                                    //       return null;
                                    //     },
                                    //     width: 163,
                                    //     height: 29,
                                    //     labelText: 'FLS compliments',
                                    //   ),
                                    // ),
                                  ],
                                ),
                                SizedBox(height: 10.0),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        flex: 8,
                                        child: Container(
                                          // width: 190, // Set desired width
                                          height: 40,
                                          child:
                                              DropdownButtonFormField<String>(
                                            value:
                                                flscontroller, // Selected value
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                flscontroller = newValue!;
                                              });
                                            },
                                            decoration: InputDecoration(
                                              labelText: 'FLS Compliments',
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
                                                    color: Colors.black,
                                                    width: 2.0),
                                              ),
                                              fillColor: Color(
                                                  0xFFE5E5FC), // Background color
                                              filled:
                                                  true, // Enable filling with the color
                                            ),
                                            items: this
                                                .foreShoeComp
                                                .map((foreShoeComp) {
                                              return DropdownMenuItem(
                                                child: Text(foreShoeComp.name),
                                                value:
                                                    foreShoeComp.id.toString(),
                                              );
                                            }).toList(),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "Please select a FLS Compliments";
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                    ]),
                                SizedBox(height: 10.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Expanded(
                                    //   child: Text(
                                    //     'Hind Limb Shoe',
                                    //     style: TextStyle(
                                    //       fontFamily: 'Karla',
                                    //       fontSize:
                                    //           getTextSize15Value(buttonTextSize),
                                    //       color: Colors.black,
                                    //     ),
                                    //   ),
                                    // ),
                                    Expanded(
                                      flex: 8,
                                      child: Container(
                                        // width: 190, // Set desired width
                                        height: 40,
                                        child: DropdownButtonFormField(
                                          value:
                                              hindlimbcontroller, // Selected value
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              hindlimbcontroller = newValue!;
                                            });
                                          },
                                          decoration: InputDecoration(
                                            labelText: 'Hind Limb Shoe',
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
                                                  color: Colors.black,
                                                  width: 2.0),
                                            ),
                                            fillColor: Color(
                                                0xFFE5E5FC), // Background color
                                            filled:
                                                true, // Enable filling with the color
                                          ),
                                          items: this
                                              .hindShoeType
                                              .map((hindShoeType) {
                                            return DropdownMenuItem(
                                              child: Text(hindShoeType.name),
                                              value: hindShoeType.id.toString(),
                                            );
                                          }).toList(),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Please select a Hind Limb Shoe";
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ),
                                    // Container to control width, height, and styling
                                    // Expanded(
                                    //   child: CustomTextFormFields(
                                    //     controller: hindlimbcontroller,
                                    //     validator: (value) {
                                    //       if (value!.isEmpty) {
                                    //         return "Enter Horse details";
                                    //       }
                                    //       return null;
                                    //     },
                                    //     width: 163,
                                    //     height: 29,
                                    //     labelText: 'Hind Limb Shoe',
                                    //   ),
                                    // ),
                                  ],
                                ),
                                SizedBox(height: 10.0),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        flex: 8,
                                        child: Container(
                                          // width: 190, // Set desired width
                                          height: 40,
                                          child: DropdownButtonFormField(
                                            value:
                                                hlsspecificaition, // Selected value
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                hlsspecificaition = newValue!;
                                              });
                                            },
                                            decoration: InputDecoration(
                                              labelText: 'HLS Specification',
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
                                                    color: Colors.black,
                                                    width: 2.0),
                                              ),
                                              fillColor: Color(
                                                  0xFFE5E5FC), // Background color
                                              filled:
                                                  true, // Enable filling with the color
                                            ),
                                            items: this
                                                .hindShoeSpecf
                                                .map((hindShoeSpecf) {
                                              return DropdownMenuItem(
                                                child: Text(hindShoeSpecf.name),
                                                value:
                                                    hindShoeSpecf.id.toString(),
                                              );
                                            }).toList(),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "Please select a HLS Specification";
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                    ]),
                                SizedBox(height: 10.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Expanded(
                                    //   child: Text(
                                    //     'HLS compliments',
                                    //     style: TextStyle(
                                    //       fontFamily: 'Karla',
                                    //       fontSize:
                                    //           getTextSize15Value(buttonTextSize),
                                    //       color: Colors.black,
                                    //     ),
                                    //   ),
                                    // ),

                                    Expanded(
                                      flex: 8,
                                      child: Container(
                                        // width: 190, // Set desired width
                                        height: 40,
                                        child: DropdownButtonFormField<String>(
                                          value:
                                              hlscontroller, // Selected value
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              hlscontroller = newValue!;
                                            });
                                          },
                                          decoration: InputDecoration(
                                            labelText: 'HLS Compliments',
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
                                                  color: Colors.black,
                                                  width: 2.0),
                                            ),
                                            fillColor: Color(
                                                0xFFE5E5FC), // Background color
                                            filled:
                                                true, // Enable filling with the color
                                          ),
                                          items: this
                                              .hindShoeComp
                                              .map((hindShoeComp) {
                                            return DropdownMenuItem(
                                              child: Text(hindShoeComp.name),
                                              value: hindShoeComp.id.toString(),
                                            );
                                          }).toList(),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Please select a HLS Compliments";
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ),
                                    // Container to control width, height, and styling
                                    // Expanded(
                                    //   child: CustomTextFormFields(
                                    //     controller: hlscontroller,
                                    //     validator: (value) {
                                    //       if (value!.isEmpty) {
                                    //         return "Enter Horse details";
                                    //       }
                                    //       return null;
                                    //     },
                                    //     width: 163,
                                    //     height: 29,
                                    //     labelText: 'HLS compliments',
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ))),
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
}
