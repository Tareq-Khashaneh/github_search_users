import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:syncrow_test/core/utils/error/failures.dart';
import 'package:syncrow_test/core/utils/network/network_checker.dart';
import 'package:syncrow_test/features/github_search/data/data_sources/local_data_source.dart';
import 'package:syncrow_test/features/github_search/data/data_sources/remote_data_source.dart';
import 'package:syncrow_test/features/github_search/data/models/user_model.dart';
import 'package:syncrow_test/features/github_search/data/repositories/github_repo_impl.dart';

class MockRemoteDataSource extends Mock implements GithubRemoteDataSource {}
class MockLocalDataSource extends Mock implements GithubLocalDataSource {}
class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;
  late GithubRepoImpl repository;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = GithubRepoImpl(mockRemoteDataSource,mockLocalDataSource,mockNetworkInfo);
  });

  final users = [
    UserModel(login: 'john', avatarUrl: '', htmlUrl: '', publicRepos: 100, updatedAt: DateTime.now()),
    UserModel(login: 'b', avatarUrl: '', htmlUrl: '', publicRepos: 10, updatedAt: DateTime.now()),
  ];

  test('should return list of users from remote data source', () async {
    // arrange
    when(() => mockRemoteDataSource.searchUsers('john'))
        .thenAnswer((_) async => users);
    when(() => mockLocalDataSource.getSearchUsers('john'))
        .thenAnswer((_) async => []);

    when(() => mockNetworkInfo.isConnected)
        .thenAnswer((_) async => true);
    when(() => mockLocalDataSource.cacheSearchResult('john', users))
        .thenAnswer((_) async {});

    // act
    final result = await repository.searchUsers('john');

    // assert
    expect(result.isRight(), true);
    result.fold(
          (_) => fail('Should not fail'),
          (users) {
        expect(users.length, 2);
        expect(users.first.login, 'john');
      },
    );

    // verify that the remote datasource method was called
    verify(() => mockRemoteDataSource.searchUsers('john')).called(1);
  });
  test('should return list of users from local data source', () async {
    // arrange
    when(() => mockLocalDataSource.getSearchUsers('john'))
        .thenAnswer((_) async => users);

    // act
    final result = await repository.searchUsers('john');

    // assert
    expect(result.isRight(), true);
    result.fold(
          (_) => fail('Should not fail'),
          (users) {
        expect(users.length, 2);
        expect(users.first.login, 'john');
      },
    );

    // verify that the remote datasource method was called
    verify(() =>mockLocalDataSource.getSearchUsers('john')).called(1);
  });
  test('should return Offline Failure when no network', () async {
    // arrange
    when(() => mockLocalDataSource.getSearchUsers('john'))
        .thenAnswer((_) async => []);
 when(() => mockNetworkInfo.isConnected)
        .thenAnswer((_) async => false);

    // act
    final result = await repository.searchUsers('john');

    // assert
    expect(result.isLeft(), true);
    result.fold(
          (_) => OfflineFailure(message: 'No internet connection'),
          (users) {
            expect(users.length, 0);
          },
    );

    // verify that the remote datasource method was called
    verify(() =>mockLocalDataSource.getSearchUsers('john')).called(1);
  });

  test('should return Failure when DioException occurs', () async {
    when(() => mockLocalDataSource.getSearchUsers('john'))
        .thenAnswer((_) async => []);
    when(() => mockNetworkInfo.isConnected)
        .thenAnswer((_) async => true);
    when(() => mockRemoteDataSource.searchUsers('john'))
        .thenThrow(DioException(requestOptions: RequestOptions(path: '',)));

    final result = await repository.searchUsers('john');

    result.fold(
          (failure) => expect(failure, isA<Failure>()),
          (_) => fail('Should not succeed on DioException'),
    );
  });

}
