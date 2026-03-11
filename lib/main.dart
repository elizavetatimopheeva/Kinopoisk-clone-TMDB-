import 'package:flutter/material.dart';
import 'package:kino/Theme/app_colors.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kino/widgets/navigation/main_navigation.dart';



void main() {
  const app = MyApp();
  runApp(app);
}

class MyApp extends StatelessWidget {
  // final MyAppModel model;
  static final mainNavigation=MainNavigation();
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
  
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.mainDarkBlue,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData (
        backgroundColor: AppColors.mainDarkBlue,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey),
        ),

      localizationsDelegates: [
       GlobalMaterialLocalizations.delegate,
       GlobalWidgetsLocalizations.delegate,
       GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'), 
        Locale('ru', 'RU'),
      ],

      routes: mainNavigation.routes,
      initialRoute: MainNavigationRouteNames.loaderWidget,
      onGenerateRoute: mainNavigation.onGenerateRoute,
    );
  }
}


