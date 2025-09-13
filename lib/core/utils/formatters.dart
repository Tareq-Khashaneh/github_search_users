import 'package:flutter/material.dart' show Colors, Color;

class Formatters {
  static String timeAgoInMonths(DateTime updatedAt) {
    final now = DateTime.now();

    int yearsDiff = now.year - updatedAt.year;
    int monthsDiff = now.month - updatedAt.month;
    int totalMonths = yearsDiff * 12 + monthsDiff;

    if (totalMonths <= 0) return "this month";
    if (totalMonths == 1) return "1 month ago";
    return "$totalMonths months ago";
  }

  static Color updateColor(DateTime updatedAt) {
    final months = DateTime.now().difference(updatedAt).inDays ~/ 30;
    if (months <= 1) return Colors.green;
    if (months <= 3) return Colors.blue;
    if (months <= 6) return Colors.orange;
    return Colors.grey;
  }
}
