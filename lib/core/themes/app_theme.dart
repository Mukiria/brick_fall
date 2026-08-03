import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppColors {
  // Light Theme Colors
  static const Color lightPrimary = Color(0xFF6750A4);
  static const Color lightPrimaryContainer = Color(0xFFEADDFF);
  static const Color lightSecondary = Color(0xFF625B71);
  static const Color lightSecondaryContainer = Color(0xFFE8DEF8);
  static const Color lightTertiary = Color(0xFF7D5260);
  static const Color lightTertiaryContainer = Color(0xFFFFD8E4);
  static const Color lightError = Color(0xFFB3261E);
  static const Color lightErrorContainer = Color(0xFFF9DEDC);
  static const Color lightBackground = Color(0xFFFEFAFF);
  static const Color lightSurface = Color(0xFFFEFAFF);
  static const Color lightSurfaceVariant = Color(0xFFE7E0EC);
  static const Color lightOutline = Color(0xFF79747E);
  static const Color lightOutlineVariant = Color(0xFFCAC4D0);
  static const Color lightShadow = Color(0xFF000000);
  static const Color lightInverseSurface = Color(0xFF313033);
  static const Color lightInversePrimary = Color(0xFFD0BCFF);
  static const Color lightPrimaryFixed = Color(0xFFEADDFF);
  static const Color lightPrimaryFixedDim = Color(0xFFD0BCFF);
  static const Color lightSecondaryFixed = Color(0xFFE8DEF8);
  static const Color lightSecondaryFixedDim = Color(0xFFCCC2DC);
  static const Color lightTertiaryFixed = Color(0xFFFFD8E4);
  static const Color lightTertiaryFixedDim = Color(0xFFEFB8C8);

  // Dark Theme Colors
  static const Color darkPrimary = Color(0xFFD0BCFF);
  static const Color darkPrimaryContainer = Color(0xFF4F378B);
  static const Color darkSecondary = Color(0xFFCCC2DC);
  static const Color darkSecondaryContainer = Color(0xFF4A4458);
  static const Color darkTertiary = Color(0xFFEFB8C8);
  static const Color darkTertiaryContainer = Color(0xFF633B48);
  static const Color darkError = Color(0xFFF2B8B5);
  static const Color darkErrorContainer = Color(0xFF8C1D18);
  static const Color darkBackground = Color(0xFF1C1B1F);
  static const Color darkSurface = Color(0xFF1C1B1F);
  static const Color darkSurfaceVariant = Color(0xFF49454F);
  static const Color darkOutline = Color(0xFF938F99);
  static const Color darkOutlineVariant = Color(0xFF49454F);
  static const Color darkShadow = Color(0xFF000000);
  static const Color darkInverseSurface = Color(0xFFE6E1E5);
  static const Color darkInversePrimary = Color(0xFF6750A4);
  static const Color darkPrimaryFixed = Color(0xFFEADDFF);
  static const Color darkPrimaryFixedDim = Color(0xFFD0BCFF);
  static const Color darkSecondaryFixed = Color(0xFFE8DEF8);
  static const Color darkSecondaryFixedDim = Color(0xFFCCC2DC);
  static const Color darkTertiaryFixed = Color(0xFFFFD8E4);
  static const Color darkTertiaryFixedDim = Color(0xFFEFB8C8);

  // Game Specific Colors
  static const List<Color> brickColors = [
    Color(0xFF00FFFF), // I - Cyan
    Color(0xFF0000FF), // J - Blue
    Color(0xFFFFA500), // L - Orange
    Color(0xFFFFFFFF), // O - Yellow
    Color(0xFF00FF00), // S - Green
    Color(0xFF800080), // T - Purple
    Color(0xFFFF0000), // Z - Red
  ];

  static const Color gridLineColor = Color(0xFF333333);
  static const Color ghostBrickColor = Color(0x44FFFFFF);
  static const Color gameOverOverlay = Color(0xCC000000);
  static const Color pauseOverlay = Color(0x88000000);
}

class AppTextStyles {
  static TextStyle get displayLarge => TextStyle(
    fontSize: 57.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.25,
    height: 1.12,
  );

  static TextStyle get displayMedium => TextStyle(
    fontSize: 45.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.16,
  );

  static TextStyle get displaySmall => TextStyle(
    fontSize: 36.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.22,
  );

