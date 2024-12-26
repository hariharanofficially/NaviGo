import 'dart:io';

import 'package:EquineApp/data/models/rider_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../data/models/horse_model.dart';
import '../../../../../data/models/registered_device_model.dart';
import '../../../../../data/models/stable_model.dart';
import '../../../../common/FormCustomWidget/dropdownform.dart';
import '../../../../common/widgets/ProfileImage.dart';
import '../../../manage_dashboard/cards/participant_dashboard/bloc/participant_dashboard_bloc.dart';
import '../../../manage_dashboard/cards/participant_dashboard/view/participant_dashboard_view.dart';
import '../bloc/add_participants_bloc.dart';
import '../bloc/add_participants_event.dart';
import '../bloc/add_participants_state.dart';
import '../../../../common/FormCustomWidget/textform_field.dart';
import '../../../../../data/models/participant.dart';

class AddParticipantsScreen extends StatelessWidget {
  final int? horseId; // Optional parameter to edit an existing horse
  String eventId = "";
  AddParticipantsScreen({required this.eventId, this.horseId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddParticipantsBloc(),
      child: AddParticipantsForm(eventId: eventId, horseId: horseId),
    );
  }
}

class AddParticipantsForm extends StatefulWidget {
  final int? horseId; // Optional parameter to edit an existing horse
  String eventId = "";
  AddParticipantsForm({required this.eventId, this.horseId});
  @override
  _AddParticipantsFormState createState() => _AddParticipantsFormState();
}

