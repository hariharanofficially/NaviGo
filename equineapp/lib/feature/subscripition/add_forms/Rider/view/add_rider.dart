import 'dart:io';
import 'dart:typed_data';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/services.dart';
import 'package:EquineApp/feature/subscripition/add_forms/Event/bloc/AddEvent_state.dart';
import 'package:EquineApp/feature/subscripition/add_forms/Rider/bloc/AddRiderBloc.dart';
import 'package:EquineApp/feature/subscripition/add_forms/Rider/bloc/AddRiderEvent.dart';
import 'package:EquineApp/feature/subscripition/add_forms/Rider/bloc/AddRiderState.dart';
import 'package:EquineApp/feature/common/FormCustomWidget/textform_field.dart';
import 'package:EquineApp/utils/constants/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:intl/intl.dart';

import '../../../../../data/models/Horsegender.dart';
import '../../../../../data/models/country.dart';
import '../../../../../data/models/division.dart';
import '../../../../../data/models/rider_model.dart';
import '../../../../../data/models/stable_model.dart';
import '../../../../../data/repo/repo.dart';
import '../../../../common/FormCustomWidget/datepickerform.dart';
import '../../../../common/FormCustomWidget/dropdownform.dart';
import '../../../../common/widgets/ProfileImage.dart';
import '../../../manage_dashboard/cards/riders_dashboard/bloc/riders_dashboard_bloc.dart';
import '../../../manage_dashboard/cards/riders_dashboard/view/riders_dashboard_view.dart';

class AddRiderScreen extends StatelessWidget {
  final int? riderId; // Optional parameter to edit an existing horse

  const AddRiderScreen({Key? key, this.riderId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddRiderBloc(),
      child: AddRiderForm(riderId: riderId),
    );
  }
}

class AddRiderForm extends StatefulWidget {
  final int? riderId; // Optional parameter to edit an existing horse

  const AddRiderForm({Key? key, this.riderId}) : super(key: key);
  @override
  _AddRiderFormState createState() => _AddRiderFormState();
}

