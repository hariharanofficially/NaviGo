import 'dart:io';
import 'dart:typed_data';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:EquineApp/feature/subscripition/add_forms/Horse/bloc/add_horse_bloc.dart';
import 'package:EquineApp/feature/subscripition/add_forms/Horse/bloc/add_horse_event.dart';
import 'package:EquineApp/feature/subscripition/add_forms/Horse/bloc/add_horse_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../../../data/models/Horsecolor.dart';
import '../../../../../data/models/Horsegender.dart';
import '../../../../../data/models/breed.dart';
import '../../../../../data/models/country.dart';
import '../../../../../data/models/division.dart';
import '../../../../../data/models/horse_model.dart';
import '../../../../../data/models/stable_model.dart';
import '../../../../../data/repo/repo.dart';
import '../../../../../data/service/service.dart';
import '../../../../common/FormCustomWidget/datepickerform.dart';
import '../../../../common/FormCustomWidget/textform_field.dart';
import '../../../../common/FormCustomWidget/dropdownform.dart';
import '../../../../common/widgets/ProfileImage.dart';
import '../../../manage_dashboard/cards/horse_dashboard/bloc/horse_dashboard_bloc.dart';
import '../../../manage_dashboard/cards/horse_dashboard/view/horse_dashboard_view.dart';
import '../../../../../utils/constants/icons.dart';

class AddHorseScreen extends StatelessWidget {
  final int? horseId; // Optional parameter to edit an existing horse

  AddHorseScreen({super.key, this.horseId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddHorseBloc(),
      child: AddHorseform(horseId: horseId),
    );
  }
}

class AddHorseform extends StatefulWidget {
  final int? horseId; // Optional parameter to edit an existing horse

  const AddHorseform({Key? key, this.horseId}) : super(key: key);
  @override
  _AddHorseformState createState() => _AddHorseformState();
}

class _AddHorseformState extends State<AddHorseform> {
  final stableDropdownState = GlobalKey<FormFieldState>();

  final _addHorseFormKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _currentNameController = TextEditingController();
  final _originalNameController = TextEditingController();
  final _residentCountryController = TextEditingController();
  final _dateOfBirthController = TextEditingController();

