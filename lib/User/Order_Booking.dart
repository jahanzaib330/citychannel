import 'package:citychannel/User/Firebase_Auth/User_Login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderBooking extends StatefulWidget {
  const OrderBooking({super.key});

  @override
  State<OrderBooking> createState() => _OrderBookingState();
}

class _OrderBookingState extends State<OrderBooking> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        title: Text("Book Order" , style: GoogleFonts.palanquin(
          fontSize: 25,
          fontWeight: FontWeight.w800,
          color: Colors.blueAccent
        ),),
        backgroundColor: const Color(0xffffffff),
        centerTitle: true,
        elevation: 0,
        leading: Builder(builder: (context) {
          return IconButton(onPressed: (){
            Scaffold.of(context).openDrawer();
          },icon: const Icon(Icons.dehaze, color: Color(0xf0000000),));
        },),
        
      ),

      drawer: Drawer(
        child: Column(
          children: [
            GestureDetector(
              // onTap: (){
              //   Navigator.push(context, MaterialPageRoute(builder: (context) => ,));
              // },
              child: const ListTile(
                leading: Icon(Icons.home),
                title:  Text("Home"),
              ),
            ),
            GestureDetector(
              // onTap: (){
              //   Navigator.push(context, MaterialPageRoute(builder: (context) => ,));
              // },
              child: const ListTile(
                leading: Icon(Icons.production_quantity_limits),
                title:  Text("Product List"),
              ),
            ),
            GestureDetector(
              // onTap: (){
              //   Navigator.push(context, MaterialPageRoute(builder: (context) => ,));
              // },
              child: const ListTile(
                leading: Icon(Icons.book),
                title:  Text("Order Summary"),
              ),
            ),

            GestureDetector(
              // onTap: (){
              //   Navigator.push(context, MaterialPageRoute(builder: (context) => ,));
              // },
              child: const ListTile(
                leading: Icon(Icons.upload),
                title:  Text("Upload Order"),
              ),
            ),

            GestureDetector(
              // onTap: (){
              //   Navigator.push(context, MaterialPageRoute(builder: (context) => ,));
              // },
              child: const ListTile(
                leading: Icon(Icons.delete),
                title:  Text("Delete  Order"),
              ),
            ),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => UserLogin(),));
              },
              child: const ListTile(
                leading: Icon(Icons.logout),
                title:  Text("Logout"),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: ScrollPhysics(),
        child: Column(
          children: [
           Stack(
             children: [
              Container(
               margin: EdgeInsets.only(left: 50 , top: 40),
               width: 300,
               height: 600,
               decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(10),
                 color: Colors.black
               ),
               child:  Stack(
                 children: [
                  Container(
                    width: 250,
                    margin: EdgeInsets.only(top: 10, left: 20),
                    child: TextField(
                     decoration: InputDecoration(
                         fillColor: Colors.blueAccent,
                         filled: true,
                         hintText: 'Booker Name: Jahanzaib',
                         hintStyle: TextStyle(color: Colors.white),
                         border: OutlineInputBorder(
                             borderRadius: BorderRadius.circular(10)
                         )
                     ),
                 ),
                  ),
                   Container(
                     width: 250,
                     margin: EdgeInsets.only(top: 90, left: 20),
                     child: TextField(
                       decoration: InputDecoration(
                           fillColor: Colors.blueAccent,
                           filled: true,
                           hintText: 'Booker Code: 115',
                           hintStyle: TextStyle(color: Colors.white),
                           border: OutlineInputBorder(
                               borderRadius: BorderRadius.circular(10)
                           )
                       ),
                     ),
                   ),

                   Container(
                     width: 250,
                     margin: EdgeInsets.only(top: 170, left: 20),
                     child: TextField(
                       decoration: InputDecoration(
                           fillColor: Colors.blueAccent,
                           filled: true,
                           hintText: 'Select Customer:',
                           hintStyle: TextStyle(color: Colors.white),
                           border: OutlineInputBorder(
                               borderRadius: BorderRadius.circular(10)
                           )
                       ),
                     ),
                   ),
                   Container(
                     width: 250,
                     margin: EdgeInsets.only(top: 250, left: 20),
                     child: TextField(
                       decoration: InputDecoration(
                           fillColor: Colors.blueAccent,
                           filled: true,
                           hintText: 'Select Item:',
                           hintStyle: TextStyle(color: Colors.white),
                           border: OutlineInputBorder(
                               borderRadius: BorderRadius.circular(10)
                           )
                       ),
                     ),
                   ),
                   Row(
                     children: [
                       Container(
                         width: 120,
                         margin: EdgeInsets.only(top: 330, left: 20),
                         child: TextField(
                           decoration: InputDecoration(
                               fillColor: Colors.blueAccent,
                               filled: true,
                               hintText: 'Quantity:',
                               hintStyle: TextStyle(color: Colors.white),
                               border: OutlineInputBorder(
                                   borderRadius: BorderRadius.circular(10)
                               )
                           ),
                         ),
                       ),
                     ],
                   ),

                   Row(
                     children: [
                       Container(
                         width: 120,
                         margin: EdgeInsets.only(top: 330, left: 150),
                         child: TextField(
                           decoration: InputDecoration(
                               fillColor: Colors.blueAccent,
                               filled: true,
                               hintText: 'Discount:',
                               hintStyle: TextStyle(color: Colors.white),
                               border: OutlineInputBorder(
                                   borderRadius: BorderRadius.circular(10)
                               )
                           ),
                         ),
                       ),
                     ],
                   ),
                   Row(
                     children: [
                       Container(
                         width: 120,
                         margin: EdgeInsets.only(top: 410, left: 20),
                         child: TextField(
                           decoration: InputDecoration(
                               fillColor: Colors.blueAccent,
                               filled: true,
                               hintText: 'Bonus:',
                               hintStyle: TextStyle(color: Colors.white),
                               border: OutlineInputBorder(
                                   borderRadius: BorderRadius.circular(10)
                               )
                           ),
                         ),
                       ),
                       Row(
                         children: [
                           Container(
                             width: 120,
                             height: 50,
                             margin: EdgeInsets.only(top: 410, left: 10),
                             decoration: BoxDecoration(
                               color: Colors.white
                             ),
                             child: ElevatedButton(
                               onPressed: (){
                                 // Navigator.push(context, MaterialPageRoute(builder: (context) => ,))
                               },
                               child: Text("Add Item", style: GoogleFonts.poppins(
                                 fontSize: 18,
                                 fontWeight: FontWeight.bold,
                                 color: Colors.white
                               ),),
                             ),
                           ),
                         ],
                       )
                     ],
                   ),

                 ],
               ),

             ),

             ],
           )
          ]
        ),
      ),





    );
  }
}
