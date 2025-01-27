import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../Models/order_model.dart';
import '../Firebase_Auth/User_Login.dart';
import 'Order_Booking.dart';

class FetchOrder extends StatefulWidget {
  const FetchOrder({super.key});

  @override
  State<FetchOrder> createState() => _FetchOrderState();
}

class _FetchOrderState extends State<FetchOrder> {
  late Future<OrderModel> futureData;
  Future<OrderModel> fetchData() async {
    const url = 'http://localhost/City_Channel_AdminPanel/City_Admin/City_Channel_Api/Order/fetch_order.php';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print(jsonResponse);
        return OrderModel.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const UserLogin()),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        title: Text(
          "Order Summary",
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
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const OrderBooking()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.production_quantity_limits),
              title: const Text("Product List"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text("Order Summary"),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const FetchOrder()),
                );
              },
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
                onTap: logout)
          ],
        ),
      ),
      body: SizedBox(
        height: 1000,
        child: FutureBuilder<OrderModel>(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Error: ${snapshot.error}",
                  style: TextStyle(color: Colors.white),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.order == null) {
              return Center(
                child: Text(
                  "No Data Available",
                  style: TextStyle(color: Colors.white),
                ),
              );
            } else {
              final confirmData = snapshot.data!.order;
              return ListView.builder(
                itemCount: confirmData!.length,
                itemBuilder: (context, index) {
                  final item = confirmData[index];
                  return ListTile(
                    title: Text(
                      item.product ?? "Unknown Product",
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      "Price: ${item.price} | Qty: ${item.quantity} | Customer_Name: ${item.customer}",
                      style: TextStyle(color: Colors.white70 , fontWeight: FontWeight.bold),
                    ),
                    trailing: Text(
                      item.codes ?? "No Code",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
