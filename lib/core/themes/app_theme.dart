import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../design/colors.dart';
import '../design/typography.dart';
import '../design/spacing.dart';
import '../design/animations.dart';

class AppTheme {
  static ThemeData get lightTheme => _buildTheme(_LightColorScheme());
  static ThemeData get darkTheme => _buildTheme(_DarkColorScheme());

  static ThemeData _buildTheme(_ColorSchemeBase scheme) {
    return ThemeData(
      useMaterial3: true,
      brightness: scheme.brightness,
      colorScheme: scheme.colorScheme,
      textTheme: _buildTextTheme(scheme.brightness),
      scaffoldBackgroundColor: scheme.backgroundColor,
      cardTheme: _cardTheme(scheme),
      elevatedButtonTheme: _elevatedButtonTheme(scheme),
      filledButtonTheme: _filledButtonTheme(scheme),
      outlinedButtonTheme: _outlinedButtonTheme(scheme),
      textButtonTheme: _textButtonTheme(scheme),
      inputDecorationTheme: _inputDecorationTheme(scheme),
      sliderTheme: _sliderTheme(scheme),
      switchTheme: _switchTheme(scheme),
      checkboxTheme: _checkboxTheme(scheme),
      radioTheme: _radioTheme(scheme),
      progressIndicatorTheme: _progressIndicatorTheme(scheme),
      dividerTheme: _dividerTheme(scheme),
      chipTheme: _chipTheme(scheme),
      dialogTheme: _dialogTheme(scheme),
      bottomSheetTheme: _bottomSheetTheme(scheme),
      navigationBarTheme: _navigationBarTheme(scheme),
      tabBarTheme: _tabBarTheme(scheme),
      appBarTheme: _appBarTheme(scheme),
      floatingActionButtonTheme: _floatingActionButtonTheme(scheme),
      popupMenuTheme: _popupMenuTheme(scheme),
      tooltipTheme: _tooltipTheme(scheme),
      snackBarTheme: _snackBarTheme(scheme),
      splashFactory: InkRipple.splashFactory,
      pageTransitionsTheme: _pageTransitionsTheme(),
    );
  }

  static TextTheme _buildTextTheme(Brightness brightness) {
    final color = brightness == Brightness.light 
        ? AppColors.lightOnSurface 
        : AppColors.darkOnSurface;
    
    return TextTheme(
      displayLarge: AppTextStyles.displayLarge.copyWith(color: color),
      displayMedium: AppTextStyles.displayMedium.copyWith(color: color),
      displaySmall: AppTextStyles.displaySmall.copyWith(color: color),
      headlineLarge: AppTextStyles.headlineLarge.copyWith(color: color),
      headlineMedium: AppTextStyles.headlineMedium.copyWith(color: color),
      headlineSmall: AppTextStyles.headlineSmall.copyWith(color: color),
      titleLarge: AppTextStyles.titleLarge.copyWith(color: color),
      titleMedium: AppTextStyles.titleMedium.copyWith(color: color),
      titleSmall: AppTextStyles.titleSmall.copyWith(color: color),
      bodyLarge: AppTextStyles.bodyLarge.copyWith(color: color),
      bodyMedium: AppTextStyles.bodyMedium.copyWith(color: color),
      bodySmall: AppTextStyles.bodySmall.copyWith(color: color.withValues(alpha: 0.7)),
      labelLarge: AppTextStyles.labelLarge.copyWith(color: color),
      labelMedium: AppTextStyles.labelMedium.copyWith(color: color),
      labelSmall: AppTextStyles.labelSmall.copyWith(color: color.withValues(alpha: 0.7)),
    ).apply(
      bodyColor: color,
      displayColor: color,
    );
  }

