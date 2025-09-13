import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:syncrow_test/features/github_search/domain/entites/user.dart';
import 'package:syncrow_test/features/github_search/presentation/controllers/user_details_controller.dart';
import 'package:syncrow_test/features/github_search/presentation/screens/user_details_screen.dart';

class FakeUserDetailsController extends GetxController
    implements UserDetailsController {
  @override
  late final User user;
  bool openUrlCalled = false;
  @override
  void onInit() {
    user = User(
      login: 'john',
      avatarUrl: 'avatar_url',
      htmlUrl: 'https://github.com/john',
      publicRepos: 42,
      updatedAt: DateTime.now(),
      name: 'John Doe',
      bio: 'Mobile developer',
      company: 'sc',
      location: 'Syria',
      followers: 100,
      following: 50,
    );
    super.onInit();
  }

  @override
  Future<void> openUrl() async {
    openUrlCalled = true;
    print('openUrlCalled: $openUrlCalled'); /// علامة أنه تم استدعاء الدالة
  }
}

void main() {
  late FakeUserDetailsController fakeUserDetailsController;

  setUp(() {
    fakeUserDetailsController = FakeUserDetailsController();
    Get.put<UserDetailsController>(FakeUserDetailsController());
  });

  testWidgets('should display user info correctly', (tester) async {
    // when(() => mockUserDetailsController.user).thenReturn(testUser);

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return GetMaterialApp(home: UserDetailsScreen());
        },
      ),
    );
    expect(
      find.descendant(
        of: find.byType(CircleAvatar),
        matching: find.byType(CachedNetworkImage),
      ),
      findsOneWidget,
    );

    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text('@john'), findsOneWidget);
    expect(find.text('Mobile developer'), findsOneWidget);
    expect(find.text('sc'), findsOneWidget);
    expect(find.text('Syria'), findsOneWidget);
    expect(find.text('Repos'), findsOneWidget);
    expect(find.text('Followers'), findsOneWidget);
    expect(find.text('Following'), findsOneWidget);
    expect(find.text('View GitHub Profile'), findsOneWidget);
  });

  testWidgets('tapping GitHub profile button should call openUrl', (
    tester,
  ) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        builder: (_, __) => GetMaterialApp(home: UserDetailsScreen()),
      ),
    );


    await tester.pump(); // يكفي غالبًا
    await tester.pump(const Duration(seconds: 5)); // اعطي وقت لأي animation


    await tester.ensureVisible(find.text('View GitHub Profile'));
    await tester.tap(find.text('View GitHub Profile'));
    await tester.pump(Duration(milliseconds: 100));

    expect(fakeUserDetailsController.openUrlCalled, true);
  });
}
