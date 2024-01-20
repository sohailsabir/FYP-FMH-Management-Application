import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fmaily_medical_history/Animations/fade_animation.dart';
import 'package:fmaily_medical_history/AuthenticationScreens/email_verification.dart';
import 'package:fmaily_medical_history/Components/Drawer/flow_screen.dart';
import 'package:fmaily_medical_history/Components/showMessage/customMessage.dart';
import 'package:fmaily_medical_history/Constants/constant.dart';
import 'package:fmaily_medical_history/AuthenticationScreens/forget_password.dart';
import 'package:fmaily_medical_history/Controller/firebase_authentication.dart';
import 'package:fmaily_medical_history/AuthenticationScreens/signup_screen.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool passVisibility=true;
  TextEditingController email=TextEditingController();
  TextEditingController password=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
             const SizedBox(
               height: 80,
             ),
              const Image(
                image: AssetImage("assets/back.png"),
              height: 200,
                width: 400,
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 30),
                height: 500,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E5FD),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                      const Center(
                        child: Text(
                          "Login Here!",
                          style: TextStyle(
                            fontSize: 30,
                            fontFamily: 'PatuaOne',
                            color: kprimarycolor,
                          ),
                        ),
                      ),
                   const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                      child: FadeAnimation(
                        1.2,
                         TextField(
                          controller: email,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.person,
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
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: FadeAnimation(
                        1.3,
                        TextField(
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
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: const BorderSide(
                                  width: 2.3, color: kprimarycolor),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20,),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>const ForgetPassword()));
                            },
                            child: const FadeAnimation(
                              1.4,
                               Text("Forget Password?",
                                style: TextStyle(
                                    color: kprimarycolor,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20,vertical: 10),
                      child: FadeAnimation(
                        1.5,
                         ElevatedButton(
                          onPressed: (){
                            FocusManager.instance.primaryFocus?.unfocus();
                            if(email.text.isNotEmpty && password.text.isNotEmpty)
                              {
                                loginUser(email.text.trim(), password.text.trim(), context).then((user){
                                  if(user!=null)
                                  {
                                    if (user.emailVerified) {
                                      print('verify');
                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const FlowScreen()));
                                    }
                                    else{
                                      Navigator.push(context, MaterialPageRoute(builder: (ctx)=>const EmailVerificationScreen()));
                                    }

                                  }
                                  else{

                                  }
                                });

                              }
                            else{
                              showDialog(context: context, builder: (BuildContext context){
                                return customMessage(message: "Please enter email and password.",icon: Icons.error,title: "Alert",);
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kprimarycolor,
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),

                          ),
                          child: const Text("Login",
                            style:  TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18
                          ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: FadeAnimation(
                        1.6,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an Account?"),
                            InkWell(
                              child: const Text("Signup",style: TextStyle(
                                  color: kprimarycolor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                              ),),
                              onTap: (){
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const SignupScreen()));
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