  static CardThemeData _cardTheme(_ColorSchemeBase scheme) {
    return CardThemeData(
      color: scheme.surfaceColor,
      elevation: 0,
      shadowColor: scheme.shadowColor,
      surfaceTintColor: scheme.surfaceTintColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius.r),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPaddingHorizontal.w,
        vertical: AppSpacing.itemSpacing.h,
      ),
    );
  }

  static ElevatedButtonThemeData _elevatedButtonTheme(_ColorSchemeBase scheme) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: scheme.primaryColor,
        foregroundColor: scheme.onPrimaryColor,
        elevation: 2,
        shadowColor: scheme.shadowColor.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.buttonRadius.r),
        ),
        padding: AppSpacing.buttonPadding,
        minimumSize: Size(AppSpacing.touchTargetMin.w, AppSpacing.buttonHeightMedium.h),
        textStyle: AppTextStyles.buttonLarge,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        animationDuration: AppAnimations.fast,
      ).copyWith(
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return scheme.primaryColor.withValues(alpha: 0.1);
          }
          if (states.contains(WidgetState.hovered)) {
            return scheme.primaryColor.withValues(alpha: 0.05);
          }
          return null;
        }),
      ),
    );
  }

  static FilledButtonThemeData _filledButtonTheme(_ColorSchemeBase scheme) {
    return FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: scheme.primaryColor,
        foregroundColor: scheme.onPrimaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.buttonRadius.r),
        ),
        padding: AppSpacing.buttonPadding,
        minimumSize: Size(AppSpacing.touchTargetMin.w, AppSpacing.buttonHeightMedium.h),
        textStyle: AppTextStyles.buttonLarge,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }

  static OutlinedButtonThemeData _outlinedButtonTheme(_ColorSchemeBase scheme) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: scheme.primaryColor,
        side: BorderSide(color: scheme.primaryColor, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.buttonRadius.r),
        ),
        padding: AppSpacing.buttonPadding,
        minimumSize: Size(AppSpacing.touchTargetMin.w, AppSpacing.buttonHeightMedium.h),
        textStyle: AppTextStyles.buttonLarge,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }

  static TextButtonThemeData _textButtonTheme(_ColorSchemeBase scheme) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: scheme.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.buttonRadius.r),
        ),
        padding: AppSpacing.buttonPadding,
        minimumSize: Size(AppSpacing.touchTargetMin.w, AppSpacing.buttonHeightMedium.h),
        textStyle: AppTextStyles.buttonLarge,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }

  static InputDecorationTheme _inputDecorationTheme(_ColorSchemeBase scheme) {
    return InputDecorationTheme(
      filled: true,
      fillColor: scheme.surfaceVariantColor,
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md.w,
        vertical: AppSpacing.smMd.h,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.inputRadius.r),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.inputRadius.r),
        borderSide: BorderSide(color: scheme.outlineVariantColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.inputRadius.r),
        borderSide: BorderSide(color: scheme.primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.inputRadius.r),
        borderSide: BorderSide(color: scheme.errorColor),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.inputRadius.r),
        borderSide: BorderSide(color: scheme.errorColor, width: 2),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.inputRadius.r),
        borderSide: BorderSide(color: scheme.outlineVariantColor.withValues(alpha: 0.5)),
      ),
      labelStyle: AppTextStyles.bodyMedium.copyWith(color: scheme.onSurfaceVariantColor),
      hintStyle: AppTextStyles.bodyMedium.copyWith(
        color: scheme.onSurfaceVariantColor.withValues(alpha: 0.5),
      ),
      errorStyle: AppTextStyles.bodySmall.copyWith(color: scheme.errorColor),
      floatingLabelStyle: AppTextStyles.labelMedium.copyWith(color: scheme.primaryColor),
      prefixIconColor: scheme.onSurfaceVariantColor.withValues(alpha: 0.5),
      suffixIconColor: scheme.onSurfaceVariantColor.withValues(alpha: 0.5),
    );
  }

  static SliderThemeData _sliderTheme(_ColorSchemeBase scheme) {
    return SliderThemeData(
      activeTrackColor: scheme.primaryColor,
      inactiveTrackColor: scheme.outlineVariantColor,
      thumbColor: scheme.primaryColor,
      overlayColor: scheme.primaryColor.withValues(alpha: 0.2),
      valueIndicatorColor: scheme.primaryColor,
      valueIndicatorTextStyle: AppTextStyles.labelSmall.copyWith(color: Colors.white),
      trackHeight: 4.h,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
      activeTickMarkColor: scheme.primaryColor,
      inactiveTickMarkColor: scheme.outlineVariantColor,
    );
  }

  static SwitchThemeData _switchTheme(_ColorSchemeBase scheme) {
    return SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return scheme.primaryColor;
        return scheme.outlineVariantColor;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return scheme.primaryColor.withValues(alpha: 0.5);
        }
        return scheme.outlineVariantColor;
      }),
      trackOutlineColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return scheme.primaryColor;
        return scheme.outlineColor;
      }),
      thumbIcon: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const Icon(Icons.check, size: 16, color: Colors.white);
        }
        return const Icon(Icons.close, size: 16, color: Colors.white);
      }),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  static CheckboxThemeData _checkboxTheme(_ColorSchemeBase scheme) {
    return CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return scheme.primaryColor;
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(scheme.onPrimaryColor),
      side: BorderSide(color: scheme.outlineColor, width: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusSm.r)),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }

  static RadioThemeData _radioTheme(_ColorSchemeBase scheme) {
    return RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return scheme.primaryColor;
        return scheme.outlineColor;
      }),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }

  static ProgressIndicatorThemeData _progressIndicatorTheme(_ColorSchemeBase scheme) {
    return ProgressIndicatorThemeData(
      color: scheme.primaryColor,
      linearTrackColor: scheme.outlineVariantColor,
      circularTrackColor: scheme.outlineVariantColor,
      refreshBackgroundColor: scheme.surfaceVariantColor,
    );
  }

  static DividerThemeData _dividerTheme(_ColorSchemeBase scheme) {
    return DividerThemeData(
      color: scheme.outlineVariantColor,
      thickness: AppSpacing.dividerNormal.w,
      space: AppSpacing.md.h,
      indent: AppSpacing.screenPaddingHorizontal.w,
      endIndent: AppSpacing.screenPaddingHorizontal.w,
    );
  }

  static ChipThemeData _chipTheme(_ColorSchemeBase scheme) {
    return ChipThemeData(
      backgroundColor: scheme.surfaceVariantColor,
      selectedColor: scheme.primaryContainerColor,
      disabledColor: scheme.surfaceVariantColor.withValues(alpha: 0.5),
      labelStyle: AppTextStyles.labelMedium.copyWith(color: scheme.onSurfaceColor),
      secondaryLabelStyle: AppTextStyles.labelMedium.copyWith(color: scheme.onPrimaryContainerColor),
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w, vertical: AppSpacing.sm.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.chipRadius.r),
      ),
      side: BorderSide(color: scheme.outlineVariantColor),
      brightness: scheme.brightness,
      elevation: 0,
      pressElevation: 2,
      checkmarkColor: scheme.onPrimaryColor,
    );
  }

  static DialogThemeData _dialogTheme(_ColorSchemeBase scheme) {
    return DialogThemeData(
      backgroundColor: scheme.surfaceColor,
      surfaceTintColor: scheme.surfaceTintColor,
      elevation: 8,
      shadowColor: scheme.shadowColor.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.dialogRadius.r),
      ),
      titleTextStyle: AppTextStyles.titleLarge.copyWith(
        color: scheme.primaryColor,
        fontWeight: FontWeight.w700,
      ),
      contentTextStyle: AppTextStyles.bodyMedium.copyWith(color: scheme.onSurfaceColor),
      alignment: Alignment.center,
    );
  }

  static BottomSheetThemeData _bottomSheetTheme(_ColorSchemeBase scheme) {
    return BottomSheetThemeData(
      backgroundColor: scheme.surfaceColor,
      surfaceTintColor: scheme.surfaceTintColor,
      elevation: 8,
      shadowColor: scheme.shadowColor.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.bottomSheetRadius.r),
        ),
      ),
      modalBackgroundColor: scheme.surfaceColor,
      dragHandleColor: scheme.outlineVariantColor,
      dragHandleSize: Size(36.w, 4.h),
      showDragHandle: true,
    );
  }

  static NavigationBarThemeData _navigationBarTheme(_ColorSchemeBase scheme) {
    return NavigationBarThemeData(
      backgroundColor: scheme.surfaceColor,
      surfaceTintColor: scheme.surfaceTintColor,
      indicatorColor: scheme.primaryContainerColor,
      indicatorShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg.r),
      ),
      labelTextStyle: WidgetStateProperty.all(AppTextStyles.labelSmall),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(color: scheme.primaryColor, size: 24.sp);
        }
        return IconThemeData(color: scheme.onSurfaceVariantColor, size: 24.sp);
      }),
      height: AppSpacing.bottomNavHeight.h,
    );
  }

  static TabBarThemeData _tabBarTheme(_ColorSchemeBase scheme) {
    return TabBarThemeData(
      labelColor: scheme.primaryColor,
      unselectedLabelColor: scheme.onSurfaceVariantColor,
      indicatorColor: scheme.primaryColor,
      indicatorSize: TabBarIndicatorSize.label,
      indicator: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: scheme.primaryColor,
            width: 3,
          ),
        ),
      ),
      labelStyle: AppTextStyles.labelMedium.copyWith(fontWeight: FontWeight.w600),
      unselectedLabelStyle: AppTextStyles.labelMedium,
      dividerColor: Colors.transparent,
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return scheme.primaryColor.withValues(alpha: 0.1);
        }
        return null;
      }),
      splashFactory: NoSplash.splashFactory,
    );
  }

  static AppBarTheme _appBarTheme(_ColorSchemeBase scheme) {
    return AppBarTheme(
      backgroundColor: scheme.surfaceColor,
      surfaceTintColor: scheme.surfaceTintColor,
      foregroundColor: scheme.onSurfaceColor,
      elevation: 0,
      scrolledUnderElevation: 2,
      shadowColor: scheme.shadowColor.withValues(alpha: 0.1),
      centerTitle: true,
      titleTextStyle: AppTextStyles.titleLarge.copyWith(
        color: scheme.onSurfaceColor,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: IconThemeData(color: scheme.onSurfaceColor, size: 24.sp),
      actionsIconTheme: IconThemeData(color: scheme.onSurfaceColor, size: 24.sp),
      toolbarHeight: AppSpacing.appBarHeight.h,
      systemOverlayStyle: scheme.brightness == Brightness.light
          ? SystemUiOverlayStyle.dark
          : SystemUiOverlayStyle.light,
    );
  }

  static FloatingActionButtonThemeData _floatingActionButtonTheme(_ColorSchemeBase scheme) {
    return FloatingActionButtonThemeData(
      backgroundColor: scheme.primaryColor,
      foregroundColor: scheme.onPrimaryColor,
      elevation: 4,
      focusElevation: 6,
      hoverElevation: 6,
      highlightElevation: 8,
      disabledElevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.buttonRadiusLarge.r),
      ),
      extendedTextStyle: AppTextStyles.buttonLarge,
      extendedIconLabelSpacing: AppSpacing.sm.w,
      extendedPadding: EdgeInsets.symmetric(
        horizontal: AppSpacing.xl.w,
        vertical: AppSpacing.md.h,
      ),
    );
  }

  static PopupMenuThemeData _popupMenuTheme(_ColorSchemeBase scheme) {
    return PopupMenuThemeData(
      color: scheme.surfaceColor,
      surfaceTintColor: scheme.surfaceTintColor,
      elevation: 8,
      shadowColor: scheme.shadowColor.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius.r),
      ),
      textStyle: AppTextStyles.bodyMedium.copyWith(color: scheme.onSurfaceColor),
      labelTextStyle: WidgetStateProperty.all(
        AppTextStyles.bodyMedium.copyWith(color: scheme.onSurfaceColor),
      ),
      iconColor: scheme.onSurfaceColor,
      enableFeedback: true,
    );
  }

  static TooltipThemeData _tooltipTheme(_ColorSchemeBase scheme) {
    return TooltipThemeData(
      decoration: BoxDecoration(
        color: scheme.onSurfaceColor.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(AppSpacing.tooltipRadius.r),
      ),
      textStyle: AppTextStyles.labelSmall.copyWith(color: scheme.surfaceColor),
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md.w,
        vertical: AppSpacing.sm.h,
      ),
      verticalOffset: AppSpacing.smMd.h,
      preferBelow: true,
      excludeFromSemantics: false,
    );
  }

  static SnackBarThemeData _snackBarTheme(_ColorSchemeBase scheme) {
    return SnackBarThemeData(
      backgroundColor: scheme.inverseSurfaceColor,
      contentTextStyle: AppTextStyles.bodyMedium.copyWith(color: scheme.inverseOnSurfaceColor),
      actionTextColor: scheme.primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius.r),
      ),
      behavior: SnackBarBehavior.floating,
      elevation: 4,
      showCloseIcon: true,
      closeIconColor: scheme.inverseOnSurfaceColor.withValues(alpha: 0.7),
    );
  }

  static PageTransitionsTheme _pageTransitionsTheme() {
    return const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.windows: ZoomPageTransitionsBuilder(),
        TargetPlatform.linux: ZoomPageTransitionsBuilder(),
      },
    );
  }
}

