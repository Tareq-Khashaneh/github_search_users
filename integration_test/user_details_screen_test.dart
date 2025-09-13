import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:syncrow_test/features/github_search/domain/entites/user.dart';
import 'package:syncrow_test/features/github_search/presentation/controllers/user_details_controller.dart';
import 'package:syncrow_test/main.dart' as app;
import 'package:get/get.dart';
import 'package:flutter/material.dart';

String? launchedUrl;

class FakeUserDetailsController extends GetxController
    implements UserDetailsController {
  late final User user;
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
    launchedUrl = "https://github.com/tareq1988";
    print('launchedUrl: $launchedUrl');
  }
}

void main() {
  late FakeUserDetailsController fakeUserDetailsController;

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    fakeUserDetailsController = FakeUserDetailsController();
    Get.put<UserDetailsController>(fakeUserDetailsController);
  });
  testWidgets('Open user details and tap GitHub button', (
    WidgetTester tester,
  ) async {
    // Start the app
    app.main();
    await tester.pumpAndSettle();
    await goToUserDetails(tester, "tareq1988");
    await tester.ensureVisible(find.text('View GitHub Profile'));
    await tester.tap(find.text('View GitHub Profile'));
    await tester.pump(Duration(seconds: 2));
    expect(launchedUrl, 'https://github.com/tareq1988');
  });
}

Future<void> goToUserDetails(WidgetTester tester, String username) async {
  final searchField = find.byKey(const Key("customField"));
  await tester.pump(Duration(seconds: 2));
  await tester.enterText(searchField, username);
  await tester.pumpAndSettle();

  final userCard = find.byKey(Key(username));
  await tester.pumpAndSettle(Duration(seconds: 2));
  await tester.tap(userCard);
  await tester.pumpAndSettle();
}
