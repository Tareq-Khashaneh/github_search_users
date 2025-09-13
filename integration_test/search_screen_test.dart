import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:syncrow_test/features/github_search/presentation/screens/search_screen.dart';
import 'package:syncrow_test/features/github_search/presentation/screens/user_details_screen.dart';
import 'package:syncrow_test/features/github_search/presentation/widgets/user_item_card.dart';
import 'package:syncrow_test/main.dart' as app;
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group("Search github users", (){
    testWidgets("Search and clear users", (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(Duration(seconds: 4));
      final searchField = find.byKey(Key("customField"));
      await tester.enterText(searchField, "john");
      await tester.pumpAndSettle(Duration(seconds: 2));
      final cardCount = find.byType(UserItemCard).evaluate().length;
      expect(cardCount, inInclusiveRange(0, 10));
      final clearButton = find.byKey(Key("clearIcon"));
      await tester.tap(clearButton);
      await tester.pumpAndSettle(Duration(seconds: 1));
      expect(find.byType(UserItemCard), findsNothing);
    });
    testWidgets("Search and navigate to user details screen and return back", (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(Duration(seconds: 4));
      final searchField = find.byKey(Key("customField"));
      await tester.enterText(searchField, "tareq");
      await tester.pumpAndSettle(Duration(seconds: 2));
      final cardCount = find.byType(UserItemCard).evaluate().length;
      expect(cardCount, inInclusiveRange(0, 10));
      if(cardCount > 0){
        await tester.tap(find.byKey(Key("tareq1988")));
        await tester.pumpAndSettle();
        expect(find.byType(UserDetailsScreen), findsOneWidget);
        await tester.tap(find.byIcon(Icons.arrow_back));
        await tester.pumpAndSettle();
        expect(find.byType(SearchScreen),findsOneWidget);
      }
      });
  });

}
