import 'package:EquineApp/data/repo/repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

import '../../../../../data/models/farrier_model.dart';
import '../../../../../data/service/service.dart';

part 'farrier_event.dart';
part 'farrier_state.dart';

class FarrierBloc extends Bloc<FarrierEvent, FarrierState> {
  FarrierBloc() : super(FarrierLoading()) {
    on<LoadFarrier>((event, emit) async {
      try {
        final List<FarrierModel> farriers = await farrierrepo.getAllFarrier();

        final farrierData = farriers.map((farrier) {
          String farrierformatte =
              DateFormat('dd-MMM-yy').format(farrier.shoeDatetime);

          return {
            "Farrier": "Fore Limb",
            "Farrier2": "FLS Spec",
            "Farrier3": "FLS Comp",
            "Farrier4": "Hind Limb",
            "Farrier5": "HLS Spec",
            "Farrier6": "HLS Comp",
            "Farrier7": farrier.foreShoeType,
            "Farrier8": farrier.foreShoeSpecification,
            "Farrier9": farrier.foreShoeComplement,
            "Farrier10": farrier.hindShoeType,
            "Farrier11": farrier.hindShoeSpecification,
            "Farrier12": farrier.hindShoeComplement,
            "farrierdate": farrierformatte,
            "farrierId": farrier.id.toString(),
          } as Map<String, Object>; // Cast to Map<String, Object>
        }).toList(); // final Farrier = [
        //   {
        //     "Farrier": "Fore Limb",
        //     "Farrier2": "FLS Spec",
        //     "Farrier3": "FLS Comp",
        //     "Farrier4": "Hind Limb",
        //     "Farrier5": "HLS Spec",
        //     "Farrier6": "HLS Comp",
        //     "Farrier7": "ST 1 Clip",
        //     "Farrier8": "0",
        //     "Farrier9": "Steel Shoe",
        //   },
        // ];
        emit(FarrierLoaded(Farrier: farrierData));
      } catch (e) {
        emit(FarrierError("Failed to load Farrier"));
      }
    });
    on<DeleteFarrier>((event, emit) async {
      try {
        // Call the delete API
        await farrierrepo.deletefarrier(id: event.farrierId);

        // Reload the farriers after deletion
        // final List<FarrierModel> farriers = await farrierrepo.getAllFarrier();

        // // Map the farriers to the required format
        // final farrierData = farriers.map((farrier) {
        //   String farrierFormatted =
        //       DateFormat('d\'th\' MMMM').format(farrier.shoeDatetime);

        //   return {
        //     "Farrier": "Fore Limb",
        //     "Farrier2": "FLS Spec",
        //     "Farrier3": "FLS Comp",
        //     "Farrier4": "Hind Limb",
        //     "Farrier5": "HLS Spec",
        //     "Farrier6": "HLS Comp",
        //     "Farrier7": farrier.foreShoeType,
        //     "Farrier8": farrier.foreShoeSpecification,
        //     "Farrier9": farrier.foreShoeComplement,
        //     "Farrier10": farrier.hindShoeType,
        //     "Farrier11": farrier.hindShoeSpecification,
        //     "Farrier12": farrier.hindShoeComplement,
        //     "farrierdate": farrierFormatted,
        //     "farrierId": farrier.id.toString(),
        //   } as Map<String, Object>; // Cast to Map<String, Object>
        // }).toList();

        // Emit the updated state
        emit(FarrierDeleted());
      } catch (e) {
        emit(FarrierDeleted());
      }
    });
  }
}
