import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:logger/logger.dart';
import '../../../../../data/models/ownername.dart';
import '../../../../common/FormCustomWidget/textform_field.dart';
import '../../../../common/widgets/ProfileImage.dart';
import '../../../../subscripition/manage_dashboard/cards/owner_dashboard/bloc/owner_bloc.dart';
import '../../../../subscripition/manage_dashboard/cards/owner_dashboard/view/owner_view.dart';
import '../../../../../utils/constants/icons.dart';
import '../bloc/owner_bloc.dart';
import '../../../../../app/route/routes/route_path.dart';
import '../../../../../app/route/routes/router.dart';
import '../../../../../feature/common/widgets/custom_app_bar_widget.dart';
import '../../../../../feature/common/widgets/navigation_widget.dart';

class AddOwnerForm extends StatelessWidget {
  final int? ownerId; // Optional parameter to edit an existing horse
  const AddOwnerForm({Key? key, this.ownerId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Addownerbloc(),
      child: _OwnerFormContent(
        ownerId: ownerId,
      ),
    );
  }
}

class _OwnerFormContent extends StatefulWidget {
  final int? ownerId;

  const _OwnerFormContent({super.key, this.ownerId});

  @override
  State<_OwnerFormContent> createState() => _OwnerFormContentState();
}

class _OwnerFormContentState extends State<_OwnerFormContent> {
  Logger logger = new Logger();

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  Ownername? ownerName; // Change to nullable type
  @override
  void initState() {
    super.initState();

    if (widget.ownerId != null) {
      context.read<Addownerbloc>().add(LoadOwnerbyId(id: widget.ownerId!));
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
      endDrawer: const NavigitionWidget(),
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
              widget.ownerId != null ? 'Edit Owner' : 'Add Owner',
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
      body: BlocConsumer<Addownerbloc, AddOwnerState>(
        listener: (context, state) {
          if (state is AddOwnerSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Owner added successfully'),
                duration: Duration(seconds: 2),
              ),
            );
          } else if (state is OwnerLoadedbyId) {
            if (widget.ownerId != null) {
              _nameController.text = state.owner.name;
              ownerName= state.owner;
            }
          } else if (state is AddOwnerFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to add stable: ${state.error}'),
                duration: Duration(seconds: 2),
              ),
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
                  if (ownerName != null) // Ensure stableName is not null
                    Stack(
                      children: [
                        // Profile Image
                        Container(
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                if (state is ownerImage &&
                                    state.pickedImage != null) {
                                  _showZoomableImage(
                                      context, state.pickedImage);
                                }
                              },
                              child: CircleAvatar(
                                radius: 50,
                                backgroundColor:
                                    Color.fromRGBO(139, 72, 223, 0.1),
                                backgroundImage: state is ownerImage &&
                                        state.pickedImage != null
                                    ? FileImage(state.pickedImage!)
                                    : null,
                                child: state is! ownerImage
                                    ? ProfileImage(
                                        recordId: ownerName!.id.toString(),
                                        tableName: "Owner",
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
                                context.read<Addownerbloc>().add(PickImage());
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  // Row(children: [
                  //   Center(
                  //       child: Container(
                  //     child: ProfileImage(
                  //       recordId: ownerName!.id.toString(),
                  //       tableName: 'Owner',
                  //       displayPane: 'profileImgs',
                  //     ),
                  //   ))
                  // ]),
                  if (ownerName == null)
                    Stack(
                      children: [
                        Container(
                            child: Center(
                                child: GestureDetector(
                          onTap: () {
                            if (state is ownerImage &&
                                state.pickedImage != null) {
                              _showZoomableImage(context, state.pickedImage);
                            }
                          },
                          child: CircleAvatar(
                              radius: 70,
                              backgroundColor:
                                  Color.fromRGBO(139, 72, 223, 0.1),
                              backgroundImage: state is ownerImage &&
                                      state.pickedImage != null
                                  ? FileImage(state.pickedImage!)
                                  : null,
                              child: state is! ownerImage
                                  ? Image.asset(
                                      'assets/images/owner.png',
                                      width: 200,
                                    )
                                  : null),
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
                                context.read<Addownerbloc>().add(PickImage());
                              },
                            ),
                          ),
                        )
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
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomTextFormField(
                          controller: _nameController,
                          hintText: 'Enter the owner name',
                          validate: true,
                          labelText: 'Enter the owner name',
                        ),
                      ],
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
                  onPressed: () {
                    // _trySubmitForm();
                    if (_formKey.currentState!.validate() == true) {
                      context.read<Addownerbloc>().add(SubmitForm(
                            id: widget.ownerId,
                            name: _nameController.text,
                          ));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  child: BlocConsumer<Addownerbloc, AddOwnerState>(
                      listener: (context, state) {
                    if (state is AddOwnerSuccess) {
                      logger.d('Stable added successfully!');

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Stable added successfully!')),
                      );
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                  create: (context) => OwnerBloc(),
                                  child: OwnerDashboard())));
                    } else if (state is AddOwnerFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text('Failed to add stable: ${state.error}')),
                      );
                    }
                  }, builder: (context, state) {
                    if (state is AddOwnerLoading) {
                      return CircularProgressIndicator(
                        color: Colors.blue,
                      );
                    } else {
                      return Text(
                        widget.ownerId != null ? ' Update OWNER' : 'Add OWNER',
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

// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// import '../../../app/route/routes/route_path.dart';
// import '../../../app/route/routes/router.dart';
// import '../../../feature/common/widgets/custom_app_bar_widget.dart';
// import '../../../feature/common/widgets/navigation_widget.dart';

// class OwnerForm extends StatefulWidget {
//   const OwnerForm({Key? key});

//   @override
//   State<OwnerForm> createState() => _OwnerFormState();
// }

// class _OwnerFormState extends State<OwnerForm> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();

//   Future<void> _addOwner() async {
//     final String name = _nameController.text.trim(); // Trim any leading or trailing whitespaces

//     if (name.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Please enter a name for the Owner'),
//           duration: Duration(seconds: 2),
//         ),
//       );
//       return; // Stop execution if name is empty
//     }

//     final url = Uri.parse('https://mindari.ae:7449/tracker/mindari-tracker/owner');
//     final token = 'E65E46E89569DAE042027A6AA7D4708E2C49A139A419745855548C16138F633C';

//     try {
//       final response = await http.post(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: jsonEncode({'owner': {'name': '$name'}}),
//       );

//       if (response.statusCode == 200) {
//         // Successfully added owner, show Snackbar
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Owner added successfully'),
//             duration: Duration(seconds: 2),
//           ),
//         );
//       } else {
//         // Error occurred while adding owner, show error message in Snackbar
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Failed to add owner: ${response.body}'),
//             duration: Duration(seconds: 2),
//           ),
//         );
//       }
//     } catch (e) {
//       // Handle network errors
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error: $e'),
//           duration: Duration(seconds: 2),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       endDrawer: const NavigitionWidget(),
//       appBar: CustomAppBarWidget(),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 _buildTextFormField(
//                   controller: _nameController,
//                   labelText: 'Name',
//                   hintText: 'Enter the owner name',
//                 ),
//                 SizedBox(height: 20),
//               ],
//             ),
//           ),
//         ),
//       ),
//       bottomNavigationBar: BottomAppBar(
//         color: Color(0xFF210063),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             ElevatedButton(
//               onPressed: _addOwner,
//               child: Text('ADD OWNER'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 router.go(RoutePath.ownerlist);
//               },
//               child: Text('VIEW OWNERS'),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTextFormField({
//     required TextEditingController controller,
//     required String labelText,
//     required String hintText,
//   }) {
//     return Card(
//       elevation: 2,
//       color: Color(0xFFF3F3F3),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(5),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: TextFormField(
//           controller: controller,
//           style: TextStyle(
//             color: Colors.black,
//           ),
//           decoration: InputDecoration(
//             labelText: labelText,
//             labelStyle: TextStyle(
//               fontWeight: FontWeight.bold,
//               color: Colors.black,
//             ),
//             hintText: hintText,
//             hintStyle: TextStyle(
//               fontSize: 12,
//               color: Colors.black,
//             ),
//             filled: true,
//             fillColor: Color(0xFFF3F3F3),
//             contentPadding: EdgeInsets.fromLTRB(11, 9, 11, 9),
//             border: InputBorder.none,
//           ),
//           validator: (value) {
//             if (value!.isEmpty) {
//               return 'Please enter the $labelText';
//             }
//             return null;
//           },
//         ),
//       ),
//     );
//   }
// }
