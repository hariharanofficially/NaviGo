import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:EquineApp/feature/subscripition/add_forms/Event/bloc/AddEvent_Event.dart';
import 'package:EquineApp/feature/subscripition/add_forms/Event/bloc/AddEvent_bloc.dart';
import 'package:EquineApp/feature/subscripition/add_forms/Event/bloc/AddEvent_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:intl/intl.dart';

import '../../../../../app/route/routes/route_path.dart';
import '../../../../../data/models/country.dart';
import '../../../../../data/models/event_model.dart';
import '../../../../../data/models/eventgroup.dart';
import '../../../../../data/models/eventtype.dart';
import '../../../../../data/repo/repo.dart';
import '../../../../MockRace_dashboard/bloc/MockRace_dashboard_bloc.dart';
import '../../../../MockRace_dashboard/view/MockRace_dashboard_view.dart';
import '../../../../bysession/bloc/bysession_bloc.dart';
import '../../../../bysession/view/bysession_view.dart';
import '../../../../common/FormCustomWidget/datepickerform.dart';
import '../../../../common/widgets/ProfileImage.dart';
import '../../../../common/FormCustomWidget/dropdownform.dart';
import '../../../../common/FormCustomWidget/textform_field.dart';
import '../../../manage_dashboard/cards/events_dashboard/bloc/events_dashboard_bloc.dart';
import '../../../manage_dashboard/cards/events_dashboard/view/events_dashboard_view.dart';
import '../../../../../utils/constants/icons.dart';

class AddEventScreen extends StatelessWidget {
  final int? eventId;
  String fromScreen = "";
  final String edittitle;
  final String addtitle;
  final String updateadd;
  final String updateedit;
  AddEventScreen(
      {super.key,
      required String fromScreen,
      this.eventId,
      required this.edittitle,
      required this.addtitle,
      required this.updateadd,
      required this.updateedit}) {
    this.fromScreen = fromScreen;
  }

  @override
  Widget build(BuildContext context) {
    print("in add eventScreen : " + this.fromScreen);
    return BlocProvider(
      create: (context) => AddEventBloc(),
      child: AddEventform(
        fromScreen: this.fromScreen,
        eventId: eventId,
        edittitle: edittitle,
        addtitle: addtitle,
        updateadd: updateadd,
        updateedit: updateedit,
      ),
    );
  }
}

class AddEventform extends StatefulWidget {
  final int? eventId;
  String fromScreen = "";
  String categorValue = "race";
  final String edittitle;
  final String addtitle;
  final String updateadd;
  final String updateedit;
  AddEventform(
      {super.key,
      required String fromScreen,
      this.eventId,
      required this.edittitle,
      required this.addtitle,
      required this.updateadd,
      required this.updateedit}) {
    this.fromScreen = fromScreen;
  }

  @override
  _AddEventformState createState() => _AddEventformState();
}

