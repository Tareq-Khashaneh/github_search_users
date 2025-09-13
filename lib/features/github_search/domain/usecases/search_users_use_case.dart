import 'package:dartz/dartz.dart';

import '../../../../core/utils/error/failures.dart';
import '../entites/user.dart';
import '../repositories/github_repo.dart';

class SearchUsersUseCase {
  final GithubRepository repository;
  SearchUsersUseCase(this.repository);

  Future<Either<Failure, List<User>>> call(String query) async {
    final result = await repository.searchUsers(query);
    return result.map((users) {
      users.sort((a, b) {
        final aPopular = a.publicRepos >= 50;
        final bPopular = b.publicRepos >= 50;

        if (aPopular && !bPopular) return -1;
        if (!aPopular && bPopular) return 1;

        if (aPopular && bPopular) {
          final sixMonthsAgo = DateTime.now().subtract(Duration(days: 180));
          final aActive = a.updatedAt.isAfter(sixMonthsAgo);
          final bActive = b.updatedAt.isAfter(sixMonthsAgo);

          if (aActive && !bActive) return -1;
          if (!aActive && bActive) return 1;
        }

        return 0;
      });

      return users.take(10).toList();
    });
  }
}
