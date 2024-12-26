import 'dart:io';

import 'package:EquineApp/feature/subscripition/add_forms/Trainer/bloc/AddTrainerBloc.dart';
import 'package:EquineApp/feature/subscripition/add_forms/Trainer/bloc/AddTrainerEvent.dart';
import 'package:EquineApp/feature/subscripition/add_forms/Trainer/bloc/AddTrainerState.dart';
import 'package:EquineApp/feature/common/FormCustomWidget/textform_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../../data/models/Horsegender.dart';
import '../../../../../data/models/country.dart';
import '../../../../../data/models/division.dart';
import '../../../../../data/models/stable_model.dart';
import '../../../../../data/models/trainermodel.dart';
import '../../../../common/FormCustomWidget/datepickerform.dart';
import '../../../../common/FormCustomWidget/dropdownform.dart';
import '../../../../common/widgets/ProfileImage.dart';
import '../../../manage_dashboard/cards/trainer_dashboard/bloc/trainer_dashboard_bloc.dart';
import '../../../manage_dashboard/cards/trainer_dashboard/view/trainer_dashboard_view.dart';

class AddTrainerScreen extends StatelessWidget {
  final int? TrainerId; // Optional parameter to edit an existing horse

  const AddTrainerScreen({Key? key, this.TrainerId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddTrainerBloc(),
      child: AddTrainerForm(TrainerId: TrainerId),
    );
  }
}

class AddTrainerForm extends StatefulWidget {
  final int? TrainerId; // Optional parameter to edit an existing horse

  const AddTrainerForm({Key? key, this.TrainerId}) : super(key: key);
  @override
  _AddTrainerFormState createState() => _AddTrainerFormState();
}

