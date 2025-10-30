import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/design/design_tokens.dart';
import '../widgets/bottom_menu_widget.dart';
import '../widgets/app_header.dart';

class MainLayout extends StatefulWidget {
  final Widget child;
  final int currentIndex;
  final String? title;

  const MainLayout({
    super.key,
    required this.child,
    this.currentIndex = 0,
    this.title,
  });

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignTokens.backgroundColor,
      appBar: AppHeader(
        showUserMenu: false,
      ),
      body: Column(
        children: [
          // if (widget.title != null)
          //   Container(
          //     color: Colors.white,
          //     child: SafeArea(
          //       bottom: false,
          //       child: SizedBox(
          //         height: kToolbarHeight,
          //         child: Row(
          //           children: [
          //             IconButton(
          //               icon: const Icon(Icons.arrow_back, color: Colors.black),
          //               onPressed: () => Navigator.of(context).maybePop(),
          //             ),
          //             const SizedBox(width: 4),
          //             Expanded(
          //               child: Text(
          //                 widget.title!,
          //                 style: const TextStyle(
          //                   color: Colors.black,
          //                   fontSize: 18,
          //                   fontWeight: FontWeight.bold,
          //                 ),
          //                 overflow: TextOverflow.ellipsis,
          //               ),
          //             ),
          //             const SizedBox(width: 12),
          //           ],
          //         ),
          //       ),
          //     ),
          //   ),
          Expanded(child: widget.child),
        ],
      ),
      bottomNavigationBar: BottomMenuWidget(
        currentIndex: widget.currentIndex,
        onTap: (index) {
          _navigateToPage(index);
        },
      ),
    );
  }

  void _navigateToPage(int index) {
    switch (index) {
      case 0: // Sales
        context.go('/dashboard');
        break;
      case 1: // Manage
        context.go('/dashboard');
        break;
      case 2: // Purchases
        context.go('/dashboard');
        break;
      case 3: // Resume
        context.go('/dashboard');
        break;
    }
  }
}
