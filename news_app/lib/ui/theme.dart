import 'package:material_ui/material_ui.dart';

/// Spacing scale used across the app (4dp grid).
abstract final class Insets {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
}

/// Corner radii used across the app.
abstract final class Radii {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 20;
  static const double xl = 28;
}

/// Builds the Material 3 theme for [brightness] seeded from [seed].
ThemeData buildTheme(Brightness brightness, Color seed) {
  final scheme = ColorScheme.fromSeed(seedColor: seed, brightness: brightness);
  final base = ThemeData(useMaterial3: true, colorScheme: scheme);
  final text = base.textTheme;
  final textTheme = text.copyWith(
    headlineMedium: text.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
    headlineSmall: text.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
    titleLarge: text.titleLarge?.copyWith(
      fontWeight: FontWeight.w700,
      height: 1.25,
    ),
    titleMedium: text.titleMedium?.copyWith(
      fontWeight: FontWeight.w600,
      height: 1.3,
    ),
    labelMedium: text.labelMedium?.copyWith(fontWeight: FontWeight.w600),
  );
  final rounded = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(Radii.lg),
  );

  return base.copyWith(
    textTheme: textTheme,
    scaffoldBackgroundColor: scheme.surface,
    visualDensity: VisualDensity.standard,
    materialTapTargetSize: MaterialTapTargetSize.padded,
    appBarTheme: AppBarTheme(
      backgroundColor: scheme.surface,
      foregroundColor: scheme.onSurface,
      surfaceTintColor: scheme.surfaceTint,
      scrolledUnderElevation: 3,
      centerTitle: false,
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: scheme.surfaceContainerLow,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: rounded.copyWith(
        side: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.6)),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: scheme.surfaceContainer,
      indicatorColor: scheme.secondaryContainer,
      labelTextStyle: WidgetStatePropertyAll(textTheme.labelMedium),
    ),
    searchBarTheme: SearchBarThemeData(
      elevation: const WidgetStatePropertyAll(0),
      backgroundColor: WidgetStatePropertyAll(scheme.surfaceContainerHigh),
      constraints: const BoxConstraints(minHeight: 56),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: Insets.lg),
      ),
    ),
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(horizontal: Insets.xl),
      minVerticalPadding: Insets.md,
      iconColor: scheme.onSurfaceVariant,
    ),
    dialogTheme: DialogThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Radii.xl),
      ),
    ),
    snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
    progressIndicatorTheme: ProgressIndicatorThemeData(color: scheme.primary),
  );
}
