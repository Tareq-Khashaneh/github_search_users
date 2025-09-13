import 'package:hive/hive.dart';
import 'package:syncrow_test/features/github_search/data/models/user_model.dart';

abstract class GithubLocalDataSource {
  Future<List<UserModel>> getSearchUsers(String query);
  Future<void> cacheSearchResult(String query, List<UserModel> users);
}

class GithubLocalDataSourceImpl implements GithubLocalDataSource {
  final Box<dynamic> box;
  GithubLocalDataSourceImpl(this.box);

  @override
  Future<List<UserModel>> getSearchUsers(String query) async {
    final cached = box.get('search_$query');

    if (cached != null) {
      return (cached as List).cast<UserModel>();
    }

    print("searchUsers from local: no cached data found for '$query'");
    return [];
  }

  @override
  Future<void> cacheSearchResult(String query, List<UserModel> users) async {
    await box.put('search_$query', users);
    print("Cached ${users.length} users for query '$query'");
  }
}
