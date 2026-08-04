// lib/core/design/spacing.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Spacing and sizing constants for consistent layout
class AppSpacing {
  AppSpacing._();

  // ============================================
  // BASE SPACING UNIT (4px grid)
  // ============================================
  
  static const double _baseUnit = 4.0;

  // ============================================
  // SPACING SCALE
  // ============================================
  
  // 0.5x = 2px
  static double get xs => (_baseUnit * 0.5).w;
  // 1x = 4px
  static double get sm => (_baseUnit * 1).w;
  // 1.5x = 6px
  static double get smMd => (_baseUnit * 1.5).w;
  // 2x = 8px
  static double get md => (_baseUnit * 2).w;
  // 2.5x = 10px
  static double get mdLg => (_baseUnit * 2.5).w;
  // 3x = 12px
  static double get lg => (_baseUnit * 3).w;
  // 4x = 16px
  static double get xl => (_baseUnit * 4).w;
  // 5x = 20px
  static double get xxl => (_baseUnit * 5).w;
  // 6x = 24px
  static double get xxxl => (_baseUnit * 6).w;
  // 8x = 32px
  static double get huge => (_baseUnit * 8).w;
  // 10x = 40px
  static double get massive => (_baseUnit * 10).w;

  // ============================================
  // RESPONSIVE SPACING (height-based)
  // ============================================
  
  static double get xsH => (_baseUnit * 0.5).h;
  static double get smH => (_baseUnit * 1).h;
  static double get smMdH => (_baseUnit * 1.5).h;
  static double get mdH => (_baseUnit * 2).h;
  static double get mdLgH => (_baseUnit * 2.5).h;
  static double get lgH => (_baseUnit * 3).h;
  static double get xlH => (_baseUnit * 4).h;
  static double get xxlH => (_baseUnit * 5).h;
  static double get xxxlH => (_baseUnit * 6).h;
  static double get hugeH => (_baseUnit * 8).h;
  static double get massiveH => (_baseUnit * 10).h;

  // ============================================
  // COMPONENT-SPECIFIC SPACING
  // ============================================
  
  // Button padding
  static double get buttonPaddingHorizontal => md * 2; // 16px
  static double get buttonPaddingVertical => smMd; // 6px
  static double get buttonPaddingHorizontalLarge => xl; // 16px
  static double get buttonPaddingVerticalLarge => md; // 8px
  static double get buttonPaddingHorizontalSmall => smMd; // 6px
  static double get buttonPaddingVerticalSmall => xs; // 2px

  // Card padding
  static double get cardPadding => lg; // 12px
  static double get cardPaddingLarge => xl; // 16px
  static double get cardPaddingSmall => md; // 8px

  // Screen padding
  static double get screenPaddingHorizontal => xl; // 16px
  static double get screenPaddingVertical => lg; // 12px
  static double get screenPaddingHorizontalLarge => xxl; // 20px
  static double get screenPaddingVerticalLarge => xl; // 16px

  // List/item spacing
  static double get itemSpacing => md; // 8px
  static double get itemSpacingLarge => lg; // 12px
  static double get itemSpacingSmall => sm; // 4px

  // Section spacing
  static double get sectionSpacing => xl; // 16px
  static double get sectionSpacingLarge => xxl; // 20px
  static double get sectionSpacingSmall => lg; // 12px

  // Inset spacing
  static double get insetSmall => sm; // 4px
  static double get insetMedium => md; // 8px
  static double get insetLarge => lg; // 12px

  // ============================================
  // BORDER RADIUS
  // ============================================
  
  static double get radiusNone => 0.r;
  static double get radiusXs => 2.r;
  static double get radiusSm => 4.r;
  static double get radiusMd => 8.r;
  static double get radiusLg => 12.r;
  static double get radiusXl => 16.r;
  static double get radiusXxl => 20.r;
  static double get radiusXxxl => 24.r;
  static double get radiusRound => 9999.r;
  static double get radiusCircle => 9999.r;