class _AddTrainerFormState extends State<AddTrainerForm>
    with SingleTickerProviderStateMixin {
  final _addTrainerformKey = GlobalKey<FormState>();
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
  final TextEditingController _TrainerWeightController =
      TextEditingController();
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
  TrainerModel? TrainerName; // Change to nullable type
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
    if (_addTrainerformKey.currentState!.validate() == true) {
      final String name = _nameController.text;
      final String fathersName = _fathersNameController.text;
      // final String nationality = _nationalityController.text;
      final String dateOfBirth = _dateOfBirthController.text;
      final String bloodGroup = _bloodgroupController.text;
      final String mobile = _mobileController.text;
      final String email = _emailController.text;
      final String remarks = _remarksController.text;
      final String TrainerWeight = _TrainerWeightController.text;
      final String address = _addressController.text;
      context.read<AddTrainerBloc>().add(SubmitTrainerForm(
            id: widget.TrainerId,
            name: name,
            fathersName: fathersName,
            nationality: _selectedbirth ?? "",
            dateOfBirth: dateOfBirth,
            bloodGroup: bloodGroup,
            mobile: mobile,
            email: email,
            division: _selecteddivision ?? "1",
            remarks: remarks,
            riderWeight: TrainerWeight,
            stablename: _selectedstable ?? "1",
            active: _isActive.toString() ?? "true",
            address: address,
          ));
      // context
      //     .read<AddTrainerBloc>()
      //     .add(UploadTrainerImage(isEdit: widget.TrainerId != null));
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

    if (widget.TrainerId != null) {
      context
          .read<AddTrainerBloc>()
          .add(LoadTrainerDetails(riderId: widget.TrainerId!));
    } else {
      context.read<AddTrainerBloc>().add(LoadfetchTrainer());
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
              widget.TrainerId != null ? 'Edit Trainer' : 'Add Trainer',
              // 'Add Trainer',
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
      body: BlocConsumer<AddTrainerBloc, AddTrainerState>(
        listener: (BuildContext context, AddTrainerState state) {
          if (state is AddTrainerSuccess) {
            String message = widget.TrainerId != null
                ? 'Trainer Updated Successfully'
                : 'Trainer Added Successfully';

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BlocProvider(
                        create: (context) => TrainersBloc(),
                        child: TrainersDashboard())));
          }
          // if (state is TrainerImageUploadedSuccessfully) {
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(content: Text('TrainerImageUploadedSuccessfully')),
          //   );
          // } else if (state is TrainerImageUploadFailure) {
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(content: Text('TrainerImageUploadFailure')),
          //   );
          // }
          if (state is TrainerLoaded) {
            print('TrainerLoaded State Received');
            print('Dropdown Items: ${state.allFormModel.trainerDetail}');
            print('Stable List: ${state.allFormModel.stable}');
            print('Horse Gender List: ${state.allFormModel.horsegender}');
            print('Division List: ${state.allFormModel.division}');
            print('Birth Country List: ${state.allFormModel.birthcountry}');

            stables = state.allFormModel.stable;
            horsegender = state.allFormModel.horsegender;
            division = state.allFormModel.division;
            birthcountry = state.allFormModel.birthcountry;

            if (widget.TrainerId != null) {
              print('Editing Trainer with ID: ${widget.TrainerId}');
              final Trainer = state.allFormModel.trainerDetail;

              if (Trainer != null) {
                print('Trainer Details: $Trainer');
                _nameController.text = Trainer.name;
                _fathersNameController.text = Trainer.fatherName;
                _dateOfBirthController.text =
                    TrainerModel.formatDateOfBirth(Trainer.dateOfBirth);
                _bloodgroupController.text = Trainer.bloodGroup;
                _mobileController.text = Trainer.mobile;
                _emailController.text = Trainer.email;
                _remarksController.text = Trainer.remarks;
                _TrainerWeightController.text = Trainer.riderWeight;
                TrainerName = state.allFormModel.trainerDetail;
                _addressController.text = Trainer.address1;
                setState(() {
                  _selectedstable = Trainer.stableId?.toString() ?? '';
                  _selectedbirth = Trainer.nationalityId?.toString() ?? '';
                  _selecteddivision = Trainer.divisionId?.toString() ?? '';
                  _isActive = Trainer.isActive ?? false;
                });

                print('Form Values Set:');
                print('_selectedstable: $_selectedstable');
                print('_selectedbirth: $_selectedbirth');
                print('_selecteddivision: $_selecteddivision');
                print('_isActive: $_isActive');
              } else {
                print(
                    'Error: TrainerDetail is null for ID: ${widget.TrainerId}');
              }
            } else {
              print(
                  'No Trainer ID provided. Initializing form for new Trainer.');
            }
          }
        },
        builder: (BuildContext context, AddTrainerState state) {
          if (state is TrainerLoading) {
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
                  if (TrainerName != null) // Ensure stableName is not null
                    Stack(children: [
                      Container(
                          child: Center(
                        child: GestureDetector(
                          onTap: () {
                            if (state is TrainerImage &&
                                state.pickedImage != null) {
                              _showZoomableImage(context, state.pickedImage);
                            }
                          },
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Color.fromRGBO(139, 72, 223, 0.1),
                            backgroundImage: state is TrainerImage &&
                                    state.pickedImage != null
                                ? FileImage(state.pickedImage!)
                                : null,
                            child: state is! TrainerImage
                                ? ProfileImage(
                                    recordId: TrainerName!.id.toString(),
                                    tableName: 'Trainer',
                                    displayPane: 'profileImgs',
                                  )
                                : null,
                          ),
                        ),
                      )),
                      Positioned(
                        top: 75,
                        left: 180,
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.white,
                          child: IconButton(
                            icon: Icon(Icons.camera_alt, size: 20),
                            onPressed: () {
                              context.read<AddTrainerBloc>().add(PickImage());
                            },
                          ),
                        ),
                      ),
                    ]),
                  if (TrainerName == null)
                    Stack(
                      children: [
                        Container(
                            child: Center(
                                child: GestureDetector(
                          onTap: () {
                            if (state is TrainerImage &&
                                state.pickedImage != null) {
                              _showZoomableImage(context, state.pickedImage);
                            }
                          },
                          child: CircleAvatar(
                            radius: 70,
                            backgroundColor: Color.fromRGBO(139, 72, 223, 0.1),
                            backgroundImage: state is TrainerImage &&
                                    state.pickedImage != null
                                ? FileImage(state.pickedImage!)
                                : null,
                            child: state is! TrainerImage
                                ? Image.asset('assets/images/Horse_riding.png',
                                    height: 200)
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
                                context.read<AddTrainerBloc>().add(PickImage());
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
                    key: _addTrainerformKey,
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

                        DropdownButtonFormField<String>(
                          value: _selectedbirth,
                          icon: Icon(Icons.keyboard_arrow_down),
                          items: this.birthcountry.map((birth) {
                            return DropdownMenuItem<String>(
                              value: birth.id.toString(),
                              child: Text(birth.name),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              _selectedbirth = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a value';
                            }
                            return null; // Validation passed
                          },
                          decoration: InputDecoration(
                            labelText: 'Nationality Name',
                            hintText: 'Nationality Name',
                            labelStyle: TextStyle(
                                fontFamily: 'Karla', color: Color(0xFF8B48DF)),
                            contentPadding: EdgeInsets.all(5),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                        ),
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
                          //   items: (state is TrainerLoaded)
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
                          CustomTextFormField(
                            hintText: 'Trainer Weight',
                            controller: _TrainerWeightController,
                            labelText: 'Trainer Weight',
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
                child: Text(
                  widget.TrainerId != null ? 'Update Trainer' : 'Add Trainer',
                  // 'Add Trainer',
                  style: GoogleFonts.karla(
                    textStyle: TextStyle(
                        color: Color.fromRGBO(33, 150, 243, 1),
                        fontSize: 15,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// class ProfileWidget extends StatelessWidget {
//   final TrainerModel stable;
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
//           tableName: "Trainer",
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
