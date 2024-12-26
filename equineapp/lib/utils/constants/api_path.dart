import '../../app/config/server_config.dart';

class ApiPath {
  static const String postUserLaunch = 'mindari-auth/user/launch';
  static const String postUserLogin = 'mindari-auth/user/login';
  static const String postUserSignup = 'mindari-auth/user/signup';
  static const String postValidate = 'mindari-auth/auth/validate';

  static String postforgetpassword({required String emailid}) {
    return 'mindari-auth/forgotcredential/userid?emailid=$emailid';
  }

  static String addowner() {
    return 'mindari-tracker/owner';
  }

  static String updateowner() {
    return 'mindari-tracker/owner';
  }

  static String getAllOwner({required String tenantId}) {
    return 'mindari-tracker/owner?tenantid=${tenantId}';
  }

  static String getAllOwnerById({required int id}) {
    return 'mindari-tracker/owner/${id}';
  }

  static String deleteOwnerById({required int id}) {
    return 'mindari-tracker/owner/${id}';
  }

  static String addParticipant() {
    return 'mindari-tracker/participant';
  }

  static String getAllParticipant({required String id}) {
    //return 'mindari-auth//participant?pageNo=0&pageSize=20&tenantId=1';
    return 'mindari-tracker/participant/event/${id}';
  }

  static String getAllParticipantById({required int id}) {
    return 'mindari-tracker/participant/${id}';
  }

  static String updateParticipant() {
    return 'mindari-tracker/participant';
  }

  static String deleteAllParticipant({required int id}) {
    return 'mindari-tracker/participant/${id}';
  }

  static String getAllSubplan() {
    return 'mindari-auth/plans';
  }

  static String getAllSubplanComponents({required int planId}) {
    return 'mindari-auth/plancomponents/plan/${planId}';
  }

  static String getAllPayment() {
    return 'mindari-auth/paymentmodels';
  }

  static String getAllSubPlanComponent({required String id}) {
    return 'mindari-tracker/rider/${id}';
  }

  static String getTenantbyid({required String id}) {
    return 'mindari-auth/tenants?userId=${id}';
  }

  static String getApprovalsByTenant({required String id}) {
    return 'mindari-auth/approval/tenant/${id}';
  }

  static String getRequestsByUser({required String id}) {
    return 'mindari-auth/approval/requester/${id}';
  }

  static String postTenant() {
    return 'mindari-auth/tenants';
  }

  static String postApprovalStatus() {
    return 'mindari-auth/approval/status';
  }

  static String addStable() {
    return 'mindari-tracker/stable/v1';
  }

  static String updateStable() {
    return 'mindari-tracker/stable';
  }

  static String getAllStable(String id) {
    return 'mindari-tracker/stable?tenantid=${id}';
  }

  static String getAllStableById({required int id}) {
    return 'mindari-tracker/stable/${id}';
  }

  static String deleteStableById({required int id}) {
    return 'mindari-tracker/stable/${id}';
  }

  static String addRider() {
    return 'mindari-tracker/rider';
  }

  static String getAllRider({required String id}) {
    return 'mindari-tracker/rider?pageNo=0&pageSize=1000&tenantid=${id}';
  }

  static String getRiderById({required int id}) {
    return 'mindari-tracker/rider/${id}';
  }

  static String updateRider() {
    return 'mindari-tracker/rider';
  }

  static String deleteRiderById({required int id}) {
    return 'mindari-tracker/rider/${id}';
  }

  static String addHorses() {
    return 'mindari-tracker/horse';
  }

  static String getAllHorses({required String id}) {
    return 'mindari-tracker/horse?pageNo=0&pageSize=10&tenantid=${id}';
  }

  static String getHorseById({required int id}) {
    return 'mindari-tracker/horse/${id}';
  }

  static String updateHorse() {
    return 'mindari-tracker/horse';
  }

  static String deleteHorsesById({required int id}) {
    return 'mindari-tracker/horse/${id}';
  }

  static String addTrainer() {
    return 'mindari-tracker/trainers';
  }

  static String getAllTrainer({required String id}) {
    return 'mindari-tracker/trainers?pageNo=0&pageSize=10&tenantid=${id}';
  }

  static String getTrainerById({required int id}) {
    return 'mindari-tracker/trainers/${id}';
  }

  static String updateTrainer() {
    return 'mindari-tracker/trainers';
  }

  static String deleteTrainerById({required int id}) {
    return 'mindari-tracker/trainers/${id}';
  }

  static String addevents() {
    return 'mindari-tracker/event';
  }

  static String addtraning() {
    return 'mindari-tracker/event/training';
  }

  static String updateEvents() {
    return 'mindari-tracker/event';
  }