  final _microchipNoController = TextEditingController();
  final _divisionController = TextEditingController();
  final _feiController = TextEditingController();
  final _remarksController = TextEditingController();
  final TextEditingController startdateval = TextEditingController();
  bool _isSecondPartVisible = false;
  bool _isActive = false;
  String? _selectedBreed = "1";
  String? _selectedbirth;
  String? _selectedgender;
  String? _selectedcolor;
  String? _selecteddivision;
  String? _selectedstable;
  HorseModel? HorseName; // Change to nullable type
  List<StableModel> stables = [];
  List<HorseModel> Horses = [];
  List<Division> division = [];
  List<Breed> Breedd = [];
  List<country> birthcountry = [];
  List<Horsegender> horsegender = []; // Correct type
  List<Horsecolor> horsecolor = []; // Correct type
  // HorseModel? horse;

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
  void dispose() {
    _nameController.dispose();
    _currentNameController.dispose();
    _originalNameController.dispose();
    _residentCountryController.dispose();
    _dateOfBirthController.dispose();

    _microchipNoController.dispose();
    _divisionController.dispose();
    _feiController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    if (widget.horseId != null) {
      context
          .read<AddHorseBloc>()
          .add(LoadHorseDetails(horseId: widget.horseId!));
    } else {
      context
          .read<AddHorseBloc>()
          .add(LoadFetch()); // Dispatch FetchRoles when widget is initialized
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
              widget.horseId != null ? 'Edit Horse' : 'Add Horse',
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
      body: BlocConsumer<AddHorseBloc, AddHorseState>(
        listener: (context, state) {
          if (state is FormSubmittedSuccessfully) {
            String message = widget.horseId != null
                ? 'Horse Updated Successfully'
                : 'Horse Added Successfully';
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BlocProvider(
                        create: (context) => HorseDashboardBloc(),
                        child: HorseDashboard(
                          title: 'Horse',
                          isProfile: false,
                          showActions: true,
                        ))));
          }
          // if (state is HorseImageUploadedSuccessfully) {
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(content: Text('HorseImageUploadedSuccessfully')),
          //   );
          // } else if (state is HorseImageUploadFailure) {
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(content: Text('HorseImageUploadFailure')),
          //   );
          // }
          if (state is DateSelected) {
            _dateOfBirthController.text = state.selectedDate;
          }
          if (state is HorseLoaded) {
            print('Dropdown Items: ${state.allFormModel.stable}');

            stables = state.allFormModel.stable;
            Horses = state.allFormModel.horse;
            division = state.allFormModel.division;
            Breedd = state.allFormModel.breed;
            birthcountry = state.allFormModel.birthcountry;
            horsegender = state.allFormModel.horsegender;
            horsecolor = state.allFormModel.horsecolor;
            if (widget.horseId != null) {
              final horse = state.allFormModel?.horseDetail;
              _nameController.text = horse!.name;
              _currentNameController.text = horse.currentName;
              _originalNameController.text = horse.originalName;
              _dateOfBirthController.text = horse.dateOfBirth;
              _microchipNoController.text =
                  horse.microChipNo.toString(); // Ensure this is being executed
              _remarksController.text = horse.remarks.toString();
              HorseName = state.allFormModel.horseDetail;
              setState(() {
                _selectedstable = horse.stableId.toString();
                _selecteddivision = horse.divisionId.toString();
                _selectedBreed = horse.breedId.toString();
                _selectedbirth = horse.countryofbirthId.toString();
                _selectedgender = horse.genderId.toString();
                _selectedcolor = horse.colorId.toString();
                //stableDropdownState.currentState?.didChange(_selectedBreed);
                _isActive = horse.isActive!;
              });
              print('Horse Details Loaded:');

              //print('Selected Stable: $_selectedstable');
              print('Microchip No: ${horse.microChipNo}');
              print('Stable ID: ${horse.stableId}');
              print('Division ID: ${horse.divisionId}');
              print('Breed ID: ${horse.breedId}');
              print('Active Status: ${horse.isActive}');
            }
          }
        },
        builder: (context, state) {
          // Check if the events list is empty or null
          if (state is HorseLoading) {
            return Center(
              child: CircularProgressIndicator(), // Show loading spinner
            );
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
                  if (HorseName != null)
                    Stack(children: [
                      Container(
                        child: Center(
                            child: GestureDetector(
                                onTap: () {
                                  if (state is horseImage &&
                                      state.pickedImage != null) {
                                    _showZoomableImage(
                                        context, state.pickedImage);
                                  }
                                },
                                child: CircleAvatar(
                                    radius: 50,
                                    backgroundColor:
                                        Color.fromRGBO(139, 72, 223, 0.1),
                                    backgroundImage: state is horseImage &&
                                            state.pickedImage != null
                                        ? FileImage(state.pickedImage!)
                                        : null,
                                    child: state is! horseImage
                                        ? ProfileImage(
                                            recordId: HorseName!.id.toString(),
                                            tableName: 'Horse',
                                            displayPane: 'profileImgs',
                                          )
                                        : null))),
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
                              context.read<AddHorseBloc>().add(PickImage());
                            },
                          ),
                        ),
                      ),
                    ]),
                  if (HorseName == null)
                    Stack(
                      children: [
                        Container(
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                if (state is horseImage &&
                                    state.pickedImage != null) {
                                  _showZoomableImage(
                                      context, state.pickedImage);
                                }
                              },
                              child: CircleAvatar(
                                radius: 70,
                                backgroundColor:
                                    Color.fromRGBO(139, 72, 223, 0.1),
                                backgroundImage: state is horseImage &&
                                        state.pickedImage != null
                                    ? FileImage(state.pickedImage!)
                                    : null,
                                child: state is! horseImage
                                    ? Image.asset(
                                        'assets/images/Stables.png',
                                        width: 200,
                                      )
                                    : null,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 100,
                          left: 200,
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.white,
                            child: IconButton(
                              icon: Icon(Icons.camera_alt, size: 20),
                              onPressed: () {
                                context.read<AddHorseBloc>().add(PickImage());
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
                    key: _addHorseFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextFormField(
                          hintText: 'Name',
                          controller: _nameController,
                          labelText: 'Name',
                          validate: true,
                        ),
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
                        // const SizedBox(height: 10),
                        // DropdownButtonFormField<String>(
                        //   key: stableDropdownState,
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
                        CustomDropdownButtonFormField(
                          hint: 'Division',
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
                          labelText: 'Division',
                        ),
                        // const SizedBox(height: 10),

                        // DropdownButtonFormField<String>(
                        //     hint: Text('Division'),
                        //     value: _selecteddivision,
                        //     icon: Icon(Icons.keyboard_arrow_down),
                        //     items: this.division.map((divisions) {
                        //       return DropdownMenuItem<String>(
                        //         value: divisions.id.toString(),
                        //         child: Text(divisions.name),
                        //       );
                        //     }).toList(),
                        //     onChanged: (String? value) {
                        //       setState(() {
                        //         _selecteddivision = value;
                        //       });
                        //     }),
                        // const SizedBox(height: 10),

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

                          const SizedBox(height: 10),
                          CustomTextFormField(
                            hintText: 'Current Name',
                            controller: _currentNameController,
                            labelText: 'Current Name',
                          ),
                          CustomTextFormField(
                            hintText: 'Original Name',
                            controller: _originalNameController,
                            labelText: 'Original Name',
                          ),
                          CustomDropdownButtonFormField(
                            hint: 'Breed Name',
                            selectedValue: _selectedBreed,
                            items:
                                Breedd, // List of gender objects with id and name fields
                            onChanged: (String? value) {
                              setState(() {
                                _selectedBreed = value;
                              });
                            },
                            labelText: 'Breed Name',
                          ),
                          // DropdownButtonFormField<String>(
                          //   hint: Text('Breed Name'),
                          //   value: _selectedBreed,
                          //   icon: Icon(Icons.keyboard_arrow_down),
                          //   items: this.Breedd.map((breed) {
                          //     return DropdownMenuItem<String>(
                          //       value: breed.id.toString(),
                          //       child: Text(breed.name),
                          //     );
                          //   }).toList(),
                          //   onChanged: (String? value) {
                          //     setState(() {
                          //       _selectedBreed = value;
                          //     });
                          //   },
                          // ),

                          // DropdownButtonFormField<String>(
                          //   hint: Text('Breeder ID'),
                          //   icon: Icon(Icons.keyboard_arrow_down),
                          //   items: const [
                          //     DropdownMenuItem(
                          //       child: Text('Breeder ID'),
                          //       value: 'Breeder ID',
                          //     ),
                          //   ],
                          //   onChanged: (String? value) {},
                          //   validator: (value) {
                          //     if (value == null) {
                          //       return 'Please select a Breeder ID';
                          //     }
                          //     return null;
                          //   },
                          // ),
                          // const SizedBox(height: 10),
                          // CustomTextFormField(
                          //     hintText: 'Resident Country ID',
                          //     controller: _residentCountryController),

                          DropdownSearch<String>(
                            items: birthcountry
                                .map((birth) => birth.name)
                                .toList(),
                            selectedItem: _selectedbirth != null
                                ? birthcountry
                                    .firstWhere(
                                      (birth) =>
                                          birth.id.toString() == _selectedbirth,
                                      orElse: () => birthcountry.first,
                                    )
                                    .name
                                : null,
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                labelText: 'Birth Country Name',
                                hintText: 'Birth Country Name',
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
                            onChanged: (String? value) {
                              setState(() {
                                _selectedbirth = birthcountry
                                    .firstWhere(
                                      (birth) => birth.name == value,
                                      orElse: () => birthcountry.first,
                                    )
                                    .id
                                    .toString();
                              });
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

                          const SizedBox(
                            height: 10,
                          ),
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
                          CustomDropdownButtonFormField(
                            hint: 'Gender Name',
                            selectedValue: _selectedgender,
                            items:
                                horsegender, // List of gender objects with id and name fields
                            onChanged: (String? value) {
                              setState(() {
                                _selectedgender = value;
                              });
                            },
                            labelText: 'Gender Name',
                          ),
                          // DropdownButtonFormField<String>(
                          //   hint: Text('Gender Name'),
                          //   value: _selectedgender,
                          //   icon: Icon(Icons.keyboard_arrow_down),
                          //   items: this.horsegender.map((gender) {
                          //     return DropdownMenuItem<String>(
                          //       value: gender.id.toString(),
                          //       child: Text(gender.name),
                          //     );
                          //   }).toList(),
                          //   onChanged: (String? value) {
                          //     setState(() {
                          //       _selectedgender = value;
                          //     });
                          //   },
                          // ),
                          CustomDropdownButtonFormField(
                            hint: 'Color Name',
                            selectedValue: _selectedcolor,
                            items:
                                horsecolor, // List of gender objects with id and name fields
                            onChanged: (String? value) {
                              setState(() {
                                _selectedcolor = value;
                              });
                            },
                            labelText: 'Color Name',
                          ),
                          // DropdownButtonFormField<String>(
                          //   hint: Text('Color Name'),
                          //   value: _selectedcolor,
                          //   icon: Icon(Icons.keyboard_arrow_down),
                          //   items: this.horsecolor.map((color) {
                          //     return DropdownMenuItem<String>(
                          //       value: color.id.toString(),
                          //       child: Text(color.name),
                          //     );
                          //   }).toList(),
                          //   onChanged: (String? value) {
                          //     setState(() {
                          //       _selectedcolor = value;
                          //     });
                          //   },
                          // ),

                          CustomTextFormField(
                            hintText: 'Microchip No',
                            controller: _microchipNoController,
                            labelText: 'Microchip No',
                          ),
                          // CustomTextFormField(
                          //     hintText: 'Fei ID', controller: _feiController),
                          CustomTextFormField(
                            hintText: 'Remarks',
                            controller: _remarksController,
                            labelText: 'Remarks',
                          ),
                          // CustomTextFormField(
                          //     hintText: 'Vendor Name',
                          //     controller: _activeController),
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
              child: SizedBox(
                height: 50,
                width: 225,
                child: ElevatedButton(
                  onPressed: () async {
                    print('id');
                    print(_selecteddivision);
                    if (_addHorseFormKey.currentState!.validate() == true) {
                      print("inside the submit validate");
                      context.read<AddHorseBloc>().add(SubmitForm(
                            id: widget.horseId,
                            name: _nameController.text,
                            currentname: _currentNameController.text,
                            originalname: _originalNameController.text,
                            dateOfBirth: _dateOfBirthController.text,
                            microchipNo: _microchipNoController.text,
                            remarks: _remarksController.text,
                            stableId: _selectedstable.toString() ?? "1",
                            breedId: _selectedBreed.toString() ?? "1",
                            divisionId: _selecteddivision.toString() ?? "1",
                            active: _isActive.toString() ?? "true",
                          ));
                      // context.read<AddHorseBloc>().add(
                      //     UploadStableImage(isEdit: widget.horseId != null));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  child: BlocConsumer<AddHorseBloc, AddHorseState>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      if (state is FormSubmitting) {
                        return CircularProgressIndicator(
                          color: Colors.blue,
                        );
                      }
                      return Text(
                        widget.horseId != null ? 'Update Horse' : 'Add Horse',
                        // 'Add Horse',
                        style: GoogleFonts.karla(
                          textStyle: TextStyle(
                              color: Color.fromRGBO(33, 150, 243, 1),
                              fontSize: 15,
                              fontWeight: FontWeight.w400),
                        ),
                      );
                    },
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
//   final HorseModel stable;
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
//           tableName: "Horse",
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
