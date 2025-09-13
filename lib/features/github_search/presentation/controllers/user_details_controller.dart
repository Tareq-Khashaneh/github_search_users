import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/entites/user.dart';

class UserDetailsController extends GetxController {
  late User user;

  @override
  void onInit() {
    user = Get.arguments['user'];
    super.onInit();
  }

  Future<void> openUrl() async {
    final Uri url = Uri.parse(user.htmlUrl);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch ${user.htmlUrl}';
    }
  }
}
