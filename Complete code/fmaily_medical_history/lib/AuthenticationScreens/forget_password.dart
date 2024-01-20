import 'package:flutter/material.dart';
import 'package:fmaily_medical_history/Animations/fade_animation.dart';
import 'package:fmaily_medical_history/Constants/constant.dart';
import 'package:fmaily_medical_history/Controller/firebase_authentication.dart';
class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  TextEditingController email= TextEditingController();
  bool emailValidation(String e){
    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(e);
    return emailValid;
  }
  bool check=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Reset Password"),
          backgroundColor: kprimarycolor,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 10,top: 50,right: 3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const FadeAnimation2(
                  1.2,
                   Center(
                    child: Image(
                      image: AssetImage("assets/back.png"),
                      width: 300,
                    ),
                  ),
                ),
                const FadeAnimation2(
                  1.3,
                   Text("Forget Password",
                    style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),),
                ),
                const SizedBox(
                  height: 15,
                ),
                FadeAnimation2(
                  1.4,
                   Text("Enter the email associated with your account and we'll send an email instruction to reset your password.",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'PatuaOne',
                    color: Colors.grey.shade600
                  ),),
                ),
                const SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: FadeAnimation2(
                    1.5,
                     TextFormField(
                       onChanged: (value){
                         setState(() {
                           check=emailValidation(value);
                         });

                       },
                      controller: email,
                      validator: (value){
                        if(!emailValidation(value!)||value.isEmpty){
                          return "Please enter valid email adddress";
                        }return null;
                      },
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.email,color: kprimarycolor,),
                          hintText: "Email",
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: kprimarycolor, width: 1.8),
                          borderRadius: BorderRadius.circular(7),
                        ),
                          enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: const BorderSide(
                              width: 1.8, color: kprimarycolor),
                        ),

                      ),

                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Center(
                  child: FadeAnimation2(
                    1.6,
                    ElevatedButton(
                      onPressed:check==true? (){
                        FocusManager.instance.primaryFocus?.unfocus();
                        resetPassword(context, email.text.trim());
                      }:null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kprimarycolor,
                        padding: const EdgeInsets.only(left: 60,right: 60,top: 13,bottom: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),

                      ),
                      child: const Text("Send Email",
                        style:  TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18
                        ),
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
