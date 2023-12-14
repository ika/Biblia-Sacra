import 'package:flutter/material.dart';

// https://rydmike.com/flexcolorscheme/themesplayground-latest/

class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  AppColorsExtension(
      {required this.primary,
      required this.onPrimary,
      required this.primaryContainer,
      required this.onPrimaryContainer,
      required this.secondary,
      required this.onSecondary,
      required this.secondaryContainer,
      required this.onSecondaryContainer,
      required this.tertiary,
      required this.onTertiary,
      required this.tertiaryContainer,
      required this.onTertiaryContainer,
      required this.error,
      required this.onError,
      required this.errorContainer,
      required this.onErrorContainer,
      required this.background,
      required this.onBackground,
      required this.surface,
      required this.onSurface,
      required this.surfaceVariant,
      required this.onSurfaceVariant,
      required this.outline,
      required this.outlineVariant,
      required this.shadow,
      required this.scrim,
      required this.inverseSurface,
      required this.onInverseSurface,
      required this.inversePrimary,
      required this.surfaceTint});

  final Color primary;
  final Color onPrimary;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color secondary;
  final Color onSecondary;
  final Color secondaryContainer;
  final Color onSecondaryContainer;
  final Color tertiary;
  final Color onTertiary;
  final Color tertiaryContainer;
  final Color onTertiaryContainer;
  final Color error;
  final Color onError;
  final Color errorContainer;
  final Color onErrorContainer;
  final Color background;
  final Color onBackground;
  final Color surface;
  final Color onSurface;
  final Color surfaceVariant;
  final Color onSurfaceVariant;
  final Color outline;
  final Color outlineVariant;
  final Color shadow;
  final Color scrim;
  final Color inverseSurface;
  final Color onInverseSurface;
  final Color inversePrimary;
  final Color surfaceTint;

  @override
  ThemeExtension<AppColorsExtension> copyWith({
    Color? primary,
    Color? onPrimary,
    Color? primaryContainer,
    Color? onPrimaryContainer,
    Color? secondary,
    Color? onSecondary,
    Color? secondaryContainer,
    Color? onSecondaryContainer,
    Color? tertiary,
    Color? onTertiary,
    Color? tertiaryContainer,
    Color? onTertiaryContainer,
    Color? error,
    Color? onError,
    Color? errorContainer,
    Color? onErrorContainer,
    Color? background,
    Color? onBackground,
    Color? surface,
    Color? onSurface,
    Color? surfaceVariant,
    Color? onSurfaceVariant,
    Color? outline,
    Color? outlineVariant,
    Color? shadow,
    Color? scrim,
    Color? inverseSurface,
    Color? onInverseSurface,
    Color? inversePrimary,
    Color? surfaceTint,
  }) {
    return AppColorsExtension(
        primary: primary ?? this.primary,
        onPrimary: onPrimary ?? this.onPrimary,
        primaryContainer: primaryContainer ?? this.primaryContainer,
        onPrimaryContainer: onPrimaryContainer ?? this.onPrimaryContainer,
        secondary: secondary ?? this.secondary,
        onSecondary: onSecondary ?? this.onSecondary,
        secondaryContainer: secondaryContainer ?? this.secondaryContainer,
        onSecondaryContainer: onSecondaryContainer ?? this.onSecondaryContainer,
        tertiary: tertiary ?? this.tertiary,
        onTertiary: onTertiary ?? this.onTertiary,
        tertiaryContainer: tertiaryContainer ?? this.tertiaryContainer,
        onTertiaryContainer: onTertiaryContainer ?? this.onTertiaryContainer,
        error: error ?? this.error,
        onError: onError ?? this.onError,
        errorContainer: errorContainer ?? this.errorContainer,
        onErrorContainer: onErrorContainer ?? this.onErrorContainer,
        background: background ?? this.background,
        onBackground: onBackground ?? this.onBackground,
        surface: surface ?? this.surface,
        onSurface: onSurface ?? this.onSurface,
        surfaceVariant: surfaceVariant ?? this.surfaceVariant,
        onSurfaceVariant: onSurfaceVariant ?? this.onSurfaceVariant,
        outline: outline ?? this.outline,
        outlineVariant: outlineVariant ?? this.outlineVariant,
        shadow: shadow ?? this.shadow,
        scrim: scrim ?? this.scrim,
        inverseSurface: inverseSurface ?? this.inverseSurface,
        onInverseSurface: onInverseSurface ?? this.onInverseSurface,
        inversePrimary: inversePrimary ?? this.inversePrimary,
        surfaceTint: surfaceTint ?? this.surfaceTint);
  }

  @override
  ThemeExtension<AppColorsExtension> lerp(
    covariant ThemeExtension<AppColorsExtension>? other,
    double t,
  ) {
    if (other is! AppColorsExtension) {
      return this;
    }

    return AppColorsExtension(
        primary: Color.lerp(primary, other.primary, t)!,
        onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
        primaryContainer:
            Color.lerp(primaryContainer, other.primaryContainer, t)!,
        onPrimaryContainer:
            Color.lerp(onPrimaryContainer, other.onPrimaryContainer, t)!,
        secondary: Color.lerp(secondary, other.secondary, t)!,
        onSecondary: Color.lerp(onSecondary, other.onSecondary, t)!,
        secondaryContainer:
            Color.lerp(secondaryContainer, other.secondaryContainer, t)!,
        onSecondaryContainer:
            Color.lerp(onSecondaryContainer, other.onSecondaryContainer, t)!,
        tertiary: Color.lerp(tertiary, other.tertiary, t)!,
        onTertiary: Color.lerp(onTertiary, other.onTertiary, t)!,
        tertiaryContainer:
            Color.lerp(tertiaryContainer, other.tertiaryContainer, t)!,
        onTertiaryContainer:
            Color.lerp(onTertiaryContainer, other.onTertiaryContainer, t)!,
        error: Color.lerp(error, other.error, t)!,
        onError: Color.lerp(onError, other.onError, t)!,
        errorContainer: Color.lerp(errorContainer, other.errorContainer, t)!,
        onErrorContainer:
            Color.lerp(onErrorContainer, other.onErrorContainer, t)!,
        background: Color.lerp(background, other.background, t)!,
        onBackground: Color.lerp(onBackground, other.onBackground, t)!,
        surface: Color.lerp(surface, other.surface, t)!,
        onSurface: Color.lerp(onSurface, other.onSurface, t)!,
        surfaceVariant: Color.lerp(surfaceVariant, other.surfaceVariant, t)!,
        onSurfaceVariant:
            Color.lerp(onSurfaceVariant, other.onSurfaceVariant, t)!,
        outline: Color.lerp(outline, other.outline, t)!,
        outlineVariant: Color.lerp(outlineVariant, other.outlineVariant, t)!,
        shadow: Color.lerp(shadow, other.shadow, t)!,
        scrim: Color.lerp(scrim, other.scrim, t)!,
        inverseSurface: Color.lerp(inverseSurface, other.inverseSurface, t)!,
        onInverseSurface:
            Color.lerp(onInverseSurface, other.onInverseSurface, t)!,
        inversePrimary: Color.lerp(inversePrimary, other.inversePrimary, t)!,
        surfaceTint: Color.lerp(surfaceTint, other.surfaceTint, t)!);
  }
}

