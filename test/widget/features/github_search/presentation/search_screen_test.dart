

import 'dart:ui';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:mocktail/mocktail.dart';
import 'package:syncrow_test/core/shared/custom_field.dart';
import 'package:syncrow_test/features/github_search/domain/entites/user.dart';
import 'package:syncrow_test/features/github_search/domain/usecases/search_users_use_case.dart';
import 'package:syncrow_test/features/github_search/presentation/controllers/github_search_controller.dart';
import 'package:syncrow_test/features/github_search/presentation/screens/search_screen.dart';
import 'package:syncrow_test/features/github_search/presentation/widgets/user_item_card.dart';
class MockSearchUsersUseCase extends Mock implements SearchUsersUseCase {}
void main() {
  late MockSearchUsersUseCase mockUseCase;
  late GithubSearchController controller;

  setUp(() {
    mockUseCase = MockSearchUsersUseCase();
    controller = Get.put( GithubSearchController(mockUseCase));
  });

  testWidgets('displays users after search', (WidgetTester tester) async {
    // arrange
    final users = [
      User(
        login: 'john',
        avatarUrl: '',
        htmlUrl: '',
        publicRepos: 100,
        updatedAt: DateTime.now(),
        name: 'john kn',
      bio: 'hi',
       company: '',
      location: '',
      followers: 10,
         following: 10,
      ),
      User(
        login: 'john1988',
        avatarUrl: '',
        htmlUrl: '',
        publicRepos: 100,
        updatedAt: DateTime.now(),
        name: 'john kn',
        bio: 'hi',
        company: '',
        location: '',
        followers: 10,
        following: 10,
      ),
    ];

    when(() => mockUseCase.call('john'))
        .thenAnswer((_) async => Right(users));

    // Build widget
    await tester.pumpWidget(
        ScreenUtilInit(
            designSize: const Size(360, 690),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (_, child) {
              return GetMaterialApp(
                home: SearchScreen(),
              );
            }
      )
    );

    await tester.enterText(find.byType(CustomField), 'john');
    await tester.pump(const Duration(seconds: 1200));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(UserItemCard, "john"), findsOneWidget);
    expect(find.widgetWithText(UserItemCard, "john1988"), findsOneWidget);
  });
  testWidgets('should not display any users after clearing the search field', (WidgetTester tester) async {
    // arrange
    final users = [User(login: 'john', avatarUrl: '', htmlUrl: '', publicRepos: 10, updatedAt: DateTime.now())];

    when(() => mockUseCase.call('john'))
        .thenAnswer((_) async => Right(users));

    // Build widget
    await tester.pumpWidget(
        ScreenUtilInit(
            designSize: const Size(360, 690),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (_, child) {
              return GetMaterialApp(
                home: SearchScreen(),
              );
            }
        )
    );
    expect(find.text('No users found'), findsOneWidget);

    await tester.enterText(find.byType(CustomField), 'john');
    await tester.pump(const Duration(seconds: 1200));
    await tester.pumpAndSettle();
    expect(find.byType(UserItemCard), findsOneWidget);
    await tester.tap(find.byKey(Key("clearIcon")));
    await tester.pump();
    expect(find.text('No users found'), findsOneWidget);
    expect(find.byType(UserItemCard), findsNothing);
  });

}