  static TextStyle get headlineLarge => TextStyle(
    fontSize: 32.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.25,
  );

  static TextStyle get headlineMedium => TextStyle(
    fontSize: 28.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.29,
  );

  static TextStyle get headlineSmall => TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.33,
  );

  static TextStyle get titleLarge => TextStyle(
    fontSize: 22.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.27,
  );

  static TextStyle get titleMedium => TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
    height: 1.50,
  );

  static TextStyle get titleSmall => TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.43,
  );

  static TextStyle get bodyLarge => TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 1.50,
  );

  static TextStyle get bodyMedium => TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.43,
  );

  static TextStyle get bodySmall => TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.33,
  );

  static TextStyle get labelLarge => TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.43,
  );

  static TextStyle get labelMedium => TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.33,
  );

  static TextStyle get labelSmall => TextStyle(
    fontSize: 11.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.45,
  );
}

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: AppColors.lightPrimary,
      primaryContainer: AppColors.lightPrimaryContainer,
      secondary: AppColors.lightSecondary,
      secondaryContainer: AppColors.lightSecondaryContainer,
      tertiary: AppColors.lightTertiary,
      tertiaryContainer: AppColors.lightTertiaryContainer,
      error: AppColors.lightError,
      errorContainer: AppColors.lightErrorContainer,
      background: AppColors.lightBackground,
      surface: AppColors.lightSurface,
      surfaceVariant: AppColors.lightSurfaceVariant,
      outline: AppColors.lightOutline,
      outlineVariant: AppColors.lightOutlineVariant,
      shadow: AppColors.lightShadow,
      inverseSurface: AppColors.lightInverseSurface,
      inversePrimary: AppColors.lightInversePrimary,
      primaryFixed: AppColors.lightPrimaryFixed,
      primaryFixedDim: AppColors.lightPrimaryFixedDim,
      secondaryFixed: AppColors.lightSecondaryFixed,
      secondaryFixedDim: AppColors.lightSecondaryFixedDim,
      tertiaryFixed: AppColors.lightTertiaryFixed,
      tertiaryFixedDim: AppColors.lightTertiaryFixedDim,
    ),
    textTheme: TextTheme(
      displayLarge: AppTextStyles.displayLarge,
      displayMedium: AppTextStyles.displayMedium,
      displaySmall: AppTextStyles.displaySmall,
      headlineLarge: AppTextStyles.headlineLarge,
      headlineMedium: AppTextStyles.headlineMedium,
      headlineSmall: AppTextStyles.headlineSmall,
      titleLarge: AppTextStyles.titleLarge,
      titleMedium: AppTextStyles.titleMedium,
      titleSmall: AppTextStyles.titleSmall,
      bodyLarge: AppTextStyles.bodyLarge,
      bodyMedium: AppTextStyles.bodyMedium,
      bodySmall: AppTextStyles.bodySmall,
      labelLarge: AppTextStyles.labelLarge,
      labelMedium: AppTextStyles.labelMedium,
      labelSmall: AppTextStyles.labelSmall,
    ),
    scaffoldBackgroundColor: AppColors.lightBackground,
    cardTheme: CardThemeData(
      color: AppColors.lightSurface,
      elevation: 1,
      shadowColor: AppColors.lightShadow,
      surfaceTintColor: AppColors.lightPrimaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.lightPrimary,
        foregroundColor: AppColors.lightPrimaryContainer,
        elevation: 2,
        shadowColor: AppColors.lightShadow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        textStyle: AppTextStyles.labelLarge,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.lightPrimary,
        foregroundColor: AppColors.lightPrimaryContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        textStyle: AppTextStyles.labelLarge,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.lightPrimary,
        side: BorderSide(color: AppColors.lightPrimary, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        textStyle: AppTextStyles.labelLarge,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.lightSurfaceVariant,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: AppColors.lightOutlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: AppColors.lightPrimary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: AppColors.lightError),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      labelStyle: AppTextStyles.bodyMedium,
      hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.lightOutline),
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: AppColors.lightPrimary,
      inactiveTrackColor: AppColors.lightOutlineVariant,
      thumbColor: AppColors.lightPrimary,
      overlayColor: AppColors.lightPrimary.withValues(alpha: 0.2),
      valueIndicatorColor: AppColors.lightPrimary,
      valueIndicatorTextStyle: AppTextStyles.labelSmall.copyWith(color: Colors.white),
      trackHeight: 4.h,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.lightPrimary;
        return AppColors.lightOutlineVariant;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.lightPrimary.withValues(alpha: 0.5);
        return AppColors.lightOutlineVariant;
      }),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.lightPrimary;
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(Colors.white),
      side: BorderSide(color: AppColors.lightOutline, width: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.lightPrimary;
        return AppColors.lightOutline;
      }),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: AppColors.lightPrimary,
      linearTrackColor: AppColors.lightOutlineVariant,
      circularTrackColor: AppColors.lightOutlineVariant,
    ),
    dividerTheme: DividerThemeData(
      color: AppColors.lightOutlineVariant,
      thickness: 1,
      space: 1,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.lightSurfaceVariant,
      selectedColor: AppColors.lightPrimaryContainer,
      labelStyle: AppTextStyles.labelMedium,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      side: BorderSide(color: AppColors.lightOutlineVariant),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.lightSurface,
      surfaceTintColor: AppColors.lightPrimaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      titleTextStyle: AppTextStyles.titleLarge.copyWith(color: AppColors.lightPrimary),
      contentTextStyle: AppTextStyles.bodyMedium,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: AppColors.lightSurface,
      surfaceTintColor: AppColors.lightPrimaryContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      modalBackgroundColor: AppColors.lightSurface,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.lightSurface,
      surfaceTintColor: AppColors.lightPrimaryContainer,
      indicatorColor: AppColors.lightPrimaryContainer,
      labelTextStyle: WidgetStateProperty.all(AppTextStyles.labelSmall),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(color: AppColors.lightPrimary, size: 24.sp);
        }
        return IconThemeData(color: AppColors.lightOutline, size: 24.sp);
      }),
      height: 70.h,
    ),
    tabBarTheme: TabBarThemeData(
      labelColor: AppColors.lightPrimary,
      unselectedLabelColor: AppColors.lightOutline,
      indicatorColor: AppColors.lightPrimary,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: AppTextStyles.labelMedium,
      unselectedLabelStyle: AppTextStyles.labelMedium,
      dividerColor: Colors.transparent,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.lightSurface,
      surfaceTintColor: AppColors.lightPrimaryContainer,
      foregroundColor: AppColors.lightPrimary,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: AppTextStyles.titleLarge.copyWith(color: AppColors.lightPrimary),
      iconTheme: IconThemeData(color: AppColors.lightPrimary, size: 24.sp),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.darkPrimary,
      primaryContainer: AppColors.darkPrimaryContainer,
      secondary: AppColors.darkSecondary,
      secondaryContainer: AppColors.darkSecondaryContainer,
      tertiary: AppColors.darkTertiary,
      tertiaryContainer: AppColors.darkTertiaryContainer,
      error: AppColors.darkError,
      errorContainer: AppColors.darkErrorContainer,
      background: AppColors.darkBackground,
      surface: AppColors.darkSurface,
      surfaceVariant: AppColors.darkSurfaceVariant,
      outline: AppColors.darkOutline,
      outlineVariant: AppColors.darkOutlineVariant,
      shadow: AppColors.darkShadow,
      inverseSurface: AppColors.darkInverseSurface,
      inversePrimary: AppColors.darkInversePrimary,
      primaryFixed: AppColors.darkPrimaryFixed,
      primaryFixedDim: AppColors.darkPrimaryFixedDim,
      secondaryFixed: AppColors.darkSecondaryFixed,
      secondaryFixedDim: AppColors.darkSecondaryFixedDim,
      tertiaryFixed: AppColors.darkTertiaryFixed,
      tertiaryFixedDim: AppColors.darkTertiaryFixedDim,
    ),
    textTheme: TextTheme(
      displayLarge: AppTextStyles.displayLarge.copyWith(color: Colors.white),
      displayMedium: AppTextStyles.displayMedium.copyWith(color: Colors.white),
      displaySmall: AppTextStyles.displaySmall.copyWith(color: Colors.white),
      headlineLarge: AppTextStyles.headlineLarge.copyWith(color: Colors.white),
      headlineMedium: AppTextStyles.headlineMedium.copyWith(color: Colors.white),
      headlineSmall: AppTextStyles.headlineSmall.copyWith(color: Colors.white),
      titleLarge: AppTextStyles.titleLarge.copyWith(color: Colors.white),
      titleMedium: AppTextStyles.titleMedium.copyWith(color: Colors.white),
      titleSmall: AppTextStyles.titleSmall.copyWith(color: Colors.white),
      bodyLarge: AppTextStyles.bodyLarge.copyWith(color: Colors.white),
      bodyMedium: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
      bodySmall: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
      labelLarge: AppTextStyles.labelLarge.copyWith(color: Colors.white),
      labelMedium: AppTextStyles.labelMedium.copyWith(color: Colors.white),
      labelSmall: AppTextStyles.labelSmall.copyWith(color: Colors.white70),
    ),
    scaffoldBackgroundColor: AppColors.darkBackground,
    cardTheme: CardThemeData(
      color: AppColors.darkSurface,
      elevation: 1,
      shadowColor: AppColors.darkShadow,
      surfaceTintColor: AppColors.darkPrimaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.darkPrimary,
        foregroundColor: AppColors.darkPrimaryContainer,
        elevation: 2,
        shadowColor: AppColors.darkShadow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        textStyle: AppTextStyles.labelLarge,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.darkPrimary,
        foregroundColor: AppColors.darkPrimaryContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        textStyle: AppTextStyles.labelLarge,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.darkPrimary,
        side: BorderSide(color: AppColors.darkPrimary, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        textStyle: AppTextStyles.labelLarge,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkSurfaceVariant,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: AppColors.darkOutlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: AppColors.darkPrimary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: AppColors.darkError),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      labelStyle: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
      hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.darkOutline),
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: AppColors.darkPrimary,
      inactiveTrackColor: AppColors.darkOutlineVariant,
      thumbColor: AppColors.darkPrimary,
      overlayColor: AppColors.darkPrimary.withValues(alpha: 0.2),
      valueIndicatorColor: AppColors.darkPrimary,
      valueIndicatorTextStyle: AppTextStyles.labelSmall.copyWith(color: Colors.white),
      trackHeight: 4.h,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.darkPrimary;
        return AppColors.darkOutlineVariant;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.darkPrimary.withValues(alpha: 0.5);
        return AppColors.darkOutlineVariant;
      }),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.darkPrimary;
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(Colors.white),
      side: BorderSide(color: AppColors.darkOutline, width: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.darkPrimary;
        return AppColors.darkOutline;
      }),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: AppColors.darkPrimary,
      linearTrackColor: AppColors.darkOutlineVariant,
      circularTrackColor: AppColors.darkOutlineVariant,
    ),
    dividerTheme: DividerThemeData(
      color: AppColors.darkOutlineVariant,
      thickness: 1,
      space: 1,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.darkSurfaceVariant,
      selectedColor: AppColors.darkPrimaryContainer,
      labelStyle: AppTextStyles.labelMedium.copyWith(color: Colors.white),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      side: BorderSide(color: AppColors.darkOutlineVariant),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.darkSurface,
      surfaceTintColor: AppColors.darkPrimaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      titleTextStyle: AppTextStyles.titleLarge.copyWith(color: AppColors.darkPrimary),
      contentTextStyle: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: AppColors.darkSurface,
      surfaceTintColor: AppColors.darkPrimaryContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      modalBackgroundColor: AppColors.darkSurface,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.darkSurface,
      surfaceTintColor: AppColors.darkPrimaryContainer,
      indicatorColor: AppColors.darkPrimaryContainer,
      labelTextStyle: WidgetStateProperty.all(AppTextStyles.labelSmall.copyWith(color: Colors.white)),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(color: AppColors.darkPrimary, size: 24.sp);
        }
        return IconThemeData(color: AppColors.darkOutline, size: 24.sp);
      }),
      height: 70.h,
    ),
    tabBarTheme: TabBarThemeData(
      labelColor: AppColors.darkPrimary,
      unselectedLabelColor: AppColors.darkOutline,
      indicatorColor: AppColors.darkPrimary,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: AppTextStyles.labelMedium.copyWith(color: Colors.white),
      unselectedLabelStyle: AppTextStyles.labelMedium.copyWith(color: Colors.white70),
      dividerColor: Colors.transparent,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkSurface,
      surfaceTintColor: AppColors.darkPrimaryContainer,
      foregroundColor: AppColors.darkPrimary,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: AppTextStyles.titleLarge.copyWith(color: AppColors.darkPrimary),
      iconTheme: IconThemeData(color: AppColors.darkPrimary, size: 24.sp),
    ),
  );
}