import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../domain/entites/user.dart';

class UserItemCard extends StatelessWidget {
  const UserItemCard({
    super.key,
    required this.onTap,
    required this.user,
    required this.timeAgoInMonths,
    required this.updateColor,
  });

  final VoidCallback onTap;
  final String Function(DateTime) timeAgoInMonths;
  final Color Function(DateTime) updateColor;
  final User user;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(12.w),
        margin: EdgeInsets.symmetric(vertical: 6.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            /// Hero Avatar
            Expanded(
              child: Hero(
                tag: user.login,
                child: CircleAvatar(
                  radius: 34.r,
                  backgroundColor: Colors.grey[200],
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: user.avatarUrl,
                      width: 72.w,
                      height: 72.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12),

            /// Info Column
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// Name & username
                  Text(
                    user.name ?? user.login,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (user.name != null)
                    Text(
                      user.login,
                      style: TextStyle(fontSize: 13.sp, color: Colors.grey),
                    ),
                  SizedBox(height: 4.h),

                  /// Bio
                  if (user.bio != null)
                    Text(
                     user.bio!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 13.sp, color: Colors.black54),
                    ),
                  SizedBox(height: 8.h),

                  /// Stats as pills
                  Wrap(
                    spacing: 2.w,
                    runSpacing: 3.h,
                    children: [
                      _buildStatPill(
                        icon: FontAwesomeIcons.book,
                        label: "Repos: ${user.publicRepos}",
                        color: Colors.blueGrey,
                      ),
                      _buildStatPill(
                        icon: FontAwesomeIcons.userGroup,
                        label: "Followers: ${user.followers ?? 0}",
                        color: Colors.blueGrey,
                      ),
                      _buildStatPill(
                        icon: FontAwesomeIcons.clock,
                        label: timeAgoInMonths(user.updatedAt),
                        color: updateColor(user.updatedAt),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            /// Trailing arrow
            SizedBox(width: 8.w),
            Icon(
              Icons.arrow_forward_ios,
              size: 16.sp,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatPill({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(icon, size: 12.sp, color: color),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(fontSize: 12.sp, color: color, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
