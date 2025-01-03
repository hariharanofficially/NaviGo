import 'package:EquineApp/data/repo/bodymeasurement/bodymeasurement_repo_impl.dart';
import 'package:EquineApp/data/repo/event/event_repo.dart';
import 'package:EquineApp/data/repo/participant/participant_repo.dart';
import 'package:EquineApp/data/repo/participant/participant_repo_impl.dart';
import 'package:EquineApp/data/repo/payment/payment_repo.dart';
import 'package:EquineApp/data/repo/payment/payment_repo_impl.dart';
import 'package:EquineApp/data/repo/planning/planning_repo_impl.dart';
import 'package:EquineApp/data/repo/role/roles_repo.dart';
import 'package:EquineApp/data/repo/role/roles_repo_impl.dart';
import 'package:EquineApp/data/repo/uploads/uploads_repo.dart';
import 'package:EquineApp/data/repo/uploads/uploads_repo_impl.dart';

import 'SubPlanComponent/SubPlanComponent_repo.dart';
import 'SubPlanComponent/SubPlanComponent_repo_impl.dart';
import 'approval/approval_repo.dart';
import 'approval/approval_repo_impl.dart';
import 'bloodtest/bloodtest_repo.dart';
import 'bloodtest/bloodtest_repo_impl.dart';
import 'bodymeasurement/bodymeasurement_repo.dart';
import 'document_upload/docs_repo.dart';
import 'document_upload/docs_repo_impl.dart';
import 'dropdown/dropdown_repo.dart';
import 'farrier/farrier_repo.dart';
import 'farrier/farrier_repo_impl.dart';
import 'horse/horse_repo.dart';
import 'horse/horse_repo_impl.dart';
import 'masterApis/masterapi_repo.dart';
import 'masterApis/masterapi_repo_impl.dart';
import 'nutrition/nutrition_repo.dart';
import 'nutrition/nutrition_repo_impl.dart';
import 'owner/owner_repo.dart';
import 'planning/planning_repo.dart';
import 'rider/rider_repo.dart';
import 'rider/rider_repo_impl.dart';
import 'subplan/subplan_repo.dart';
import 'subplan/subplan_repo_impl.dart';
import 'package:get_it/get_it.dart';
import 'Sharecode/sharecodes_repo.dart';
import 'Sharecode/sharecodes_repo_impl.dart';
import 'auth/auth_repo.dart';
import 'auth/auth_repo_impl.dart';
import 'cache/cache_repo.dart';
import 'cache/cache_repo_impl.dart';
import 'tenant/tenant_repo.dart';
import 'tenant/tenant_repo_impl.dart';
import 'tracker/tracker_repo.dart';
import 'tracker/tracker_repo_impl.dart';
import 'stable/stable_repo.dart';
import 'stable/stable_repo_impl.dart';
import 'trainer/trainer_repo.dart';
import 'trainer/trainer_repo_impl.dart';
import 'training/training_repo.dart';
import 'training/training_repo_impl.dart';
import 'treatment/treatment_repo.dart';
import 'treatment/treatment_repo_impl.dart';

final getIt = GetIt.instance;

