import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:syncrow_test/features/github_search/data/data_sources/local_data_source.dart';
import 'package:syncrow_test/features/github_search/domain/entites/user.dart';

import '../../../../core/utils/error/handle_dio_exception.dart';
import '../../../../core/utils/error/failures.dart';
import '../../../../core/utils/network/network_checker.dart';
import '../../domain/repositories/github_repo.dart';
import '../data_sources/remote_data_source.dart';


class GithubRepoImpl extends GithubRepository {
  final GithubRemoteDataSource remoteDataSource;
  final GithubLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  GithubRepoImpl(this.remoteDataSource, this.localDataSource, this.networkInfo);

  @override
  Future<Either<Failure, List<User>>> searchUsers(String query) async {
    try {
      final cached = await localDataSource.getSearchUsers(query);
      if (cached.isNotEmpty) {
        print("loading from cache");
        return Right(cached);
      }

      if (await networkInfo.isConnected) {
        final success = await remoteDataSource.searchUsers(query);

        if (query.isNotEmpty) {
          await localDataSource.cacheSearchResult(query, success);

        }
        return Right(success);
      } else {
        return Left(OfflineFailure(message: 'No internet connection'));
      }
    } on DioException catch (e) {
      return Left(HandleDioException.handleDioError(e));
    }
  }
}
