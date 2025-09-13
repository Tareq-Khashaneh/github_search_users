import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:syncrow_test/core/services/app_service.dart';
import 'package:syncrow_test/core/utils/network/network_checker.dart';
import 'package:syncrow_test/core/services/network_service.dart';
import 'package:syncrow_test/features/github_search/data/data_sources/local_data_source.dart';
import 'package:syncrow_test/features/github_search/data/repositories/github_repo_impl.dart';
import 'package:syncrow_test/features/github_search/presentation/controllers/github_search_controller.dart';

import '../../data/data_sources/remote_data_source.dart';
import '../../domain/usecases/search_users_use_case.dart';


class GithubSearchBinding extends Bindings {

  @override
  void dependencies() {
    // Core
    final AppService appService = Get.find<AppService>();
    // Data layer
    final remoteDataSource = GithubRemoteDataSourceImpl(appService.networkService);
    final localDataSource = GithubLocalDataSourceImpl(appService.cacheBox);
    final repository = GithubRepoImpl(remoteDataSource,localDataSource,appService.networkInfo);

    // Use cases
    final searchUsers = SearchUsersUseCase(repository);

    // Controller
    Get.put(GithubSearchController(searchUsers, ));
  }
}
