import '../../models/SubPlanComponent_model.dart';

abstract class SubPlanComponentRepo{
  Future<List<SubPlanComponentModel>> getAllSubPlanComponent({required int id});
}
