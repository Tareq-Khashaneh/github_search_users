import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:syncrow_test/features/github_search/domain/entites/user.dart';
import 'package:syncrow_test/features/github_search/domain/repositories/github_repo.dart';
import 'package:syncrow_test/features/github_search/domain/usecases/search_users_use_case.dart';

class MockRepository extends Mock implements GithubRepository {}

void main() {
  late MockRepository mockRepository;
  late SearchUsersUseCase searchUsersUseCase;
  setUp(() {
    mockRepository = MockRepository();
    searchUsersUseCase = SearchUsersUseCase(mockRepository);
  });
  test("should return sorted list of users limited to 10", () async {
    final users = [
      User(
        login: 'a',
        avatarUrl: '',
        htmlUrl: '',
        publicRepos: 100,
        updatedAt: DateTime.now(),
      ),
      User(
        login: 'b',
        avatarUrl: '',
        htmlUrl: '',
        publicRepos: 10,
        updatedAt: DateTime.now(),
      ),
    ];
    when(
      () => mockRepository.searchUsers('john'),
    ).thenAnswer((_) async => Right(users));

    final result = await searchUsersUseCase.call('john');
    expect(result.isRight(), true);
    result.fold((_) => fail("Expected Right but got Left"), (sortedUsers) {
      expect(sortedUsers, isA<List<User>>());
      expect(sortedUsers.first.login, 'a');
      expect(sortedUsers.length, lessThanOrEqualTo(10));
    });
  });
}