abstract class _ColorSchemeBase {
  Brightness get brightness;
  ColorScheme get colorScheme;
  Color get backgroundColor;
  Color get surfaceColor;
  Color get surfaceVariantColor;
  Color get surfaceTintColor;
  Color get primaryColor;
  Color get onPrimaryColor;
  Color get primaryContainerColor;
  Color get onPrimaryContainerColor;
  Color get secondaryColor;
  Color get onSecondaryColor;
  Color get secondaryContainerColor;
  Color get onSecondaryContainerColor;
  Color get tertiaryColor;
  Color get onTertiaryColor;
  Color get tertiaryContainerColor;
  Color get onTertiaryContainerColor;
  Color get errorColor;
  Color get onErrorColor;
  Color get errorContainerColor;
  Color get onErrorContainerColor;
  Color get outlineColor;
  Color get outlineVariantColor;
  Color get shadowColor;
  Color get onSurfaceColor;
  Color get onSurfaceVariantColor;
  Color get inverseSurfaceColor;
  Color get inverseOnSurfaceColor;
}

class _LightColorScheme extends _ColorSchemeBase {
  @override
  Brightness get brightness => Brightness.light;

  @override
  ColorScheme get colorScheme => const ColorScheme.light(
        primary: AppColors.lightPrimary,
        primaryContainer: AppColors.lightPrimaryContainer,
        onPrimary: AppColors.lightOnPrimary,
        onPrimaryContainer: AppColors.lightOnPrimaryContainer,
        secondary: AppColors.lightSecondary,
        secondaryContainer: AppColors.lightSecondaryContainer,
        onSecondary: AppColors.lightOnSecondary,
        onSecondaryContainer: AppColors.lightOnSecondaryContainer,
        tertiary: AppColors.lightTertiary,
        tertiaryContainer: AppColors.lightTertiaryContainer,
        onTertiary: AppColors.lightOnTertiary,
        onTertiaryContainer: AppColors.lightOnTertiaryContainer,
        error: AppColors.lightError,
        errorContainer: AppColors.lightErrorContainer,
        onError: AppColors.lightOnError,
        onErrorContainer: AppColors.lightOnErrorContainer,
        surface: AppColors.lightSurface,
        onSurface: AppColors.lightOnSurface,
        surfaceContainerHighest: AppColors.lightSurfaceContainerHighest,
        surfaceContainerHigh: AppColors.lightSurfaceContainerHigh,
        surfaceContainer: AppColors.lightSurfaceContainer,
        surfaceContainerLow: AppColors.lightSurfaceContainerLow,
        surfaceContainerLowest: AppColors.lightSurfaceContainerLowest,
        onSurfaceVariant: AppColors.lightOnSurfaceVariant,
        outline: AppColors.lightOutline,
        outlineVariant: AppColors.lightOutlineVariant,
        shadow: AppColors.lightShadow,
        scrim: AppColors.lightScrim,
        inverseSurface: AppColors.lightInverseSurface,
        onInverseSurface: AppColors.lightInverseOnSurface,
        inversePrimary: AppColors.lightInversePrimary,
        primaryFixed: AppColors.lightPrimaryFixed,
        primaryFixedDim: AppColors.lightPrimaryFixedDim,
        onPrimaryFixed: AppColors.lightOnPrimaryFixed,
        onPrimaryFixedVariant: AppColors.lightOnPrimaryFixedVariant,
        secondaryFixed: AppColors.lightSecondaryFixed,
        secondaryFixedDim: AppColors.lightSecondaryFixedDim,
        onSecondaryFixed: AppColors.lightOnSecondaryFixed,
        onSecondaryFixedVariant: AppColors.lightOnSecondaryFixedVariant,
        tertiaryFixed: AppColors.lightTertiaryFixed,
        tertiaryFixedDim: AppColors.lightTertiaryFixedDim,
        onTertiaryFixed: AppColors.lightOnTertiaryFixed,
        onTertiaryFixedVariant: AppColors.lightOnTertiaryFixedVariant,
        surfaceTint: AppColors.lightSurfaceTint,
        surfaceBright: AppColors.lightSurface,
        surfaceDim: AppColors.lightSurfaceContainer,
      );

