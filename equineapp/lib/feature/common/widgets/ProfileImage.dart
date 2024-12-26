import 'package:flutter/material.dart';
import 'dart:typed_data';
import '../../../../../../data/repo/repo.dart';

class ProfileImage extends StatelessWidget {
  final String recordId;
  final String tableName;
  final String displayPane;

  const ProfileImage({
    Key? key,
    required this.recordId,
    required this.tableName,
    required this.displayPane,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: uploadsRepo.getProfileImage(
        recordId: recordId,
        tableName: tableName,
        displayPane: displayPane,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return CircleAvatar(
            radius: 50,
            backgroundImage: MemoryImage(snapshot.data!),
            backgroundColor: Colors.transparent,
          );
        } else if (snapshot.hasError) {
          return CircleAvatar(
            radius: 50,
          );
        }
        return const CircularProgressIndicator(); // Show a loading indicator
      },
    );
  }
}