class _AddEventformState extends State<AddEventform> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController startdateval = TextEditingController();
  final TextEditingController enddateval = TextEditingController();
  String? _eventCountryController;
  final TextEditingController _shortnameController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _rideStartTimeController =
      TextEditingController();
  final TextEditingController _rideStartDateController =
      TextEditingController();
  final TextEditingController _sourceController = TextEditingController();
  final TextEditingController _vemdorNameController = TextEditingController();
  final TextEditingController _phasesController = TextEditingController();
  bool _isSecondPartVisible = false;
  String? _selectedstable;

  String? _selectedeventgroup;
  String? _selecteddivision;
  String? _selectedeventtype;
  EventModel? evetntsName; // Change to nullable type
  List<Eventgroup> eventgroup = [];
  List<country> eventcountry = [];
  List<Eventtype> eventtype = [];
  EventModel? events;

  _selectDate(BuildContext context, String select) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      if (select == 'start') {
        setState(() {
          startdateval.text = DateFormat('yyyy-MM-dd').format(picked);
        });
      } else if (select == 'ridestart') {
        setState(() {
          _rideStartDateController.text =
              DateFormat('yyyy-MM-dd').format(picked);
        });
      } else {
        setState(() {
          enddateval.text = DateFormat('yyyy-MM-dd').format(picked);
        });
      }
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _rideStartTimeController.text = picked.format(context).toString();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    print("in add _AddEventformState : " + widget.fromScreen);
    if (widget.eventId != null) {
      context
          .read<AddEventBloc>()
          .add(LoadeventDetails(eventId: widget.eventId!));
    } else {
      context.read<AddEventBloc>().add(Loadfetchevent());
    } // Dispatch FetchRoles when widget is initialized
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
                widget.eventId != null ? widget.edittitle : widget.addtitle,
                // 'Add Race',
                style: GoogleFonts.karla(
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: BlocConsumer<AddEventBloc, AddEventState>(
          listener: (BuildContext context, AddEventState state) {
            if (state is AddRaceEventSuccess) {
              String message = widget.eventId != null
                  ? 'Event Updated Successfully'
                  : 'Event Added Successfully';
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message)),
              );
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BlocProvider(
                          create: (context) => EventsDashboardBloc(),
                          child: EventsDashboard())));
            } else if (state is AddTrainingEventSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Event Added Successfully")),
              );
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BlocProvider(
                          create: (context) => Bysessionbloc(),
                          child: Bysession())));
            } else if (state is AddMockEventSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Event Added Successfully")),
              );
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BlocProvider(
                          create: (context) => MockRaceDashboardBloc(),
                          child: MockRaceDashboard())));
            } else if (state is AddEventFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
            // else if (state is EventImageUploadedSuccessfully) {
            //   ScaffoldMessenger.of(context).showSnackBar(
            //     SnackBar(content: Text('eventImageUploadedSuccessfully')),
            //   );
            // } else if (state is EventImageUploadFailure) {
            //   ScaffoldMessenger.of(context).showSnackBar(
            //     SnackBar(content: Text('eventImageUploadFailure')),
            //   );
            // }
            else if (state is eventLoaded) {
              print('Dropdown Items: ${state.allFormModel.eventDetail}');
              eventgroup = state.allFormModel.eventgroup;
              eventtype = state.allFormModel.eventtype;
              eventcountry = state.allFormModel.birthcountry;

              if (widget.eventId != null) {
                final events = state.allFormModel.eventDetail;
                _titleController.text = events!.name;
                startdateval.text = events!.startdate;
                enddateval.text = events.endDate!;
                _locationController.text = events!.locationname;
                _groupNameController.text = events!.groupName;
                _rideStartTimeController.text = events.rideStartTime!;
                _cityController.text = events.cityName;
                _rideStartDateController.text = events.rideDate.toString();
                _groupNameController.text = events.groupName;
                _sourceController.text = events.source;
                _vemdorNameController.text = events.vendorName;
                setState(() {
                  _selectedeventgroup = events.eventGroup.toString();
                  _eventCountryController = events.eventcountry.toString();
                  _selectedeventtype = events.eventType.toString();
                });
              }
            }
          },
          builder: (BuildContext context, AddEventState state) {
            if (state is eventLoading) {
              return Center(child: CircularProgressIndicator());
            }
            return SingleChildScrollView(
              reverse: true,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 35.0, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const SizedBox(height: 10),
                    // if (evetntsName != null) // Ensure stableName is not null
                    //   Row(children: [
                    //     Center(
                    //         child: Container(
                    //             child: ProfileImage(
                    //       recordId: events!.id.toString(),
                    //       tableName: 'Event',
                    //       displayPane: 'profileImgs',
                    //     )))
                    //   ]), // Row(children: [

                    // if (evetntsName == null)
                    //   Stack(
                    //     children: [
                    //       Container(
                    //         child: Center(
                    //           child: GestureDetector(
                    //             onTap: () {
                    //               if (state is eventsImage &&
                    //                   state.pickedImage != null) {
                    //                 _showZoomableImage(
                    //                     context, state.pickedImage);
                    //               }
                    //             },
                    //             child: CircleAvatar(
                    //               radius: 70,
                    //               backgroundColor:
                    //                   Color.fromRGBO(139, 72, 223, 0.1),
                    //               backgroundImage: state is eventsImage &&
                    //                       state.pickedImage != null
                    //                   ? FileImage(state.pickedImage!)
                    //                   : null,
                    //               child: state is! eventsImage
                    //                   ? Image.asset(
                    //                       'assets/images/events_icon.png',
                    //                       width: 200,
                    //                     )
                    //                   : null,
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //       Positioned(
                    //         top: 100,
                    //         left: 200,
                    //         child: CircleAvatar(
                    //           radius: 15,
                    //           backgroundColor: Colors.white,
                    //           child: IconButton(
                    //             icon: Icon(Icons.camera_alt, size: 20),
                    //             onPressed: () {
                    //               context.read<AddEventBloc>().add(PickImage());
                    //             },
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    const SizedBox(height: 20),
                    Text(
                      'Required Information',
                      style: GoogleFonts.karla(
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextFormField(
                            hintText: 'Title',
                            controller: _titleController,
                            labelText: 'Title',
                            validate: true,
                          ),

                          const SizedBox(height: 10),
                          // DropdownButtonFormField<String>(
                          //   hint: Text('Stable Name'),
                          //   value: _selectedstable,
                          //   icon: Icon(Icons.keyboard_arrow_down),
                          //   items: (state is eventLoaded)
                          //       ? state.allFormModel.stable.map((stables) {
                          //           return DropdownMenuItem(
                          //             child: Text(stables.name),
                          //             value: stables.id.toString(),
                          //           );
                          //         }).toList()
                          //       : [],
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
                          CustomDatePickerFormField(
                            controller: startdateval,
                            hintText: 'Start Date',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Choose Date';
                              }
                              return null;
                            },
                            onDateTap: (BuildContext context) {
                              _selectDate(context, 'start');
                            },
                            labelText: 'Start Date',
                          ),
                          // TextFormField(
                          //   keyboardType: TextInputType.phone,
                          //   autocorrect: false,
                          //   controller: startdateval,
                          //   onTap: () {
                          //     _selectDate(context, 'start');
                          //     FocusScope.of(context)
                          //         .requestFocus(new FocusNode());
                          //   },
                          //   maxLines: 1,
                          //   validator: (value) {
                          //     if (value!.isEmpty || value.length < 1) {
                          //       return 'Choose Date';
                          //     }
                          //   },
                          //   decoration: InputDecoration(
                          //     suffixIcon: IconButton(
                          //       icon: const Icon(Icons.calendar_today,
                          //           color: Colors.black45),
                          //       onPressed: () {
                          //         _selectDate(context, 'start');
                          //         FocusScope.of(context)
                          //             .requestFocus(new FocusNode());
                          //       },
                          //     ),
                          //     hintText: 'Start Date',
                          //   ),
                          // ),
                          // const SizedBox(height: 10),
                          CustomDatePickerFormField(
                            controller: enddateval,
                            hintText: 'End Date',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Choose Date';
                              }
                              return null;
                            },
                            onDateTap: (BuildContext context) {
                              _selectDate(context, 'end');
                            },
                            labelText: 'End Date',
                          ),
                          // TextFormField(
                          //   keyboardType: TextInputType.phone,
                          //   autocorrect: false,
                          //   controller: enddateval,
                          //   onTap: () {
                          //     _selectDate(context, 'end');
                          //     FocusScope.of(context)
                          //         .requestFocus(new FocusNode());
                          //   },
                          //   maxLines: 1,
                          //   validator: (value) {
                          //     if (value!.isEmpty || value.length < 1) {
                          //       return 'Choose Date';
                          //     }
                          //   },
                          //   decoration: InputDecoration(
                          //     suffixIcon: IconButton(
                          //       icon: const Icon(Icons.calendar_today,
                          //           color: Colors.black45),
                          //       onPressed: () {
                          //         _selectDate(context, 'end');
                          //         FocusScope.of(context)
                          //             .requestFocus(new FocusNode());
                          //       },
                          //     ),
                          //     hintText: 'End Date',
                          //   ),
                          // ),
                          // const SizedBox(height: 10),
                          CustomDropdownButtonFormField(
                            hint: 'Event Group',
                            selectedValue: _selectedeventgroup,
                            items:
                                eventgroup, // List of gender objects with id and name fields
                            onChanged: (String? value) {
                              setState(() {
                                _selectedeventgroup = value;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a value';
                              }
                              return null; // Validation passed
                            },
                            labelText: 'Event Group',
                          ),
                          //  DropdownButtonFormField<String>(
                          //   hint: Text('Event Group'),
                          //   value: _selectedeventgroup,
                          //   icon: Icon(Icons.keyboard_arrow_down),
                          //   items: this.eventgroup.map((color) {
                          //     return DropdownMenuItem<String>(
                          //       value: color.id.toString(),
                          //       child: Text(color.name),
                          //     );
                          //   }).toList(),
                          //   onChanged: (String? value) {
                          //     setState(() {
                          //       _selectedeventgroup = value;
                          //     });
                          //   },
                          // ),
                          // CustomTextFormField(
                          //     hintText: 'Event Group',
                          //     controller: _eventGroupController),
                          // const SizedBox(height: 10),
                          // DropdownButtonFormField<String>(
                          //   value: _eventCountryController,
                          //   icon: Icon(Icons.keyboard_arrow_down),
                          //   items: this.eventcountry.map((birth) {
                          //     return DropdownMenuItem<String>(
                          //       value: birth.id.toString(),
                          //       child: Text(birth.name),
                          //     );
                          //   }).toList(),
                          //   onChanged: (String? value) {
                          //     setState(() {
                          //       _eventCountryController = value;
                          //     });
                          //   },
                          //   decoration: InputDecoration(
                          //     labelText: 'Event Country',
                          //     hintText: 'Event Country',
                          //     labelStyle: TextStyle(
                          //         fontFamily: 'Karla',
                          //         color: Color(0xFF8B48DF)),
                          //     contentPadding: EdgeInsets.all(5),
                          //     border: OutlineInputBorder(
                          //       borderRadius: BorderRadius.all(
                          //         Radius.circular(10),
                          //       ),
                          //       borderSide: BorderSide(color: Colors.black),
                          //     ),
                          //   ),
                          // ),
                          DropdownSearch<String>(
                            items: eventcountry
                                .map((event) => event.name)
                                .toList(),
                            selectedItem: _eventCountryController != null
                                ? eventcountry
                                    .firstWhere(
                                      (event) =>
                                          event.id.toString() ==
                                          _eventCountryController,
                                      orElse: () => eventcountry.first,
                                    )
                                    .name
                                : null,
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                labelText: 'Event Country',
                                hintText: 'Event Country',
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
                                _eventCountryController = eventcountry
                                    .firstWhere(
                                      (event) => event.name == value,
                                      orElse: () => eventcountry.first,
                                    )
                                    .id
                                    .toString();
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
                                  labelText: 'Search Event Country',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ),

                          // CustomTextFormField(
                          //   hintText: 'Event Country',
                          //   controller: _eventCountryController,
                          //   labelText: 'Event Country',
                          // ),
                          // const SizedBox(height: 10),
                          // DropdownButtonFormField<String>(
                          //   hint: Text('Division'),
                          //   value: _selecteddivision,
                          //   icon: Icon(Icons.keyboard_arrow_down),
                          //   items: (state is eventLoaded)
                          //       ? state.allFormModel.division.map((color) {
                          //           return DropdownMenuItem<String>(
                          //             value: color.id.toString(),
                          //             child: Text(color.name),
                          //           );
                          //         }).toList()
                          //       : [],
                          //   onChanged: (String? value) {
                          //     setState(() {
                          //       _selecteddivision = value;
                          //     });
                          //   },
                          // ),
                          // CustomTextFormField(
                          //     hintText: 'Division',
                          //     controller: _divisionController),
                          const SizedBox(height: 10),
                          CustomDropdownButtonFormField(
                            hint: 'Event Type',
                            selectedValue: _selectedeventtype,
                            items:
                                eventtype, // List of gender objects with id and name fields
                            onChanged: (String? value) {
                              setState(() {
                                _selectedeventtype = value;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a value';
                              }
                              return null; // Validation passed
                            },
                            labelText: 'Event Type',
                          ),
                          // DropdownButtonFormField<String>(
                          //   hint: Text('Event Type'),
                          //   value: _selectedeventtype,
                          //   icon: Icon(Icons.keyboard_arrow_down),
                          //   items: this.eventtype.map((color) {
                          //     return DropdownMenuItem<String>(
                          //       value: color.id.toString(),
                          //       child: Text(color.name),
                          //     );
                          //   }).toList(),
                          //   onChanged: (String? value) {
                          //     setState(() {
                          //       _selectedeventtype = value;
                          //     });
                          //   },
                          // ),
                          // CustomTextFormField(
                          //     hintText: 'Event Type',
                          //     controller: _eventTypeController),
                          // const SizedBox(height: 10),
                          //CustomTextFormField(hintText: 'Short Name', controller: _shortnameController),
                          // const SizedBox(height: 10),

                          CustomTextFormField(
                            hintText: 'Location',
                            controller: _locationController,
                            labelText: 'Location',
                            validate: true,
                          ),
                          // const SizedBox(height: 10),
                          TextFormField(
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
                            validator: (value) {
                              if (value!.isEmpty || value!.length < 1) {
                                return 'Choose Time';
                              }
                            },
                            decoration: InputDecoration(
                              labelText: 'Event start Time',
                              hintText: 'Event start Time',
                              labelStyle: TextStyle(
                                  fontFamily: 'Karla',
                                  color: Color(0xFF8B48DF)),
                              contentPadding: EdgeInsets.all(5),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                borderSide: BorderSide(color: Colors.black),
                              ),
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
                            ),
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
                              hintText: 'City',
                              controller: _cityController,
                              labelText: 'City',
                            ),
                            const SizedBox(height: 10),
                            CustomTextFormField(
                              hintText: 'Group Name',
                              controller: _groupNameController,
                              labelText: 'Group Name',
                            ),
                            const SizedBox(height: 10),
                            //ride start time

                            //ride start date
                            CustomDatePickerFormField(
                              controller: _rideStartDateController,
                              hintText: 'Ride Date',
                              // validator: (value) {
                              //   if (value == null || value.isEmpty) {
                              //     return 'Choose Date';
                              //   }
                              //   return null;
                              // },
                              onDateTap: (BuildContext context) {
                                _selectDate(context, 'ridestart');
                              },
                              labelText: 'Ride Date',
                            ),
                            // TextFormField(
                            //   keyboardType: TextInputType.phone,
                            //   autocorrect: false,
                            //   controller: _rideStartDateController,
                            //   onSaved: (value) {
                            //     _rideStartDateController.text =
                            //         DateFormat('dd-MM-yyyy')
                            //             .format(DateTime.parse(value!));
                            //   },
                            //   onTap: () {
                            //     _selectDate(context, 'ridestart');
                            //     FocusScope.of(context)
                            //         .requestFocus(new FocusNode());
                            //   },
                            //   maxLines: 1,
                            //   //initialValue: 'Aseem Wangoo',
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
                            //         _selectDate(context, 'ridestart');
                            //         FocusScope.of(context)
                            //             .requestFocus(new FocusNode());
                            //       },
                            //     ),
                            //     hintText: 'Event start Date',
                            //   ),
                            // ),
                            // const SizedBox(
                            //   height: 10,
                            // ),
                            const SizedBox(height: 10),
                            CustomTextFormField(
                              hintText: 'Source',
                              controller: _sourceController,
                              labelText: 'Source',
                            ),
                            const SizedBox(height: 10),
                            CustomTextFormField(
                              hintText: 'Vendor Name',
                              controller: _vemdorNameController,
                              labelText: 'Vendor Name',
                            ),
                            const SizedBox(height: 10),
                            CustomTextFormField(
                              hintText: 'Phases',
                              controller: _phasesController,
                              labelText: 'Phases',
                            ),
                            const SizedBox(height: 10),
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
                    const SizedBox(height: 20),
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
                      onPressed: () {
                        print(
                            "from screeen from screen :: " + widget.fromScreen);
                        if (_formKey.currentState!.validate() == true) {
                          context.read<AddEventBloc>().add(SubmitForm(
                              id: widget.eventId,
                              fromScreen: widget.fromScreen,
                              startDate: startdateval.text,
                              endDate: enddateval.text,
                              shortName: _shortnameController.text,
                              title: _titleController.text,
                              groupName: _groupNameController.text,
                              locationName: _locationController.text,
                              city: _cityController.text,
                              rideStartTime: _rideStartTimeController.text,
                              rideDate: _rideStartDateController.text,
                              source: _sourceController.text,
                              vendorName: _vemdorNameController.text,
                              stableId: _selectedstable ?? "1",
                              eventGroupId: _selectedeventgroup ?? "1",
                              eventTypeId: _selectedeventtype ?? "1",
                              eventCountryId: _eventCountryController ?? "1",
                              divisionId: _selecteddivision ?? "1",
                              category: "mock"));
                          context.read<AddEventBloc>().add(UploadEventImage());
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      child: Text(
                        widget.eventId != null
                            ? widget.updateedit
                            : widget.updateadd,
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
              )),
        ));
  }
}

