import 'package:flutter/material.dart';
import 'package:weather_app/screens/maps_screen.dart';
import 'package:weather_app/settings/style_settings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: MyThemes.darkTheme,
        darkTheme: MyThemes.darkTheme,
        //themeMode: themeProvider.themeMode,
        home: const MapSample());
  }
}