class _AddRiderFormState extends State<AddRiderForm>
    with SingleTickerProviderStateMixin {
  final _addriderformKey = GlobalKey<FormState>();
  final TextEditingController startdateval = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _fathersNameController = TextEditingController();
  // final TextEditingController _nationalityController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _bloodgroupController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _divisionController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();
  final TextEditingController _riderWeightController = TextEditingController();
  final TextEditingController _feiexpirydatecontroller =
      TextEditingController();
  final TextEditingController _feinocontroller = TextEditingController();
  final TextEditingController _stablenamecontroller = TextEditingController();
  bool _isSecondPartVisible = false;
  bool _isActive = false;
  bool isPassword(String input) =>
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~.]).{8,}$')
          .hasMatch(input);
  bool _isLoading = false;
  bool _passwordvisible = true;
  String _userName = '';
  String _userEmail = '';
  String _password = '';
  String? _phoneNumber = '';
  String verificationID = "";
  bool isMatched = false;
  bool isPhno = false;
  bool isUser = false;
  String apiError = '';
  String? _selecteddivision;
  String? _selectedhorsegender;
  String? _selectedstable;
  String? _selectedbirth;
  RiderModel? riderName; // Change to nullable type
  List<StableModel> stables = [];
  List<Horsegender> horsegender = []; // Correct type
  List<Division> division = [];
  List<country> birthcountry = [];

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

  void _trySubmitForm(BuildContext context) {
    if (_addriderformKey.currentState!.validate() == true) {
      final String name = _nameController.text;
      final String fathersName = _fathersNameController.text;
      // final String nationality = _nationalityController.text;
      final String dateOfBirth = _dateOfBirthController.text;
      final String bloodGroup = _bloodgroupController.text;
      final String mobile = _mobileController.text;
      final String email = _emailController.text;
      final String remarks = _remarksController.text;
      final String riderWeight = _riderWeightController.text;

      context.read<AddRiderBloc>().add(SubmitRiderForm(
            id: widget.riderId,
            name: name,
            fathersName: fathersName,
            nationality: _selectedbirth ?? "",
            dateOfBirth: dateOfBirth,
            bloodGroup: bloodGroup,
            mobile: mobile,
            email: email,
            division: _selecteddivision ?? "1",
            remarks: remarks,
            riderWeight: riderWeight,
            stablename: _selectedstable ?? "1",
            active: _isActive.toString() ?? "true",
          ));
      // context
      //     .read<AddRiderBloc>()
      //     .add(UploadRiderImage(isEdit: widget.riderId != null));
    }
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  bool isEmail(String input) => (RegExp(r'\S+@\S+\.\S+').hasMatch(input));
  bool isapierr = false;

  bool isPhone(String input) =>
      RegExp(r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$')
          .hasMatch(input);
  int tabIndex = 0;

  @override
  void initState() {
    super.initState();

    if (widget.riderId != null) {
      context
          .read<AddRiderBloc>()
          .add(LoadriderDetails(riderId: widget.riderId!));
    } else {
      context.read<AddRiderBloc>().add(Loadfetchrider());
    }
  }

  @override
  void dispose() {
    FocusManager.instance.primaryFocus?.unfocus();
    super.dispose();
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
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Row(
          children: [
            SizedBox(width: 80),
            Text(
              widget.riderId != null ? 'Edit Rider' : 'Add Rider',
              // 'Add Rider',
              style: GoogleFonts.karla(
                textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
      body: BlocConsumer<AddRiderBloc, AddRiderState>(
        listener: (BuildContext context, AddRiderState state) {
          if (state is AddRiderSuccess) {
            String message = widget.riderId != null
                ? 'Rider Updated Successfully'
                : 'Rider Added Successfully';

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BlocProvider(
                        create: (context) => RidersBloc(),
                        child: RidersDashboard())));
          }
          // if (state is RiderImageUploadedSuccessfully) {
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(content: Text('RiderImageUploadedSuccessfully')),
          //   );
          // } else if (state is RiderImageUploadFailure) {
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(content: Text('RiderImageUploadFailure')),
          //   );
          // }
          if (state is RiderLoaded) {
            print('Dropdown Items: ${state.allFormModel.rider}');
            stables = state.allFormModel.stable;
            horsegender = state.allFormModel.horsegender; // Correct type
            division = state.allFormModel.division;
            birthcountry = state.allFormModel.birthcountry;
            if (widget.riderId != null) {
              final rider = state.allFormModel?.riderDetail;
              _nameController.text = rider!.name;
              _fathersNameController.text = rider.fatherName;
              _dateOfBirthController.text = RiderModel.formatDateOfBirth(rider.dateOfBirth);
              _bloodgroupController.text = rider.bloodGroup;
              _mobileController.text = rider.mobile;
              _emailController.text = rider.email;
              _remarksController.text = rider.remarks;
              _riderWeightController.text = rider.riderWeight;
              riderName = state.allFormModel.riderDetail;
              setState(() {
                _selectedstable = rider.stableId.toString();
                _selectedbirth = rider.nationalityId.toString();
                _selecteddivision = rider.divisionId.toString();
                _isActive = rider.isActive!;
              });
            }
          }
        },
        builder: (BuildContext context, AddRiderState state) {
          if (state is RiderLoading) {
            return Center(child: (CircularProgressIndicator()));
          }
          return SingleChildScrollView(
            reverse: true,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 35.0, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  if (riderName != null) // Ensure stableName is not null
                    Stack(children: [
                      Container(
                        child: Center(
                          child: GestureDetector(
                            onTap: () {
                              if (state is riderImage &&
                                  state.pickedImage != null) {
                                _showZoomableImage(context, state.pickedImage);
                              }
                            },
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor:
                                  Color.fromRGBO(139, 72, 223, 0.1),
                              backgroundImage: state is riderImage &&
                                      state.pickedImage != null
                                  ? FileImage(state.pickedImage!)
                                  : null,
                              child: state is! riderImage
                                  ? ProfileImage(
                                      recordId: riderName!.id.toString(),
                                      tableName: "Rider",
                                      displayPane: "profileImgs",
                                    )
                                  : null,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 75,
                        left: 180,
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.white,
                          child: IconButton(
                            icon: Icon(Icons.camera_alt, size: 20),
                            onPressed: () {
                              context.read<AddRiderBloc>().add(PickImage());
                            },
                          ),
                        ),
                      ),
                    ]),
                  if (riderName == null)
                    Stack(
                      children: [
                        Container(
                            child: Center(
                                child: GestureDetector(
                          onTap: () {
                            if (state is riderImage &&
                                state.pickedImage != null) {
                              _showZoomableImage(context, state.pickedImage);
                            }
                          },
                          child: CircleAvatar(
                            radius: 70,
                            backgroundColor: Color.fromRGBO(139, 72, 223, 0.1),
                            backgroundImage:
                                state is riderImage && state.pickedImage != null
                                    ? FileImage(state.pickedImage!)
                                    : null,
                            child: state is! riderImage
                                ? Image.asset('assets/images/Horse_riding.png',
                                    height: 120)
                                : null,
                          ),
                        ))),
                        Positioned(
                          top: 100,
                          left: 200,
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.white,
                            child: IconButton(
                              icon: Icon(Icons.camera_alt, size: 20),
                              onPressed: () {
                                context.read<AddRiderBloc>().add(PickImage());
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 20),
                  Text(
                    'Required Information',
                    style: GoogleFonts.karla(
                      textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Form(
                    key: _addriderformKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextFormField(
                          hintText: 'Name',
                          controller: _nameController,
                          labelText: 'Name',
                          validate: true,
                        ),
                        // const SizedBox(height: 10),
                        CustomDropdownButtonFormField(
                          hint: 'Stable Name',
                          selectedValue: _selectedstable,
                          items:
                              stables, // List of gender objects with id and name fields
                          onChanged: (String? value) {
                            setState(() {
                              _selectedstable = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a value';
                            }
                            return null; // Validation passed
                          },
                          labelText: 'Stable Name',
                        ),
                        // DropdownButtonFormField<String>(
                        //   hint: Text('Stable Name'),
                        //   value: _selectedstable,
                        //   icon: Icon(Icons.keyboard_arrow_down),
                        //   items: this.stables.map((stables) {
                        //     return DropdownMenuItem(
                        //       child: Text(stables.name),
                        //       value: stables.id.toString(),
                        //     );
                        //   }).toList(),
                        //   onChanged: (String? value) {
                        //     setState(() {
                        //       _selectedstable = value;
                        //     });
                        //   },
                        //   validator: (value) {
                        //     if (value == null) {
                        //       return 'Please select a Stable Name';
                        //     }
                        //     return null;
                        //   },
                        // ),
                        // const SizedBox(height: 10),
// Inside your widget
                        DropdownSearch<String>(
                          items:
                              birthcountry.map((birth) => birth.name).toList(),
                          selectedItem: _selectedbirth != null
                              ? birthcountry
                                  .firstWhere(
                                    (birth) =>
                                        birth.id.toString() == _selectedbirth,
                                    orElse: () => birthcountry
                                        .first, // Provide a default value
                                  )
                                  .name
                              : null,
                          dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                              labelText: 'Nationality Name',
                              hintText: 'Nationality Name',
                              labelStyle: TextStyle(
                                fontFamily: 'Karla',
                                color: Color(0xFF8B48DF),
                              ),
                              contentPadding: EdgeInsets.all(5),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                borderSide: BorderSide(color: Colors.black),
                              ),
                            ),
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedbirth = birthcountry
                                  .firstWhere(
                                    (birth) => birth.name == newValue,
                                    orElse: () => birthcountry.first,
                                  )
                                  ?.id
                                  ?.toString();
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a value';
                            }
                            return null; // Validation passed
                          },
                          popupProps: PopupProps.menu(
                            showSearchBox: true,
                            searchFieldProps: TextFieldProps(
                              decoration: InputDecoration(
                                labelText: 'Search',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ),

                        // DropdownButtonFormField<String>(
                        //   value: _selectedbirth,
                        //   icon: Icon(Icons.keyboard_arrow_down),
                        //   items: this.birthcountry.map((birth) {
                        //     return DropdownMenuItem<String>(
                        //       value: birth.id.toString(),
                        //       child: Text(birth.name),
                        //     );
                        //   }).toList(),
                        //   onChanged: (String? value) {
                        //     setState(() {
                        //       _selectedbirth = value;
                        //     });
                        //   },
                        //   decoration: InputDecoration(
                        //     labelText: 'Nationality Name',
                        //     hintText: 'Nationality Name',
                        //     labelStyle: TextStyle(
                        //         fontFamily: 'Karla', color: Color(0xFF8B48DF)),
                        //     contentPadding: EdgeInsets.all(5),
                        //     border: OutlineInputBorder(
                        //       borderRadius: BorderRadius.all(
                        //         Radius.circular(10),
                        //       ),
                        //       borderSide: BorderSide(color: Colors.black),
                        //     ),
                        //   ),
                        // ),
                        const SizedBox(
                          height: 10,
                        ),
                        // CustomTextFormField(
                        //     hintText: 'Nationality ID',
                        //     controller: _nationalityController),
                        CustomDropdownButtonFormField(
                          hint: 'Division Name',
                          selectedValue: _selecteddivision,
                          items:
                              division, // List of gender objects with id and name fields
                          onChanged: (String? value) {
                            setState(() {
                              _selecteddivision = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a value';
                            }
                            return null; // Validation passed
                          },
                          labelText: 'Division Name',
                        ),
                        // DropdownButtonFormField<String>(
                        //   hint: Text('Division Name'),
                        //   value: _selecteddivision,
                        //   icon: Icon(Icons.keyboard_arrow_down),
                        //   items: this.division.map((divisions) {
                        //     return DropdownMenuItem<String>(
                        //       value: divisions.id.toString(),
                        //       child: Text(divisions.name),
                        //     );
                        //   }).toList(),
                        //   onChanged: (String? value) {
                        //     setState(() {
                        //       _selecteddivision = value;
                        //     });
                        //   },
                        // ),
                        // CustomTextFormField(
                        //     hintText: 'Division ID',
                        //     controller: _divisionController),
                        SwitchListTile(
                          title: Text('Active'),
                          value: _isActive,
                          onChanged: (bool value) {
                            setState(() {
                              _isActive = value;
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        if (_isSecondPartVisible) ...[
                          Divider(
                            color: Colors.grey,
                            thickness: 1,
                          ),
                          const SizedBox(height: 10),
                          RichText(
                            text: TextSpan(
                              text: 'Not Mandatory ', // First part
                              style: GoogleFonts.karla(
                                textStyle: TextStyle(
                                  color: Colors
                                      .red, // Give this part a different color
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              children: [
                                TextSpan(
                                  text: '(Optional)', // Second part
                                  style: GoogleFonts.karla(
                                    textStyle: TextStyle(
                                      color: Colors
                                          .black, // Default color for this part
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          CustomTextFormField(
                            hintText: 'Father Name',
                            controller: _fathersNameController,
                            labelText: 'Father Name',
                          ),
                          // TextFormField(
                          //   keyboardType: TextInputType
                          //       .phone, // Prevents keyboard from showing
                          //   controller: _dateOfBirthController,
                          //   readOnly: true, // Makes the TextFormField read-only
                          //   onTap: () {
                          //     _selectDate(context, 'start');
                          //     FocusScope.of(context).requestFocus(FocusNode());
                          //   },
                          //   validator: (value) {
                          //     if (value == null || value.isEmpty) {
                          //       return 'Choose Date';
                          //     }
                          //     return null; // Return null if validation is successful
                          //   },
                          //   decoration: InputDecoration(
                          //     suffixIcon: IconButton(
                          //       icon: const Icon(
                          //         Icons.calendar_today,
                          //         color: Colors.black45,
                          //       ),
                          //       onPressed: () {
                          //         _selectDate(context, 'start');
                          //         FocusScope.of(context)
                          //             .requestFocus(FocusNode());
                          //       },
                          //     ),
                          //     hintText: 'Date of Birth',
                          //   ),
                          // ),
                          CustomDatePickerFormField(
                            controller: _dateOfBirthController,
                            hintText: 'Date of Birth',
                            // validator: (value) {
                            //   if (value == null || value.isEmpty) {
                            //     return 'Choose Date';
                            //   }
                            //   return null;
                            // },
                            onDateTap: (BuildContext context) {
                              _selectDate(context, 'start');
                            },
                            labelText: 'Date of Birth',
                          ),
                          // TextFormField(
                          //   keyboardType: TextInputType.phone,
                          //   autocorrect: false,
                          //   controller: _feiexpirydatecontroller,
                          //   onSaved: (value) {
                          //     startdateval.text = DateFormat('dd-MM-yyyy')
                          //         .format(DateTime.parse(value!));
                          //   },
                          //   onTap: () {
                          //     _selectDate(context, 'start');
                          //     FocusScope.of(context)
                          //         .requestFocus(new FocusNode());
                          //   },
                          //   maxLines: 1,
                          //   validator: (value) {
                          //     if (value!.isEmpty || value!.length < 1) {
                          //       return 'Choose Date';
                          //     }
                          //   },
                          //   decoration: InputDecoration(
                          //     suffixIcon: IconButton(
                          //       icon: const Icon(
                          //         Icons.calendar_today,
                          //         color: Colors.black45,
                          //       ),
                          //       onPressed: () {
                          //         _selectDate(context, 'start');
                          //         FocusScope.of(context)
                          //             .requestFocus(new FocusNode());
                          //       },
                          //     ),
                          //     hintText: 'feiexpirydate',
                          //   ),
                          // ),
                          // CustomTextFormField(
                          //     hintText: 'feino', controller: _feinocontroller),
                          // CustomTextFormField(
                          //     hintText: 'stablename',
                          //     controller: _stablenamecontroller),
                          //       DropdownButtonFormField<String>(
                          //   hint: Text('Breed Name'),
                          //   value: _selectedhorsegender,
                          //   icon: Icon(Icons.keyboard_arrow_down),
                          //   items: (state is RiderLoaded)
                          //       ? state.allFormModel.horsegender.map((horsegenders) {
                          //           return DropdownMenuItem<String>(
                          //             value: horsegenders.id.toString(),
                          //             child: Text(horsegenders.name),
                          //           );
                          //         }).toList()
                          //       : [],
                          //   onChanged: (String? value) {
                          //     setState(() {
                          //       _selectedhorsegender = value;
                          //     });
                          //   },
                          // ),
                          // CustomTextFormField(
                          //     hintText: 'Gender ID',
                          //     controller: _genderController),
                          CustomTextFormField(
                            hintText: 'Blood Group',
                            controller: _bloodgroupController,
                            labelText: 'Blood Group',
                          ),
                          CustomTextFormField(
                            hintText: 'Address',
                            controller: _addressController,
                            labelText: 'Address',
                          ),
                          CustomTextFormField(
                            hintText: 'Mobile',
                            controller: _mobileController,
                            labelText: 'Mobile',
                          ),
                          CustomTextFormField(
                            hintText: 'Email',
                            controller: _emailController,
                            labelText: 'Email',
                          ),
                          CustomTextFormField(
                            hintText: 'Remarks',
                            controller: _remarksController,
                            labelText: 'Remarks',
                          ),
                          // CustomTextFormField(
                          //   hintText: 'Rider Weight',
                          //   controller: _riderWeightController,
                          //   labelText: 'Rider Weight',
                          // ),
                          TextFormField(
                            controller: _riderWeightController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            style: const TextStyle(fontSize: 16),
                            decoration: InputDecoration(
                              labelText: 'Rider Weight',
                              labelStyle: TextStyle(
                                  fontFamily: 'Karla',
                                  color: Color(0xFF8B48DF)),
                              contentPadding: EdgeInsets.all(5),
                              hintText: 'Rider Weight',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                borderSide: BorderSide(color: Colors.black),
                              ),
                            ),
                            // validator: (value) {
                            //   if (value == true) {
                            //     if (value == null || value.trim().isEmpty) {
                            //       return 'This field is required';
                            //     }
                            //   }

                            //   // Return null if the entered password is valid
                            //   return null;
                            // },
                            //onChanged: (value) => _password = value,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _isSecondPartVisible = !_isSecondPartVisible;
                        });
                      },
                      icon: Icon(_isSecondPartVisible
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down),
                      label: Text(
                          _isSecondPartVisible ? 'Show Less' : 'Show More'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(139, 72, 223, 1),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom)),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        child: BottomAppBar(
          color: Color.fromRGBO(139, 72, 223, 1),
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              color: Color.fromRGBO(139, 72, 223, 1),
            ),
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  _trySubmitForm(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
                child: BlocConsumer<AddRiderBloc, AddRiderState>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      if (state is AddRiderLoading) {
                        return CircularProgressIndicator(
                          color: Colors.blue,
                        );
                      }
                      return Text(
                        widget.riderId != null ? 'Update Rider' : 'Add Rider',
                        // 'Add Rider',
                        style: GoogleFonts.karla(
                          textStyle: TextStyle(
                              color: Color.fromRGBO(33, 150, 243, 1),
                              fontSize: 15,
                              fontWeight: FontWeight.w400),
                        ),
                      );
                    }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// class ProfileWidget extends StatelessWidget {
//   final RiderModel stable;
//   const ProfileWidget({required this.stable});

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//         child: Scaffold(
//             //     appBar: AppBar(
//             //     //title: Text('Future Demo Page'),
//             // ),
//             body: FutureBuilder<Uint8List>(
//       future: uploadsRepo.getProfileImage(
//           recordId: stable.id.toString(),
//           tableName: "Rider",
//           displayPane: "profileImgs"),
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           return CircleAvatar(
//             radius: 50,
//             backgroundImage: MemoryImage(snapshot.data!),
//           );
//         } else if (snapshot.hasError) {
//           //return Text('Error fetching image');
//           return CircleAvatar(
//             radius: 50,
//           );
//         }
//         return CircularProgressIndicator(); // Show a loading indicator
//       },
//     )));
//   }
// }
