

import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:syncrow_test/features/github_search/presentation/bindings/github_search_binding.dart';
import 'package:syncrow_test/features/github_search/presentation/screens/user_details_screen.dart';

import '../../../features/github_search/presentation/bindings/user_details_binding.dart';
import '../../../features/github_search/presentation/screens/search_screen.dart';

abstract class AppRoutes {
  static const String searchRoute = "/search";
  static const String userDetailsRoute = "/user-details";
  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.searchRoute,
      page: () =>  SearchScreen(),
      binding: GithubSearchBinding()
    ), GetPage(
        name: AppRoutes.userDetailsRoute,
        page: () =>  UserDetailsScreen(),
      binding: UserDetailsBinding(),
    ),
  ];
}
