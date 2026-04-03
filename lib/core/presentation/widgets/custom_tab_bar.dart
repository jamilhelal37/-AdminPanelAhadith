import 'package:flutter/material.dart';

class CustomTabBar extends StatelessWidget {
  const CustomTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Container(
          height: 94,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            color: Color(0xffF4F2F2),
          ),

          child: const TabBar(
            dividerColor: Color(0x8c8c8c66),
            dividerHeight: 3,
            padding: EdgeInsets.symmetric(horizontal: 16),
            indicatorSize: TabBarIndicatorSize.tab,

            indicatorColor: Color(0xff1EA2B1),
            indicatorWeight: 3.0,
            unselectedLabelColor: Color(0x8c8c8c66),
            labelColor: Color(0xff1EA2B1),

            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            tabs: [
              Tab(text: 'إنشاء حساب'),
              Tab(text: 'تسجيل دخول'),
            ],
          ),
        ),
      ),
    );
  }
}
