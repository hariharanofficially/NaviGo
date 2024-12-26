import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:EquineApp/data/models/api_response.dart';

import '../../../utils/constants/api_path.dart';
import '../../../utils/exceptions/exceptions.dart';
import '../../models/ownername.dart';
import '../../service/service.dart';
part 'owner_repo_impl.dart';

abstract class OwnerRepo {
  Future<ApiResponse> addowner({required ownername});
  Future<ApiResponse> updateowner({required int id, required ownername});
  Future<Ownername> getAllOwnerById({required int id});
  Future<List<Ownername>> getAllOwner();
  Future<void> deleteOwnerById({required int id});
}
