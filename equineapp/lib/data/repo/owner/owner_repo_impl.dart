part of 'owner_repo.dart';

class OwnerRepoImpl implements OwnerRepo {
  Logger logger = new Logger();

  @override
  Future<ApiResponse> addowner({required ownername}) async {
    try {
      var tenantId = await cacheService.getString(name: 'tenantId');

      Map data = {
        "owner": {
          "name": ownername,
          "tenantid": tenantId,
        }
      };
      final String url = '${ApiPath.getUrlPath(ApiPath.addowner())}';
      final response = await httpApiService.postCall(url, data);
      logger.d(response.body.toString());
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body.toString());
        logger.d(responseData.toString());
        int ownerId = responseData['owner']['id'];
        cacheService.setString(name: 'OWNERID', value: ownerId.toString());
        return ApiResponse.fromHttpResponse(response);
      }
      return ApiResponse();
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error While fetching events");
    }
  }

  @override
  Future<ApiResponse> updateowner({required int id, required ownername}) async {
    try {
      var tenantId = await cacheService.getString(name: 'tenantId');

      Map data = {
        "owner": {
          "id": id,
          "name": ownername,
          "tenantid": tenantId,
        }
      };
      final String url = '${ApiPath.getUrlPath(ApiPath.updateowner())}';
      final response = await httpApiService.putCall(url, data);
      logger.d(response.body.toString());
      if (response.statusCode == 200) {
        return ApiResponse.fromHttpResponse(response);
      }
      return ApiResponse();
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error While fetching events");
    }
  }

  @override
  Future<List<Ownername>> getAllOwner() async {
    try {
      final String tenantId = await cacheService.getString(
        name: 'tenantId',
      );
      final String url =
          '${ApiPath.getUrlPath(ApiPath.getAllOwner(tenantId: tenantId))}';
      final response = await httpApiService.getCall(url);
      logger.d(response.body.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        final List<Ownername> owners = (data['owners'] as List)
            .map((owner) => Ownername.fromJson(owner))
            .toList();
        return owners;
      }
      return [];
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error While fetching events");
    }
  }

  @override
  Future<Ownername> getAllOwnerById({required int id}) async {
    try {
      final String url =
          '${ApiPath.getUrlPath(ApiPath.getAllOwnerById(id: id))}';
      final response = await httpApiService.getCall(url);
      logger.d(response.body.toString());
      var responseData = jsonDecode(response.body.toString());
      logger.d(responseData.toString());
      int ownerId = responseData['owner']['id'];
      cacheService.setString(name: 'ownerId', value: ownerId.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        final owner = Ownername.fromJson(data['owner']);
        return owner;
      } else {
        throw RepoException(
            "Failed to fetch rider details. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error While fetching events");
    }
  }

  @override
  Future<void> deleteOwnerById({required int id}) async {
    try {
      final String url = ApiPath.getUrlPath(ApiPath.deleteOwnerById(id: id));
      final response = await httpApiService.deleteCall(url);
      logger.d(response.body.toString());

      if (response.statusCode != 200) {
        throw RepoException("Failed to delete horse");
      }
    } catch (e) {
      logger.e(e.toString());
      throw RepoException("Error while deleting horse");
    }
  }
}
