abstract class CacheRepo {
  Future<String> getString({required String name});
  void setString({required String name, required String value});

  Future<int> getInt({required String name});
  void setInt({required String name, required int value});

  Future<bool> getBoolean({required String name});
  void setBoolean({required String name, required bool value});

  Future<void> clear();
}