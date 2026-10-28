import 'package:flutter/material.dart';

import '../view_screens/auth/loginPage.dart';
import '../view_screens/auth/otploginpage.dart';
import '../view_screens/auth/registrationpage.dart';
import '../view_screens/dashboard.dart';
import '../view_screens/profile_screen.dart';
import '../view_screens/alert_screen.dart';
import '../view_screens/commentary_screen.dart';
import '../view_screens/referral_screen.dart';
import '../view_screens/wallet_screen.dart';
import '../view_screens/market_watch_screen.dart';
import '../view_screens/set_mw_screen.dart';
import '../view_screens/reg_login_screen.dart';

class AppRoutes {
  static const welcome     = '/';
  static const login       = '/login';
  static const otp         = '/otp';
  static const register    = '/register';
  static const dashboard   = '/dashboard';
  static const profile     = '/profile';
  static const alert       = '/alert';
  static const commentary  = '/commentary';
  static const referral    = '/referral';
  static const wallet      = '/wallet';
  static const marketWatch = '/market-watch';
  static const setMW       = '/set-mw';
  static const regLogin    = '/reg-login';

  static Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case otp:
        return MaterialPageRoute(builder: (_) => OtpLoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case alert:
        return MaterialPageRoute(builder: (_) => const AlertScreen());
      case commentary:
        return MaterialPageRoute(builder: (_) => const CommentaryScreen());
      case referral:
        return MaterialPageRoute(builder: (_) => const ReferralScreen());
      case wallet:
        return MaterialPageRoute(builder: (_) => const WalletScreen());
      case marketWatch:
        return MaterialPageRoute(builder: (_) => const MarketWatchScreen());
      case setMW:
        return MaterialPageRoute(builder: (_) => const SetMWScreen());
      case regLogin:
        return MaterialPageRoute(builder: (_) => const RegLoginScreen());
      default:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
    }
  }
}