  @override
  Color get backgroundColor => AppColors.lightBackground;
  @override
  Color get surfaceColor => AppColors.lightSurface;
  @override
  Color get surfaceVariantColor => AppColors.lightSurfaceVariant;
  @override
  Color get surfaceTintColor => AppColors.lightSurfaceTint;
  @override
  Color get primaryColor => AppColors.lightPrimary;
  @override
  Color get onPrimaryColor => AppColors.lightOnPrimary;
  @override
  Color get primaryContainerColor => AppColors.lightPrimaryContainer;
  @override
  Color get onPrimaryContainerColor => AppColors.lightOnPrimaryContainer;
  @override
  Color get secondaryColor => AppColors.lightSecondary;
  @override
  Color get onSecondaryColor => AppColors.lightOnSecondary;
  @override
  Color get secondaryContainerColor => AppColors.lightSecondaryContainer;
  @override
  Color get onSecondaryContainerColor => AppColors.lightOnSecondaryContainer;
  @override
  Color get tertiaryColor => AppColors.lightTertiary;
  @override
  Color get onTertiaryColor => AppColors.lightOnTertiary;
  @override
  Color get tertiaryContainerColor => AppColors.lightTertiaryContainer;
  @override
  Color get onTertiaryContainerColor => AppColors.lightOnTertiaryContainer;
  @override
  Color get errorColor => AppColors.lightError;
  @override
  Color get onErrorColor => AppColors.lightOnError;
  @override
  Color get errorContainerColor => AppColors.lightErrorContainer;
  @override
  Color get onErrorContainerColor => AppColors.lightOnErrorContainer;
  @override
  Color get outlineColor => AppColors.lightOutline;
  @override
  Color get outlineVariantColor => AppColors.lightOutlineVariant;
  @override
  Color get shadowColor => AppColors.lightShadow;
  @override
  Color get onSurfaceColor => AppColors.lightOnSurface;
  @override
  Color get onSurfaceVariantColor => AppColors.lightOnSurfaceVariant;
  @override
  Color get inverseSurfaceColor => AppColors.lightInverseSurface;
  @override
  Color get inverseOnSurfaceColor => AppColors.lightInverseOnSurface;
}