class _AddParticipantsFormState extends State<AddParticipantsForm> {
  final _AddParticipantsformKey = GlobalKey<FormState>();
  final TextEditingController _startNumberController = TextEditingController();
  // final TextEditingController _eventTypeIdController = TextEditingController();
  // final TextEditingController _riderIdController = TextEditingController();
  // final TextEditingController _horseIdController = TextEditingController();
  final TextEditingController _ownerIdController = TextEditingController();
  final TextEditingController _trackerDeviceIdController =
      TextEditingController();
  final TextEditingController _gatesController = TextEditingController();
  // final TextEditingController _stableController = TextEditingController();
  bool _isSecondPartVisible = false;
  String? _selectedstable;
  String? _selectedrider;
  String? _selectedhorse;
  String? _selecteddevice;
  Participant? participantName;
  List<StableModel> stables = [];
  List<HorseModel> Horses = [];
  List<RiderModel> Rider = [];
  List<RegisteredDevice> trackerDevices = []; // Correct type
  void _trySubmitForm(BuildContext context) {
    final bool isValid =
        _AddParticipantsformKey.currentState!.validate() == true;
    if (isValid) {
      context.read<AddParticipantsBloc>().add(SubmitParticipantsForm(
            //ownername: _ownerIdController.text,
            ownername: "1",
            stablename: _selectedstable.toString(),
            startNumber: _startNumberController.text,
            riderId: _selectedrider.toString(),
            horseId: _selectedhorse.toString(),
            deviceId: _selecteddevice.toString(),
            eventId: widget.eventId,
            id: widget.horseId,
          ));
      context.read<AddParticipantsBloc>().add(UploadPartImage());
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.horseId != null) {
      context
          .read<AddParticipantsBloc>()
          .add(LoadparticipantDetails(participantId: widget.horseId!));
    } else {
      context.read<AddParticipantsBloc>().add(
          Loadfetchparticipant()); // Dispatch FetchRoles when widget is initialized}
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
            SizedBox(width: 40),
            Text(
              widget.horseId != null ? 'Edit Participants' : 'Add Participants',
              // 'Add Participants',
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
      body: BlocConsumer<AddParticipantsBloc, AddParticipantsState>(
        listener: (BuildContext context, AddParticipantsState state) {
          if (state is AddParticipantsSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Participant Added Successfully')),
            );
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BlocProvider(
                        create: (context) => ParticipantBloc(),
                        child: ParticipantDashboard(eventId: widget.eventId))));
          } else if (state is AddParticipantsFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Participant Added Failed')),
            );
          }
          // else if (state is ParticipantsImageUploadedSuccessfully) {
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(content: Text('RiderImageUploadedSuccessfully')),
          //   );
          // } else if (state is ParticipantsImageUploadFailure) {
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(content: Text('RiderImageUploadFailure')),
          //   );
          // }
          else if (state is ParticipantsLoaded) {
            stables = state.allFormModel.stable;
            Horses = state.allFormModel.horse;
            Rider = state.allFormModel.rider;
            trackerDevices = state.allFormModel.trackerDevices;
            if (widget.horseId != null) {
              final participants = state.allFormModel?.participantDetails;
              setState(() {
                _selectedstable = participants?.stableId.toString();
                _startNumberController.text = participants!.startNumber;
                _selectedrider = participants.riderId.toString();
                _selectedhorse = participants.horseId.toString();
                _selecteddevice = participants.trackerDevice.toString();
                _trackerDeviceIdController.text =
                    participants.trackerDevice.toString();
              });
            }
          }
        },
        builder: (BuildContext context, AddParticipantsState state) {
          if (state is ParticipantsLoading) {
            return Center(child: CircularProgressIndicator());
          } else {
            return SingleChildScrollView(
              reverse: true,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 35.0, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const SizedBox(height: 10),
                    // if (participantName != null)
                    //   Row(children: [
                    //     Center(
                    //         child: Container(
                    //       child: ProfileImage(
                    //         recordId: participantName!.id.toString(),
                    //         tableName: "Participant",
                    //         displayPane: 'profileImgs',
                    //       ),
                    //     ))
                    //   ]),
                    // if (participantName == null)
                    //   Stack(
                    //     children: [
                    //       Container(
                    //         child: Center(
                    //             child: GestureDetector(
                    //           onTap: () {
                    //             if (state is participantImage &&
                    //                 state.pickedImage != null) {
                    //               _showZoomableImage(
                    //                   context, state.pickedImage);
                    //             }
                    //           },
                    //           child: CircleAvatar(
                    //               radius: 70,
                    //               backgroundColor:
                    //                   Color.fromRGBO(139, 72, 223, 0.1),
                    //               backgroundImage: state is participantImage &&
                    //                       state.pickedImage != null
                    //                   ? FileImage(state.pickedImage!)
                    //                   : null,
                    //               child: state is! participantImage
                    //                   ? Image.asset(
                    //                       'assets/images/participants.png',
                    //                       height: 100,
                    //                     )
                    //                   : null),
                    //         )),
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
                    //               context
                    //                   .read<AddParticipantsBloc>()
                    //                   .add(PickImage());
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
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Form(
                      key: _AddParticipantsformKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // DropdownButtonFormField<String>(
                          //   hint: Text('Select stable'),
                          //   icon: Icon(Icons.keyboard_arrow_down),
                          //   items: [
                          //     DropdownMenuItem(
                          //       child: Text('Stable'),
                          //       value: 'Stable',
                          //     ),
                          //   ],
                          //   onChanged: (String? value) {},
                          //   validator: (value) {
                          //     if (value == null) {
                          //       return 'Please select a Stable';
                          //     }
                          //     return null;
                          //   },
                          // ),
                          const SizedBox(height: 10),
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
                          // CustomTextFormField(
                          //   hintText: 'Stable Name',
                          //   controller: _stableController,
                          // ),
                          CustomTextFormField(
                            hintText: 'Start Number',
                            controller: _startNumberController,
                            labelText: 'Start Number',
                            validate: true,
                          ),
                          // CustomTextFormField(
                          //   hintText: 'Event type ID',
                          //   controller: _eventTypeIdController,
                          // ),
                          CustomDropdownButtonFormField(
                            hint: 'Rider Name',
                            selectedValue: _selectedrider,
                            items:
                                Rider, // List of gender objects with id and name fields
                            onChanged: (String? value) {
                              setState(() {
                                _selectedrider = value;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a value';
                              }
                              return null; // Validation passed
                            },
                            labelText: 'Rider Name',
                          ),
                          // DropdownButtonFormField<String>(
                          //   hint: Text('Rider Name'),
                          //   value: _selectedrider,
                          //   icon: Icon(Icons.keyboard_arrow_down),
                          //   items: this.Rider.map((riders) {
                          //     return DropdownMenuItem(
                          //       child: Text(riders.name),
                          //       value: riders.id.toString(),
                          //     );
                          //   }).toList(),
                          //   onChanged: (String? value) {
                          //     setState(() {
                          //       _selectedrider = value;
                          //     });
                          //   },
                          //   validator: (value) {
                          //     if (value == null) {
                          //       return 'Please select a Rider Name';
                          //     }
                          //     return null;
                          //   },
                          // ),
                          CustomDropdownButtonFormField(
                            hint: 'Horse Name',
                            selectedValue: _selectedhorse,
                            items:
                                Horses, // List of gender objects with id and name fields
                            onChanged: (String? value) {
                              setState(() {
                                _selectedhorse = value;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a value';
                              }
                              return null; // Validation passed
                            },
                            labelText: 'Horse Name',
                          ),
                          // DropdownButtonFormField<String>(
                          //   hint: Text('Horse Name'),
                          //   value: _selectedhorse,
                          //   icon: Icon(Icons.keyboard_arrow_down),
                          //   items: this.Horses.map((horses) {
                          //     return DropdownMenuItem(
                          //       child: Text(horses.name),
                          //       value: horses.id.toString(),
                          //     );
                          //   }).toList(),
                          //   onChanged: (String? value) {
                          //     setState(() {
                          //       _selectedhorse = value;
                          //     });
                          //   },
                          //   validator: (value) {
                          //     if (value == null) {
                          //       return 'Please select a Horse Name';
                          //     }
                          //     return null;
                          //   },
                          // ),
                          // CustomTextFormField(
                          //   hintText: 'Rider ID',
                          //   controller: _riderIdController,
                          // ),
                          // CustomTextFormField(
                          //   hintText: 'Horse ID',
                          //   controller: _horseIdController,
                          // ),
                          // CustomTextFormField(
                          //   hintText: 'Owner ID',
                          //   controller: _ownerIdController,
                          // ),

                          CustomTextFormField(
                            hintText: 'Gates',
                            controller: _gatesController,
                            labelText: 'Gates',
                            validate: true,
                          ),
                          // const SizedBox(height: 10),

                          DropdownButtonFormField<String>(
                            value: _selecteddevice,
                            icon: Icon(Icons.keyboard_arrow_down),
                            items: this.trackerDevices.map((device) {
                              return DropdownMenuItem(
                                child: Text(device.deviceName),
                                value: device.deviceId.toString(),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                _selecteddevice = value;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: 'Tracker Device',
                              hintText: 'Tracker Device',
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
                            ),
                            validator: (value) {
                              if (value == null) {
                                return 'Please select a Device';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          // if (_isSecondPartVisible) ...[
                          //   CustomTextFormField(
                          //     hintText: 'Tracker Device ID',
                          //     controller: _trackerDeviceIdController,
                          //   ),
                          // ],
                        ],
                      ),
                    ),
                    // const SizedBox(height: 20),
                    // Center(
                    //   child: ElevatedButton.icon(
                    //     onPressed: () {
                    //       setState(() {
                    //         _isSecondPartVisible = !_isSecondPartVisible;
                    //       });
                    //     },
                    //     icon: Icon(_isSecondPartVisible
                    //         ? Icons.keyboard_arrow_up
                    //         : Icons.keyboard_arrow_down),
                    //     label: Text(
                    //         _isSecondPartVisible ? 'Show Less' : 'Show More'),
                    //     style: ElevatedButton.styleFrom(
                    //       backgroundColor: Color.fromRGBO(139, 72, 223, 1),
                    //       foregroundColor: Colors.white,
                    //     ),
                    //   ),
                    // ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                    ),
                  ],
                ),
              ),
            );
          }
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
                    _trySubmitForm(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  child: Text(
                    widget.horseId != null
                        ? 'Update Participants'
                        : 'Add Participants',
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
      ),
    );
  }
}
