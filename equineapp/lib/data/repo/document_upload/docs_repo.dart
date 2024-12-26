import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../../models/api_response.dart';

abstract class DocsRepo {
  Future<void> getdownloadDocs(
    int docsId,
  );
  Future<ApiResponse> postuploaddocs({
    required String recordId,
    required String tableName,
    required String rootLabel,
    required File documents,
    required String displayPane,
  });
  Future<ApiResponse> postfetchDocs({
    required String recordId,
    required String tableName,
    required String displayPane,
  });
}
