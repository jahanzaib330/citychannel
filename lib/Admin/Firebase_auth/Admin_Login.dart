import 'dart:html';

import 'package:citychannel/Admin/Firebase_auth/Admin_Register.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  @override
  Widget build(BuildContext context) {
    return  Container(
            decoration: const BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/images/login.png'),
                    fit: BoxFit.cover
                )
            ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(left: 35 , top: 40),
              child: Text("Welcome to\n    Login" , style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 33
              ),),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: ScrollPhysics(),
              child: Container(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.5,
                right: 35,
                left: 35),
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        hintText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                        )
                      ),
                    ),
                    SizedBox(height: 20,),

                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          hintText: 'Password',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)
                          )
                      ),
                    ),
                    SizedBox(height: 40,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Sign In", style: GoogleFonts.pacifico(
                          fontSize: 27,
                          color: Color(0xff4c505b),
                          fontWeight: FontWeight.w700,
                        ),),
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Color(0xff4c505b),
                          child: IconButton(
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => AdminRegister(),));
                              },
                            icon: Icon(Icons.arrow_forward),

                        ),
                        )

                      ],
                    )
                  ],
                ),

              ),
            )
          ],
        ),
      ),
      );

  }
}
