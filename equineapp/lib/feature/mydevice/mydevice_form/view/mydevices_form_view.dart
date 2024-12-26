import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../common/FormCustomWidget/textform_field.dart';
import '../../mydevice_dashboard/bloc/mydevice_bloc.dart';
import '../../mydevice_dashboard/view/my_device_view.dart';
import '../bloc/mydevices_form_bloc.dart';

class MydevicesForm extends StatefulWidget {
  final int? mydevices;

  const MydevicesForm({super.key, this.mydevices});

  @override
  State<MydevicesForm> createState() => _MydevicesFormState();
}

class _MydevicesFormState extends State<MydevicesForm> {
  final _FormKey = GlobalKey<FormState>();
  final _trackerDeviceIdController = TextEditingController();
  final _deviceMacIdController = TextEditingController();
  final _heartRateCensorIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.mydevices != null) {
      context
          .read<MydevicesFormBloc>()
          .add(Loadmydevices(mydevices: widget.mydevices!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MydevicesFormBloc, MydevicesFormState>(
      listener: (BuildContext context, state) {
        if (state is MydevicesFormSubmittedSuccessfully) {
          String message = widget.mydevices != null
              ? 'devices Updated Successfully'
              : 'devices Added Successfully';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BlocProvider(
                      create: (context) => MydeviceBloc(), child: mydevice())));
        } else if (state is MydevicesFormSubmittedFailure) {
          String message = widget.mydevices != null
              ? 'devices Updated failure'
              : 'devices Added failure';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        } else if (state is MydevicesformLoaded) {
          if (widget.mydevices != null) {
            final devices = state.device;
            _trackerDeviceIdController.text = devices.deviceName;
            _deviceMacIdController.text = devices.macId;
            _heartRateCensorIdController.text = devices.hrCensorId;
          }
        }
      },
      builder: (BuildContext context, state) {
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
                  widget.mydevices != null ? 'Edit Device' : 'Add Device',
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
          body: SingleChildScrollView(
              reverse: true,
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 35.0, vertical: 10),
                  child: Form(
                    key: _FormKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Required Information',
                            style: GoogleFonts.karla(
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          CustomTextFormField(
                            hintText: 'TrackerDeviceId',
                            controller: _trackerDeviceIdController,
                            labelText: 'TrackerDeviceId',
                          ),
                          CustomTextFormField(
                            hintText: 'DeviceMacId',
                            controller: _deviceMacIdController,
                            labelText: 'DeviceMacId',
                          ),
                          CustomTextFormField(
                            hintText: 'HeartRateCensorId',
                            controller: _heartRateCensorIdController,
                            labelText: 'HeartRateCensorId',
                          )
                        ]),
                  ))),
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
                                if (_FormKey.currentState!.validate()) {
                                  print("Inside The Submit Validate");
                                  context.read<MydevicesFormBloc>().add(
                                      submitdevice(
                                          id: widget.mydevices,
                                          devicename:
                                              _trackerDeviceIdController.text,
                                          macId: _deviceMacIdController.text,
                                          deviceId: _heartRateCensorIdController
                                              .text));
                                }
                              },
                              child: Text(widget.mydevices != null
                                  ? 'update Device'
                                  : 'Add Device'),
                            ))))),
          ),
        );
      },
    );
  }
}
