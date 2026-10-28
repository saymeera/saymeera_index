import 'package:flutter/material.dart';
import 'package:saymiraindex/core/constants/app_colors.dart';

import '../../../routes/app_routes.dart';
import '../../api_connections/connection_services.dart';
import '../../helper_components/componenets/trading_dialog.dart';
import '../../helper_components/local_storage/AppPreferences.dart';



class OtpLoginScreens extends StatefulWidget {
  const OtpLoginScreens({super.key});

  @override
  State<OtpLoginScreens> createState() => _OtpLoginScreensState();
}

class _OtpLoginScreensState extends State<OtpLoginScreens> {
  String? emailmobile;
  bool _loaded = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

TextEditingController otpController=TextEditingController();
@override
void didChangeDependencies() {
  super.didChangeDependencies();
  if (!_loaded) {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is String) {
      emailmobile = args;
    }
    _loaded = true;
  }

}


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.red.shade700,
      appBar: AppBar(
        backgroundColor: Colors.red.shade700,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Login',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        height: size.height,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.08,
            vertical: size.height * 0.04,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              SizedBox(height: size.height * 0.04),
              /// Logo
              Image.asset(
                'assets/images/say_mira_logo.jpeg',
                width: size.width * 0.7,
              ),

              SizedBox(height: size.height * 0.02),

              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  /// Powered By
                  Text(
                    'Powered by',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryRed,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Padding(
                    padding:  EdgeInsets.only(left: size.width*0.15),
                    child: Text(
                      'Trade jockey',
                      style: TextStyle(
                        fontSize: 40,
                        color: AppColors.primaryRed,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),


              SizedBox(height: size.height * 0.08),

              /// Enter OTP Label
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Enter OTP',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              /// OTP Field
              TextFormField(
                keyboardType: TextInputType.number,
                controller: otpController,
                decoration: InputDecoration(
                  hintText: 'OTP',
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(
                      color: Colors.red.shade600,
                    ),
                  ),
                ),
              ),

              SizedBox(height: size.height * 0.04),

              /// Login Button (Right Aligned)
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: size.width * 0.4,
                  height: size.height * 0.06,
                  child: ElevatedButton(
                    onPressed: () {


                      print("emial_otp $emailmobile");
                      /*
                      if(otpController.text.isNotEmpty) {
                        // TODO: Verify OTP
                        var jsondata = {"mobile": emailmobile,
                          "otp": otpController.text};
                        ConnectionServices.verifyOtp(
                            jsondata, "auth/verifyloginOtp", context).then((
                            onRes) {
                          if (onRes.status == true) {
                            Navigator.pushNamed(context, AppRoutes.dashboard);
                          } else {
                            TradingDialog.show(
                                context: context,
                                title: "SayMiraMedia",
                                message: "Please enter the valid OTP number",
                                type: TradingDialogType.warning,
                                secondaryText: "CANCEL",
                                showSecondary: false,
                                showPrimary: true
                            );
                          }
                        });
                      }*/
                      // Navigator.pushNamed(context, AppRoutes.dashboard);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child:  Text(
                      'Login',
                      style: TextStyle(

                        color: AppColors.textWhite,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: size.height * 0.07),

              /// New User Text
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'For New User',
                  style: TextStyle(

                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color:AppColors.primaryRed,
                  ),
                ),
              ),


              const SizedBox(height: 10),

              /// Register Button
              SizedBox(
                width: double.infinity,
                height: size.height * 0.065,
                child: ElevatedButton(
                  onPressed: () {

                    Navigator.pushNamed(context, AppRoutes.register);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child:  Text(
                    'Click here to Register',
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


class OtpLoginScreen extends StatefulWidget {
  const OtpLoginScreen({super.key});

  @override
  State<OtpLoginScreen> createState() => _OtpLoginScreenState();
}

class _OtpLoginScreenState extends State<OtpLoginScreen> {
  final TextEditingController otpConteroller = TextEditingController();

  @override
  void dispose() {
    otpConteroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String emailOrPhone =
        ModalRoute.of(context)!.settings.arguments as String;

    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.red.shade700,
      appBar: AppBar(
        backgroundColor: Colors.red.shade700,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Login',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        height: size.height,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.08,
            vertical: size.height * 0.04,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              SizedBox(height: size.height * 0.04),
              /// Logo
              Image.asset(
                'assets/images/say_mira_logo.jpeg',
                width: size.width * 0.7,
              ),

              SizedBox(height: size.height * 0.02),

             Column(
               mainAxisAlignment: MainAxisAlignment.start,
               children: [
                 /// Powered By
                 Text(
                   'Powered by',
                   style: TextStyle(
                     fontSize: 30,
                     fontWeight: FontWeight.bold,
                     color: AppColors.primaryRed,
                   ),
                 ),

                 const SizedBox(height: 4),

                 Padding(
                   padding:  EdgeInsets.only(left: size.width*0.15),
                   child: Text(
                     'Trade jockey',
                     style: TextStyle(
                       fontSize: 40,
                       color: AppColors.primaryRed,
                       fontWeight: FontWeight.bold,
                     ),
                   ),
                 ),
               ],
             ),


              SizedBox(height: size.height * 0.08),

              /// Enter OTP Label
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Enter OTP',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              /// OTP Field
              TextFormField(
                keyboardType: TextInputType.number,
                controller: otpConteroller,
                decoration: InputDecoration(
                  hintText: 'OTP',
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(
                      color: Colors.red.shade600,
                    ),
                  ),
                ),
              ),

              SizedBox(height: size.height * 0.04),

              /// Login Button (Right Aligned)
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: size.width * 0.4,
                  height: size.height * 0.06,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Verify OTP
                      var jsondata={
                        "mobile":emailOrPhone,
                        "otp":otpConteroller.text
                      };
                      print("check_email_value $emailOrPhone");
                      ConnectionServices.verifyOtp(
                          jsondata, "auth/verifyloginOtp", context).then((
                          onRes) async {
                        if (!mounted) return;
                        if (onRes.status == true) {
                          await AppPreferences.setLoggedIn(true);
                          if (!mounted) return;
                          Navigator.pushNamed(context, AppRoutes.dashboard);
                        } else {
                          TradingDialog.show(
                            context: context,
                            title: "SayMiraMedia",
                            message: "Please enter the valid OTP number",
                            type: TradingDialogType.warning,
                            secondaryText: "CANCEL",
                            showSecondary: false,
                            showPrimary: true,
                          );
                        }
                      }).catchError((error) {
                        if (!mounted) return;
                        TradingDialog.show(
                          context: context,
                          title: "SayMiraMedia",
                          message: "Something went wrong. Please try again.",
                          type: TradingDialogType.error,
                          showSecondary: false,
                          showPrimary: true,
                        );
                      });
                      // Navigator.pushNamed(context, AppRoutes.dashboard);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child:  Text(
                      'Login',
                      style: TextStyle(

                        color: AppColors.textWhite,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: size.height * 0.07),

              /// New User Text
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'For New User',
                  style: TextStyle(

                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color:AppColors.primaryRed,
                  ),
                ),
              ),


              const SizedBox(height: 10),

              /// Register Button
              SizedBox(
                width: double.infinity,
                height: size.height * 0.065,
                child: ElevatedButton(
                  onPressed: () {

                    Navigator.pushNamed(context, AppRoutes.register);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child:  Text(
                    'Click here to Register',
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
