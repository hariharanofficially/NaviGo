import 'package:flutter/material.dart';
import 'package:EquineApp/feature/common/widgets/navigation_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/models/approvalRequest_model.dart';
import '../../nav_bar/Dashboard/bloc/Dashboard_bloc.dart';
import '../../nav_bar/Dashboard/view/Dashboard_view.dart';
import '../../header/app_bar.dart';
import '../../home/home_screen.dart';
import '../../nav_bar/nav_bar.dart';
import '../../subscripition/manage_dashboard/singlestable_menu/bloc/singestablemenu_bloc.dart';
import '../../subscripition/manage_dashboard/singlestable_menu/view/singlestablemenu_view.dart';
import '../bloc/my_requests_bloc.dart';

class MyRequest extends StatefulWidget {
  const MyRequest({super.key});

  @override
  State<MyRequest> createState() => _MyRequestState();
}

class _MyRequestState extends State<MyRequest> {
  int selectedTab = 0;
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    context.read<MyRequestsBloc>().add(const LoadMyRequests());
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyRequestsBloc, MyRequestsState>(
      listener: (context, state) {
        if (state is MyRequestsError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: const CustomAppBar(),
          endDrawer: const NavigitionWidget(),
          body: state is MyRequestsLoading
              ? const Center(child: CircularProgressIndicator())
              : state is MyRequestsLoaded
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
                                  'My Requests',
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
                        
                        Expanded(
                          child: PageView(
                            controller: _pageController,
                            onPageChanged: (index) {
                              setState(() {
                                selectedTab = index;
                              });
                            },
                            children: [
                              // _buildApprovalList(state.myapproval, 'pending'),
                              _buildApprovalList(state.request, 'approved'),
                              // _buildApprovalList(state.myapproval3, 'rejected'),
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

  Widget _buildApprovalList(List<ApprovalRequest> approvals, String type) {
    if (type == 'approved') {
      return ListView.builder(
        itemCount: approvals.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 25.0),
            child: approved(request: approvals[index]),
          );
        },
      );
    } else {
      return Container(); // fallback for unknown type
    }
  }
}

class approved extends StatelessWidget {
  final ApprovalRequest request;

  const approved({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
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
                      this.request.shareCode,
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
                      this.request.role,
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
            if (this.request.approvalStatus == 'rejected')
            Chip(
              label: Text('Rejected'),
              labelStyle: TextStyle(
                  color: Colors.black),
              backgroundColor: Colors.red.shade200,
            ),
            if (this.request.approvalStatus == 'approved')
            Chip(
              label: Text('Approved'),
              labelStyle: TextStyle(
                  color: Colors.black),
              backgroundColor: Colors.green.shade200,
            ),
            if (this.request.approvalStatus == 'pending')
              Chip(
                label: Text('Pending'),
                labelStyle: TextStyle(
                    color: Colors.black),
                backgroundColor: Colors.blue.shade200,
              ),

            SizedBox(width: 10),
            // Text(
            //   this.request.approvalStatus,
            //   style: GoogleFonts.karla(
            //     textStyle: const TextStyle(
            //       color: Colors.black,
            //       fontSize: 13,
            //       fontWeight: FontWeight.w400,
            //     ),
            //   ),
            // ),
            // OutlinedButton(
            //   onPressed: () {
            //     // Add your logic for the revoke action here
            //   },
            //   style: OutlinedButton.styleFrom(
            //     side: const BorderSide(color: Colors.red),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(18.0),
            //     ),
            //   ),
            //   child: const Text(
            //     'Revoke',
            //     style: TextStyle(color: Colors.red),
            //   ),
            // ),
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

// class rejected extends StatelessWidget {
//   final String MyApproval3;

//   const rejected({super.key, required this.MyApproval3});

//   @override
//   Widget build(BuildContext context) {
//      return Column(
//       children: [
//         // Implement the UI for the approved state
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               child: Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       MyApproval3,
//                       style: GoogleFonts.karla(
//                         textStyle: const TextStyle(
//                           color: Colors.black,
//                           fontSize: 15,
//                           fontWeight: FontWeight.w400,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       MyApproval3,
//                       style: GoogleFonts.karla(
//                         textStyle: const TextStyle(
//                           color: Colors.black,
//                           fontSize: 13,
//                           fontWeight: FontWeight.w400,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             OutlinedButton(
//               onPressed: () {
//                 // Add your logic for the revoke action here
//               },
//               style: OutlinedButton.styleFrom(
//                 side: const BorderSide(color: Colors.red),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(18.0),
//                 ),
//               ),
//               child: const Text(
//                 'Revoke',
//                 style: TextStyle(color: Colors.red),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 18),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: List.generate(
//             30,
//             (index) => Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 4.0),
//               child: Container(
//                 width: 4,
//                 height: 4,
//                 decoration: const BoxDecoration(
//                   color: Colors.grey,
//                   shape: BoxShape.circle,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
