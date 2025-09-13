// import 'package:flutter/material.dart';
//
// import '../constants/api_endpoint.dart';
// import '../constants/app_colors.dart';
// import '../constants/app_images.dart';
//
// class AppDrawer extends StatelessWidget {
//   const AppDrawer({super.key});
//
//   void _navigateTo(BuildContext context, String routeName) {
//     Navigator.of(context).pop(); // Close drawer
//     Navigator.of(context).pushReplacementNamed(routeName);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           const DrawerHeader(
//             decoration: BoxDecoration(
//
//                 color: AppColors.surface,
//                 image: DecorationImage(
//
//                     image: NetworkImage(Api.logo),fit: BoxFit.contain)),
//             child: SizedBox(),
//           ),
//           ListTile(
//             leading: const Icon(Icons.dashboard),
//             title: const Text('Dashboard'),
//             onTap: () => _navigateTo(context, '/dashboard'),
//           ),
//           ListTile(
//             leading: const Icon(Icons.search),
//             title: const Text('Search'),
//             onTap: () => _navigateTo(context, '/search'),
//           ),
//         ],
//       ),
//     );
//   }
// }
