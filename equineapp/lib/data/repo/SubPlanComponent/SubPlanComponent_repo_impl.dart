import 'dart:convert';

import 'package:EquineApp/data/models/SubPlanComponent_model.dart';
import 'package:logger/logger.dart';

import '../../../utils/constants/api_path.dart';
import '../../../utils/exceptions/exceptions.dart';
import '../../service/service.dart';
import 'SubPlanComponent_repo.dart';

class SubPlanComponentRepoImpl implements SubPlanComponentRepo {
  Logger logger = new Logger();
  @override
  Future<List<SubPlanComponentModel>> getAllSubPlanComponent(
      {required int id}) async {
    try {
      final String url =
          '${ApiPath.getUrlPath(ApiPath.getAllSubplanComponents(planId: id))}';
      final response = await httpApiService.getCall(url);
      logger.d(response.body.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        final List<SubPlanComponentModel> planComponents =
            (data['planComponents'] as List)
                .map((planComponents) =>
                    SubPlanComponentModel.fromJson(planComponents))
                .toList();
        return planComponents;
      }
      return [];
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error while fetching events");
    }
  }
}
