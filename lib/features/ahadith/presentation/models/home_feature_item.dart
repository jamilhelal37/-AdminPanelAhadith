import 'package:flutter/material.dart';

class HomeFeatureItem {
  const HomeFeatureItem({
    required this.label,
    required this.icon,
    required this.routeName,
  });

  final String label;
  final IconData icon;
  final String routeName;
}
