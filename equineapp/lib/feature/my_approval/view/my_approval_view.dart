import 'package:EquineApp/feature/my_approval/bloc/my_approval_bloc.dart';
import 'package:flutter/material.dart';
import 'package:EquineApp/feature/common/widgets/navigation_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/models/approvalRequest_model.dart';
import '../../nav_bar/Dashboard/bloc/Dashboard_bloc.dart';
import '../../nav_bar/Dashboard/view/Dashboard_view.dart';
import '../../header/app_bar.dart';
import '../../../feature/common/widgets/custom_searchbar.dart';
import '../../home/home_screen.dart';
import '../../nav_bar/nav_bar.dart';
import '../../subscripition/manage_dashboard/singlestable_menu/bloc/singestablemenu_bloc.dart';
import '../../subscripition/manage_dashboard/singlestable_menu/view/singlestablemenu_view.dart';

class MyApproval extends StatefulWidget {
  const MyApproval({super.key});

  @override
  State<MyApproval> createState() => _MyApprovalState();
}

class _MyApprovalState extends State<MyApproval> {
  int selectedTab = 0;
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    context.read<MyApprovalBloc>().add(const LoadMyApproval());
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyApprovalBloc, MyApprovalState>(
      listener: (context, state) {
        if (state is MyApprovalError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: const CustomAppBar(),
          endDrawer: const NavigitionWidget(),
          body: state is MyApprovalLoading
              ? const Center(child: CircularProgressIndicator())
              : state is MyApprovalLoaded
                  ? Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back,
                                  color: Colors.redAccent),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE5E5FC),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                padding:
                                    const EdgeInsets.fromLTRB(80, 15, 80, 15),
                                child: Text(
                                  'Approvals',
                                  style: GoogleFonts.karla(
                                    textStyle: const TextStyle(
                                      color: Color(0xFF595BD4),
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // const Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Text(
                        //       'Select',
                        //       style: TextStyle(
                        //         fontFamily: 'Karla',
                        //         fontWeight: FontWeight.w200,
                        //         fontSize: 10,
                        //       ),
                        //     ),
                        //     Align(
                        //         alignment: Alignment.centerRight,
                        //         child: CustomSearchBar(
                        //           width: 100,
                        //           height: 30,
                        //         )),
                        //   ],
                        // ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildTabButton('Pending', 0),
                            _buildTabButton('Approved', 1),
                            _buildTabButton('Rejected', 2),
                          ],
                        ),
                        const Divider(thickness: 2),
                        Expanded(
                          child: PageView(
                            controller: _pageController,
                            onPageChanged: (index) {
                              setState(() {
                                selectedTab = index;
                              });
                            },
                            children: [
                              _buildApprovalList(state.pending, 'pending'),
                              _buildApprovalList(state.approved, 'approved'),
                              _buildApprovalList(state.rejected, 'rejected'),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Container(),
          // floatingActionButtonLocation:
          //     FloatingActionButtonLocation.centerDocked,
          // floatingActionButton: Container(
          //   margin: const EdgeInsets.only(top: 80),
          //   height: 64,
          //   width: 64,
          //   child: FloatingActionButton(
          //     backgroundColor: Colors.white,
          //     elevation: 0,
          //     onPressed: () => Navigator.push(context,
          //         MaterialPageRoute(builder: (context) => const HomeScreen())),
          //     shape: RoundedRectangleBorder(
          //       side: const BorderSide(
          //           width: 1.5, color: Color.fromRGBO(254, 149, 38, 0.7)),
          //       borderRadius: BorderRadius.circular(100),
          //     ),
          //     child: Image.asset('assets/images/Racing.png'),
          //   ),
          // ),
          bottomNavigationBar: NavBar(
            pageIndex: selectedTab,
          ),
        );
      },
    );
  }

  Widget _buildTabButton(String title, int index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton(
          onPressed: () {
            setState(() {
              selectedTab = index;
              _pageController.animateToPage(index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn);
            });
          },
          child: Text(
            title,
            style: TextStyle(
              color: selectedTab == index ? Colors.blue : Colors.black,
              fontWeight:
                  selectedTab == index ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
        if (selectedTab == index)
          Container(
            height: 4,
            width: 60,
            color: Colors.green, // Green bar color
            margin: const EdgeInsets.only(top: 2),
          ),
      ],
    );
  }

  Widget _buildApprovalList(List<ApprovalRequest> approvals, String type) {
    if (approvals.isEmpty) {
      return Center(
        child: Text(
          'No data available',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      );
    }
    if (type == 'pending') {
      return ListView.builder(
        itemCount: approvals.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: pending(request: approvals[index]),
          );
        },
      );
    } else if (type == 'approved') {
      return ListView.builder(
        itemCount: approvals.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 25.0),
            child: approved(request: approvals[index]),
          );
        },
      );
    } else if (type == 'rejected') {
      return ListView.builder(
        itemCount: approvals.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 25.0),
            child: rejected(request: approvals[index]),
          );
        },
      );
    } else {
      return Container(); // fallback for unknown type
    }
  }
}

