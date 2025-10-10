abstract class GenderRepository {
  Future<void> saveGender(String gender);
  String? getGender();
}
