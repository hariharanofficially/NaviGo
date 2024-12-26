import 'dart:convert';

import 'package:EquineApp/data/models/horse_model.dart';
import 'package:EquineApp/data/models/rider_model.dart';
import 'package:EquineApp/data/models/stable_model.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../../../utils/constants/api_path.dart';
import '../../../utils/exceptions/exceptions.dart';
import '../../models/FoodUom_model.dart';
import '../../models/Horsecolor.dart';
import '../../models/Horsegender.dart';
import '../../models/bloodtest_element.dart';
import '../../models/bloodtest_type.dart';
import '../../models/foodType_model.dart';
import '../../models/shoeSpecification.dart';
import '../../models/shoeType_model.dart';
import '../../models/shoecomplement.dart';
import '../../models/trainermodel.dart';
import '../../models/trainingType.dart';
import '../../models/all_form_model.dart';
import '../../models/country.dart';
import '../../models/registered_device_model.dart';
import '../../models/surfaceType.dart';
import '../../models/treatment_type.dart';
import '../../service/service.dart';
import '../../models/breed.dart';
import '../../models/breeder.dart';
import '../../models/division.dart';
import '../../models/eventgroup.dart';
import '../../models/eventstate.dart';
import '../../models/eventtype.dart';
import '../repo.dart';
part 'dropdown_repo_impl.dart';

abstract class DropdownRepo {
  Future<List<Horsegender>> getAllHorsegender();

  Future<List<Horsecolor>> getAllHorsecolor();
  Future<List<Breed>> getAllbreed();
  Future<List<Breeder>> getAllbreeder();
  Future<List<Division>> getAlldivision();
  Future<List<Eventgroup>> getAlleventgroup();
  Future<List<Eventstate>> getAlleventstate();
  Future<List<Eventtype>> getAlleventtype();
  Future<List<country>> getAllcountry();
  Future<AllFormModel> getAllFormData(); // New method
}