// class ProfileWidget extends StatelessWidget {
//   final EventModel stable;
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
//           tableName: "Race",
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

// class AddEventScreen extends StatefulWidget {
//   @override
//   _AddEventScreenState createState() => _AddEventScreenState();
// }

// class _AddEventScreenState extends State<AddEventScreen>
//     with SingleTickerProviderStateMixin {
//   bool isPassword(String input) =>
//       RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~.]).{8,}$')
//           .hasMatch(input);
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController startdateval = TextEditingController();
//   final TextEditingController enddateval = TextEditingController();
//   final TextEditingController _eventGroupController = TextEditingController();
//   final TextEditingController _eventCountryController = TextEditingController();
//   final TextEditingController _divisionController = TextEditingController();
//   final TextEditingController _eventTypeController = TextEditingController();

//   final TextEditingController _shortnameController = TextEditingController();
//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _groupNameController = TextEditingController();

//   final TextEditingController _locationController = TextEditingController();
//   final TextEditingController _cityController = TextEditingController();
//   final TextEditingController _rideStartTimeController =
//       TextEditingController();
//   final TextEditingController _rideStartDateController =
//       TextEditingController();

//   final TextEditingController _sourceController = TextEditingController();
//   final TextEditingController _vemdorNameController = TextEditingController();

