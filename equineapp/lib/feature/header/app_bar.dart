import 'package:EquineApp/feature/generate_qr/bloc/generate_qr_bloc.dart';
import 'package:EquineApp/feature/generate_qr/view/generate_qr_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

// import '../../Subscription_plan/My_Plan/generate_qr.dart';
import '../../utils/constants/icons.dart';
import '../common/widgets/sharecode_popup.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 50,
            ),
            Row(
              children: [
                GestureDetector(
                  child: Iconify(
                    qrScan,
                    color: Color.fromRGBO(234, 146, 53, 1),
                    size: 28,
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const SharecodePopup(showGenerateOnly: false, showlogin: true,); // Display the SharecodePopup
                      },
                    );
                    //  Navigator.push(context, MaterialPageRoute(builder: (context)=>BlocProvider(create:(context)=>QrBloc(),child: GenerateQr())));
                  },
                ),
                SizedBox(
                  width: 12,
                ),
              ],
            )
          ],
        ),
      ),
      actions: [
        Builder(
          builder: (context) => Padding(
            padding: const EdgeInsets.only(right: 25.0),
            child: IconButton(
              icon: Iconify(
                sideMenu,
                color: Color.fromRGBO(234, 146, 53, 1),
                size: 28,
              ),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
          ),
        ),
      ],
    );
  }
}
