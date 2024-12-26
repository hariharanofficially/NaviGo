import '../../models/SubscriptionPlans_model.dart';

abstract class SubPlanRepo{
  Future<List<SubscriptionPlansModel>> getAllSubplan();
}