  static String getAllevents({required String id}) {
    return 'mindari-tracker/event?pageNo=0&pageSize=10&tenantid=${id}';
  }

  static String getAlleventsById({required int id}) {
    return 'mindari-tracker/event/${id}';
  }

  static String deleteEventById({required int id}) {
    return 'mindari-tracker/event/${id}';
  }

  static String getAllEventsByPeriods(String startDate, String endDate) {
    return 'mindari-tracker/event?pageNo=0&pageSize=100&startDate=${startDate}&endDate=${endDate}';
  }

  static String getEventParticipants(String eventId) {
    return 'mindari-tracker/participant/event/${eventId}';
  }

  static String getTrackerParticipant({required String trackerDeviceId}) {
    return 'mindari-tracker/participant/trackerDevice/${trackerDeviceId}';
  }

  static String getTrackerFeed({required String participantId}) {
    return 'mindari-tracker/tracker-feed?participantId=${participantId}';
  }

  static String getTrackerFeed1(
      {required String eventId, required String participantId}) {
    return 'mindari-tracker/tracker-feed?participantId=${participantId}&eventId=${eventId}&currentLoop=1';
  }

  static String getRegisteredDevices(
      {required String userId, required String tenantId}) {
    return 'mindari-tracker/tracker-device?pageNo=0&pageSize=100&userId=${userId}&tenantid=${tenantId}';
  }

  static String getRegisteredDevicesByTenant({required String tenantId}) {
    return 'mindari-tracker/tracker-device?pageNo=0&pageSize=100&tenantid=${tenantId}';
  }

  static String postRegisterDevice() {
    return 'mindari-tracker/tracker-device';
  }

  static String postTrackerFeed() {
    return 'mindari-tracker/tracker-feed';
  }

  static String postshare() {
    return 'mindari-auth/sharecodes/generate/qr';
  }

  static String validateshare() {
    return 'mindari-auth/sharecodes/validate';
  }

  static String getroles() {
    return 'mindari-auth/role';
  }

  static String getAllcountry() {
    return 'mindari-tracker/country';
  }

  static String getAlldivision() {
    return 'mindari-tracker/division';
  }

  static String getAlleventgroup({required String id}) {
    return 'mindari-tracker/event-group';
    //return 'mindari-tracker/event-group?tenantId=${id}';
  }

  static String getAlleventstate() {
    return 'mindari-tracker/event-state';
  }

  static String getAlleventtype({required String id}) {
    return 'mindari-tracker/event-type';
    //return 'mindari-tracker/event-type?tenantId=${id}';
  }

  static String getRolesByUserAndTenant(
      {required String userId, required String tenantId}) {
    return 'mindari-auth/user/tenant/role?userId=${userId}&tenantid=${tenantId}';
    //return 'mindari-tracker/event-type?tenantId=${id}';
  }

  static String getAllbreed() {
    return 'mindari-tracker/breed';
  }

  static String getAllbreeder() {
    return 'mindari-tracker/breeder';
  }

  static String getAllHorsecolor() {
    return 'mindari-tracker/horse-color';
  }

  static String getAllHorsegender() {
    return 'mindari-tracker/horse-gender';
  }

//image upload
  static String getProfileImage(
      String recordId, String tenantId, String tableName, String displayPane) {
    return 'mindari-upload/api/v1/downloadMediaByRecordId?rcordId=${recordId}&tenantid=${tenantId}&tableName=${tableName}&displayPane=${displayPane}';
  }

  static String postimagestable() {
    return 'mindari-upload/api/v1/uploadImages';
  }

//document upload

  static String postuploaddocs() {
    return 'mindari-upload/api/v1/uploadDocuments';
  }

  static String postfetchDocs() {
    return 'mindari-upload/api/v1/fetchDocumentsByRecord';
  }

  static String getdownloadDocs(String tenantId, int docsId) {
    return 'mindari-upload/open/v1/downloadDocument?documentId=${docsId}&tenantid=${tenantId}';
  }

  static String getAlltrackerdevice({required String tenantId}) {
    return 'mindari-tracker/tracker-device?pageNo=0&pageSize=10&tenantid=${tenantId}';
  }

  static String getAlltrackerdevicebyId({required int id}) {
    return 'mindari-tracker/tracker-device/${id}';
  }

  static String postdevicetracker() {
    return 'mindari-tracker/tracker-device';
  }

  static String updatedevicetracker() {
    return 'mindari-tracker/tracker-device';
  }

  static const String getAllProducts = 'products';

  static const String getCategoriesProduct = 'products/category';
  static const String getAllCategories = 'products/categories';

  static String getUrlPath(String path) {
    return ServerConfig.baseUrl + path;
  }

  //profile

