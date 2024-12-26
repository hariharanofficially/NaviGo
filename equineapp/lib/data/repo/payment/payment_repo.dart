import '../../models/paymentmodel.dart';

abstract class PaymentRepo{
  Future<List<Paymentmodel>> getAllPayment();
}