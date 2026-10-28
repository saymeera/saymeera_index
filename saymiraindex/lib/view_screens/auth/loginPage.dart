import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:saymiraindex/api_connections/connection_services.dart';

import '../../../core/constants/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../../core/widgets/SayMiraLoadingDialog.dart';
import '../../helper_components/componenets/dialog_utils.dart';
import '../../helper_components/componenets/trading_dialog.dart';
import 'otploginpage.dart';



class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {



  TextEditingController emilphoneController=TextEditingController();

  bool isEmail(String input) => EmailValidator.validate(input);
  bool isPhone(String input) =>
      RegExp(r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$')
          .hasMatch(input);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.primaryRed,
      appBar: AppBar(
        toolbarHeight: 80, // 👈 increases app bar height
        backgroundColor: AppColors.primaryRed,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Login',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          Container(
            height: size.height,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
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
                  /// Email / Phone Field
                  TextFormField(
                    validator: (String? data){
                      if(data!.isEmpty||data==""){
                        return "Please enter registered Mobile No  ";
                      }
                      if ( !isPhone(data)) {
                        return 'Please enter a valid phone number.';
                      }
                      return null;

                    },

                    controller: emilphoneController,
                    decoration: InputDecoration(

                      hintText: 'Phone Number',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade500,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 20,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: Colors.grey.shade500,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: Colors.red.shade600,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: size.height * 0.04),

                  /// Registration Button
                  Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      width: size.width * 0.4,
                      height: size.height * 0.06,
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Verify OTP

                          // Navigator.pushNamed(context, AppRoutes.otp);
                          if(emilphoneController.text.isEmpty){
                            TradingDialog.show(
                              context: context,
                              title: "SayMiraMedia",
                              message: "Please enter phone number",
                              type: TradingDialogType.warning,
                              primaryText: "Ok",
                              secondaryText: "CANCEL",
                            );
                          }else{
                            //Navigator.pushNamed(context, AppRoutes.otp,arguments: emilphoneController.text);


                            var jsonData={
                              "mobile":emilphoneController.text
                            };
                            /// ✅ SHOW CUSTOM LOADER
                            SayMiraLoadingDialog.show(context);
                            ConnectionServices.sendOtp(jsonData, "auth/sendloginOtp", context)
                                .then((onSend) {
                              SayMiraLoadingDialog.hide(context);
                              if (!mounted) return;
                              if (onSend.status == true) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OtpLoginScreen(),
                                    settings: RouteSettings(
                                      arguments: emilphoneController.text,
                                    ),
                                  ),
                                );
                              } else {
                                TradingDialog.show(
                                  context: context,
                                  title: "SayMiraMedia",
                                  message: onSend.message,
                                  type: TradingDialogType.warning,
                                  secondaryText: "CANCEL",
                                  showSecondary: false,
                                  showPrimary: true,
                                );
                              }
                            }).catchError((error) {
                              print("lgoin $error");
                              SayMiraLoadingDialog.hide(context);
                              if (!mounted) return;
                              TradingDialog.show(
                                context: context,
                                title: "SayMiraMedia",
                                message: "Something went wrong. Please try again. $error",
                                type: TradingDialogType.error,
                                showSecondary: false,
                                showPrimary: true,
                              );
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.buttonPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child:  Text(
                          'Next',
                          style: TextStyle(

                            color: AppColors.textWhite,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  //
                  // SizedBox(
                  //   width: double.infinity,
                  //   height: size.height * 0.065,
                  //   child: ElevatedButton(
                  //     onPressed: () {
                  //       // TODO: Login logic
                  //       // TODO: Navigate to Login
                  //       Navigator.pushNamed(context, AppRoutes.otp);
                  //     },
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: AppColors.buttonSecondary,
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(16),
                  //       ),
                  //     ),
                  //     child: const Text(
                  //       'Next',
                  //       style: TextStyle(
                  //         fontSize: 16,
                  //         fontWeight: FontWeight.w600,
                  //         color: Colors.white,
                  //       ),
                  //     ),
                  //   ),
                  // ),

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

        ],
      ),
    );
  }
}

