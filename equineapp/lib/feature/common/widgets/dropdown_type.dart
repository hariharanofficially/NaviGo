import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../header/app_bar.dart';
import '../../nav_bar/nav_bar.dart';
import 'navigation_widget.dart';

class Dropdowntype extends StatefulWidget {
  final String title;
  final Function(int id, String name) onEdit;
  final Function(int Id) onDelete;
  final VoidCallback onTap;
  final List<Map<String, dynamic>> trainingList;

  const Dropdowntype(
      {super.key,
      required this.title,
      required this.onEdit,
      required this.onDelete,
      required this.onTap,
      required this.trainingList});

  @override
  State<Dropdowntype> createState() => _DropdowntypeState();
}

class _DropdowntypeState extends State<Dropdowntype> {
  int selectedTab = 0;

  // List<Map<String, dynamic>> trainingList = [
  //   {'id': 1, 'name': 'name'},
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      endDrawer: NavigitionWidget(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.redAccent),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFE5E5FC),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: const EdgeInsets.fromLTRB(10, 10, 25, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.title,
                              style: GoogleFonts.karla(
                                textStyle: TextStyle(
                                  color: Color(0xFF595BD4),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            SizedBox(width: 25),
                            GestureDetector(
                              onTap: widget.onTap,
                              child: Container(
                                width: 30,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Color(0xFF595BD4),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // List of training data
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.trainingList.length,
                itemBuilder: (context, index) {
                  final training = widget.trainingList[index];

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(
                        training['name'],
                        style: GoogleFonts.karla(
                          textStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      onTap: () {
                        // Pass the selected training ID (for backend) and show the name in UI
                        Navigator.pop(context, {
                          'id': training['id'], // Pass this to the backend
                          'name': training['name'] // Show this in the UI
                        });
                      },
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                widget.onEdit(
                                  int.parse(training['id']
                                      .toString()), // Send ID to the backend
                                  training[
                                      'name'], // Display name in the frontend
                                );
                              }),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              widget.onDelete(
                                  int.parse(training['id'].toString()));
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavBar(
        pageIndex: selectedTab,
      ),
    );
  }
}
