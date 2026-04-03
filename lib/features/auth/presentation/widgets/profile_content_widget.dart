import 'package:flutter/material.dart';

import '../screens/profile_screen.dart';

/// Uses the full profile screen implementation from auth feature.
class ProfileContentWidget extends StatelessWidget {
  const ProfileContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProfileScreen(embedded: true);
  }
}