/// Optional. If you also want to assign colors in the `ColorScheme`.
extension ColorSchemeBuilder on AppColorsExtension {
  ColorScheme toColorScheme(Brightness brightness) {
    return ColorScheme(
        brightness: brightness,
        primary: primary,
        onPrimary: onPrimary,
        primaryContainer: primaryContainer,
        onPrimaryContainer: onPrimaryContainer,
        secondary: secondary,
        onSecondary: onSecondary,
        secondaryContainer: secondaryContainer,
        onSecondaryContainer: onSecondaryContainer,
        tertiary: tertiary,
        onTertiary: onTertiary,
        tertiaryContainer: tertiaryContainer,
        onTertiaryContainer: onTertiaryContainer,
        error: error,
        onError: onError,
        errorContainer: errorContainer,
        onErrorContainer: onErrorContainer,
        background: background,
        onBackground: onBackground,
        surface: surface,
        onSurface: onSurface,
        surfaceVariant: surfaceVariant,
        onSurfaceVariant: onSurfaceVariant,
        outline: outline,
        outlineVariant: outlineVariant,
        shadow: shadow,
        scrim: scrim,
        inverseSurface: inverseSurface,
        onInverseSurface: onInverseSurface,
        inversePrimary: inversePrimary,
        surfaceTint: surfaceTint);
  }
}

class AppTheme {
  static final light = ThemeData.light().copyWith(
    extensions: [
      _flexSchemeLight,
    ],
  );

  // san juan blue
  static final _flexSchemeLight = AppColorsExtension(
    primary: const Color(0xff375778),
    onPrimary: const Color(0xffffffff),
    primaryContainer: const Color(0xffa4c4ed),
    onPrimaryContainer: const Color(0xff0e1014),
    secondary: const Color(0xfff2c4c7),
    onSecondary: const Color(0xff000000),
    secondaryContainer: const Color(0xffffe3e5),
    onSecondaryContainer: const Color(0xff141313),
    tertiary: const Color(0xfff98d94),
    onTertiary: const Color(0xff000000),
    tertiaryContainer: const Color(0xffffc4c6),
    onTertiaryContainer: const Color(0xff141011),
    error: const Color(0xffb00020),
    onError: const Color(0xffffffff),
    errorContainer: const Color(0xfffcd8df),
    onErrorContainer: const Color(0xff141213),
    background: const Color(0xfff9fafb),
    onBackground: const Color(0xff090909),
    surface: const Color(0xfff9fafb),
    onSurface: const Color(0xff090909),
    surfaceVariant: const Color(0xffe3e5e7),
    onSurfaceVariant: const Color(0xff111112),
    outline: const Color(0xff7c7c7c),
    outlineVariant: const Color(0xffc8c8c8),
    shadow: const Color(0xff000000),
    scrim: const Color(0xff000000),
    inverseSurface: const Color(0xff121213),
    onInverseSurface: const Color(0xfff5f5f5),
    inversePrimary: const Color(0xffc3d7eb),
    surfaceTint: const Color(0xff375778),
  );

