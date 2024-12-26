import 'package:EquineApp/data/models/Horsecolor.dart';
import 'package:EquineApp/data/models/Horsegender.dart';
import 'package:EquineApp/data/models/bloodtest_element.dart';
import 'package:EquineApp/data/models/bloodtest_type.dart';
import 'package:EquineApp/data/models/breed.dart';
import 'package:EquineApp/data/models/breeder.dart';
import 'package:EquineApp/data/models/country.dart';
import 'package:EquineApp/data/models/division.dart';
import 'package:EquineApp/data/models/event_model.dart';
import 'package:EquineApp/data/models/eventgroup.dart';
import 'package:EquineApp/data/models/eventstate.dart';
import 'package:EquineApp/data/models/eventtype.dart';
import 'package:EquineApp/data/models/horse_model.dart';
import 'package:EquineApp/data/models/participant.dart';
import 'package:EquineApp/data/models/registered_device_model.dart';
import 'package:EquineApp/data/models/rider_model.dart';
import 'FoodUom_model.dart';
import 'bloodtest_result.dart';
import 'farrier_model.dart';
import 'foodType_model.dart';
import 'nutrition_model.dart';
import 'shoeSpecification.dart';
import 'shoeType_model.dart';
import 'shoecomplement.dart';
import 'stable_model.dart';
import '../../data/models/training_model.dart';
import '../../data/models/trainingType.dart';
import '../../data/models/surfaceType.dart';
import 'trainermodel.dart';
import 'treatment_model.dart';
import 'treatment_type.dart';

class AllFormModel {
  final List<StableModel> stable;
  final List<RiderModel> rider;

  final List<HorseModel> horse;

  final List<Breed> breed;
  final List<Breeder> breeder;
  final List<country> birthcountry;
  final List<Division> division;
  final List<Eventgroup> eventgroup;
  final List<Eventstate> eventstate;
  final List<Eventtype> eventtype;
  final List<Horsegender> horsegender; // Correct type
  final List<Horsecolor> horsecolor;
  final List<RegisteredDevice> trackerDevices; // Correct type
  final List<SurfaceType> surfaceType; // Correct type
  final List<TrainingType> trainingType; // Correct type
  final List<BloodTestElement> bloodtestelement; // Correct type
  final List<BloodTestType> bloodtestType; // Correct type
  final List<TreatmentType> treatmentType; // Correct type
  final List<FoodType> foodtype; // Correct type
  final List<FoodUomType> fooduomtype; // Correct type
  final List<shoeType> shoetype;
  final List<shoeSpecification> shoespecf;
  final List<shoeComplement> shoecomp;
  late HorseModel horseDetail;
  late NutritionModel nutritionDetail;
  late FarrierModel farrierDetail;
  late TreatmentModel treatmentDetail;
  TrainingModel? trainingDetail;

  late RiderModel riderDetail;
  TrainerModel? trainerDetail;
  EventModel? eventDetail;
  late Participant participantDetails;
  late BloodTestResult bloodtestDetails;

  AllFormModel({
    required this.stable,
    required this.rider,
    required this.horse,
    required this.breeder,
    required this.breed,
    required this.birthcountry,
    required this.division,
    required this.eventgroup,
    required this.eventstate,
    required this.eventtype,
    required this.horsecolor,
    required this.horsegender,
    required this.trackerDevices,
    required this.surfaceType,
    required this.trainingType,
    required this.bloodtestelement,
    required this.bloodtestType,
    required this.treatmentType,
    required this.foodtype,
    required this.fooduomtype,
    required this.shoetype,
    required this.shoespecf,
    required this.shoecomp,
  });
}