//   final TextEditingController _phasesController = TextEditingController();

//   bool _isLoading = false;
//   bool _passwordvisible = true;
//   String _userName = '';
//   String _userEmail = '';
//   String _password = '';
//   String? _phoneNumber = '';
//   String verificationID = "";
//   bool isMatched = false;
//   bool isPhno = false;
//   bool isUser = false;
//   String apiError = '';

//   _selectDate(BuildContext context, String select) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2101),
//     );
//     if (picked != null) {
//       if (select == 'start')
//         setState(() {
//           startdateval.text = DateFormat('dd-MM-yyyy').format(picked);
//         });
//       else if (select == 'ridestart')
//         setState(() {
//           _rideStartDateController.text =
//               DateFormat('dd-MM-yyyy').format(picked);
//         });
//       else
//         setState(() {
//           enddateval.text = DateFormat('dd-MM-yyyy').format(picked);
//         });
//     }
//   }

//   Future<void> _selectTime(BuildContext context) async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );
//     if (picked != null)
//       setState(() {
//         _rideStartTimeController.text = picked!.format(context).toString();
//       });
//     print('time chose');
//     print(picked?.format(context));
//     //print({picked.hour.toString() + ':' + picked.minute.toString()});
//   }

//   bool isNumeric(String s) {
//     if (s == null) {
//       return false;
//     }
//     return double.tryParse(s) != null;
//   }

