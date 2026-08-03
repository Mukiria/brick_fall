import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/themes/app_theme.dart';

class ControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color color;
  final double size;
  final bool isLarge;

  const ControlButton({
    super.key,
    required this.icon,
    this.onTap,
    required this.color,
    this.size = 56,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(isLarge ? 32.r : 16.r),
        child: Container(
          width: size.sp,
          height: size.sp,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(isLarge ? 32.r : 16.r),
            border: Border.all(color: color.withValues(alpha: 0.5), width: 2),
          ),
          child: Icon(icon, color: color, size: isLarge ? 32.sp : 24.sp),
        ),
      ),
    );
  }
}