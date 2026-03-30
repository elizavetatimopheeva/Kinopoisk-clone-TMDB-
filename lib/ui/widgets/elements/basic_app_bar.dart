// import 'package:flutter/material.dart';
// import 'package:kino/domain/services/auth_service.dart';

// class BasicAppBar extends StatelessWidget {
//   final String text;
//   const BasicAppBar({super.key, required this.text});

//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       centerTitle: true,
//       title: Text(text, style: TextStyle()),
//       actions: [
//         IconButton(
//           onPressed: () {
//             AuthService().logout();
//           },
//           icon: const Icon(Icons.search),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:kino/domain/services/auth_service.dart';

class BasicAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String text;
  const BasicAppBar({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(text, style: const TextStyle()),
      actions: [
        // IconButton(
        //   onPressed: () {
        //     AuthService().logout();
        //   },
        //   icon: const Icon(Icons.search),
        // ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
