import 'dart:convert';

import 'package:logger/logger.dart';

import '../../../utils/constants/api_path.dart';
import '../../../utils/exceptions/exceptions.dart';
import '../../models/SubscriptionPlans_model.dart';
import '../../service/service.dart';
import 'subplan_repo.dart';

class SubPlanRepoImpl implements SubPlanRepo {
  Logger logger = new Logger();
  @override
  Future<List<SubscriptionPlansModel>> getAllSubplan() async {
    try {
      final String url = '${ApiPath.getUrlPath(ApiPath.getAllSubplan())}';
      logger.d(url.toString());
      final response = await httpApiService.getCall(url);
      logger.d(response.body.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        final List<SubscriptionPlansModel> plans = (data['subPlans'] as List)
            .map((p) => SubscriptionPlansModel.fromJson(p))
            .toList();
        return plans;
      }
      return [];
    } catch (e) {
      logger.e(e);
      throw RepoException("Error while fetching events");
    }
  }
}
