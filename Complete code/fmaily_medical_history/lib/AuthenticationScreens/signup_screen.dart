import 'package:age_calculator/age_calculator.dart';
import 'package:flutter/material.dart';
import 'package:fmaily_medical_history/Animations/fade_animation.dart';
import 'package:fmaily_medical_history/Constants/constant.dart';
import 'package:fmaily_medical_history/AuthenticationScreens/login_screen.dart';
import 'package:fmaily_medical_history/Controller/firebase_authentication.dart';
import 'package:fmaily_medical_history/Controller/user_controller.dart';
import 'package:intl/intl.dart';
import '../Components/showMessage/SnackBar.dart';
import '../Components/showMessage/customMessage.dart';
import '../Controller/check_username.dart';
import 'email_verification.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController dateOfBirth=TextEditingController();
  TextEditingController email=TextEditingController();
  TextEditingController password=TextEditingController();
  TextEditingController cPassword=TextEditingController();
  TextEditingController firstName=TextEditingController();
  TextEditingController lastName=TextEditingController();
  TextEditingController username=TextEditingController();


  String? bloodType;
  bool passVisibility=true;
  final _form=GlobalKey<FormState>();
  bool emailValidation(String e){
    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(e);
    return emailValid;
  }
  List<DropdownMenuItem<String>> get bloodGroup{
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "A+", child: Text("A+")),
      const DropdownMenuItem(value: "A-", child: Text("A-")),
      const DropdownMenuItem(value: "B+", child: Text("B+")),
      const DropdownMenuItem(value: "B-", child: Text("B-")),
      const DropdownMenuItem(value: "O+", child: Text("O+")),
      const DropdownMenuItem(value: "O-", child: Text("O-")),
      const DropdownMenuItem(value: "AB+", child: Text("AB+")),
      const DropdownMenuItem(value: "AB-", child: Text("AB-")),
    ];
    return menuItems;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0E5FD),
      body: SafeArea(
        child: SingleChildScrollView(
          child:Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 40,bottom: 40),
                child: const Center(
                  child: Text("Register Now",
                    style: TextStyle(
                      fontSize: 30,
                      fontFamily: "PatuaOne",
                      color: kprimarycolor,
                    ),),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(50),topRight: Radius.circular(50),bottomLeft: Radius.circular(50),bottomRight: Radius.circular(50)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFE0E8FE).withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Form(
                  key: _form,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      FadeAnimation(
                        1.1,
                         Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                          child: TextFormField(

                            controller: firstName,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.person_outline_sharp,
                                color: kprimarycolor,
                              ),

                              hintText: "First Name",
                              hintStyle: const TextStyle(color: Colors.grey),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: kprimarycolor, width: 2.3),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide:
                                  const BorderSide(color: kprimarycolor)),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: const BorderSide(
                                    width: 2.3, color: kprimarycolor),
                              ),
                            ),
                            validator: (value){
                              if(value!.isEmpty){
                                return "Empty field not allowed";
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      FadeAnimation(
                        1.2,
                         Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                          child: TextFormField(
                             controller: lastName,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.person_outline_sharp,
                                color: kprimarycolor,
                              ),
                              hintText: "Last Name",
                              hintStyle: const TextStyle(color: Colors.grey),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: kprimarycolor, width: 2.3),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide:
                                  const BorderSide(color: kprimarycolor)),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: const BorderSide(
                                    width: 2.3, color: kprimarycolor),
                              ),
                            ),
                            validator: (value){
                              if(value!.isEmpty){
                                return "Empty field not allowed";
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      FadeAnimation(
                        1.3,
                         Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                          child: TextFormField(
                            controller: dateOfBirth,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.calendar_today_rounded,
                                color: kprimarycolor,
                              ),
                              hintText: "Date of Birth",
                              hintStyle: const TextStyle(color: Colors.grey),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: kprimarycolor, width: 2.3),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide:
                                  const BorderSide(color: kprimarycolor)),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: const BorderSide(
                                    width: 2.3, color: kprimarycolor),
                              ),
                            ),
                            validator: (value){
                              if(value!.isEmpty){
                                return "Please Enter Date of Birth";
                              }
                              return null;
                            },
                            onTap: ()async{
                              DateTime? pickDate=await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1950), lastDate: DateTime.now(),
                                builder: ((context, child){
                                  return Theme(data: Theme.of(context).copyWith(
                                    colorScheme: const ColorScheme.light(
                                      primary: kprimarycolor,
                                      onPrimary: Colors.white,
                                      onSurface: kprimarycolor,
                                    ),
                                  ), child: child!);
                                })
                              );
                              if(pickDate!=null)
                                {
                                  setState(() {
                                    dateOfBirth.text=DateFormat('yyyy-MM-dd').format(pickDate);
                                  });
                                }
                            },
                          ),
                        ),
                      ),
                      FadeAnimation(
                        1.4,
                         Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                          child: DropdownButtonHideUnderline(
                            child: ButtonTheme(
                              alignedDropdown: true,
                              child: DropdownButtonFormField(
                                validator: (value) => value == null ? 'field required' : null,
                                value: bloodType,
                                items: bloodGroup,
                                decoration: InputDecoration(
                                  hintText: "Select Blood Group",
                                  hintStyle: const TextStyle(color: Colors.grey),
                                  prefixIcon: const Icon(Icons.bloodtype,color: kprimarycolor,),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color:  kprimarycolor,width: 2.3), borderRadius: BorderRadius.circular(25),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(color: kprimarycolor, width: 2.3),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: kprimarycolor, width: 2.3),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),

                                onChanged: (value){
                                  setState(() {
                                    bloodType=value;
                                  });
                                },

                              ),
                            ),
                          ),
                        ),
                      ),
                      FadeAnimation(
                        1.5,
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                          child: TextFormField(
                            controller: username,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.person,
                                color: kprimarycolor,
                              ),
                              hintText: "Username",
                              hintStyle: const TextStyle(color: Colors.grey),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: kprimarycolor, width: 2.3),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide:
                                  const BorderSide(color: kprimarycolor)),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: const BorderSide(
                                    width: 2.3, color: kprimarycolor),
                              ),
                            ),
                            validator: (value){
                              if (value!.length < 8 || value.isEmpty) {
                                return "Username must be at least 8 characters.";
                              } else if (value.length > 25) {
                                return "Username is too long.";
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                      ),
                      FadeAnimation(
                        1.5,
                         Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                          child: TextFormField(
                            controller: email,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.email,
                                color: kprimarycolor,
                              ),
                              hintText: "Email",
                              hintStyle: const TextStyle(color: Colors.grey),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: kprimarycolor, width: 2.3),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide:
                                  const BorderSide(color: kprimarycolor)),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: const BorderSide(
                                    width: 2.3, color: kprimarycolor),
                              ),
                            ),
                            validator: (value){
                              if(!emailValidation(value!)||value.isEmpty){
                                return "Please enter valid email address";
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      FadeAnimation(
                        1.6,
                         Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: TextFormField(
                            controller: password,
                            obscureText: passVisibility,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: kprimarycolor,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  passVisibility ? Icons.visibility_off : Icons.visibility,
                                  color: kprimarycolor,
                                ),
                                onPressed: () {
                                  setState(() {
                                    passVisibility = !passVisibility;
                                  });
                                },
                              ),

                              hintText: "Password",
                              hintStyle: const TextStyle(color: Colors.grey),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: kprimarycolor, width: 2.3),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(color: kprimarycolor, width: 2.3),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: const BorderSide(
                                    width: 2.3, color: kprimarycolor),
                              ),
                            ),
                            validator: (value){
                              if(value!.isEmpty||value.length<7){
                                return "Please enter at least 7 character";
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      FadeAnimation(
                        1.7,
                         Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20,vertical: 10),
                          child: ElevatedButton(
                            onPressed: ()async{
                              FocusManager.instance.primaryFocus?.unfocus();
                              if(!_form.currentState!.validate()){
                                return;
                              }
                              else{

                                final valid = await usernameCheck(username.text.trim(),context);
                                if (!valid) {
                                  Navigator.pop(context);
                                  showDialog(context: context, builder: (context){
                                    return customMessage(message: "Username already exist.",icon: Icons.error,title: "Alert",);
                                  });
                                }
                                else{
                                  // save the username or something
                                  DateDuration duration;
                                  duration=AgeCalculator.age(DateTime.parse(dateOfBirth.text));
                                  createAccount(email.text.trim(), password.text.trim(),context).then((value){
                                    if(value!=null)
                                    {
                                      saveUserData(firstName.text.trim(), lastName.text.trim(), dateOfBirth.text.trim(),bloodType!, email.text.trim(), password.text.trim(), duration.years, value.uid,context,username.text.trim()).then((value){
                                        Navigator.pop(context);
                                        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));
                                        // ScaffoldMessenger.of(context).showSnackBar(
                                        //   SnackBar(
                                        //     content: customSnackBarContainer(
                                        //       title: "Congratulation!",
                                        //       text: "Account created successfully.",
                                        //     ),
                                        //     behavior: SnackBarBehavior.floating,
                                        //     backgroundColor: Colors.transparent,
                                        //     elevation: 0.0,
                                        //     margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height-160),
                                        //
                                        //   ),
                                        // );

                                        //now new added code

                                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx)=>const EmailVerificationScreen()));


                                      });

                                    }
                                    else{
                                    }
                                  });
                                }

                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kprimarycolor,
                              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),

                            ),
                            child: const Text("Signup",
                              style:  TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18
                              ),
                            ),
                          ),
                        ),
                      ),
                      FadeAnimation(
                        1.8,
                         Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Alread have an Account?"),
                              InkWell(
                                child: const Text("Signin",style: TextStyle(
                                    color: kprimarycolor,
                                    fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),),
                                onTap: (){
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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

