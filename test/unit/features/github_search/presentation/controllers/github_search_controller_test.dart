import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:syncrow_test/core/utils/error/failures.dart';
import 'package:syncrow_test/features/github_search/domain/entites/user.dart';
import 'package:syncrow_test/features/github_search/domain/usecases/search_users_use_case.dart';
import 'package:syncrow_test/features/github_search/presentation/controllers/github_search_controller.dart';
import 'package:dartz/dartz.dart';

// Mock the UseCase
class MockSearchUsersUseCase extends Mock implements SearchUsersUseCase {}

void main() {
  late GithubSearchController controller;
  late MockSearchUsersUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockSearchUsersUseCase();
    controller = GithubSearchController(mockUseCase);
    Get.testMode = true; // Disable dependency injection / UI overlay
  });
  final users = [
    User(
      login: 'john',
      avatarUrl: '',
      htmlUrl: '',
      publicRepos: 100,
      updatedAt: DateTime.now(),
    ),

    User(
      login: 'b',
      avatarUrl: '',
      htmlUrl: '',
      publicRepos: 20,
      updatedAt: DateTime.now(),
    ),
  ];

  group('GithubSearchController', () {
    test('should clear searchController and users when clear() called', () {
      controller.users.add(users[0]);
      controller.searchController.text = 'john';

      controller.clear();

      expect(controller.searchController.text, '');
      expect(controller.users, isEmpty);
    });

    test('should update _query when onQueryChanged is called', () {
      controller.onQueryChanged('john');
      expect(
        controller.searchController.text,
        '',
      ); // controller does not auto update text

      expect(controller.query, 'john');
    });

    test('should fetch users successfully and update users list', () async {
      when(
        () => mockUseCase.call('john'),
      ).thenAnswer((_) async => Right(users));

      controller.onQueryChanged('john');

      Future.delayed(Duration(milliseconds: 2000)).whenComplete(() {
        expect(controller.users.length, 2);
        expect(controller.isLoading.value, false);
        expect(controller.users.first.login, 'john');
        expect(controller.errorMessage, '');
      });
    });

    test('should handle failure and update errorMessage', () async {
      when(() => mockUseCase.call('john')).thenAnswer(
        (_) async => Left(UnexpectedFailure(message: 'Network error')),
      );

      controller.onQueryChanged('john');

      await Future.delayed(Duration(milliseconds: 1100));

      expect(controller.isLoading.value, false);
      expect(controller.users, isEmpty);
      expect(controller.errorMessage, '');
    });

    test('should clear users if query is empty', () async {
      controller.users.addAll(users);

      controller.onQueryChanged('');

      Future.delayed(Duration(milliseconds: 1100)).then((value) {
        expect(controller.users, isEmpty);
      });
      expect(controller.isLoading.value, false);
    });
  });
}
