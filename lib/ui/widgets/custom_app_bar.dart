import 'package:event_sports/app/configs/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: AppColors.backgroundColor,
      ),
      backgroundColor: AppColors.backgroundColor,
      toolbarHeight: 0,
      elevation: 0,
      
    );
  }
}
