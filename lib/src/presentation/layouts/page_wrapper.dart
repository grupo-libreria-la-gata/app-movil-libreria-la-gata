import 'package:flutter/material.dart';
import 'main_layout.dart';

/// Wrapper para páginas que necesitan el menú inferior
class PageWrapper extends StatelessWidget {
  final Widget child;
  final int currentIndex;
  final String? title;

  const PageWrapper({
    super.key,
    required this.child,
    this.currentIndex = 0,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      currentIndex: currentIndex,
      title: title,
      child: child,
    );
  }
}