  static final dark = ThemeData.dark().copyWith(
    extensions: [
      _flexSchemeDark,
    ],
  );

  static final _flexSchemeDark = AppColorsExtension(
    primary: const Color(0xff5e7691),
    onPrimary: const Color(0xfff6f8fa),
    primaryContainer: const Color(0xff375778),
    onPrimaryContainer: const Color(0xffe8edf2),
    secondary: const Color(0xfff4cfd1),
    onSecondary: const Color(0xff141414),
    secondaryContainer: const Color(0xff96434f),
    onSecondaryContainer: const Color(0xfff7eaec),
    tertiary: const Color(0xffeba1a6),
    onTertiary: const Color(0xff141011),
    tertiaryContainer: const Color(0xffae424f),
    onTertiaryContainer: const Color(0xfffbeaec),
    error: const Color(0xffcf6679),
    onError: const Color(0xff140c0d),
    errorContainer: const Color(0xffb1384e),
    onErrorContainer: const Color(0xfffbe8ec),
    background: const Color(0xff141617),
    onBackground: const Color(0xffececec),
    surface: const Color(0xff141617),
    onSurface: const Color(0xffececec),
    surfaceVariant: const Color(0xff36383b),
    onSurfaceVariant: const Color(0xffdfdfe0),
    outline: const Color(0xff797979),
    outlineVariant: const Color(0xff2d2d2d),
    shadow: const Color(0xff000000),
    scrim: const Color(0xff000000),
    inverseSurface: const Color(0xfff6f8f9),
    onInverseSurface: const Color(0xff131313),
    inversePrimary: const Color(0xff36414d),
    surfaceTint: const Color(0xff5e7691),
  );
}

    // primary: const Color(0xff4496e0),
    // onPrimary: const Color(0xffffffff),
    // primaryContainer: const Color(0xffb4e6ff),
    // onPrimaryContainer: const Color(0xff0f1314),
    // secondary: const Color(0xff202b6d),
    // onSecondary: const Color(0xffffffff),
    // secondaryContainer: const Color(0xff99ccf9),
    // onSecondaryContainer: const Color(0xff0d1114),
    // tertiary: const Color(0xff514239),
    // onTertiary: const Color(0xffffffff),
    // tertiaryContainer: const Color(0xffbaa99d),
    // onTertiaryContainer: const Color(0xff100e0d),
    // error: const Color(0xffb00020),
    // onError: const Color(0xffffffff),
    // errorContainer: const Color(0xfffcd8df),
    // onErrorContainer: const Color(0xff141213),
    // background: const Color(0xfff9fcfe),
    // onBackground: const Color(0xff090909),
    // surface: const Color(0xfff9fcfe),
    // onSurface: const Color(0xff090909),
    // surfaceVariant: const Color(0xffe4e9ed),
    // onSurfaceVariant: const Color(0xff111212),
    // outline: const Color(0xff7c7c7c),
    // outlineVariant: const Color(0xffc8c8c8),
    // shadow: const Color(0xff000000),
    // scrim: const Color(0xff000000),
    // inverseSurface: const Color(0xff121416),
    // onInverseSurface: const Color(0xfff5f5f5),
    // inversePrimary: const Color(0xffddfeff),
    // surfaceTint: const Color(0xff4496e0),

    //    primary: const Color(0xffb4e6ff),
    // onPrimary: const Color(0xff121414),
    // primaryContainer: const Color(0xff1e8fdb),
    // onPrimaryContainer: const Color(0xffe4f6ff),
    // secondary: const Color(0xff99ccf9),
    // onSecondary: const Color(0xff101414),
    // secondaryContainer: const Color(0xff202b6d),
    // onSecondaryContainer: const Color(0xffe4e6f0),
    // tertiary: const Color(0xffbaa99d),
    // onTertiary: const Color(0xff121110),
    // tertiaryContainer: const Color(0xff514239),
    // onTertiaryContainer: const Color(0xffeceae8),
    // error: const Color(0xffcf6679),
    // onError: const Color(0xff140c0d),
    // errorContainer: const Color(0xffb1384e),
    // onErrorContainer: const Color(0xfffbe8ec),
    // background: const Color(0xff191b1d),
    // onBackground: const Color(0xffeceded),
    // surface: const Color(0xff191b1d),
    // onSurface: const Color(0xffeceded),
    // surfaceVariant: const Color(0xff3f4446),
    // onSurfaceVariant: const Color(0xffe0e1e1),
    // outline: const Color(0xff767d7d),
    // outlineVariant: const Color(0xff2c2e2e),
    // shadow: const Color(0xff000000),
    // scrim: const Color(0xff000000),
    // inverseSurface: const Color(0xfffbfdff),
    // onInverseSurface: const Color(0xff131314),
    // inversePrimary: const Color(0xff5c7177),
    // surfaceTint: const Color(0xffb4e6ff),
