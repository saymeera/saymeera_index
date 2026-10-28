import 'package:flutter/material.dart';
import 'package:location_picker_plus/models/city_model.dart';
import 'package:location_picker_plus/models/country_model.dart';
import 'package:location_picker_plus/models/state_model.dart';
import 'package:location_picker_plus/widgets/address_dropdown_fields.dart';
import 'package:saymiraindex/core/constants/app_colors.dart';
import 'package:saymiraindex/core/widgets/CustomDatePicker.dart';
import 'package:saymiraindex/core/widgets/CustomStaticDropdown.dart';

import '../../api_connections/connection_services.dart';
import '../../helper_components/componenets/trading_dialog.dart';
import '../../routes/app_routes.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String userType = 'individual'; // individual | corporate

  var selectedDate = "DD", selectedMonth = "MM", selectedYear = "YYYY";
  final _formKey = GlobalKey<FormState>();

  String? selectedCorporateType;

  List<String> corporateTypes = [
    "Sole Proprietorship",
    "Partnership Firm",
    "Private Limited Company",
    "Public Limited Company",
    "One Person Company (OPC)",
    "Limited Liability Partnership (LLP)",
    "Government Company",
    "Semi-Government Company",
    "Private Sector Company",
    "Public Sector Undertaking (PSU)",
    "Listed Company",
    "Unlisted Company",
    "Manufacturing Company",
    "Service-Based Company",
    "Trading Company",
    "IT / Software Company",
    "Consulting Company",
    "Financial Services Company",
    "Startup",
    "Small & Medium Enterprise (SME/MSME)",
    "Large Enterprise / MNC",
    "Non-Profit Organization (NGO) / Section 8",
    "Holding Company",
    "Subsidiary Company",
    "Joint Venture (JV)",
    "Foreign Company (Operating in India)",
  ];


  TextEditingController emilController=TextEditingController();
  TextEditingController discountCodeController=TextEditingController();
  TextEditingController fullNameController=TextEditingController();
  TextEditingController phoneController=TextEditingController();
  TextEditingController languageController=TextEditingController();
  TextEditingController nationalityController=TextEditingController();
  TextEditingController districtController=TextEditingController();
  TextEditingController corporateNameController=TextEditingController();
  TextEditingController emailOtpController=TextEditingController();
  TextEditingController phoneOtpController=TextEditingController();

  TextEditingController NAController=TextEditingController();



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
        title: const Text('Register', style: TextStyle(color: Colors.white)),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Container(
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            // border: Border.all(color: Colors.red.shade700, width: 3),
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(size.width * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: size.height * 0.0),
            
                  /// Header
                  Column(
                    children: [
                      Image.asset(
                        'assets/images/say_mira_logo.jpeg',
                        height: size.height * 0.05,
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "It'll hardly take 2 minutes to register....",
                        style: TextStyle(
                          color: AppColors.logoColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
            
                  const SizedBox(height: 15),
            
                  /// Radio Buttons
                  Row(
                    children: [
                      Radio<String>(
                        value: 'individual',
                        groupValue: userType,
                        activeColor: Colors.green,
                        onChanged: (value) {
                          setState(() => userType = value!);
                        },
                      ),
                      const Text(
                        "Individual",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 20),
                      Radio<String>(
                        value: 'corporate',
            
                        groupValue: userType,
                        activeColor: Colors.green,
                        onChanged: (value) {
                          setState(() => userType = value!);
                        },
                      ),
                      const Text(
                        "Corporate",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
            
                  const SizedBox(height: 12),
            
                  _input("Full Name",false,fullNameController,
                    keyboardType: TextInputType.text,
                    validator: (value){
                      if(value==null || value.isEmpty){
                        return "full name required";
                      }
                      if(value.length < 10){
                        return "Enter valid full name";
                      }
                      return null;
                    },),
            
                  const SizedBox(height: 10),
            
                  /// 🔀 Switch Form
                  if (userType == 'individual') ..._individualForm(),
                  if (userType == 'corporate') ..._corporateForm(),
            
                  const SizedBox(height: 10),
            
                  _input("Mobile No.",false,phoneController,
                    keyboardType: TextInputType.text,
                    validator: (value){
                      if(value==null || value.isEmpty){
                        return "mobile number required";
                      }
                      if(value.length < 10){
                        return "Enter valid mobile number";
                      }
                      return null;
                    },),
                  const SizedBox(height: 8),
                  _otpMobRow("for_mobile"),
            
                  const SizedBox(height: 10),
            
                  _input("Email",false,emilController),
                  const SizedBox(height: 8),
                  _otpRow("for_email"),
            
                  const SizedBox(height: 10),

                  _input2("Discount Code (If Any)",false,discountCodeController),
            
                  const SizedBox(height: 20),
            
                  /// Register Button
                  SizedBox(
                    height: size.height * 0.065,
                    child: ElevatedButton(
                      onPressed: () async {

                        if(!validateRegister()) return;

                        try {

                          final res = await ConnectionServices.registerUser(
                            buildRegisterFields(),
                            null, // profile image if available
                            "auth/register",
                            context,
                          );

                          /// ✅ SUCCESS DIALOG
                          TradingDialog.show(
                            context: context,
                            title: "Success",
                            message: "Registration Completed Successfully!",
                            type: TradingDialogType.success,
                            showSecondary: false,
                            showPrimary: true,
                            primaryText: "OK",
                            onPrimary: () {

                              /// CLOSE DIALOG
                              Navigator.pop(context);

                              /// 🔥 REDIRECT TO LOGIN
//                              Navigator.pushReplacementNamed(context, "/login");

                              Navigator.pushNamed(context, AppRoutes.login);

                            },
                          );

                        } catch (e) {

                          TradingDialog.show(
                            context: context,
                            title: "Error",
                            message: "Registration Failed. Please try again.",
                            type: TradingDialogType.error,
                            showSecondary: false,
                            showPrimary: true,
                          );

                        }

                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        "Register",
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.textWhite,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Map<String,String> buildRegisterFields(){

    return {

     // "userId": "", // generate if dynamic
      "name": fullNameController.text.trim(),
      "email": emilController.text.trim(),
      "mobile": phoneController.text.trim(),
      "gender": selectedGender ?? "",
     // "dOB": "$selectedDate/$selectedMonth/$selectedYear",
      "dOB": userType == 'individual'
          ? "$selectedDate/$selectedMonth/$selectedYear"
          : "",
      "discountCode": discountCodeController.text.trim(),

      "referralUserId": "",
      "brokerUserId": "",
      "brokerRegisteredAt": "",
      "subtype":userType ,
          "isIndividual": userType == 'individual' ? "true" : "false",

      "country": _selectedCountry?.name ?? "",
      "state": _selectedState?.name ?? "",

      "isAdmin": "Nonadmin",

      "corporateName":
      userType == 'corporate'
          ? corporateNameController.text.trim()
          : "",

      "type": selectedCorporateType ?? "",
    };
  }


  TextEditingController _dateController = TextEditingController();
  String? selectedGender;
  final List<String> genderOptions = ['Male', 'Female', 'Other'];

  CountryModel? _selectedCountry;
  StateModel? _selectedState;
  CityModel? _selectedCity;

  /// 👤 Individual Fields
  List<Widget> _individualForm() => [
    Row(
      mainAxisSize: MainAxisSize.max, // DEFAULT

      children: [
        Expanded(
          flex: 1,
          child: CustomStaticDropdown<String>(
            hint: "Gender",
            value: selectedGender,
            items: genderOptions,
            itemAsString: (item) => item,
            onChanged: (newValue) {
              setState(() {
                selectedGender = newValue;
              });
            },
          ),
        ),

        const SizedBox(width: 8),

        Expanded(
          flex: 2,
          child: InkWell(
            onTap: () {
              ProCalendarPicker.show(
                initialDate: DateTime(2000, 1, 1),
                context: context,
                onDateSelected: (date) {
                  setState(() {
                    selectedDate = date.day.toString();
                    selectedMonth = date.month.toString();
                    selectedYear = date.year.toString();
                  });
                },
              );
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              child: Row(
                children: [
                  _dateBox(selectedDate),
                  const SizedBox(width: 6),
                  _dateBox(selectedMonth),
                  const SizedBox(width: 6),
                  _dateBox(selectedYear),
                ],
              ),
            ),
          ),
        ),
      ],
    ),

    // const SizedBox(height: 10),
    // Row(
    //   children: [
    //     Expanded(child: _input("Language",false,languageController)),
    //     const SizedBox(width: 8),
    //     Expanded(child: _input("Nationality",false,nationalityController)),
    //   ],
    // ),

    const SizedBox(height: 16),
    Row(
      children: [
        const Text(
      "Select \n Residence",
      style: TextStyle(
        color: Colors.grey,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
    ),

        const SizedBox(width: 16),
     Expanded(
          flex: 1,
          child: CountryDropdownField(

            initialValue: _selectedCountry,

            onChanged: (country) {
              setState(() {
                _selectedCountry = country;
                _selectedState = null;
                _selectedCity = null;
              });
            },
          ),
        ),
      ],
    ),
    const SizedBox(height: 16),
    Row(
      children: [

        Expanded(
          flex: 1,
          child:
          _selectedCountry==null||
          _selectedCountry!.name=="India"||
           _selectedCountry!.name=="india"||
            _selectedCountry!.name=="INDIA"?

           StateDropdownField(
            enabled: true,
            countryId: _selectedCountry?.id,
            initialValue: _selectedState,
            onChanged: (state) {
              setState(() {
                _selectedState = state;
                _selectedCity = null;
              });
            },
          ): _input("NA",true,NAController),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 1,
          child: _input(
                _selectedCountry==null||
          _selectedCountry!.name=="India"||
           _selectedCountry!.name=="india"||
            _selectedCountry!.name=="INDIA"?

            "District":"NA",
           _selectedCountry==null||
          _selectedCountry!.name=="India"||
           _selectedCountry!.name=="india"||
            _selectedCountry!.name=="INDIA"?
          false:true,districtController),
        ),
      ],
    ),
  ];

  // /// 🏢 Corporate Fields
  // List<Widget> _corporateForm() => [
  //   _input("Company Name"),
  //   const SizedBox(height: 10),
  //   _input("GST Number"),
  //   const SizedBox(height: 10),
  //   _input("Company Address"),
  // ];
  Widget _dateBox(String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(value),
      ),
    );
  }

  /// 🏢 Corporate Fields (MATCHING SCREENSHOT)
  List<Widget> _corporateForm() => [
    _input("Corporate Name",false,corporateNameController),

    const SizedBox(height: 14),

    const Text(
      "Choose Corporate Type & its Regd. Official Location",
      style: TextStyle(
        color: Colors.grey,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
    ),

    const SizedBox(height: 10),

    /// Type + Country
    Row(
      children: [
        Expanded(child: DropdownButtonFormField<String>(
          validator: (value){
            if(value == null){
              return "Select Corporate Type";
            }
            return null;
          },
          value: selectedCorporateType,
          hint: const Text("Select Corporate Type"),
          items: corporateTypes.map((type) {
            return DropdownMenuItem<String>(
              value: type,
              child: Text(type),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedCorporateType = value;
            });
          },
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        )
        //_dropdownField("Type")
        ),
        const SizedBox(width: 8),

      ],
    ),

    const SizedBox(height: 10),

    const SizedBox(height: 16),
    Row(
      children: [
        const Text(
          "Select \n Residence",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(width: 16),
        Expanded(
          flex: 1,
          child: CountryDropdownField(

            initialValue: _selectedCountry,

            onChanged: (country) {
              setState(() {
                _selectedCountry = country;
                _selectedState = null;
                _selectedCity = null;
              });
            },
          ),
        ),
      ],
    ),
    const SizedBox(height: 16),
    Row(
      children: [

        Expanded(
          flex: 1,
          child:
          _selectedCountry==null||
              _selectedCountry!.name=="India"||
              _selectedCountry!.name=="india"||
              _selectedCountry!.name=="INDIA"?

          StateDropdownField(
            enabled: true,
            countryId: _selectedCountry?.id,
            initialValue: _selectedState,
            onChanged: (state) {
              setState(() {
                _selectedState = state;
                _selectedCity = null;
              });
            },
          ): _input("NA",true,NAController),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 1,
          child: _input(
              _selectedCountry==null||
                  _selectedCountry!.name=="India"||
                  _selectedCountry!.name=="india"||
                  _selectedCountry!.name=="INDIA"?

              "District":"NA",
              _selectedCountry==null||
                  _selectedCountry!.name=="India"||
                  _selectedCountry!.name=="india"||
                  _selectedCountry!.name=="INDIA"?
              false:true,districtController),
        ),
      ],
    ),
  ];

  /*
  static Widget _dropdownField(String hint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(hint, style: const TextStyle(color: Colors.grey)),
          const Icon(Icons.arrow_drop_down, color: Colors.grey),
        ],
      ),
    );
  }
  */



  bool validateRegister(){

    if(!_formKey.currentState!.validate()){
      return false;
    }

    /// OTP CHECK
    if(!isMobSent){
      showWarn("Please verify your Mobile OTP");
      return false;
    }

    if(!isEmailSent){
      showWarn("Please verify your Email OTP");
      return false;
    }

    /// COUNTRY
    if(_selectedCountry == null){
      showWarn("Please select country");
      return false;
    }

    /// STATE (ONLY INDIA)
    if(_selectedCountry!.name.toLowerCase() == "india"){

      if(_selectedState == null){
        showWarn("Please select state");
        return false;
      }

      if(districtController.text.trim().isEmpty){
        showWarn("Please enter district");
        return false;
      }
    }

    /// INDIVIDUAL
    if(userType == 'individual'){

      if(selectedGender == null){
        showWarn("Please select gender");
        return false;
      }

      if(selectedYear == "YYYY"){
        showWarn("Please select Date of Birth");
        return false;
      }
    }

    /// CORPORATE
    if(userType == 'corporate'){

      if(corporateNameController.text.trim().isEmpty){
        showWarn("Please enter corporate name");
        return false;
      }

      if(selectedCorporateType == null){
        showWarn("Please select corporate type");
        return false;
      }
    }

    return true;
  }

  void showWarn(String msg){
    TradingDialog.show(
        context: context,
        title: "SayMiraMedia",
        message: msg,
        type: TradingDialogType.warning,
        secondaryText: "CANCEL",
        showSecondary: false,
        showPrimary: true
    );
  }




  bool isMobSent=false,isEmailSent=false,isEmailVerified=false,isPhoneVerified=false;
  /// Input Field
  static Widget _input2(String hint,bool readOnlyValue,
      TextEditingController textEditingController,) {
    return TextFormField(
      readOnly: readOnlyValue,
      controller: textEditingController,

      decoration: InputDecoration(
        hintText: hint,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
      ),
    );
  }
  /// Input Field
  static Widget _input(String hint,bool readOnlyValue,
      TextEditingController textEditingController,
      {String? Function(String?)? validator,
        TextInputType? keyboardType}) {
    return TextFormField(
      readOnly: readOnlyValue,
      controller: textEditingController,
      keyboardType: keyboardType,
      validator: validator ??
              (value) {
            if (!readOnlyValue && (value == null || value.trim().isEmpty)) {
              return "$hint is required";
            }
            return null;
          },
      decoration: InputDecoration(
        hintText: hint,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
      ),
    );
  }

  /// OTP Row
   Widget _otpRow(var type) {
    return Row(
      children: [
         GestureDetector(
           onTap:isEmailVerified?null: (){
             if(isEmailSent){
               if(emailOtpController.text.isNotEmpty) {
                 var jsondata={"email":emilController.text,
                   "otp":emailOtpController.text};
                 ConnectionServices.verifyOtp(
                     jsondata, "auth/verifyMailOtp", context).then((
                     onRes) {
                   if (onRes.status == true) {
                     setState(() {
                       isEmailVerified = true;
                     });
                   } else {
                     setState(() {
                       isEmailVerified = false;
                     });
                   }
                 });
               }else{
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
             }
             else {
               if (emilController.text.isNotEmpty) {
                 var jsondata={"email":emilController.text};
                 ConnectionServices.sendOtp(
                     jsondata, "auth/sendmailOtp", context).then((
                     onRes) {
                   if (onRes.status == true) {
                     setState(() {
                       isEmailSent = true;
                     });
                   } else {
                     setState(() {
                       isEmailSent = false;
                     });
                   }
                 });
               }else{
                 TradingDialog.show(
                     context: context,
                     title: "SayMiraMedia",
                     message: "Please enter the valid email",
                     type: TradingDialogType.warning,
                     secondaryText: "CANCEL",
                     showSecondary: false,
                     showPrimary: true
                 );
               }
             }

           },
           child:
           isEmailVerified?
               Icon(Icons.check_circle,color: Colors.green,):
           Text(
            isEmailSent?"Verify OTP":
             "Get OTP",
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
                   ),
         ),
        const SizedBox(width: 12),
        Expanded(
          child: TextFormField(
            controller: emailOtpController,
            decoration: InputDecoration(
              hintText: "OTP",
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ),
      ],
    );
  }
  /// MOBOTP Row
  Widget _otpMobRow(var type) {
    return Row(
      children: [
        GestureDetector(
          onTap:isPhoneVerified?null: (){
            if(!isMobSent){
              if(phoneController.text.isNotEmpty) {

                var jsondata={"mobile":phoneController.text};
                ConnectionServices.sendOtp(
                    jsondata, "auth/sendmobOtp", context).then((
                    onRes) {
                  if (onRes.status == true) {
                    setState(() {
                      isMobSent = true;
                    });
                  } else {
                    setState(() {
                      isMobSent = false;
                    });
                  }
                });
              }else{
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
            }else {
              if(phoneOtpController.text.isNotEmpty) {

                var jsondata={"mobile":phoneController.text,
                "otp":phoneOtpController.text};
                ConnectionServices.verifyOtp(
                    jsondata, "auth/verifymobOtp", context).then((
                    onRes) {
                  if (onRes.status == true) {
                    setState(() {
                      isPhoneVerified = true;
                    });
                  } else {
                    setState(() {
                      isPhoneVerified = false;
                    });
                  }
                });
              }else{
                TradingDialog.show(
                    context: context,
                    title: "SayMiraMedia",
                    message: "Please enter the valid Phone number",
                    type: TradingDialogType.warning,
                    secondaryText: "CANCEL",
                    showSecondary: false,
                    showPrimary: true
                );
              }
            }
          },
          child:
          isPhoneVerified?
          Icon(Icons.check_circle,color: Colors.green,):
          Text(
          isMobSent?"Verify OTP":
            "Get OTP",
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextFormField(
            controller: phoneOtpController,
            decoration: InputDecoration(
              hintText: "OTP",
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

