import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:logger/logger.dart';

import '../../../../../data/models/stable_model.dart';
import '../../../../../data/repo/repo.dart';
import '../../../../common/FormCustomWidget/textform_field.dart';
import '../../../../common/widgets/ProfileImage.dart';
import '../../../manage_dashboard/cards/stable_dashboard/bloc/stable_dashboard_bloc.dart';
import '../../../manage_dashboard/cards/stable_dashboard/view/stable_dashboard_view.dart';
import '../../../../../utils/constants/icons.dart';
import '../bloc/add_stable_bloc.dart';
import '../bloc/add_stable_event.dart';
import '../bloc/add_stable_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddStableScreen extends StatefulWidget {
  final int? stableId; // Optional parameter to edit an existing horse

  const AddStableScreen({
    super.key,
    this.stableId,
  });

  @override
  State<AddStableScreen> createState() => _AddStableScreenState();
}

final _stableformKey = GlobalKey<FormState>();

class _AddStableScreenState extends State<AddStableScreen> {
  bool _isLoading = false;
  Logger logger = new Logger();
  final nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phnoController = TextEditingController();
  bool _isSecondPartVisible = false;
  StableModel? stableName; // Change to nullable type

  Future<void> _trySubmitForm() async {
    final bool? isValid = _stableformKey.currentState?.validate();
    if (isValid == true) {
      setState(() {
        _isLoading = true;
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    phnoController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    if (widget.stableId != null) {
      context.read<AddStableBloc>().add(LoadstablebyId(id: widget.stableId!));
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 80,
            ),
            Text(
              widget.stableId != null ? 'Edit Stable' : 'Add Stable',
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
      body: BlocConsumer<AddStableBloc, AddStableState>(
        listener: (context, state) {
          if (state is AddStableSuccess) {
            logger.d('Stable added successfully!');

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Stable added successfully!')),
            );
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BlocProvider(
                        create: (context) => StableBloc(),
                        child: StableDashboard())));
          } else if (state is StableLoadedbyId) {
            if (widget.stableId != null) {
              nameController.text = state.stable.name;
              stableName = state.stable;
            }
          } else if (state is AddStableFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to add stable: ${state.error}')),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            reverse: true,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 35.0, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  if (stableName != null) // Ensure stableName is not null
                    Stack(
                      children: [
                        // Profile Image
                        Container(
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                if (state is stableImage &&
                                    state.pickedImage != null) {
                                  _showZoomableImage(
                                      context, state.pickedImage);
                                }
                              },
                              child: CircleAvatar(
                                radius: 50,
                                backgroundColor:
                                    Color.fromRGBO(139, 72, 223, 0.1),
                                backgroundImage: state is stableImage &&
                                        state.pickedImage != null
                                    ? FileImage(state.pickedImage!)
                                    : null,
                                child: state is! stableImage
                                    ? ProfileImage(
                                        recordId: stableName!.id.toString(),
                                        tableName: "Stable",
                                        displayPane: "profileImgs",
                                      )
                                    : null,
                              ),
                            ),
                          ),
                        ),
                        // Camera Icon
                        Positioned(
                          top: 75,
                          left: 180,
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.white,
                            child: IconButton(
                              icon: Icon(Icons.camera_alt, size: 20),
                              onPressed: () {
                                context.read<AddStableBloc>().add(PickImage());
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (stableName == null)
                    Stack(
                      children: [
                        Container(
                            child: Center(
                                child: GestureDetector(
                          onTap: () {
                            if (state is stableImage &&
                                state.pickedImage != null) {
                              _showZoomableImage(context, state.pickedImage);
                            }
                          },
                          child: CircleAvatar(
                            radius: 70,
                            backgroundColor: Color.fromRGBO(139, 72, 223, 0.1),
                            backgroundImage: state is stableImage &&
                                    state.pickedImage != null
                                ? FileImage(state.pickedImage!)
                                : null,
                            child: state is! stableImage
                                ? Image.asset(
                                    'assets/images/Stables.png',
                                    width: 200,
                                  )
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
                                context.read<AddStableBloc>().add(PickImage());
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Required Information',
                    style: GoogleFonts.karla(
                      textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: _stableformKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //phase
                        CustomTextFormField(
                          hintText: 'Enter Stable Name',
                          controller: nameController,
                          validate: true,
                          labelText: 'Enter Stable Name',
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
                            hintText: 'Stable Address',
                            controller: addressController,
                            labelText: 'Stable Address',
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Additional Information',
                            style: GoogleFonts.karla(
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomTextFormField(
                            hintText: 'Enter Phone Number',
                            controller: phnoController,
                            labelText: 'Enter Phone Number',
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
                          bottom: MediaQuery.of(context).viewInsets.bottom))
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
                    // _trySubmitForm();
                    if (_stableformKey.currentState?.validate() == true) {
                      print("inside the submit validate");
                      context.read<AddStableBloc>().add(SubmitForm(
                            id: widget.stableId,
                            name: nameController.text,
                            address: addressController.text,
                            phoneNumber: phnoController.text,
                          ));
                      // context
                      //     .read<AddStableBloc>()
                      //     .add(UploadImage(isEdit: widget.stableId != null));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  child: BlocConsumer<AddStableBloc, AddStableState>(
                      listener: (context, state) {
                    if (state is AddStableSuccess) {
                      logger.d('Stable added successfully!');

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Stable added successfully!')),
                      );
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                  create: (context) => StableBloc(),
                                  child: StableDashboard())));
                    } else if (state is AddStableFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text('Failed to add stable: ${state.error}')),
                      );
                    }
                  }, builder: (context, state) {
                    if (state is AddStableLoading) {
                      return CircularProgressIndicator(
                        color: Colors.blue,
                      );
                    } else {
                      return Text(
                        widget.stableId != null
                            ? ' Update Stable'
                            : 'Add Stable',
                        style: GoogleFonts.karla(
                          textStyle: TextStyle(
                              color: Color.fromRGBO(33, 150, 243, 1),
                              fontSize: 15,
                              fontWeight: FontWeight.w400),
                        ),
                      );
                    }
                  }),
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
//   final StableModel stable;
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
//           tableName: "Stable",
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
