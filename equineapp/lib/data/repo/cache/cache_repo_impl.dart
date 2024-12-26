
import '../../../utils/exceptions/exceptions.dart';
import '../../service/service.dart';
import 'cache_repo.dart';

class CacheRepoImpl extends CacheRepo {
  @override
  Future<String> getString({required String name}) {
    try {
      return cacheService.getString(name: name);
    }catch (e) {
      throw RepoException("Error while getting cache variable");
    }
  }

  @override
  void setString({required String name, required String value}) {
    try {
      cacheService.setString(name: name, value: value);
    }catch (e) {
      throw RepoException("Error while getting cache variable");
    }
  }

  @override
  Future<int> getInt({required String name}) {
    try {
      return cacheService.getInt(name: name);
    }catch (e) {
      throw RepoException("Error while getting cache variable");
    }
  }

  @override
  void setInt({required String name, required int value}) {
    try {
      cacheService.setInt(name: name, value: value);
    }catch (e) {
      throw RepoException("Error while getting cache variable");
    }
  }

  @override
  Future<bool> getBoolean({required String name}) {
    try {
      return cacheService.getBoolean(name: name);
    }catch (e) {
      throw RepoException("Error while getting cache variable");
    }
  }

  @override
  void setBoolean({required String name, required bool value}) {
    try {
      cacheService.setBoolean(name: name, value: value);
    }catch (e) {
      throw RepoException("Error while getting cache variable");
    }
  }

  @override
  Future<void> clear() async {
    await cacheService.clear();
  }


}