  static String addbodymeasurement() {
    return 'mindari-tracker/horseprofile/body';
  }

  static String updatebodymeasurement() {
    return 'mindari-tracker/horseprofile/body';
  }

  static String getAllbodymeasurement(
      {required String tenantId, required String horsesid}) {
    // 'horseprofile/body?tenantid=2&pageNo=0&pageSize=10&horseid=17';
    return 'mindari-tracker/horseprofile/body?tenantid=${tenantId}&pageNo=0&pageSize=10&horsesid=$horsesid';
  }

  static String getAllbodymeasurementbyId({required int id}) {
    return 'mindari-tracker/horseprofile/body/${id}';
  }

  static String getAlltraining(
      {required String tenantId, required String horseid}) {
    return 'mindari-tracker/horseprofile/training?tenantid=${tenantId}&horseid=${horseid}&pageNo=0&pageSize=10&filterText=';
  }

  static String getAlltrainingbyId({required int id}) {
    return 'mindari-tracker/horseprofile/training/${id}';
  }

  static String getAlltreament(
      {required String tenantId, required String horseid}) {
    return 'mindari-tracker/horseprofile/treatment?tenantid=${tenantId}&horseid=${horseid}&pageNo=0&pageSize=10&filterText=';
  }

  static String getAlltreamentbyId({required int id}) {
    return 'mindari-tracker/horseprofile/treatment/${id}';
  }

  static String getAllnutrition(
      {required String tenantId, required String horseid}) {
    return 'mindari-tracker/horseprofile/nutrition?tenantid=${tenantId}&horseid=${horseid}&pageNo=0&pageSize=10&filterText=';
  }

  static String getAllnutritionbyId({required int id}) {
    return 'mindari-tracker/horseprofile/nutrition/${id}';
  }

  static String getAllfarrier(
      {required String tenantId, required String horseid}) {
    return 'mindari-tracker/horseprofile/farrier?tenantid=${tenantId}&horseid=${horseid}&pageNo=0&pageSize=100&filterText=';
  }

  static String getAllfarrierbyId({required int id}) {
    return 'mindari-tracker/horseprofile/farrier/${id}';
  }

  static String addtraining() {
    return 'mindari-tracker/horseprofile/training';
  }

  static String updatetraining() {
    return 'mindari-tracker/horseprofile/training';
  }

  static String addBloodtest() {
    return 'mindari-tracker/horseprofile/bloodtest';
  }

  static String updateBloodtest() {
    return 'mindari-tracker/horseprofile/bloodtest';
  }

  static String getBloodTestResults(
      {required String tenantId, required String horseId}) {
    return 'mindari-tracker/horseprofile/bloodtest?tenantid=${tenantId}&horseid=${horseId}&pageNo=0&pageSize=100&filterText=';
  }

  static String getAllBloodTestResultsbyId({required int id}) {
    return 'mindari-tracker/horseprofile/bloodtest/${id}';
  }

  static String getBloodTestHorseTenantResult(
      {required String tenantId,
      required String horseId,
      required String testDate}) {
    return 'mindari-tracker/horseprofile/bloodtest?tenantid=${tenantId}&horseid=${horseId}&pageNo=0&pageSize=100&filterText=&testDate=${testDate}';
  }

  static String deleteBloodTestById({required String id}) {
    return 'mindari-tracker/horseprofile/bloodtest/${id}';
  }

  static String addtreatment() {
    return 'mindari-tracker/horseprofile/treatment';
  }

  static String updatetreatment() {
    return 'mindari-tracker/horseprofile/treatment';
  }

  static String addnutrition() {
    return 'mindari-tracker/horseprofile/nutrition';
  }

  static String updatenutrition() {
    return 'mindari-tracker/horseprofile/nutrition';
  }

  static String addfarrier() {
    return 'mindari-tracker/horseprofile/farrier';
  }

  static String updatefarrier() {
    return 'mindari-tracker/horseprofile/farrier';
  }

  static String addplanning() {
    return 'mindari-tracker/horseprofile/planning';
  }

  static String updateplanning() {
    return 'mindari-tracker/horseprofile/planning';
  }

  static String getAllplanning(
      {required String tenantId, required String horseId}) {
    return 'mindari-tracker/horseprofile/planning?tenantid=${tenantId}&pageNo=0&pageSize=10&horseid=${horseId}';
  }

  // Master APIs
  static String deleteSurfaceType({required int id}) {
    return 'mindari-tracker/surfaceType/${id}';
  }

  static String getAllSurfaceType({required String tenantId}) {
    return 'mindari-tracker/surfaceType/all?tenantid=${tenantId}&filterText=';
  }

  static String addSurfaceType() {
    return 'mindari-tracker/surfaceType';
  }

