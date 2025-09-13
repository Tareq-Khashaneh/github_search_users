import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:syncrow_test/core/config/routes/routes.dart';
import 'package:syncrow_test/core/constants/app_colors.dart';
import 'package:syncrow_test/core/shared/custom_field.dart';
import 'package:syncrow_test/core/shared/custom_title.dart';
import 'package:syncrow_test/core/utils/alert_service.dart';
import 'package:syncrow_test/core/utils/formatters.dart';
import 'package:syncrow_test/features/github_search/presentation/widgets/user_item_card.dart';
import '../controllers/github_search_controller.dart';
import '../widgets/user_item_shimmer.dart';

class SearchScreen extends GetView<GithubSearchController> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text(
            "GitHub User Search",
            style: TextStyle(fontSize: 18.sp), // responsive font
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
          child: Column(
            children: [
              /// Search Field
              CustomField(
                key: Key("customField"),
                controller: controller.searchController,
                onChanged: controller.onQueryChanged,

                hint: "Search GitHub user...",
                fillColor: Colors.white,
                prefixIcon: Padding(
                  padding: EdgeInsets.all(12.w),
                  child: FaIcon(
                    FontAwesomeIcons.magnifyingGlass,
                    color: Colors.grey,
                    size: 18.sp, // responsive icon
                  ),
                ),
                borderRadius: 16.r, // responsive radius
                suffixIcon: IconButton(
                  icon: FaIcon(
                    key: Key("clearIcon"),
                    FontAwesomeIcons.xmark,
                    color: Colors.grey,
                    size: 18.sp,
                  ),
                  onPressed: controller.clear,
                ),
              ),

              /// Error Snackbar
              Obx(() {
                if (controller.errorMessage.isNotEmpty) {

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    AlertsService.showSnackBar(context, controller.errorMessage);
                    controller.errorMessage = '';
                  });
                }
                return SizedBox.shrink();
              }),

              /// Results
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return ListView.builder(
                      itemCount: 6,
                      itemBuilder: (_, __) => const UserItemShimmer(),
                    );
                  }

                  if (controller.users.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FaIcon(
                            FontAwesomeIcons.user,
                            size: 48.sp,
                            color: Colors.grey[300],
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            "No users found",
                            style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                          ),
                        ],
                      ),
                    );
                  }

                  return Padding(
                    padding: EdgeInsets.only(top: 12.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTitle(
                          text: 'Users',
                          color: AppColors.textPrimary,
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: controller.users.length,
                            itemBuilder: (context, index) {
                              final user = controller.users[index];
                              return UserItemCard(
                                key: Key(user.login),
                                timeAgoInMonths: Formatters.timeAgoInMonths,
                                updateColor: Formatters.updateColor,
                                onTap: () => Get.toNamed(
                                  AppRoutes.userDetailsRoute,
                                  arguments: {'user': user},
                                ),
                                user: user,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
