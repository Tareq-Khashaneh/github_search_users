import 'package:dio/dio.dart';
import 'package:syncrow_test/core/constants/api_endpoint.dart';
import 'package:syncrow_test/core/services/network_service.dart';

import '../models/user_model.dart';

abstract class GithubRemoteDataSource {
  Future<List<UserModel>> searchUsers(String query);
  Future<UserModel> getUserDetails(String username);
}

class GithubRemoteDataSourceImpl implements GithubRemoteDataSource {
  final NetworkService _networkService;

  GithubRemoteDataSourceImpl(this._networkService);

  @override
  Future<List<UserModel>> searchUsers(String query) async {
    final response = await _networkService.request(
      endpoint: Api.search,
      method: RequestMethod.get,
      queryParameters: {'q': query},
    );
    final List items = response.data['items'];
    if (response.statusCode == 200) {
      List<UserModel> users = items
          .map((e) => UserModel.fromJson(e))
          .toList();
      const int maxConcurrent = 5;
      final List<UserModel> result = [];


      for (var i = 0; i < users.length; i += maxConcurrent) {
        final batch = users.skip(i).take(maxConcurrent).toList();
        final details = await Future.wait(batch.map((u) => getUserDetails(u.login)));
        result.addAll(details);
      }

      return result;
    }
    throw DioException(
      response: response,
      requestOptions: response.requestOptions,
      type: DioExceptionType.badResponse,
    );
  }

  @override
  Future<UserModel> getUserDetails(String username) async {
    final response = await _networkService.request(
      endpoint: "${Api.userDetails}/$username",
      method: RequestMethod.get,
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(response.data);
    }
    throw DioException(
      response: response,
      requestOptions: response.requestOptions,
      type: DioExceptionType.badResponse,
    );
  }
}
