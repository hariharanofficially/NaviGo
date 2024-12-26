import 'dart:convert';

import 'package:logger/logger.dart';

import '../../../utils/constants/api_path.dart';
import '../../../utils/exceptions/exceptions.dart';
import '../../models/paymentmodel.dart';
import '../../service/service.dart';
import 'payment_repo.dart';

class PaymentRepoImpl implements PaymentRepo {
  Logger logger = new Logger();

@override
  Future<List<Paymentmodel>> getAllPayment() async {
    try {
      final String url = '${ApiPath.getUrlPath(ApiPath.getAllPayment())}';
      final response = await httpApiService.getCall(url);
      logger.d(response.body.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        final List<Paymentmodel> subPaymentModels = (data['subPaymentModels'] as List)
            .map((subPaymentModels) => Paymentmodel.fromJson(subPaymentModels))
            .toList();
        return subPaymentModels;
      }
      return [];
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error while fetching events");
    }
  }
}