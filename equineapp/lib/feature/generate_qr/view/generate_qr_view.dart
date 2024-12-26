import 'dart:convert';

import 'package:EquineApp/feature/generate_qr/bloc/generate_qr_bloc.dart';
import 'package:EquineApp/feature/generate_qr/bloc/generate_qr_event.dart';
import 'package:EquineApp/feature/generate_qr/bloc/generate_qr_state.dart';
import 'package:EquineApp/utils/constants/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';

class GenerateQr extends StatelessWidget {
  const GenerateQr({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QrBloc(),
      child: const GenerateQrView(),
    );
  }
}

class GenerateQrView extends StatefulWidget {
  const GenerateQrView({super.key});

  @override
  _GenerateQrViewState createState() => _GenerateQrViewState();
}

class _GenerateQrViewState extends State<GenerateQrView> {
  String? selectedRole;

  @override
  void initState() {
    super.initState();
    context
        .read<QrBloc>()
        .add(FetchRoles()); // Dispatch FetchRoles when widget is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigates back when pressed
          },
        ),
      ),
      body: BlocConsumer<QrBloc, QrState>(
        listener: (BuildContext context, QrState state) {
          if (state is GenerateQrError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (BuildContext context, QrState state) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Generate / Share Code',
                      style: GoogleFonts.karla(
                        textStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.w700),
                      ),
                      textAlign: TextAlign.center),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Generate and Share code to grant access to your Tenant',
                    style: GoogleFonts.karla(
                      textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: 250,
                    height: 70,
                    child: DropdownButtonFormField<String>(
                      hint: const Padding(
                        padding: EdgeInsets.only(left: 20.0),
                        child: Text('Choose role',
                            style: TextStyle(color: Colors.white)),
                      ),
                      iconEnabledColor: Colors.white,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(35),
                        ),
                        fillColor: const Color.fromRGBO(89, 91, 212, 0.5),
                        filled: true,
                      ),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      value: selectedRole,
                      items: (state is FetchRolesSuccess)
                          ? state.roles.map((role) {
                              return DropdownMenuItem<String>(
                                value: role.id.toString(),
                                child: Text(role.name),
                              );
                            }).toList()
                          : [],
                      onChanged: (String? value) {
                        setState(() {
                          selectedRole = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a role';
                        }
                        return null;
                      },
                    ),
                  ),
                  // Container(
                  //   width: 250,
                  //   height: 70,
                  //   child: DropdownButtonFormField<String>(
                  //     padding: const EdgeInsets.only(left: 20.0),
                  //     hint: const Padding(
                  //       padding: EdgeInsets.only(left: 20.0),
                  //       child: Text('Choose role',
                  //           style: TextStyle(color: Colors.white)),
                  //     ),
                  //     iconEnabledColor: Colors.white,
                  //     decoration: InputDecoration(
                  //       border: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(35),
                  //         gapPadding: 0,
                  //       ),
                  //       fillColor: const Color.fromRGBO(89, 91, 212, 0.5),
                  //       filled: true,
                  //     ),
                  //     icon: const Icon(Icons.keyboard_arrow_down),
                  //     items: const [
                  //       DropdownMenuItem(
                  //         child: Text('trainer'),
                  //         value: '6',
                  //       ),
                  //       DropdownMenuItem(
                  //         child: Text('event_organizer'),
                  //         value: '2',
                  //       ),
                  //     ],
                  //     onChanged: (String? value) {
                  //       if (value != null) {
                  //         context.read<QrBloc>().add(RoleSelected(value));
                  //       }
                  //     },
                  //     validator: (value) {
                  //       if (value == null) {
                  //         return 'Please select a role';
                  //       }
                  //       return null;
                  //     },
                  //   ),
                  // ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (state is GenerateQrLoaded) ...[
                    Image.memory(
                      base64Decode(state.qrCode),
                      width: 200,
                      height: 200,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Scan and share the code',
                      style: GoogleFonts.karla(
                        textStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Iconify(
                            whatsapp,
                            color: const Color.fromRGBO(89, 91, 212, 1),
                            size: 50,
                          ),
                          onPressed: () async {
                            try {
                              final sharecode = state
                                  .sharecode; // Get the sharecode from the state
                              final qrCodeBase64 = state
                                  .qrCode; // Get the QR code as base64 string
                              final qrCodeBytes = base64Decode(qrCodeBase64);

                              // Save the QR code image as a file
                              final directory =
                                  await getApplicationDocumentsDirectory();
                              final filePath = '${directory.path}/qr_code.png';
                              final file = File(filePath);
                              await file.writeAsBytes(qrCodeBytes);

                              final url =
                                  'https://api.whatsapp.com/send?text=$sharecode';

                              // Check if the URL can be launched
                              if (await canLaunch(url)) {
                                // Launch WhatsApp with the text message
                                launch(url);

                                // Share the image (via file)
                                final shareText =
                                    'Share this QR code with others!';
                                Share.shareFiles([filePath], text: shareText);
                              } else {
                                throw 'Could not launch $url';
                              }
                            } catch (e) {
                              print("Error: $e");
                            }
                          },
                        ),
                        SizedBox(
                          width: 50,
                        ),
                        IconButton(
                          icon: Iconify(
                            msg,
                            color: const Color.fromRGBO(89, 91, 212, 1),
                            size: 50,
                          ),
                          onPressed: () async {
                            final sharecode = state
                                .sharecode; // Get the sharecode from the state
                            final qrCodeBase64 = state
                                .qrCode; // Get the QR code as base64 string
                            final qrCodeBytes = base64Decode(qrCodeBase64);

                            // Save the QR code image as a file
                            final directory =
                                await getApplicationDocumentsDirectory();
                            final filePath = '${directory.path}/qr_code.png';
                            final file = File(filePath);
                            await file.writeAsBytes(qrCodeBytes);

                            // Implement sharing functionality with both qrcode and sharecode
                            // final url =
                            //     'mailto:?subject=QR Code&body=$sharecode'; // %0A is for newline
                            final url =
                                'mailto:?subject=QR Code&body=$sharecode';
                            if (await canLaunch(url)) {
                              await launch(url);
                              final shareText =
                                  'Share this QR code with others!';
                              await Share.shareFiles([filePath],
                                  text: shareText);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                        ),
                      ],
                    ),
                  ] else ...[
                    Text('No QR Code'),
                  ],
                  SizedBox(
                    height: 50,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (selectedRole != null) {
                        context.read<QrBloc>().add(RoleSelected(selectedRole!));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please select a role')),
                        );
                      }
                    },
                    child: Text('Generate'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(139, 72, 223, 1),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
