import 'package:flutter/material.dart';
import 'package:frontend_spaceregis/core/routes/app_routes.dart';
import 'package:frontend_spaceregis/core/theme/app_theme.dart';
import 'package:frontend_spaceregis/screens.dart';
void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appTheme ,
      routes: {
        splashScreen: (context) => const SplashScreen(),
        homeScreen: (context) => const HomeScreen(),
        dashboardScreen: (context) => const DashboardScreen(),
        createSpeciesScreen: (context) => const CreateSpecies(),
        personalAccountScreen: (context) => const PersonalAccount(),
        loginScreen: (context) => const LoginScreen(),
        registerScreen: (context) => const RegisterScreen(),
        introScreen: (context) => const IntroductionPage(),
        
      },
      initialRoute: splashScreen,
    );
  }
}
