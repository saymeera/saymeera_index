import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../helper_components/local_storage/AppPreferences.dart';
import '../routes/app_routes.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkLogin();
    });
  }


  void checkLogin()  {

    if (AppPreferences.isLoggedIn()) {
      Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
    }
  }



  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.08,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              /// Welcome Text
              Text(
                'Welcome to Say Mira',
                style: TextStyle(
                  fontSize: size.width * 0.06,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: size.height * 0.1),

              /// Logo Image
              Image.asset(
                'assets/images/say_mira_logo.jpeg', // add your logo here
                width: size.width * 0.65,
                fit: BoxFit.contain,
              ),

              SizedBox(height: size.height * 0.08),

              /// Login Button
              SizedBox(
                width: double.infinity,
                height: size.height * 0.065,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Navigate to Login
                    Navigator.pushNamed(context, AppRoutes.login);

                  },
                  style: ElevatedButton.styleFrom(
                    // backgroundColor: Colors.red.shade800,
                    backgroundColor: AppColors.buttonPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child:  Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textWhite,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              SizedBox(height: size.height * 0.025),

              /// Registration Button
              SizedBox(
                width: double.infinity,
                height: size.height * 0.065,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Navigate to Registration
                    Navigator.pushNamed(context, AppRoutes.register);

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:AppColors.buttonSecondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child:  Text(
                    'Registration',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textWhite,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class WelcomeScreens extends StatelessWidget {
  const WelcomeScreens({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.08,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              /// Welcome Text
              Text(
                'Welcome to Say Mira',
                style: TextStyle(
                  fontSize: size.width * 0.06,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: size.height * 0.1),

              /// Logo Image
              Image.asset(
                'assets/images/say_mira_logo.jpeg', // add your logo here
                width: size.width * 0.65,
                fit: BoxFit.contain,
              ),

              SizedBox(height: size.height * 0.08),

              /// Login Button
              SizedBox(
                width: double.infinity,
                height: size.height * 0.065,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Navigate to Login
                    Navigator.pushNamed(context, AppRoutes.login);

                  },
                  style: ElevatedButton.styleFrom(
                   // backgroundColor: Colors.red.shade800,
                    backgroundColor: AppColors.buttonPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child:  Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textWhite,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              SizedBox(height: size.height * 0.025),

              /// Registration Button
              SizedBox(
                width: double.infinity,
                height: size.height * 0.065,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Navigate to Registration
                    Navigator.pushNamed(context, AppRoutes.register);

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:AppColors.buttonSecondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child:  Text(
                    'Registration',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textWhite,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
