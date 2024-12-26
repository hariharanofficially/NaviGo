import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

import '../../../utils/constants/icons.dart';

class selectImage extends StatefulWidget {
  const selectImage({super.key});

  @override
  State<selectImage> createState() => _selectImageState();
}

class _selectImageState extends State<selectImage> {
  @override
  Widget build(BuildContext context) {
    return   Stack(
      children: [
        Container(child: Center(child: Image.asset('assets/images/editprofile.png',height: 120,))),
        Positioned(
          top:75,
          left: 200,
          child: CircleAvatar(radius:15,backgroundColor:Colors.white,child: Iconify(camera,size: 24,)),
        )
      ],
    );
  }
}
