import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const String defaultFontFamily = 'NotoSans';
  static const Color _lightCanvas = Color(0xFFF8F1E6);
  static const Color _darkCanvas = Color(0xFF0D0A07);
  static const Color lightSystemUiBackground = _lightCanvas;
  static const Color darkSystemUiBackground = _darkCanvas;

  static const FlexSchemeColor _goldenLightColors = FlexSchemeColor(
    primary: Color(0xffd0953b),
    primaryContainer: Color(0xfff8dcb8),
    secondary: Color(0xffca9b2c),
    secondaryContainer: Color(0xfff8dcb8),
    tertiary: Color(0xffd0953b),
    tertiaryContainer: Color(0xffFEF7FF),
    appBarColor: Color(0xffd0953b),
    error: Color(0xffb3261e),
  );

  static const FlexSchemeColor _goldenDarkColors = FlexSchemeColor(
    primary: Color(0xFFE6C899),
    primaryContainer: Color(0xFF4A3922),
    secondary: Color(0xFFD3B27B),
    secondaryContainer: Color(0xFF3B2E1E),
    tertiary: Color(0xFFF0DAB5),
    tertiaryContainer: Color(0xFF59452A),
    appBarColor: Color(0xFF15110D),
    error: Color(0xffcf6679),
  );

  static ThemeData _withAppFontFamily(ThemeData theme, String fontFamily) {
    return theme.copyWith(
      textTheme: theme.textTheme.apply(fontFamily: fontFamily),
      primaryTextTheme: theme.primaryTextTheme.apply(fontFamily: fontFamily),
    );
  }

  static ThemeData lightWithFont([String fontFamily = defaultFontFamily]) {
    final base = FlexThemeData.light(
      colors: _goldenLightColors,
      swapLegacyOnMaterial3: true,
      surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
      blendLevel: 20,
      appBarStyle: FlexAppBarStyle.background,
      bottomAppBarElevation: 1.0,
      subThemesData: const FlexSubThemesData(
        interactionEffects: true,
        tintedDisabledControls: true,
        blendOnLevel: 20,
        blendOnColors: true,
        useM2StyleDividerInM3: true,
        thickBorderWidth: 2.0,
        elevatedButtonSchemeColor: SchemeColor.onPrimaryContainer,
        elevatedButtonSecondarySchemeColor: SchemeColor.primaryContainer,
        outlinedButtonOutlineSchemeColor: SchemeColor.primary,
        toggleButtonsBorderSchemeColor: SchemeColor.primary,
        segmentedButtonSchemeColor: SchemeColor.primary,
        segmentedButtonBorderSchemeColor: SchemeColor.primary,
        unselectedToggleIsColored: true,
        sliderValueTinted: true,
        inputDecoratorSchemeColor: SchemeColor.primary,
        inputDecoratorIsFilled: true,
        inputDecoratorBackgroundAlpha: 15,
        inputDecoratorBorderType: FlexInputBorderType.outline,
        inputDecoratorRadius: 10.0,
        inputDecoratorPrefixIconSchemeColor: SchemeColor.primary,
        chipRadius: 10.0,
        popupMenuRadius: 6.0,
        popupMenuElevation: 6.0,
        alignedDropdown: true,
        appBarScrolledUnderElevation: 8.0,
        drawerWidth: 280.0,
        drawerIndicatorSchemeColor: SchemeColor.primary,
        bottomNavigationBarMutedUnselectedLabel: false,
        bottomNavigationBarMutedUnselectedIcon: false,
        menuRadius: 6.0,
        menuElevation: 6.0,
        menuBarRadius: 0.0,
        menuBarElevation: 1.0,
        searchBarElevation: 1.0,
        searchViewElevation: 1.0,
        searchUseGlobalShape: true,
        navigationBarSelectedLabelSchemeColor: SchemeColor.primary,
        navigationBarSelectedIconSchemeColor: SchemeColor.onPrimary,
        navigationBarIndicatorSchemeColor: SchemeColor.primary,
        navigationBarElevation: 2.0,
        navigationBarHeight: 70.0,
        navigationRailSelectedLabelSchemeColor: SchemeColor.primary,
        navigationRailSelectedIconSchemeColor: SchemeColor.onPrimary,
        navigationRailUseIndicator: true,
        navigationRailIndicatorSchemeColor: SchemeColor.primary,
        navigationRailIndicatorOpacity: 1.0,
      ),
      keyColors: const FlexKeyColors(
        useTertiary: true,
        keepPrimary: true,
        keepTertiary: true,
      ),
      tones: FlexSchemeVariant.chroma.tones(Brightness.light),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
    );

    return _withAppFontFamily(
      base.copyWith(
        scaffoldBackgroundColor: _lightCanvas,
        canvasColor: _lightCanvas,
        appBarTheme: AppBarTheme(
          backgroundColor: base.colorScheme.surface,
          foregroundColor: base.colorScheme.onSurface,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          iconTheme: IconThemeData(color: base.colorScheme.onSurface),
          actionsIconTheme: IconThemeData(color: base.colorScheme.onSurface),
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFFFDF9F3),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: const Color(0xFFFDF9F3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.fixed,
          backgroundColor: const Color(0xFFF1E2C9),
          contentTextStyle: const TextStyle(
            fontSize: 14,
            height: 1.45,
            fontWeight: FontWeight.w700,
            color: Color(0xFF5F4316),
          ),
          elevation: 0,
          actionTextColor: Color(0xFF8F6320),
          disabledActionTextColor: Color(0xFF8A7A61),
          showCloseIcon: false,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
            side: const BorderSide(color: Color(0xFFD6B37B)),
          ),
        ),
        tooltipTheme: TooltipThemeData(
          decoration: BoxDecoration(
            color: const Color(0xFFF2E1C2),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFD3AE73)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1F7C5B25),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          textStyle: const TextStyle(
            color: Color(0xFF5D431A),
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          waitDuration: const Duration(milliseconds: 300),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF5EFE7),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF7E7366), width: 1.2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF7E7366), width: 1.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xffd0953b), width: 1.6),
          ),
        ),
      ),
      fontFamily,
    );
  }

  static ThemeData darkWithFont([String fontFamily = defaultFontFamily]) {
    final base = FlexThemeData.dark(
      colors: _goldenDarkColors,
      swapLegacyOnMaterial3: true,
      surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
      blendLevel: 16,
      appBarStyle: FlexAppBarStyle.background,
      bottomAppBarElevation: 2.0,
      subThemesData: const FlexSubThemesData(
        interactionEffects: true,
        tintedDisabledControls: true,
        blendOnLevel: 18,
        blendOnColors: true,
        useM2StyleDividerInM3: true,
        thickBorderWidth: 2.0,
        elevatedButtonSchemeColor: SchemeColor.onPrimaryContainer,
        elevatedButtonSecondarySchemeColor: SchemeColor.primaryContainer,
        outlinedButtonOutlineSchemeColor: SchemeColor.primary,
        toggleButtonsBorderSchemeColor: SchemeColor.primary,
        segmentedButtonSchemeColor: SchemeColor.primary,
        segmentedButtonBorderSchemeColor: SchemeColor.primary,
        unselectedToggleIsColored: true,
        sliderValueTinted: true,
        inputDecoratorSchemeColor: SchemeColor.primary,
        inputDecoratorIsFilled: true,
        inputDecoratorBackgroundAlpha: 12,
        inputDecoratorBorderType: FlexInputBorderType.outline,
        inputDecoratorRadius: 10.0,
        chipRadius: 10.0,
        popupMenuRadius: 6.0,
        popupMenuElevation: 6.0,
        alignedDropdown: true,
        drawerWidth: 280.0,
        drawerIndicatorSchemeColor: SchemeColor.primary,
        bottomNavigationBarMutedUnselectedLabel: false,
        bottomNavigationBarMutedUnselectedIcon: false,
        menuRadius: 6.0,
        menuElevation: 6.0,
        menuBarRadius: 0.0,
        menuBarElevation: 1.0,
        searchBarElevation: 1.0,
        searchViewElevation: 1.0,
        searchUseGlobalShape: true,
        navigationBarSelectedLabelSchemeColor: SchemeColor.primary,
        navigationBarSelectedIconSchemeColor: SchemeColor.onPrimaryContainer,
        navigationBarIndicatorSchemeColor: SchemeColor.primaryContainer,
        navigationBarElevation: 2.0,
        navigationBarHeight: 70.0,
        navigationRailSelectedLabelSchemeColor: SchemeColor.primary,
        navigationRailSelectedIconSchemeColor: SchemeColor.onPrimaryContainer,
        navigationRailUseIndicator: true,
        navigationRailIndicatorSchemeColor: SchemeColor.primaryContainer,
        navigationRailIndicatorOpacity: 1.0,
      ),
      keyColors: const FlexKeyColors(useTertiary: true, keepPrimary: true),
      tones: FlexSchemeVariant.chroma.tones(Brightness.dark),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
    );

    return _withAppFontFamily(
      base.copyWith(
        scaffoldBackgroundColor: _darkCanvas,
        canvasColor: _darkCanvas,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF15110D),
          foregroundColor: Color(0xFFF3E6D2),
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          iconTheme: IconThemeData(color: Color(0xFFF3E6D2)),
          actionsIconTheme: IconThemeData(color: Color(0xFFF3E6D2)),
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF1B1611),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: const Color(0xFF1B1611),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.fixed,
          backgroundColor: const Color(0xFF241D15),
          contentTextStyle: const TextStyle(
            fontSize: 14,
            height: 1.45,
            fontWeight: FontWeight.w700,
            color: Color(0xFFF4E8D6),
          ),
          elevation: 0,
          actionTextColor: Color(0xFFE4C38F),
          disabledActionTextColor: Color(0xFFBAA78B),
          showCloseIcon: false,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
            side: const BorderSide(color: Color(0xFF756346)),
          ),
        ),
        tooltipTheme: TooltipThemeData(
          decoration: BoxDecoration(
            color: const Color(0xFF322416),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF8F7043)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x26000000),
                blurRadius: 12,
                offset: Offset(0, 5),
              ),
            ],
          ),
          textStyle: const TextStyle(
            color: Color(0xFFF3E6D2),
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          waitDuration: const Duration(milliseconds: 300),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF1B1611),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF8A7A63), width: 1.1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF8A7A63), width: 1.1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE0C089), width: 1.5),
          ),
        ),
        navigationBarTheme: const NavigationBarThemeData(
          backgroundColor: Color(0xFF15110D),
          indicatorColor: Color(0xFF4A3922),
          elevation: 0,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF15110D),
          selectedItemColor: Color(0xFFE6C899),
          unselectedItemColor: Color(0xFFB8A78E),
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.w700),
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500),
        ),
        navigationRailTheme: const NavigationRailThemeData(
          backgroundColor: Color(0xFF15110D),
          indicatorColor: Color(0xFF4A3922),
          selectedIconTheme: IconThemeData(color: Color(0xFFF3E6D2)),
          unselectedIconTheme: IconThemeData(color: Color(0xFFB8A78E)),
          selectedLabelTextStyle: TextStyle(
            color: Color(0xFFE6C899),
            fontWeight: FontWeight.w700,
          ),
          unselectedLabelTextStyle: TextStyle(
            color: Color(0xFFB8A78E),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      fontFamily,
    );
  }
}
