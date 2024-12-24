import 'package:citychannel/Models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../Models/customer_model.dart';
import '../../Models/user_model.dart';
import '../Firebase_Auth/User_Login.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class DetailScreen extends StatefulWidget {
  final UserModel user;

  const DetailScreen({super.key, required this.user});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _customerCodeController = TextEditingController();
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _productCodeController = TextEditingController();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productPriceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _bonusController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController datetime = TextEditingController();
  String? currentAddress = "Fetching location...";
  String currentDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
  late Future<ProductModel> futureProducts;
  late Future<CustomerModel> futureCustomers;
  String? selectedProduct;
  String? selectCustomer;

  @override
  void initState() {
    super.initState();
    futureProducts = fetchProducts();
    futureCustomers = fetchCustomers();
    _getCurrentLocation();
    _updateDateTime();
  }

  Future<ProductModel> fetchProducts() async {
    final response = await http.get(Uri.parse(
        'http://localhost/City_Channel_AdminPanel/City_Admin/City_Channel_Api/Product/View_Product.php'));

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON.
      return ProductModel.fromJson(json.decode(response.body));
    } else {
      // If the server does not return a 200 OK response, throw an exception.
      throw Exception('Failed to load products');
    }
  }

  Future<CustomerModel> fetchCustomers() async {
    final responsecustomer = await http.get(Uri.parse(
        'http://localhost/City_Channel_AdminPanel/City_Admin/City_Channel_Api/Customers/View_Customer.php'));

    if (responsecustomer.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON.

      return CustomerModel.fromJson(json.decode(responsecustomer.body));
    } else {
      // If the server does not return a 200 OK response, throw an exception.
      throw Exception('Failed to load Customers');
    }
  }

  Future<void> _getCurrentLocation() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    setState(() {
      currentAddress = "Location services are disabled.";
    });
    return;
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      setState(() {
        currentAddress = "Location permissions are denied.";
      });
      return;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    setState(() {
      currentAddress = "Location permissions are permanently denied.";
    });
    return;
  }

  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);

  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    setState(() {
      currentAddress =
          "${placemarks.first.locality}, ${placemarks.first.administrativeArea}";
    });
  } catch (e) {
    setState(() {
      currentAddress = "Error retrieving location: $e";
    });
  }
}

  void _updateDateTime() {
    setState(() {
      currentDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    });
    Future.delayed(Duration(seconds: 1), _updateDateTime);
  }

  void _addItem() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Item added successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      _customerCodeController.clear();
      _customerNameController.clear();
      _productCodeController.clear();
      _productNameController.clear();
      _productPriceController.clear();
      _quantityController.clear();
      _bonusController.clear();
      _discountController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
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
              onTap: () {
                // Handle Home navigation
              },
            ),
            ListTile(
              leading: const Icon(Icons.production_quantity_limits),
              title: const Text("Product List"),
              onTap: () {
                // Handle Product List navigation
              },
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text("Order Summary"),
              onTap: () {
                // Handle Order Summary navigation
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserLogin(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Text(
                    "Live Location: $currentAddress",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Real-Time Date: $currentDate",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),

              const SizedBox(height: 20),
              // User Information Section
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Booker Name: ${widget.user.bookerName}",
                      style: GoogleFonts.palanquin(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "New Code: ${widget.user.newcode}",
                      style: GoogleFonts.palanquin(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Form Section
              Container(
  width: MediaQuery.of(context).size.width * 0.9,
  padding: const EdgeInsets.all(20),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1), // Subtle shadow for depth
        blurRadius: 12,
        offset: const Offset(0, 5),
      ),
    ],
  ),
  child: Form(
    key: _formKey,
    child: Column(
      children: [
        Row(
          children: [
            FutureBuilder<CustomerModel>(
              future: futureCustomers,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  List<Customers> customer = snapshot.data!.customers!;
                  return Expanded(
                    child: DropdownButtonHideUnderline(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.33,
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          hint: Text(
                            'Select',
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                          items: customer.map((item) {
                            return DropdownMenuItem<String>(
                              value: item.customerName,
                              child: Text(
                                item.customerName!,
                                style: const TextStyle(fontSize: 14),
                              ),
                            );
                          }).toList(),
                          value: selectCustomer,
                          onChanged: (value) {
                            setState(() {
                              selectCustomer = value;
                              Customers selectedItem = customer.firstWhere(
                                (c) => c.customerName == value
                              );
                              _customerCodeController.text = selectedItem.customerCode!;
                            });
                          },
                          buttonStyleData: const ButtonStyleData(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Colors.grey),
                              ),
                            ),
                            height: 45, // Adjusted button height
                          ),
                          dropdownStyleData: const DropdownStyleData(maxHeight: 200),
                          menuItemStyleData: const MenuItemStyleData(height: 45),
                          dropdownSearchData: DropdownSearchData(
                            searchController: _customerNameController,
                            searchInnerWidgetHeight: 50,
                            searchInnerWidget: Container(
                              height: 50,
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                              child: TextFormField(
                                expands: true,
                                maxLines: null,
                                controller: _customerNameController,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                  hintText: 'Search for an Customer...',
                                  hintStyle: const TextStyle(fontSize: 12),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),                          ),
                          onMenuStateChange: (isOpen) {
                            if (!isOpen) {
                              _customerNameController.clear();
                            }
                          },
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
            const SizedBox(width: 10),

            FutureBuilder<ProductModel>(
              future: futureProducts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.products == null) {
                  return const Center(child: Text('No products available'));
                } else {
                  List<Products> products = snapshot.data!.products!;
                  return Expanded(
                    child: DropdownButtonHideUnderline(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.33,
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          hint: Text(
                            'Select',
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                          items: products.map((item) {
                            return DropdownMenuItem<String>(
                              value: item.productName,
                              child: Text(
                                item.productName!,
                                style: const TextStyle(fontSize: 14),
                              ),
                            );
                          }).toList(),
                          value: selectedProduct,
                          onChanged: (value) {
                            setState(() {
                              selectedProduct = value;
                              Products selectedItem = products.firstWhere((product) => product.productName == value);
                              _productCodeController.text = selectedItem.productCode!;
                              _productPriceController.text = selectedItem.productPrice!;
                            });
                          },
                          buttonStyleData: const ButtonStyleData(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: Colors.grey)),
                            ),
                            height: 45,
                          ),
                          dropdownStyleData: const DropdownStyleData(maxHeight: 200),
                          menuItemStyleData: const MenuItemStyleData(height: 45),
                          dropdownSearchData: DropdownSearchData(
                            searchController: _productNameController,
                            searchInnerWidgetHeight: 50,
                            searchInnerWidget: Container(
                              height: 50,
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                              child: TextFormField(
                                expands: true,
                                maxLines: null,
                                controller: _productNameController,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                  hintText: 'Search for an item...',
                                  hintStyle: const TextStyle(fontSize: 12),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                            searchMatchFn: (item, searchValue) {
                              return item.value.toString().contains(searchValue);
                            },
                          ),
                          onMenuStateChange: (isOpen) {
                            if (!isOpen) {
                              _productNameController.clear();
                            }
                          },
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.blueAccent.withOpacity(0.1),
                  hintText: 'Qty',
                  hintStyle: const TextStyle(color: Colors.blueAccent),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter quantity';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                controller: _bonusController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.blueAccent.withOpacity(0.1),
                  hintText: 'Bonus',
                  hintStyle: const TextStyle(color: Colors.blueAccent),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter bonus';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _discountController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.blueAccent.withOpacity(0.1),
                  hintText: 'Discount',
                  hintStyle: const TextStyle(color: Colors.blueAccent),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter Discount';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                controller: _customerCodeController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.blueAccent.withOpacity(0.1),
                  hintText: 'Customer Code',
                  hintStyle: const TextStyle(color: Colors.blueAccent),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter Customer Code';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                readOnly: true,
                controller: _productCodeController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.blueAccent.withOpacity(0.1),
                  hintText: 'Product Code',
                  hintStyle: const TextStyle(color: Colors.blueAccent),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter Product Code';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                readOnly: true,
                controller: _productPriceController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.blueAccent.withOpacity(0.1),
                  hintText: 'Product Price',
                  hintStyle: const TextStyle(color: Colors.blueAccent),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter Product Price';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: _addItem,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "Add Item",
                style: GoogleFonts.palanquin(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  ),
)

            ],
          ),
        ),
      ),
    );
  }
}
