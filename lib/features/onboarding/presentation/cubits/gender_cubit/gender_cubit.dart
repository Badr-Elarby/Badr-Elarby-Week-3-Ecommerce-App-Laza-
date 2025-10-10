import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laza/features/onboarding/data/repositories/gender_repository.dart';

part 'gender_state.dart';

class GenderCubit extends Cubit<GenderState> {
  final GenderRepository _genderRepository;

  GenderCubit(this._genderRepository) : super(GenderInitial());

  String? getGender() {
    try {
      return _genderRepository.getGender();
    } catch (e) {
      emit(GenderError(e.toString()));
      return null;
    }
  }

  Future<void> saveGender(String gender) async {
    emit(GenderLoading());
    try {
      await _genderRepository.saveGender(gender);
      emit(GenderSuccess(gender));
    } catch (e) {
      emit(GenderError(e.toString()));
    }
  }
}
