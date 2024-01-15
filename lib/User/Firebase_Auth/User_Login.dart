import 'package:citychannel/User/Order_Booking.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserLogin extends StatefulWidget {
  const UserLogin({super.key});

  @override
  State<UserLogin> createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
              padding: EdgeInsets.only(left: 35, top: 40),
              child: Text("Welcome to\n    Login", style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 33
              ),),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: ScrollPhysics(),
              child: Container(
                padding: EdgeInsets.only(top: MediaQuery
                    .of(context)
                    .size
                    .height * 0.5,
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
                        Text("Login", style: GoogleFonts.pacifico(
                          fontSize: 27,
                          color: Color(0xff4c505b),
                          fontWeight: FontWeight.w700,
                        ),),
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Color(0xff4c505b),
                          child: IconButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) => OrderBooking(),));
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
