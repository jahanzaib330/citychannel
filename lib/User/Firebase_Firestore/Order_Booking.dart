import 'package:citychannel/User/Firebase_Auth/User_Login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Models/user_model.dart';
import '../../Providers/user_provider.dart';
import 'Detail_Screen.dart';

class OrderBooking extends StatefulWidget {
  const OrderBooking({super.key});

  @override
  State<OrderBooking> createState() => _OrderBookingState();
}

class _OrderBookingState extends State<OrderBooking> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  String? selectedItem;
  String userEmail = "user@example.com";
  String userPassword = "password123";

  @override
  void initState() {
    super.initState();
    fetchBookerDetails();
  }

  Future<void> fetchBookerDetails() async {
    const String apiUrl =
        "http://localhost/city_Channel_AdminPanel/City_Admin/City_Channel_Api/bookers/login.php";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          "email": userEmail,
          "password": userPassword,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData["status"] == "success") {
          setState(() {
            _nameController.text = responseData["data"]["booker_name"];
            _codeController.text = responseData["data"]["booker_code"];
          });
        } else {
          showError(responseData["message"]);
        }
      } else {
        showError("Failed to fetch data from the server");
      }
    } catch (e) {
      showError("An error occurred: $e");
    }
  }
  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _bookOrder(UserModel user) {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>  DetailScreen(user: user,),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    Future<void> logout() async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const UserLogin()),
      );
    }


    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        title: Text(
          "Book Order",
          style: GoogleFonts.palanquin(
            fontSize: 25,
            fontWeight: FontWeight.w800,
            color: Colors.blueAccent,
          ),
        ),
        backgroundColor: const Color(0xffffffff),
        centerTitle: true,
        elevation: 0,
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(Icons.dehaze, color: Color(0xf0000000)),
            );
          },
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.production_quantity_limits),
              title: const Text("Product List"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text("Order Summary"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.upload),
              title: const Text("Upload Order"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text("Delete Order"),
              onTap: () {},
            ),
      ListTile(
        leading: const Icon(Icons.logout),
        title: const Text("Logout"),
        onTap: logout
      )

      ],
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 40),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      user == null
                          ? const Center(child: Text("No user logged in"))
                          : TextFormField(
                              controller: _nameController
                                ..text = user.bookerName,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.blueAccent.withOpacity(0.1),
                                hintText: 'Booker Name:',
                                hintStyle:
                                    const TextStyle(color: Colors.blueAccent),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the booker name';
                                }
                                return null;
                              },
                            ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _codeController ..text = user!.newcode,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.blueAccent.withOpacity(0.1),
                          hintText: 'Booker Code: ',
                          hintStyle: const TextStyle(color: Colors.blueAccent),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the booker code';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Booker code must be a valid number';
                          }
                          return null;
                        },
                      ),
                      DropdownButtonFormField(
                          items: [], onChanged: (item) {
                      // selectedItem = item;
                          }),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: (){
                          _bookOrder(user);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "Book an Order",
                          style: GoogleFonts.palanquin(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
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