  static String updateSurfaceType() {
    return 'mindari-tracker/surfaceType';
  }

  static String deleteTrainingType({required int id}) {
    return 'mindari-tracker/trainingTypes/${id}';
  }

  static String getAllTrainingType({required String tenantId}) {
    return 'mindari-tracker/trainingTypes/all?tenantid=${tenantId}&filterText=';
  }

  static String addTrainingType() {
    return 'mindari-tracker/trainingTypes';
  }

  static String updateTrainingType() {
    return 'mindari-tracker/trainingTypes';
  }

  static String getAllBloodTestElement({required String tenantId}) {
    return 'mindari-tracker/bloodTestElement/paginated?tenantid=${tenantId}&page=0&size=10&filterText=';
  }

  static String deleteBloodTestType({required int id}) {
    return 'mindari-tracker/bloodTestType/${id}';
  }

  static String getAllBloodTestType({required String tenantId}) {
    return 'mindari-tracker/bloodTestType/all?tenantid=${tenantId}&filterText=';
  }

  static String addBloodTestType() {
    return 'mindari-tracker/bloodTestType';
  }

  static String updateBloodTestType() {
    return 'mindari-tracker/bloodTestType';
  }

  static String deleteTreatmentType({required int id}) {
    return 'mindari-tracker/treatmentType/${id}';
  }

  static String getAllTreatmentType({required String tenantId}) {
    return 'mindari-tracker/treatmentType/all?tenantid=${tenantId}&filterText=';
  }

  static String addTreatmentType() {
    return 'mindari-tracker/treatmentType';
  }

  static String updateTreatmentType() {
    return 'mindari-tracker/treatmentType';
  }

  static String deleteFoodType({required int id}) {
    return 'mindari-tracker/foodType/${id}';
  }

  static String getAllFoodType({required String tenantId}) {
    return 'mindari-tracker/foodType/all?tenantid=${tenantId}&filterText=';
  }

  static String addFoodType() {
    return 'mindari-tracker/foodType';
  }

  static String updateFoodType() {
    return 'mindari-tracker/foodType';
  }

  static String deleteFoodUomType({required int id}) {
    return 'mindari-tracker/feedUnitMeasurement/${id}';
  }

  static String getAllFoodUomType({required String tenantId}) {
    return 'mindari-tracker/feedUnitMeasurement/all?tenantid=${tenantId}&filterText=';
  }

  static String addFoodUomType() {
    return 'mindari-tracker/feedUnitMeasurement';
  }

  static String updateFoodUomType() {
    return 'mindari-tracker/feedUnitMeasurement';
  }

  static String deleteshoeType({required int id}) {
    return 'mindari-tracker/shoeType/${id}';
  }

  static String getAllshoeType({required String tenantId}) {
    return 'mindari-tracker/shoeType/all?tenantid=${tenantId}&filterText=';
  }

  static String addshoeType() {
    return 'mindari-tracker/shoeType';
  }

  static String updateshoeType() {
    return 'mindari-tracker/shoeType';
  }

  static String deleteshoeSpecification({required int id}) {
    return 'mindari-tracker/shoeSpecification/${id}';
  }

  static String getAllshoeSpecification({required String tenantId}) {
    return 'mindari-tracker/shoeSpecification/all?tenantid=${tenantId}&filterText=';
  }

  static String addshoeSpecification() {
    return 'mindari-tracker/shoeSpecification';
  }

  static String updateshoeSpecification() {
    return 'mindari-tracker/shoeSpecification';
  }

  static String deleteshoeComplement({required int id}) {
    return 'mindari-tracker/shoeComplement/${id}';
  }

  static String getAllshoeComplement({required String tenantId}) {
    return 'mindari-tracker/shoeComplement/all?tenantid=${tenantId}&filterText=';
  }

  static String addshoeComplement() {
    return 'mindari-tracker/shoeComplement';
  }

  static String updateshoeComplement() {
    return 'mindari-tracker/shoeComplement';
  }

  //profile delete api

  static String deletebodymeasurement({required int id}) {
    return 'mindari-tracker/horseprofile/body/${id}';
  }

  static String deletetraining({required int id}) {
    return 'mindari-tracker/horseprofile/training/${id}';
  }

  static String deletetreatment({required int id}) {
    return 'mindari-tracker/horseprofile/treatment/${id}';
  }

  static String deletenutrition({required int id}) {
    return 'mindari-tracker/horseprofile/nutrition/${id}';
  }

  static String deletefarrier({required int id}) {
    return 'mindari-tracker/horseprofile/farrier/${id}';
  }

  // static String deleteplanning({required int id}) {
  //   return 'mindari-tracker/horse/${id}';
  // }
}
