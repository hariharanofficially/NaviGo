// invoice_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../subscripition/home_dashboard/Single_stable/bloc/single_stable_bloc.dart';
import '../../subscripition/home_dashboard/Single_stable/view/single_stable_view.dart';
import '../bloc/invoice_bloc.dart';
import '../bloc/invoice_event.dart';
import '../bloc/invoice_state.dart';

class InvoiceScreen extends StatefulWidget {
  final String subPlan;
  final DateTime? selectedDate;

  InvoiceScreen({
    Key? key,
    required this.subPlan,
    this.selectedDate,
  }) : super(key: key);

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InvoiceBloc(
        subPlan: widget.subPlan,
        selectedDate: widget.selectedDate ?? now,
      )..add(LoadInvoice()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Back'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: BlocBuilder<InvoiceBloc, InvoiceState>(
                builder: (context, state) {
                  if (state is InvoiceInitial) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is InvoiceLoaded) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Invoice',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          '${DateFormat.yMd().format(state.selectedDate)}/ No.456456',
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          'To: Alex Bets',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                          ),
                        ),
                        Text(
                          'Mail: Bets@gmail.com',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Divider(
                          height: 10,
                          thickness: 2,
                          color: Colors.black,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          'Supscription Plan',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20.0),
                        _buildItemRow(state.subPlan, '', 1000.0),
                        SizedBox(height: 30.0),
                        Divider(
                          height: 10,
                          thickness: 2,
                          color: Colors.black,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Text(
                              'SubtotalTotal: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                                color: Colors.blue,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 100.0),
                              child: Text(
                                '\$1000.0',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 200,
                        ),
                        Row(
                          children: [
                            Text(
                              'Subtotal: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                                color: Colors.black,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 120.0),
                              child: Text(
                                '\$1000.0',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                          height: 40,
                          width: 350,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BlocProvider(
                                          create: (context) =>
                                              SingleStableDashboardBloc(),
                                          child: SingleStableDashboard())));
                            },
                            child: Text(
                              'Send Email',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.black),
                            ),
                          ),
                        )
                      ],
                    );
                  } else {
                    return Text('Something went wrong!');
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItemRow(String item, String description, double price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          item,
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
        Text(
          description,
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
        Text(
          '\$$price',
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
      ],
    );
  }
}
