part of 'dropdown_repo.dart';

class DropdownRepoImpl implements DropdownRepo {
  final Logger logger = Logger();

  @override
  Future<List<Horsegender>> getAllHorsegender() async {
    try {
      final String url = '${ApiPath.getUrlPath(ApiPath.getAllHorsegender())}';
      final response = await httpApiService.getCall(url);
      logger.d(response.body.toString());

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        final List<Horsegender> genders = (data['horseGenders'] as List)
            .map((genders) => Horsegender.fromJson(genders))
            .toList();

        return genders;
      } else {
        return [];
      }
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error While fetching horsegender");
    }
  }

  @override
  Future<List<Horsecolor>> getAllHorsecolor() async {
    try {
      final String url = '${ApiPath.getUrlPath(ApiPath.getAllHorsecolor())}';
      final response = await httpApiService.getCall(url);
      logger.d(response.body.toString());

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        final List<Horsecolor> colors = (data['horseColors'] as List)
            .map((colors) => Horsecolor.fromJson(colors))
            .toList();

        return colors;
      } else {
        return [];
      }
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error While fetching horsecolor");
    }
  }

  @override
  Future<List<Breed>> getAllbreed() async {
    try {
      final String url = '${ApiPath.getUrlPath(ApiPath.getAllbreed())}';
      final response = await httpApiService.getCall(url);
      logger.d(response.body.toString());

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        final List<Breed> breeds = (data['breeds'] as List)
            .map((breed) => Breed.fromJson(breed))
            .toList();

        return breeds;
      } else {
        return [];
      }
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error While fetching Breed");
    }
  }

  @override
  Future<List<Breeder>> getAllbreeder() async {
    ;
    try {
      final String url = '${ApiPath.getUrlPath(ApiPath.getAllbreeder())}';
      final response = await httpApiService.getCall(url);
      logger.d(response.body.toString());

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        final List<Breeder> breeders = (data['breeders'] as List)
            .map((breeders) => Breeder.fromJson(breeders))
            .toList();

        return breeders;
      } else {
        return [];
      }
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error While fetching Breeder");
    }
  }

  @override
  Future<List<Division>> getAlldivision() async {
    try {
      final String url = '${ApiPath.getUrlPath(ApiPath.getAlldivision())}';
      final response = await httpApiService.getCall(url);
      logger.d(response.body.toString());

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        final List<Division> divisions = (data['divisions'] as List)
            .map((divisions) => Division.fromJson(divisions))
            .toList();

        return divisions;
      } else {
        return [];
      }
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error While fetching Division");
    }
  }

  @override
  Future<List<Eventgroup>> getAlleventgroup() async {
    try {
      var tenantId = await cacheService.getString(name: 'tenantId');

      final String url =
          '${ApiPath.getUrlPath(ApiPath.getAlleventgroup(id: tenantId))}';
      final response = await httpApiService.getCall(url);
      logger.d(response.body.toString());

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        final List<Eventgroup> eventGroups = (data['eventGroups'] as List)
            .map((eventGroups) => Eventgroup.fromJson(eventGroups))
            .toList();

        return eventGroups;
      } else {
        return [];
      }
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error While fetching Eventgroup");
    }
  }

  @override
  Future<List<Eventstate>> getAlleventstate() async {
    try {
      final String url = '${ApiPath.getUrlPath(ApiPath.getAlleventstate())}';
      final response = await httpApiService.getCall(url);
      logger.d(response.body.toString());

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        final List<Eventstate> eventStates = (data['eventStates'] as List)
            .map((eventStates) => Eventstate.fromJson(eventStates))
            .toList();

        return eventStates;
      } else {
        return [];
      }
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error While fetching eventstate");
    }
  }

  @override
  Future<List<Eventtype>> getAlleventtype() async {
    try {
      var tenantId = await cacheService.getString(name: 'tenantId');

      final String url =
          '${ApiPath.getUrlPath(ApiPath.getAlleventtype(id: tenantId))}';
      final response = await httpApiService.getCall(url);
      logger.d(response.body.toString());

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        final List<Eventtype> eventTypes = (data['eventTypes'] as List)
            .map((eventTypes) => Eventtype.fromJson(eventTypes))
            .toList();

        return eventTypes;
      } else {
        return [];
      }
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error While fetching Eventtype");
    }
  }

  @override
  Future<List<country>> getAllcountry() async {
    try {
      final String url = '${ApiPath.getUrlPath(ApiPath.getAllcountry())}';
      final response = await httpApiService.getCall(url);
      logger.d(response.body.toString());

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        final List<country> countries = (data['countries'] as List)
            .map((countries) => country.fromJson(countries))
            .toList();

        return countries;
      } else {
        return [];
      }
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error While fetching Eventtype");
    }
  }

  @override
  Future<AllFormModel> getAllFormData() async {
    try {
      var tenantId = await cacheService.getString(name: 'tenantId');

      final List<Horsegender> horseGenders = await getAllHorsegender();
      final List<Horsecolor> horseColors = await getAllHorsecolor();
      final List<Breed> breeds = await getAllbreed();
      final List<Breeder> breeders = await getAllbreeder();
      final List<Division> divisions = await getAlldivision();
      final List<Eventgroup> eventGroups = await getAlleventgroup();
      final List<Eventstate> eventStates = await getAlleventstate();
      final List<Eventtype> eventTypes = await getAlleventtype();
      final List<country> countries = await getAllcountry();
      final List<StableModel> stables = await stablerepo.getAllStable(tenantId);
      final List<RiderModel> riders = await riderrepo.getAllRider();
      final List<HorseModel> horses =
          await horseRepo.getAllHorses(tenantId: tenantId);
      final List<RegisteredDevice> trackerDevices =
          await trackerRepo.getRegisteredDevicesByTenantId(tenantId: tenantId);
      final List<SurfaceType> surface =
          await masterApiRepo.getAllSurfaceTypes();
      final List<TrainingType> training =
          await masterApiRepo.getAllTrainingTypes();
      final List<BloodTestElement> bloodtestelement =
          await masterApiRepo.getAllBloodTestElement();
      final List<BloodTestType> bloodtesttype =
          await masterApiRepo.getAllBloodTestTypes();
      final List<TreatmentType> treatmenttype =
          await masterApiRepo.getAllTreatmentType();
      final List<FoodType> foodtype = await masterApiRepo.getAllFoodType();
      final List<FoodUomType> fooduomtype = await masterApiRepo.getAllFoodUom();
      final List<shoeType> shoetype = await masterApiRepo.getAllshoeType();
      final List<shoeSpecification> shoespecf =
          await masterApiRepo.getAllshoeSpecification();
      final List<shoeComplement> shoecomp =
          await masterApiRepo.getAllshoeComplement();
      return AllFormModel(
        breed: breeds,
        breeder: breeders,
        birthcountry: countries,
        division: divisions,
        eventgroup: eventGroups,
        eventstate: eventStates,
        eventtype: eventTypes,
        horsecolor: horseColors,
        horsegender: horseGenders,
        stable: stables,
        rider: riders,
        horse: horses,
        trackerDevices: trackerDevices,
        trainingType: training,
        surfaceType: surface,
        bloodtestelement: bloodtestelement,
        bloodtestType: bloodtesttype,
        treatmentType: treatmenttype,
        foodtype: foodtype,
        fooduomtype: fooduomtype,
        shoetype: shoetype,
        shoespecf: shoespecf,
        shoecomp: shoecomp,
      );
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error While fetching all form data");
    }
  }
}
