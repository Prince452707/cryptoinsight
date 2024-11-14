import 'package:flutter/material.dart';



class ThemeProvider extends ChangeNotifier {
  static const Color _primaryDark = Color(0xFF6200EA);
  static const Color _primaryLight = Color(0xFF3F51B5);
  static const Color _accentDark = Color(0xFFFF4081);
  static const Color _accentLight = Color(0xFFFF9800);
  static const Color _backgroundDark = Color(0xFF121212);
  static const Color _backgroundLight = Color(0xFFF5F5F5);
  static const Color _cardDark = Color(0xFF1E1E1E);
  static const Color _cardLight = Color(0xFFFFFFFF);
  static final ThemeData _darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: _primaryDark,
    scaffoldBackgroundColor: _backgroundDark,
    cardColor: _cardDark,
    colorScheme: const ColorScheme.dark(
      primary: _primaryDark,
      secondary: _accentDark,
      surface: _cardDark,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
      bodyMedium: TextStyle(color: Colors.white70, fontFamily: 'Roboto'),
      displayLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
      labelLarge: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: _accentDark,
      textTheme: ButtonTextTheme.primary,
    ),
    iconTheme: const IconThemeData(color: _accentDark),
  );

  static final ThemeData _lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: _primaryLight,
    scaffoldBackgroundColor: _backgroundLight,
    cardColor: _cardLight,
    colorScheme: const ColorScheme.light(
      primary: _primaryLight,
      secondary: _accentLight,
      surface: _cardLight,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black87, fontFamily: 'Roboto'),
      bodyMedium: TextStyle(color: Colors.black54, fontFamily: 'Roboto'),
      displayLarge: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
      labelLarge: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: _accentLight,
      textTheme: ButtonTextTheme.primary,
    ),
    iconTheme: const IconThemeData(color: _accentLight),
  );

  late ThemeData _currentTheme;

  ThemeProvider() {
    _currentTheme = _darkTheme;
  }

  ThemeData get currentTheme => _currentTheme;
  bool get isDarkMode => _currentTheme.brightness == Brightness.dark;

  void toggleTheme() {
    _currentTheme = isDarkMode ? _lightTheme : _darkTheme;
    notifyListeners();
  }

  void setDarkMode() {
    _currentTheme = _darkTheme;
    notifyListeners();
  }

  void setLightMode() {
    _currentTheme = _lightTheme;
    notifyListeners();
  }
}