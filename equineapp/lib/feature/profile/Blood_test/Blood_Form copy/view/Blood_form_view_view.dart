import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../../data/models/bloodtest_element.dart';
import '../../../../../data/models/bloodtest_type.dart';
import '../../../../../data/models/horse_model.dart';
import '../../../../../utils/constants/appreance_definition.dart';
import '../../../../common/widgets/navigation_widget.dart';
import '../../../../header/app_bar.dart';
import '../../../../nav_bar/nav_bar.dart';
import '../bloc/blood_form_view_bloc.dart';

class BloodFormView extends StatefulWidget {
  final HorseModel horse;
  final String testDate;

  const BloodFormView({
    super.key,
    required this.horse,
    required this.testDate,
  });

  @override
  State<BloodFormView> createState() => _BloodFormViewState();
}

class _BloodFormViewState extends State<BloodFormView> {
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
  // List<BloodTestElement> hematologyTests = [];
  final _dateOfBirthController = TextEditingController();

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
    context.read<BloodFormViewBloc>().add(LoadBloodFormView(
        horseId: widget.horse.id.toString(), testDate: widget.testDate));
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
    return BlocConsumer<BloodFormViewBloc, BloodFormViewState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: CustomAppBar(),
          endDrawer: NavigitionWidget(),
          body: state is BloodFormViewLoading
              ? Center(
                  child: CircularProgressIndicator(), // Show loading spinner
                )
              : state is BloodFormViewLoaded
                  ? SingleChildScrollView(
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
                                          IconButton(
                                            icon: Icon(Icons.download,
                                                color: Colors.green),
                                            onPressed: () {
                                              // Implement the download action
                                            },
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
                            buildListWithTitle(
                              widget.testDate,
                              'Date Of Test',
                            ),
                            buildListWithTitle(
                              state.bloodTestType,
                              'Test Purpose',
                            ),
                            SizedBox(height: 20.0),
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
                            // Display Blood Test Data
                            buildBloodTestTable(
                                state.bioChemistryTests), // Add the table here
                            Text(
                              'Hematology',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            buildBloodTesthemotaology(state.hematologyTests),
                          ],
                        ),
                      ),
                    )
                  : null,
          bottomNavigationBar: NavBar(
            pageIndex: selectedTab,
          ),
        );
      },
    );
  }

  Widget buildBloodTestTable(List<BloodTestElement> bloodTestElements) {
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
        for (var element in bloodTestElements)
          TableRow(
            children: [
              tableCell(element.name),
              tableCell(element.unit),
              tableCell(element.normalRange),
              tableCell(element.resultValue?.toString() ?? '0'),
            ],
          ),
      ],
    );
  }

  Widget buildBloodTesthemotaology(List<BloodTestElement> bloodTestElements) {
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
        for (var element in bloodTestElements)
          TableRow(
            children: [
              tableCell(element.name),
              tableCell(element.unit),
              tableCell(element.normalRange),
              tableCell(element.resultValue?.toString() ?? '0'),
            ],
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
