import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:syncrow_test/core/utils/formatters.dart';
import 'package:syncrow_test/features/github_search/presentation/controllers/user_details_controller.dart';

class UserDetailsScreen extends GetView<UserDetailsController> {
  const UserDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Details", style: TextStyle(fontSize: 18.sp)),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 35.h,horizontal: 10.w),
          child: SingleChildScrollView(
            child: Column(
              children: [
                /// Avatar
                Hero(
                  tag: controller.user.login,
                  child: CircleAvatar(
                    radius: 60.r,
                    backgroundColor: Colors.grey[200],
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: controller.user.avatarUrl,
                        width: 120.w,
                        height: 120.w,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => SizedBox(
                          width: 20.w,
                          height: 20.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            Icon(Icons.error, color: Colors.red, size: 28.sp),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),

                /// Name & Login
                Text(
                  controller.user.name ?? controller.user.login,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                if (controller.user.name != null)
                  Text(
                    "@${controller.user.login}",
                    style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                  ),
                SizedBox(height: 12.h),

                /// Bio
                if (controller.user.bio != null &&
                    controller.user.bio!.isNotEmpty)
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      controller.user.bio!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                SizedBox(height: 16.h),

                /// Stats
                Row(

                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        "Repos",
                        controller.user.publicRepos.toString(),
                        FontAwesomeIcons.book,
                        Colors.blue,
                      ),
                    ),
                    SizedBox(width: 5,),
                    Expanded(
                      child: _buildStatCard(
                        "Updated",
                        Formatters.timeAgoInMonths(controller.user.updatedAt),
                        FontAwesomeIcons.clock,
                        Colors.blue,
                      ),
                    ),
                    SizedBox(width: 5,),
                    Expanded(
                      child: _buildStatCard(
                        "Followers",
                        (controller.user.followers ?? 0).toString(),
                        FontAwesomeIcons.userGroup,
                        Colors.green,
                      ),
                    ),
                    SizedBox(width: 5,),
                    Expanded(
                      child: _buildStatCard(
                        "Following",
                        (controller.user.following ?? 0).toString(),
                        FontAwesomeIcons.userPlus,
                        Colors.orange,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                /// Additional Info
                if (controller.user.company != null ||
                    controller.user.location != null)
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 2,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 12.h,
                        horizontal: 16.w,
                      ),
                      child: Column(
                        children: [
                          if (controller.user.company != null)
                            Row(
                              children: [
                                Icon(Icons.business, size: 20.sp),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: Text(
                                    controller.user.company!,
                                    style: TextStyle(fontSize: 14.sp),
                                  ),
                                ),
                              ],
                            ),
                          if (controller.user.location != null)
                            Row(
                              children: [
                                Icon(Icons.location_on, size: 20.sp),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: Text(
                                    controller.user.location!,
                                    style: TextStyle(fontSize: 14.sp),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                SizedBox(height: 20.h),

                /// GitHub profile button
                ElevatedButton.icon(
                  onPressed: () async => await controller.openUrl(),
                  icon: Icon(Icons.link, size: 18.sp),
                  label: Text(
                    "View GitHub Profile",
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 12.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      height: 120.h,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1), // new non-deprecated API
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(

        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
        children: [
          FittedBox(child: FaIcon(icon, color: color, size: 18.sp)),

          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ),

          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: color.withOpacity(0.8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
