import 'package:laza/core/services/local_storage_service.dart';
import 'package:laza/features/onboarding/data/repositories/gender_repository.dart';

class GenderRepositoryImpl implements GenderRepository {
  final LocalStorageService _localStorage;

  GenderRepositoryImpl(this._localStorage);

  @override
  Future<void> saveGender(String gender) async {
    await _localStorage.saveGender(gender);
  }

  @override
  String? getGender() {
    return _localStorage.getGender();
  }
}