void initRepo() {
  getIt.registerLazySingleton<CacheRepo>(() => CacheRepoImpl());
  getIt.registerLazySingleton<AuthRepo>(() => AuthRepoImpl());
  getIt.registerLazySingleton<TrackerRepo>(() => TrackerRepoImpl());
  getIt.registerLazySingleton<SubPlanRepo>(() => SubPlanRepoImpl());
  getIt.registerLazySingleton<SubPlanComponentRepo>(
      () => SubPlanComponentRepoImpl());
  getIt.registerLazySingleton<HorseRepo>(() => HorseRepoImpl());
  getIt.registerLazySingleton<RiderRepo>(() => RiderRepoImpl());
  getIt.registerLazySingleton<StableRepo>(() => StableRepoImpl());
  getIt.registerLazySingleton<SharecodesRepo>(() => SharecodesRepoImpl());
  getIt.registerLazySingleton<TenantRepo>(() => TenantRepoImpl());
  getIt.registerLazySingleton<PaymentRepo>(() => PaymentRepoImpl());
  getIt.registerLazySingleton<EventRepo>(() => EventRepoimpl());
  getIt.registerLazySingleton<ParticipantRepo>(() => ParticipantRepoImpl());
  getIt.registerLazySingleton<OwnerRepo>(() => OwnerRepoImpl());
  getIt.registerLazySingleton<ApprovalRepo>(() => ApprovalRepoImpl());
  getIt.registerLazySingleton<DropdownRepo>(() => DropdownRepoImpl());
  getIt.registerLazySingleton<UploadsRepo>(() => UploadsRepoImpl());
  getIt.registerLazySingleton<RolesRepo>(() => RolesRepoImpl());
  getIt.registerLazySingleton<MasterApiRepo>(() => MasterApiRepoImpl());
  getIt.registerLazySingleton<BodyMeasurementRepo>(
      () => BodyMeasurementRepoImpl());
  getIt.registerLazySingleton<TrainingRepo>(() => TrainingRepoImpl());
  getIt.registerLazySingleton<TreatmentRepo>(() => TreatmentRepoImpl());
  getIt.registerLazySingleton<NutritionRepo>(() => NutritionRepoImpl());
  getIt.registerLazySingleton<FarrierRepo>(() => FarrierRepoImpl());
  getIt.registerLazySingleton<bloodtestrepo>(() => bloodtestrepoimpl());
  getIt.registerLazySingleton<PlanningRepo>(() => PlanningRepoImpl());
  getIt.registerLazySingleton<TrainerRepo>(() => TrainerRepoImpl());
  getIt.registerLazySingleton<DocsRepo>(() => DocsRepoImpl());
}

CacheRepo get cacheRepo => getIt.get<CacheRepo>();
AuthRepo get authRepo => getIt.get<AuthRepo>();
TrackerRepo get trackerRepo => getIt.get<TrackerRepo>();
SubPlanRepo get subPlanRepo => getIt.get<SubPlanRepo>();
SubPlanComponentRepo get subPlanComponentRepo =>
    getIt.get<SubPlanComponentRepo>();
HorseRepo get horseRepo => getIt.get<HorseRepo>();
RiderRepo get riderrepo => getIt.get<RiderRepo>();
StableRepo get stablerepo => getIt.get<StableRepo>();
SharecodesRepo get sharerepo => getIt.get<SharecodesRepo>();
TenantRepo get tenantrepo => getIt.get<TenantRepo>();
PaymentRepo get paymentrepo => getIt.get<PaymentRepo>();
EventRepo get eventrepo => getIt.get<EventRepo>();
ParticipantRepo get participantrepo => getIt.get<ParticipantRepo>();
OwnerRepo get ownerrepo => getIt.get<OwnerRepo>();
ApprovalRepo get approvalrepo => getIt.get<ApprovalRepo>();
DropdownRepo get dropdownRepo => getIt.get<DropdownRepo>();
UploadsRepo get uploadsRepo => getIt.get<UploadsRepo>();
RolesRepo get rolesrepo => getIt.get<RolesRepo>();
MasterApiRepo get masterApiRepo => getIt.get<MasterApiRepo>();
BodyMeasurementRepo get bodymeasurementrepo => getIt.get<BodyMeasurementRepo>();
TrainingRepo get trainingrepo => getIt.get<TrainingRepo>();
TreatmentRepo get treatmentrepo => getIt.get<TreatmentRepo>();
NutritionRepo get nutritionrepo => getIt.get<NutritionRepo>();
FarrierRepo get farrierrepo => getIt.get<FarrierRepo>();
bloodtestrepo get Bloodtestrepo => getIt.get<bloodtestrepo>();
PlanningRepo get planningrepo => getIt.get<PlanningRepo>();
TrainerRepo get trainerrepo => getIt.get<TrainerRepo>();
DocsRepo get docsRepo => getIt.get<DocsRepo>();
