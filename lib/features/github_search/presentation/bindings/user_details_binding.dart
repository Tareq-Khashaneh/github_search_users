

import 'package:get/get.dart';
import 'package:syncrow_test/features/github_search/presentation/controllers/user_details_controller.dart';

class UserDetailsBinding extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut(() => UserDetailsController());
  }}