class pending extends StatefulWidget {
  final ApprovalRequest request;

  const pending({super.key, required this.request});

  @override
  _pendingState createState() => _pendingState();
}

class _pendingState extends State<pending> {
  bool _isResendElevated = false;
  bool _isDenyElevated = false;
  bool _isAcceptElevated = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      widget.request.requestedFirstName +
                          ' ' +
                          widget.request.requestedLastName,
                      style: GoogleFonts.karla(
                        textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Role: ' + widget.request.role,
                      style: GoogleFonts.karla(
                        textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      //textAlign: TextAlign.right
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Text(
                  //   widget.MyApproval,
                  //   style: GoogleFonts.karla(
                  //     textStyle: const TextStyle(
                  //       color: Colors.black,
                  //       fontSize: 13,
                  //       fontWeight: FontWeight.w400,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // _buildActionButton(
                //   label: 'Resend',
                //   color: const Color(0xFF8B48DF),
                //   isElevated: _isResendElevated,
                //   onPressed: () {
                //     setState(() {
                //       _isResendElevated = !_isResendElevated;
                //     });
                //   },
                //   icon: Icons.refresh,
                // ),
                const SizedBox(width: 10),
                _buildActionButton(
                  label: 'Deny',
                  color: const Color(0xFFCF142B),
                  isElevated: _isDenyElevated,
                  onPressed: () {
                    setState(() {
                      _isDenyElevated = !_isDenyElevated;
                    });
                    context.read<MyApprovalBloc>().add(RejectRequestEvent(
                          id: widget.request.id,
                        ));
                  },
                  icon: Icons.cancel,
                ),
                const SizedBox(width: 10),
                _buildActionButton(
                  label: 'Accept',
                  color: const Color(0xFF34A853),
                  isElevated: _isAcceptElevated,
                  onPressed: () {
                    setState(() {
                      _isAcceptElevated = !_isAcceptElevated;
                    });
                    context.read<MyApprovalBloc>().add(ApproveRequestEvent(
                          id: widget.request.id,
                        ));
                  },
                  icon: Icons.check,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            30,
            (index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required Color color,
    required bool isElevated,
    required VoidCallback onPressed,
    required IconData icon,
  }) {
    return Flexible(
      child: isElevated
          ? ElevatedButton.icon(
              onPressed: onPressed,
              icon: Icon(icon, size: 16),
              label: Text(
                label,
                style: const TextStyle(fontSize: 12),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                minimumSize: const Size(42, 30), // Set the button size
              ),
            )
          : OutlinedButton.icon(
              onPressed: onPressed,
              icon: Icon(icon, size: 16, color: color),
              label: Text(
                label,
                style: TextStyle(color: color, fontSize: 12),
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(42, 30), // Set the button size
                side: BorderSide(
                  color: color,
                ),
              ),
            ),
    );
  }
}

class approved extends StatelessWidget {
  final ApprovalRequest request;

  const approved({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    bool _isSelected = false;
    return Column(
      children: [
        // Implement the UI for the approved state
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      this.request.requestedFirstName,
                      style: GoogleFonts.karla(
                        textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      this.request.requestedEmail,
                      style: GoogleFonts.karla(
                        textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(-10, 0), // Move slightly to the left
              child: OutlinedButton(
                onPressed: () {
                  context.read<MyApprovalBloc>().add(RevokeRequestEvent(
                        id: request.id,
                      ));
                  // Add your logic for the revoke action here
                },
                style: OutlinedButton.styleFrom(
                  side:
                      BorderSide(color: _isSelected ? Colors.red : Colors.red),
                  backgroundColor: _isSelected
                      ? Colors.red
                      : Colors.transparent, // Change background color on select
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
                child: Text(
                  'Revoke',
                  style: TextStyle(
                      color: _isSelected
                          ? Colors.white
                          : Colors.red), // Change text color on select
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            30,
            (index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class rejected extends StatelessWidget {
  final ApprovalRequest request;

  const rejected({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    bool _isSelected = false;

    return Column(
      children: [
        // Implement the UI for the approved state
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      this.request.requestedFirstName,
                      style: GoogleFonts.karla(
                        textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      this.request.requestedEmail,
                      style: GoogleFonts.karla(
                        textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(-10, 0), // Move slightly to the left(
              child: OutlinedButton(
                onPressed: () {
                  // Add your logic for the revoke action here
                  context.read<MyApprovalBloc>().add(RevokeRequestEvent(
                        id: request.id,
                      ));
                },
                style: OutlinedButton.styleFrom(
                  side:
                      BorderSide(color: _isSelected ? Colors.red : Colors.red),
                  backgroundColor: _isSelected
                      ? Colors.red
                      : Colors.transparent, // Change background color on select
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
                child: Text(
                  'Revoke',
                  style: TextStyle(
                      color: _isSelected
                          ? Colors.white
                          : Colors.red), // Change text color on select
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            30,
            (index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