  // Component-specific radii
  static double get buttonRadius => radiusMd; // 8px
  static double get buttonRadiusLarge => radiusLg; // 12px
  static double get buttonRadiusSmall => radiusSm; // 4px
  static double get cardRadius => radiusXl; // 16px
  static double get cardRadiusLarge => radiusXxl; // 20px
  static double get cardRadiusSmall => radiusLg; // 12px
  static double get chipRadius => radiusRound;
  static double get inputRadius => radiusMd; // 8px
  static double get dialogRadius => radiusXxl; // 20px
  static double get bottomSheetRadius => radiusXxl; // 20px
  static double get tooltipRadius => radiusSm; // 4px

  // ============================================
  // ICON SIZES
  // ============================================
  
  static double get iconXs => 12.sp;
  static double get iconSm => 16.sp;
  static double get iconMd => 20.sp;
  static double get iconLg => 24.sp;
  static double get iconXl => 28.sp;
  static double get iconXxl => 32.sp;
  static double get iconXxxl => 40.sp;
  static double get iconHuge => 48.sp;
  static double get iconMassive => 64.sp;

  // ============================================
  // COMPONENT SIZES
  // ============================================
  
  // Button heights
  static double get buttonHeightSmall => 32.h;
  static double get buttonHeightMedium => 40.h;
  static double get buttonHeightLarge => 48.h;
  static double get buttonHeightXLarge => 56.h;

  // Input heights
  static double get inputHeightSmall => 36.h;
  static double get inputHeightMedium => 44.h;
  static double get inputHeightLarge => 52.h;

  // Touch targets (minimum 48x48 for accessibility)
  static double get touchTargetMin => 48.w;
  static double get touchTargetComfortable => 56.w;

  // App bar
  static double get appBarHeight => 56.h;
  static double get appBarHeightExtended => 72.h;

  // Bottom navigation
  static double get bottomNavHeight => 70.h;
  static double get bottomNavHeightCompact => 56.h;

  // Divider thickness
  static double get dividerThin => 0.5.w;
  static double get dividerNormal => 1.w;
  static double get dividerThick => 2.w;

  // ============================================
  // LAYOUT CONSTRAINTS
  // ============================================
  
  static double get maxContentWidth => 430.w;
  static double get maxContentWidthLarge => 600.w;
  static double get minTouchWidth => 48.w;
  static double get minTouchHeight => 48.h;

  // ============================================
  // ANIMATION SPACING (for staggered animations)
  // ============================================
  
  static double get staggerDelay => 50; // ms
  static double get staggerDelayLarge => 100; // ms

  // ============================================
  // HELPER METHODS
  // ============================================
  
  static EdgeInsets symmetric({double horizontal = 0, double vertical = 0}) {
    return EdgeInsets.symmetric(
      horizontal: horizontal.w,
      vertical: vertical.h,
    );
  }

  static EdgeInsets all(double value) {
    return EdgeInsets.all(value.w);
  }

  static EdgeInsets only({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) {
    return EdgeInsets.only(
      left: left.w,
      top: top.h,
      right: right.w,
      bottom: bottom.h,
    );
  }

  static EdgeInsets fromLTRB(
    double left,
    double top,
    double right,
    double bottom,
  ) {
    return EdgeInsets.fromLTRB(left.w, top.h, right.w, bottom.h);
  }

  static BorderRadius circular(double radius) {
    return BorderRadius.circular(radius.r);
  }

  static BorderRadius radiusOnly({
    double topLeft = 0,
    double topRight = 0,
    double bottomLeft = 0,
    double bottomRight = 0,
  }) {
    return BorderRadius.only(
      topLeft: Radius.circular(topLeft.r),
      topRight: Radius.circular(topRight.r),
      bottomLeft: Radius.circular(bottomLeft.r),
      bottomRight: Radius.circular(bottomRight.r),
    );
  }

  // Predefined insets
  static EdgeInsets get screenPadding => symmetric(
    horizontal: screenPaddingHorizontal,
    vertical: screenPaddingVertical,
  );

  static EdgeInsets get cardPaddingInsets => all(cardPadding);
  static EdgeInsets get buttonPadding => symmetric(
    horizontal: buttonPaddingHorizontal,
    vertical: buttonPaddingVertical,
  );
  static EdgeInsets get buttonPaddingLarge => symmetric(
    horizontal: buttonPaddingHorizontalLarge,
    vertical: buttonPaddingVerticalLarge,
  );
}