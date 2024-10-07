import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_flash_event/demande/all/demande_all_screen.dart';
import 'package:flutter_flash_event/home/home_screen.dart';
import 'package:flutter_flash_event/jeton/new/jeton_new_screen.dart';
import 'package:flutter_flash_event/kermesse/form/form_kermesse_screen.dart';
import 'package:flutter_flash_event/kermesse/show/kermesse_show_screen.dart';
import 'package:flutter_flash_event/myAccount/my_account_screen.dart';
import 'package:flutter_flash_event/login/login_screen.dart';
import 'package:flutter_flash_event/screens/register_screen.dart';
import 'package:flutter_flash_event/screens/splash_screen.dart';
import 'package:flutter_flash_event/stand/form/form_stand_screen.dart';
import 'package:flutter_flash_event/stand/show/stand_show_screen.dart';
import 'package:flutter_flash_event/tombola/new/tombola_new_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  final args = settings.arguments;
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(builder: (_) => LoginScreen());
    case '/register':
      return MaterialPageRoute(builder: (_) => const RegisterScreen());
    case HomeScreen.routeName:
      return MaterialPageRoute(builder: (_) => const HomeScreen());
    case MyAccountScreen.routeName:
      return MaterialPageRoute(builder: (_) => const MyAccountScreen());
    case FormKermesseScreen.routeName:
      return MaterialPageRoute(builder: (_) => const FormKermesseScreen());
    case FormStandScreen.routeName:
      return MaterialPageRoute(builder: (context) => FormStandScreen(id: args as int));
    case KermesseShowScreen.routeName:
      return MaterialPageRoute(builder: (context) => KermesseShowScreen(id: args as int));
    case StandShowScreen.routeName:
      return MaterialPageRoute(builder: (context) => StandShowScreen(id: args as int));
    case TombolaNewScreen.routeName:
      return MaterialPageRoute(builder: (context) => TombolaNewScreen(id: args as int));
    case JetonNewScreen.routeName:
      return MaterialPageRoute(builder: (context) => JetonNewScreen(id: args as int));
    case DemandeAllScreen.routeName:
      return MaterialPageRoute(builder: (context) => DemandeAllScreen());
    default:
      return MaterialPageRoute(builder: (_) => SplashScreen());
  }
}
