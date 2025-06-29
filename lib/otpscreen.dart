import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_cli/home.dart';
import 'package:flutter/material.dart';

class OtpScreen extends StatefulWidget {
  final String verificationid;

  const OtpScreen({super.key, required this.verificationid});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}


class _OtpScreenState extends State<OtpScreen> {
  TextEditingController otpcontroller=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Otp Screen",style: TextStyle(color: Colors.white,backgroundColor: Colors.blue),),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: TextField(
              controller: otpcontroller,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: "Enter The Otp",
                  suffixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25)
                  )
                ),
            ),
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () async {
              try {
                PhoneAuthCredential credential = PhoneAuthProvider.credential(
                  verificationId: widget.verificationid, // Make sure this is non-null
                  smsCode: otpcontroller.text.trim(),
                );

                // Sign in with the credential
                await FirebaseAuth.instance.signInWithCredential(credential).then((value){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
                });

                // Success feedback or navigation
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("OTP Verified Successfully")),
                );

                // Navigate to another page if needed
                // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));

              } catch (ex) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Invalid OTP or error occurred")),
                );
                print("Error verifying OTP: $ex");
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              "OTP",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),

        ],
      ),
    );
  }
}