class _DarkColorScheme extends _ColorSchemeBase {
  @override
  Brightness get brightness => Brightness.dark;

  @override
  ColorScheme get colorScheme => const ColorScheme.dark(
        primary: AppColors.darkPrimary,
        primaryContainer: AppColors.darkPrimaryContainer,
        onPrimary: AppColors.darkOnPrimary,
        onPrimaryContainer: AppColors.darkOnPrimaryContainer,
        secondary: AppColors.darkSecondary,
        secondaryContainer: AppColors.darkSecondaryContainer,
        onSecondary: AppColors.darkOnSecondary,
        onSecondaryContainer: AppColors.darkOnSecondaryContainer,
        tertiary: AppColors.darkTertiary,
        tertiaryContainer: AppColors.darkTertiaryContainer,
        onTertiary: AppColors.darkOnTertiary,
        onTertiaryContainer: AppColors.darkOnTertiaryContainer,
        error: AppColors.darkError,
        errorContainer: AppColors.darkErrorContainer,
        onError: AppColors.darkOnError,
        onErrorContainer: AppColors.darkOnErrorContainer,
        surface: AppColors.darkSurface,
        onSurface: AppColors.darkOnSurface,
        surfaceContainerHighest: AppColors.darkSurfaceContainerHighest,
        surfaceContainerHigh: AppColors.darkSurfaceContainerHigh,
        surfaceContainer: AppColors.darkSurfaceContainer,
        surfaceContainerLow: AppColors.darkSurfaceContainerLow,
        surfaceContainerLowest: AppColors.darkSurfaceContainerLowest,
        onSurfaceVariant: AppColors.darkOnSurfaceVariant,
        outline: AppColors.darkOutline,
        outlineVariant: AppColors.darkOutlineVariant,
        shadow: AppColors.darkShadow,
        scrim: AppColors.darkScrim,
        inverseSurface: AppColors.darkInverseSurface,
        onInverseSurface: AppColors.darkInverseOnSurface,
        inversePrimary: AppColors.darkInversePrimary,
        primaryFixed: AppColors.darkPrimaryFixed,
        primaryFixedDim: AppColors.darkPrimaryFixedDim,
        onPrimaryFixed: AppColors.darkOnPrimaryFixed,
        onPrimaryFixedVariant: AppColors.darkOnPrimaryFixedVariant,
        secondaryFixed: AppColors.darkSecondaryFixed,
        secondaryFixedDim: AppColors.darkSecondaryFixedDim,
        onSecondaryFixed: AppColors.darkOnSecondaryFixed,
        onSecondaryFixedVariant: AppColors.darkOnSecondaryFixedVariant,
        tertiaryFixed: AppColors.darkTertiaryFixed,
        tertiaryFixedDim: AppColors.darkTertiaryFixedDim,
        onTertiaryFixed: AppColors.darkOnTertiaryFixed,
        onTertiaryFixedVariant: AppColors.darkOnTertiaryFixedVariant,
        surfaceTint: AppColors.darkSurfaceTint,
        surfaceBright: AppColors.darkSurfaceContainerHigh,
        surfaceDim: AppColors.darkSurfaceContainerLow,
      );

