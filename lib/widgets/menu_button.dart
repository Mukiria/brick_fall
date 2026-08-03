import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/themes/app_theme.dart';

class MenuButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool outlined;

  const MenuButton({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return SizedBox(
      width: double.infinity,
      height: 60.h,
      child: outlined
          ? OutlinedButton.icon(
              icon: Icon(icon, size: 24.sp),
              label: Text(label, style: theme.textTheme.labelLarge),
              style: OutlinedButton.styleFrom(
                foregroundColor: color,
                side: BorderSide(color: color, width: 2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
              ),
              onPressed: onTap,
            )
          : FilledButton.icon(
              icon: Icon(icon, size: 24.sp),
              label: Text(label, style: theme.textTheme.labelLarge),
              style: FilledButton.styleFrom(
                backgroundColor: color,
                foregroundColor: theme.colorScheme.onPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                elevation: 4,
              ),
              onPressed: onTap,
            ),
    );
  }
}