//   bool isEmail(String input) => (RegExp(r'\S+@\S+\.\S+').hasMatch(input));
//   bool isapierr = false;

//   bool isPhone(String input) =>
//       RegExp(r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$')
//           .hasMatch(input);
//   int tabIndex = 0;
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   void dispose() {
//     FocusManager.instance.primaryFocus?.unfocus();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     Future<void> _trySubmitForm() async {
//       context.goNamed(RoutePath.dashboard);
//       final bool? isValid = _formKey.currentState?.validate();
//       if (isValid == true) {
//         setState(() {
//           _isLoading = true;
//         });
//       }
//     }

//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         leading: Icon(Icons.arrow_back_ios),
//         title: Row(
//           // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             SizedBox(
//               width: 80,
//             ),
//             Text(
//               'Add Events',
//               style: GoogleFonts.karla(
//                 textStyle: TextStyle(
//                     color: Colors.black,
//                     fontSize: 20,
//                     fontWeight: FontWeight.w700),
//               ),
//             ),
//           ],
//         ),
//       ),
//       body: SingleChildScrollView(
//         reverse: true,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 10),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(
//                 height: 10,
//               ),
//               Stack(
//                 children: [
//                   Container(
//                       child: Center(
//                           child: CircleAvatar(
//                               radius: 70,
//                               backgroundColor:
//                                   Color.fromRGBO(139, 72, 223, 0.1),
//                               child: Image.asset(
//                                 'assets/images/events_icon.png',
//                                 width: 200,
//                               )))),
//                   Positioned(
//                     top: 100,
//                     left: 200,
//                     child: CircleAvatar(
//                         radius: 15,
//                         backgroundColor: Colors.white,
//                         child: Iconify(
//                           camera,
//                           size: 24,
//                         )),
//                   )
//                 ],
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               Text(
//                 'Required Information',
//                 style: GoogleFonts.karla(
//                   textStyle: TextStyle(
//                       color: Colors.black,
//                       fontSize: 15,
//                       fontWeight: FontWeight.w400),
//                 ),
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               Form(
//                 key: _formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     //Stable
//                     DropdownButtonFormField<String>(
//                         hint: Text('Select stable'),
//                         key: const ValueKey('dropdown'),
//                         icon: Icon(Icons.keyboard_arrow_down),
//                         items: const [
//                           DropdownMenuItem(
//                             //  key: ValueKey('option-hello'),
//                             child: Text('Stable'),
//                             value: 'Stable',
//                           ),
//                         ],
//                         onChanged: (String? value) {},
//                         validator: (value) {
//                           if (value == null) {
//                             return 'Please select a Stable';
//                           }
//                           return null;
//                         }),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     //start Date
//                     TextFormField(
//                       // focusNode: _focusNode,
//                       keyboardType: TextInputType.phone,
//                       autocorrect: false,
//                       controller: startdateval,
//                       onSaved: (value) {
//                         startdateval.text = DateFormat('dd-MM-yyyy')
//                             .format(DateTime.parse(value!));
//                       },
//                       onTap: () {
//                         _selectDate(context, 'start');
//                         FocusScope.of(context).requestFocus(new FocusNode());
//                       },
//                       maxLines: 1,
//                       //initialValue: 'Aseem Wangoo',
//                       validator: (value) {
//                         if (value!.isEmpty || value!.length < 1) {
//                           return 'Choose Date';
//                         }
//                       },
//                       decoration: InputDecoration(
//                         suffixIcon: IconButton(
//                           icon: const Icon(
//                             Icons.calendar_today,
//                             color: Colors.black45,
//                           ),
//                           onPressed: () {
//                             _selectDate(context, 'start');
//                             FocusScope.of(context)
//                                 .requestFocus(new FocusNode());
//                           },
//                         ),
//                         hintText: 'Start Date',
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     //End Date
//                     TextFormField(
//                       // focusNode: _focusNode,
//                       keyboardType: TextInputType.phone,
//                       autocorrect: false,
//                       controller: enddateval,
//                       onSaved: (value) {
//                         enddateval.text = DateFormat('dd-MM-yyyy')
//                             .format(DateTime.parse(value!));
//                       },
//                       onTap: () {
//                         _selectDate(context, 'end');
//                         FocusScope.of(context).requestFocus(new FocusNode());
//                       },
//                       maxLines: 1,
//                       //initialValue: 'Aseem Wangoo',
//                       validator: (value) {
//                         if (value!.isEmpty || value!.length < 1) {
//                           return 'Choose Date';
//                         }
//                       },
//                       decoration: InputDecoration(
//                         suffixIcon: IconButton(
//                           icon: const Icon(
//                             Icons.calendar_today,
//                             color: Colors.black45,
//                           ),
//                           onPressed: () {
//                             _selectDate(context, 'end');
//                             FocusScope.of(context)
//                                 .requestFocus(new FocusNode());
//                           },
//                         ),
//                         hintText: 'End Date',
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     //Event Group ID
//                     CustomTextFormField(
//                         hintText: 'Event Group ID',
//                         controller: _eventGroupController),
//                     //Event country id
//                     CustomTextFormField(
//                         hintText: 'Event country id',
//                         controller: _eventCountryController),
//                     //Division ID

//                     CustomTextFormField(
//                         hintText: 'Division ID',
//                         controller: _divisionController),

// //Event type iD
//                     CustomTextFormField(
//                         hintText: 'Event type id',
//                         controller: _eventTypeController),
//                     //group Flag
//                     DropdownButtonFormField<String>(

//                         //key: const ValueKey('dropdown'),
//                         icon: Icon(Icons.keyboard_arrow_down),
//                         hint: Text('Select a group Flag'),
//                         items: const [
//                           DropdownMenuItem(
//                             //  key: ValueKey('option-hello'),
//                             child: Text('Group Flag'),
//                             value: 'Group Flag',
//                           ),
//                         ],
//                         onChanged: (String? value) {},
//                         validator: (value) {
//                           if (value == null) {
//                             return 'Please select a group Flag';
//                           }
//                           return null;
//                         }),
//                     const SizedBox(
//                       height: 10,
//                     ),

//                     //Short Name
//                     CustomTextFormField(
//                         hintText: 'Short Name',
//                         controller: _shortnameController),
//                     //Title
//                     CustomTextFormField(
//                         hintText: 'Title', controller: _titleController),
//                     //Group name
//                     CustomTextFormField(
//                         hintText: 'Group name',
//                         controller: _groupNameController),
//                     //Category
//                     DropdownButtonFormField<String>(
//                         hint: Text('Select Category'),
//                         icon: Icon(Icons.keyboard_arrow_down),
//                         items: const [
//                           DropdownMenuItem(
//                             //  key: ValueKey('option-hello'),
//                             child: Text('Category'),
//                             value: 'Category',
//                           ),
//                         ],
//                         onChanged: (String? value) {},
//                         validator: (value) {
//                           if (value == null) {
//                             return 'Please select a ';
//                           }
//                           return null;
//                         }),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     //Location
//                     CustomTextFormField(
//                         hintText: 'Location', controller: _locationController),
//                     //city
//                     CustomTextFormField(
//                         hintText: 'City', controller: _cityController),
//                     //ride start time
//                     TextFormField(
//                       // focusNode: _focusNode,
//                       keyboardType: TextInputType.phone,
//                       autocorrect: false,
//                       controller: _rideStartTimeController,
//                       onSaved: (value) {
//                         _rideStartTimeController.text = DateFormat('dd-MM-yyyy')
//                             .format(DateTime.parse(value!));
//                       },
//                       onTap: () {
//                         _selectTime(context);
//                         FocusScope.of(context).requestFocus(new FocusNode());
//                       },
//                       maxLines: 1,
//                       //initialValue: 'Aseem Wangoo',
//                       validator: (value) {
//                         if (value!.isEmpty || value!.length < 1) {
//                           return 'Choose Time';
//                         }
//                       },
//                       decoration: InputDecoration(
//                         suffixIcon: IconButton(
//                           icon: const Icon(
//                             Icons.watch_later_outlined,
//                             color: Colors.black45,
//                           ),
//                           onPressed: () {
//                             _selectTime(context);
//                             FocusScope.of(context)
//                                 .requestFocus(new FocusNode());
//                           },
//                         ),
//                         hintText: 'Ride start Time',
//                       ),
//                     ),
//                     //ride start date
//                     TextFormField(
//                       // focusNode: _focusNode,
//                       keyboardType: TextInputType.phone,
//                       autocorrect: false,
//                       controller: _rideStartDateController,
//                       onSaved: (value) {
//                         _rideStartDateController.text = DateFormat('dd-MM-yyyy')
//                             .format(DateTime.parse(value!));
//                       },
//                       onTap: () {
//                         _selectDate(context, 'ridestart');
//                         FocusScope.of(context).requestFocus(new FocusNode());
//                       },
//                       maxLines: 1,
//                       //initialValue: 'Aseem Wangoo',
//                       validator: (value) {
//                         if (value!.isEmpty || value!.length < 1) {
//                           return 'Choose Date';
//                         }
//                       },
//                       decoration: InputDecoration(
//                         suffixIcon: IconButton(
//                           icon: const Icon(
//                             Icons.calendar_today,
//                             color: Colors.black45,
//                           ),
//                           onPressed: () {
//                             _selectDate(context, 'ridestart');
//                             FocusScope.of(context)
//                                 .requestFocus(new FocusNode());
//                           },
//                         ),
//                         hintText: 'Ride start Date',
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     //source
//                     CustomTextFormField(
//                         hintText: 'Source', controller: _sourceController),
//                     //vendors name
//                     CustomTextFormField(
//                         hintText: 'Vendor Name',
//                         controller: _vemdorNameController),
//                     //vendros rider id
//                     DropdownButtonFormField<String>(
//                         hint: Text('Select Vendor Rider ID'),
//                         //key: const ValueKey('dropdown'),
//                         icon: Icon(Icons.keyboard_arrow_down),
//                         items: const [
//                           DropdownMenuItem(
//                             //  key: ValueKey('option-hello'),
//                             child: Text('Vendor Rider ID'),
//                             value: 'Vendor Rider ID',
//                           ),
//                         ],
//                         onChanged: (String? value) {},
//                         validator: (value) {
//                           if (value == null) {
//                             return 'Please select a ';
//                           }
//                           return null;
//                         }),
//                     //phase
//                     CustomTextFormField(
//                         hintText: 'Phase', controller: _phasesController),

//                     /* _isLoading
//                         ? Center(child: const CircularProgressIndicator())
////                         :  Center(
//                       child: SizedBox(
//                         width: 450,
//                         height: 45,
//                         child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Color(0xff156cf7),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(15),
//                             ),
//                           ),
//                           onPressed: () async {
//                             print('pholength');
//                             print(_phoneNumber.toString().length);

//                             _trySubmitForm();

//                           },
//                           child: SizedBox(
//                             width: 366,
//                             height: 45,
//                             child: Align(
//                                 child: Text(
//                                   'Sign Up'.toUpperCase(),
//                                   style: const TextStyle(
//                                       fontSize: 16, color: Colors.white),
//                                 )),
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 25,),
// */
//                   ],
//                 ),
//               ),
//               Padding(
//                   padding: EdgeInsets.only(
//                       bottom: MediaQuery.of(context).viewInsets.bottom))
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: ClipRRect(
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(20.0),
//           topRight: Radius.circular(20.0),
//         ),
//         child: BottomAppBar(
//           color: Color.fromRGBO(139, 72, 223, 1),
//           child: Container(
//             height: 100,
//             decoration: BoxDecoration(
//               color: Color.fromRGBO(139, 72, 223, 1),
//             ),
//             child: Center(
//               child: SizedBox(
//                 height: 50,
//                 width: 225,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     _trySubmitForm();
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.white,
//                   ),
//                   child: Text(
//                     'Add Events',
//                     style: GoogleFonts.karla(
//                       textStyle: TextStyle(
//                           color: Color.fromRGBO(33, 150, 243, 1),
//                           fontSize: 15,
//                           fontWeight: FontWeight.w400),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