  @override
  Color get backgroundColor => AppColors.darkBackground;
  @override
  Color get surfaceColor => AppColors.darkSurface;
  @override
  Color get surfaceVariantColor => AppColors.darkSurfaceVariant;
  @override
  Color get surfaceTintColor => AppColors.darkSurfaceTint;
  @override
  Color get primaryColor => AppColors.darkPrimary;
  @override
  Color get onPrimaryColor => AppColors.darkOnPrimary;
  @override
  Color get primaryContainerColor => AppColors.darkPrimaryContainer;
  @override
  Color get onPrimaryContainerColor => AppColors.darkOnPrimaryContainer;
  @override
  Color get secondaryColor => AppColors.darkSecondary;
  @override
  Color get onSecondaryColor => AppColors.darkOnSecondary;
  @override
  Color get secondaryContainerColor => AppColors.darkSecondaryContainer;
  @override
  Color get onSecondaryContainerColor => AppColors.darkOnSecondaryContainer;
  @override
  Color get tertiaryColor => AppColors.darkTertiary;
  @override
  Color get onTertiaryColor => AppColors.darkOnTertiary;
  @override
  Color get tertiaryContainerColor => AppColors.darkTertiaryContainer;
  @override
  Color get onTertiaryContainerColor => AppColors.darkOnTertiaryContainer;
  @override
  Color get errorColor => AppColors.darkError;
  @override
  Color get onErrorColor => AppColors.darkOnError;
  @override
  Color get errorContainerColor => AppColors.darkErrorContainer;
  @override
  Color get onErrorContainerColor => AppColors.darkOnErrorContainer;
  @override
  Color get outlineColor => AppColors.darkOutline;
  @override
  Color get outlineVariantColor => AppColors.darkOutlineVariant;
  @override
  Color get shadowColor => AppColors.darkShadow;
  @override
  Color get onSurfaceColor => AppColors.darkOnSurface;
  @override
  Color get onSurfaceVariantColor => AppColors.darkOnSurfaceVariant;
  @override
  Color get inverseSurfaceColor => AppColors.darkInverseSurface;
  @override
  Color get inverseOnSurfaceColor => AppColors.darkInverseOnSurface;
}