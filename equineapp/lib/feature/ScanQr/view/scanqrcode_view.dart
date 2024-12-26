import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../../../utils/constants/appreance_definition.dart';
import '../bloc/scanqrcode_bloc.dart';

class Scanqrcode extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ScanqrcodeState();
}

class _ScanqrcodeState extends State<Scanqrcode> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  final TextEditingController qrcodecontroller = TextEditingController();

  @override
  void dispose() {
    controller?.dispose();
    qrcodecontroller.dispose();
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (controller != null) {
      controller!.pauseCamera();
    }
    controller?.resumeCamera();
  }

  void _onQRViewCreated(QRViewController qrcontroller) {
    controller = qrcontroller;
    controller!.scannedDataStream.listen((scanData) {
      setState(() {
        qrcodecontroller.text = scanData.code ?? ''; // Populate scanned value
      });
      context.read<QRScannerBloc>().add(QRCodeScanned(scanData.code ?? ''));
      controller!.pauseCamera(); // Optional: Pause the camera after a scan
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 56.0,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          // leading: IconButton(
          //   icon: const Icon(Icons.arrow_back),
          //   onPressed: () {
          //     Navigator.pop(context); // Navigates back when pressed
          //   },
          // ),
          title: Row(
            children: [
              Expanded(
                flex: 1, // Flex for the leading container
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    child: Container(
                      width: 100,
                      height: 30,
                      color: Color(0xFFD9D9D9),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(
                                  context); // Navigates to the previous screen
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Icon(
                                Icons.arrow_back, // Back arrow icon
                                color: Colors.black, // Adjust icon color
                                size: 20, // Adjust icon size
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2, // Flex for the centered text
                child: Center(
                  child: Text(
                    'Authentication',
                    style: TextStyle(
                      fontFamily: 'Karla',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1, // Flex for the trailing container
                child: Align(
                  alignment: Alignment.centerRight,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                    child: Container(
                      width: 100,
                      height: 30,
                      color: Color(0xFFD9D9D9),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: BlocConsumer<QRScannerBloc, QRScannerState>(
        listener: (BuildContext context, QRScannerState state) {
          if (state is QRCodeSubmitSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Your request is sent for approval.')),
            );
            Navigator.pop(context);
          } else if (state is QRCodeSubmitFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to send request. Try again.')),
            );
          }
        },
        builder: (context, state) {
          if (state is QRScannerLoading) {
            return Center(child: CircularProgressIndicator());
          }
          return Column(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Stack(
                  children: [
                    QRView(
                      key: qrKey,
                      onQRViewCreated: _onQRViewCreated,
                      overlay: QrScannerOverlayShape(
                        borderColor: Colors.red,
                        borderRadius: 10,
                        borderLength: 30,
                        borderWidth: 10,
                        cutOutSize: 250,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      const Text(
                        '---------------------------------OR---------------------------------',
                        style: TextStyle(
                          fontFamily: 'Karla',
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Text(
                        'Manually enter the verification code below',
                        style: TextStyle(
                          fontFamily: 'Karla',
                          fontSize: 16,
                          fontWeight: FontWeight.w200,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: 260,
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: qrcodecontroller,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            // labelText: '',
                            // labelStyle: TextStyle(
                            //     fontSize: getTextSize20Value(buttonTextSize),
                            //     fontFamily: 'Karla',
                            //     fontWeight: FontWeight.w100,
                            //     color: Color(0xFF8B48DF)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 2.0),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                            ),
                          ),

                          // validator: (value) {
                          //   if (value!.isEmpty) {
                          //     return "Enter Username";
                          //   }
                          // },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // TextButton(
                      //     onPressed: () {},
                      //     child: const Text(
                      //       'Resend code',
                      //       style: TextStyle(color: Color(0xFF167FFC)),
                      //     )),
                      ElevatedButton(
                          onPressed: () {
                            final code = qrcodecontroller.text;
                            if (code.isNotEmpty) {
                              context
                                  .read<QRScannerBloc>()
                                  .add(QRCodeSubmit(code: code));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(0xFFFE9526), // Hex color code

                            foregroundColor: const Color(0xFF8B48DF),
                            padding: const EdgeInsets.symmetric(horizontal: 60),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(
                                  10.0)), // Adjust the radius as needed
                            ),
                          ),
                          child: const Text(
                            'Submit',
                            style: TextStyle(
                              fontFamily: 'Karla',
                              fontSize: 16,
                              fontWeight: FontWeight.w200,
                              color: Colors.white,
                            ),
                          )),
                      // SizedBox(
                      //   height: 30,
                      // ),
                      // const Text(
                      //   'Your request is sent for approval. ',
                      //   style: TextStyle(
                      //     fontFamily: 'Karla',
                      //     fontSize: 16,
                      //     fontWeight: FontWeight.w300,
                      //     color: Colors.black,
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 30,
                      // ),
                      // Container(
                      //   width: MediaQuery.of(context).size.width,
                      //   color: Colors.white,
                      //   child: Center(
                      //     child: (state is QRCodeScannedState)
                      //         ? Text('Scan result: ${state.code}')
                      //         : const Text('Scan a code'),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        // builder: (context, state) {
        //   return Column(
        //     children: <Widget>[
        //       Expanded(
        //         flex: 3,
        //         child: QRView(
        //           key: qrKey,
        //           onQRViewCreated: _onQRViewCreated,
        //           overlay:
        //           QrScannerOverlayShape(
        //             borderColor: Colors.red,
        //             borderRadius: 10,
        //             borderLength: 30,
        //             borderWidth: 10,
        //             cutOutSize: 300,
        //           ),
        //         ),
        //       ),

        //       Expanded(
        //         flex: 3,
        //         child: Center(
        //           child: (state is QRCodeScannedState)
        //               ? Text('Scan result: ${state.code}')
        //               : Text('Scan a code'),
        //         ),
        //       )
        //     ],
        //   );
        // },
      ),
    );
  }
}
