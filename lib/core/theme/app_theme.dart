import 'package:flutter/material.dart';
import 'package:frontend_spaceregis/core/constant/constant.dart';
import 'package:google_fonts/google_fonts.dart';

final appTheme = ThemeData(
  scaffoldBackgroundColor: Colors.white,
  textTheme: GoogleFonts.poppinsTextTheme(),
  appBarTheme: const AppBarTheme(
    backgroundColor: greenColor,
    surfaceTintColor: greenColor,
    elevation: 1,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: greenColor,
    type: BottomNavigationBarType.fixed,
    selectedLabelStyle: const TextStyle(color: Colors.white, fontSize: 25),
    unselectedLabelStyle: const TextStyle(color: Colors.white, fontSize: 25),
  ),
);
