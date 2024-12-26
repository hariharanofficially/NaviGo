import 'package:EquineApp/data/repo/repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

import '../../../../../data/models/nutrition_model.dart';

part 'nutrition_event.dart';
part 'nutrition_state.dart';

class NutritionBloc extends Bloc<NutritionEvent, NutritionState> {
  NutritionBloc() : super(NutritionLoading()) {
    on<LoadNutrition>((event, emit) async {
      try {
        // Fetch actual nutrition data from the repository
        final List<NutritionModel> nutritionList =
            await nutritionrepo.getAllNutrition();

        // Convert fetched nutrition data into the format required by NutritionLoaded
        final List<Map<String, Object>> nutritionData =
            nutritionList.map((nutrition) {
          String formattedDate =
              DateFormat('dd-MMM-yy').format(nutrition.servingDatetime);
          return {
            "Nutrition": "Food Type",
            "Nutrition2": nutrition.foodTypeName, // Convert double to string
            "Nutrition3":nutrition.feeduomName, // You can customize this as needed
            "Nutrition4":
                nutrition.servingValue.toString(), // Convert double to string
            "NutritionDate": formattedDate ?? '',
            "nutritionId": nutrition.id.toString(),
          } as Map<String, Object>;
        }).toList();
        // final Nutrition = [
        //   {
        //     "Nutrition": "Food Type",
        //     "Nutrition2": "Supplements",
        //     "Nutrition3": "Value",
        //     "Nutrition4": "200",
        //   },
        // ];
        emit(NutritionLoaded(nutritions: nutritionData));
      } catch (e) {
        emit(NutritionError("Failed to load Treatment"));
      }
    });

    on<DeleteNutrition>((event, emit) async {
      try {
        // Call the delete API
        await nutritionrepo.deletenutrition(id: event.nutritionId);

        // Reload nutrition data after deletion
        // final List<NutritionModel> nutritionList =
        //     await nutritionrepo.getAllNutrition();

        // // Convert the data into the required format
        // final List<Map<String, Object>> nutritionData =
        //     nutritionList.map((nutrition) {
        //   String formattedDate =
        //       DateFormat('d\'th\' MMMM').format(nutrition.servingDatetime);
        //   return {
        //     "Nutrition": "Food Type",
        //     "Nutrition2": nutrition.foodTypeName,
        //     "Nutrition3": "Value",
        //     "Nutrition4": nutrition.servingValue.toString(),
        //     "NutritionDate": formattedDate,
        //     "nutritionId": nutrition.id.toString(),
        //   };
        // }).toList();

        emit(NutritionDeleted());
      } catch (e) {
        emit(NutritionDeleted());
      }
    });
  }
}
