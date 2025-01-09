import 'package:citychannel/Models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../Models/customer_model.dart';
import '../../Models/order_model.dart';
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

  final TextEditingController bookerName = TextEditingController();
  final TextEditingController newCode = TextEditingController();
  final TextEditingController customerCode = TextEditingController();
  final TextEditingController price = TextEditingController();
  final TextEditingController productCode = TextEditingController();
  final TextEditingController qty = TextEditingController();
  final TextEditingController bonus = TextEditingController(text: 0.toString());
  final TextEditingController discount =
      TextEditingController(text: 0.toString());
  final TextEditingController datetime = TextEditingController();
  final TextEditingController latitute = TextEditingController();
  final TextEditingController longitute = TextEditingController();

  String? currentAddress = "Fetching location...";
  String currentDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
  late Future<ProductModel> futureProducts;
  late Future<CustomerModel> futureCustomers;
  String? selectedProduct;
  String? selectCustomer;
  Position? currentPosition;
  bool positionTaken = false;
  LocationPermission? permission;
  Future<void> insertrecord() async {
    datetime.text = DateTime.now().toString();
    latitute.text = currentPosition!.latitude.toString();
    longitute.text = currentPosition!.longitude.toString();

    if (_formKey.currentState!.validate()) {
      try {
        String uri =
            "http://localhost/City_Channel_AdminPanel/City_Admin/City_Channel_Api/Order/Add_Order.php";
        var res = await http.post(
          Uri.parse(uri),
          body: {
            "BookerName": bookerName.text,
            "Codes": newCode.text,
            "Customer": selectCustomer,
            "CustomerCode": customerCode.text,
            "Product": selectedProduct,
            "Price": price.text,
            "ProductCode": productCode.text,
            "Quantity": qty.text,
            "Bonus": bonus.text,
            "Discount": discount.text,
            "Now_Date": datetime.text,
            "Latitude": latitute.text,
            "Longitude": longitute.text,
          },
        );

        if (res.statusCode == 200) {
          var response = jsonDecode(res.body);
          print(response);
          if (response["success"] == "true") {
            _clearFields();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Order added successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Order added successfully!'),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Server error: ${res.statusCode}'),
              backgroundColor: Colors.pinkAccent,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred. $e'),
            backgroundColor: Colors.teal,
          ),
        );
      }
    }
  }

  void _clearFields() {
    selectCustomer = null;
    customerCode.clear();
    selectedProduct = null;
    price.clear();
    productCode.clear();
    qty.text = "0";
    bonus.text = "0";
    discount.text = "0";
  }

  @override
  void initState() {
    super.initState();
    bookerName.text = widget.user.bookerName;
    newCode.text = widget.user.bookerCode.toString();
    getCurrentLocation();
    futureProducts = fetchProducts();
    futureCustomers = fetchCustomers();
    _updateDateTime();
    futureData = fetchData();
  }

  late Future<CodeModel> futureData;
  Future<CodeModel> fetchData() async {
    const url = 'http://localhost/City_Channel_AdminPanel/City_Admin/City_Channel_Api/Order/fetch_order.php';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return CodeModel.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
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

  Future getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("Location Service is Disabled");
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location Permission are denied");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          "Location permission are permanently denied, we cannot request permission");
    }
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      if (!positionTaken) {
        currentPosition = position;
        positionTaken = true;
      }
      if (currentPosition == null) {
        setState(() {
          currentAddress = "Location Not Found";
        });
      } else {
        setState(() {
          currentAddress =
              "${currentPosition!.latitude},${currentPosition!.longitude}";
        });
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  void _updateDateTime() {
    setState(() {
      currentDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    });
    Future.delayed(Duration(seconds: 1), _updateDateTime);
  }

  // void _addItem() {
  //   if (_formKey.currentState!.validate()) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Item added successfully!'),
  //         backgroundColor: Colors.green,
  //       ),
  //     );
  //     customercode.clear();
  //     Customer.clear();
  //     productcode.clear();
  //     product.clear();
  //     price.clear();
  //     qty.clear();
  //     bonus.clear();
  //     discount.clear();
  //   }
  // }

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
          child: SingleChildScrollView(
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
                        color: Colors.black.withOpacity(0.1),
                        // Subtle shadow for depth
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
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Center(
                                      child: Text('Error: ${snapshot.error}'));
                                }
                                else if (!snapshot.hasData ||
                                snapshot.data!.customers == null) {
                                  return const Center(
                                      child: Text('No Customers Available'));
                                } else {
                                  // Ensure the data is not null and contains customers
                                  List<Customers> customers =
                                      snapshot.data!.customers !;
                                  List<Customers> filteredCustomers =
                                      List.from(customers);

                                  return Expanded(
                                    child: DropdownButtonHideUnderline(
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.33,
                                        child: StatefulBuilder(
                                          builder: (context, setInnerState) {
                                            return DropdownButton2<String>(
                                              isExpanded: true,
                                              hint: Text(
                                                'Select',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Theme.of(context)
                                                      .hintColor,
                                                ),
                                              ),
                                              items:
                                                  filteredCustomers.map((item) {
                                                return DropdownMenuItem<String>(
                                                  value: '${item.customerName} ${item.customerAddress}' ,
                                                  child: Text(
                                                    '${item.customerName!} ${item.customerAddress!}',
                                                    style: const TextStyle(
                                                        fontSize: 14),
                                                  ),
                                                );
                                              }).toList(),
                                              value: selectCustomer,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectCustomer = value;
                                                  Customers selectedItem =
                                                      customers.firstWhere(
                                                    (c) =>
                                                        c.customerName == value,
                                                  );
                                                  customerCode.text =
                                                      selectedItem
                                                          .customerCode!;
                                                });
                                              },
                                              buttonStyleData:
                                                  const ButtonStyleData(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    bottom: BorderSide(
                                                        color: Colors.grey),
                                                  ),
                                                ),
                                                height: 45,
                                              ),
                                              dropdownStyleData:
                                                  const DropdownStyleData(
                                                maxHeight: 200,
                                              ),
                                              menuItemStyleData:
                                                  const MenuItemStyleData(
                                                height: 45,
                                              ),
                                              dropdownSearchData:
                                                  DropdownSearchData(
                                                // searchController: customer,
                                                searchInnerWidgetHeight: 50,
                                                searchInnerWidget: Container(
                                                  height: 50,
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 8,
                                                      horizontal: 8),
                                                  child: TextFormField(
                                                    expands: true,
                                                    maxLines: null,
                                                    // controller: customer,
                                                    onChanged: (searchValue) {
                                                      setInnerState(() {
                                                        filteredCustomers = customers
                                                            .where((item) => item
                                                                .customerName!
                                                                .toLowerCase()
                                                                .contains(
                                                                    searchValue
                                                                        .toLowerCase()))
                                                            .toList();
                                                      });
                                                    },
                                                    decoration: InputDecoration(
                                                      isDense: true,
                                                      contentPadding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              horizontal: 10,
                                                              vertical: 8),
                                                      hintText:
                                                          'Search for a Customer...',
                                                      hintStyle:
                                                          const TextStyle(
                                                              fontSize: 12),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
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
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Center(
                                      child: Text('Error: ${snapshot.error}'));
                                } else if (!snapshot.hasData ||
                                    snapshot.data!.products == null) {
                                  return const Center(
                                      child: Text('No products available'));
                                } else {
                                  List<Products> products =
                                      snapshot.data!.products!;
                                  return Expanded(
                                    child: DropdownButtonHideUnderline(
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.33,
                                        child: DropdownButton2<String>(
                                          isExpanded: true,
                                          hint: Text(
                                            'Select',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color:
                                                  Theme.of(context).hintColor,
                                            ),
                                          ),
                                          items: products.map((item) {
                                            return DropdownMenuItem<String>(
                                              value: item.productName,
                                              child: Text(
                                                item.productName!,
                                                style: const TextStyle(
                                                    fontSize: 14),
                                              ),
                                            );
                                          }).toList(),
                                          value: selectedProduct,
                                          onChanged: (value) {
                                            setState(() {
                                              selectedProduct = value;
                                              Products selectedItem = products
                                                  .firstWhere((product) =>
                                                      product.productName ==
                                                      value);
                                              productCode.text =
                                                  selectedItem.productCode!;
                                              price.text =
                                                  selectedItem.productPrice!;
                                            });
                                          },
                                          buttonStyleData:
                                              const ButtonStyleData(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      color: Colors.grey)),
                                            ),
                                            height: 45,
                                          ),
                                          dropdownStyleData:
                                              const DropdownStyleData(
                                                  maxHeight: 200),
                                          menuItemStyleData:
                                              const MenuItemStyleData(
                                                  height: 45),
                                          dropdownSearchData:
                                              DropdownSearchData(
                                            // searchController: product,
                                            searchInnerWidgetHeight: 50,
                                            searchInnerWidget: Container(
                                              height: 50,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 8),
                                              child: TextFormField(
                                                expands: true,
                                                maxLines: null,
                                                // controller: product,
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 10,
                                                          vertical: 8),
                                                  hintText:
                                                      'Search for an item...',
                                                  hintStyle: const TextStyle(
                                                      fontSize: 12),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            searchMatchFn: (item, searchValue) {
                                              return item.value
                                                  .toString()
                                                  .contains(searchValue);
                                            },
                                          ),
                                          onMenuStateChange: (isOpen) {
                                            if (!isOpen) {
                                              selectedProduct = null;
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
                                controller: qty,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.blueAccent.withOpacity(0.1),
                                  hintText: 'Qty',
                                  hintStyle:
                                      const TextStyle(color: Colors.blueAccent),
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
                                controller: bonus,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.blueAccent.withOpacity(0.1),
                                  hintText: 'Bonus',
                                  hintStyle:
                                      const TextStyle(color: Colors.blueAccent),
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
                                controller: discount,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.blueAccent.withOpacity(0.1),
                                  hintText: 'Discount',
                                  hintStyle:
                                      const TextStyle(color: Colors.blueAccent),
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
                                readOnly: true,
                                controller: customerCode,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.blueAccent.withOpacity(0.1),
                                  hintText: 'Customer Code',
                                  hintStyle:
                                      const TextStyle(color: Colors.blueAccent),
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
                                controller: productCode,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.blueAccent.withOpacity(0.1),
                                  hintText: 'Product Code',
                                  hintStyle:
                                      const TextStyle(color: Colors.blueAccent),
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
                                controller: price,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.blueAccent.withOpacity(0.1),
                                  hintText: 'Product Price',
                                  hintStyle:
                                      const TextStyle(color: Colors.blueAccent),
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
                              onPressed: insertrecord,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
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
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    print('Button Pressed!');
                  },
                  child: Text('Add'),
                ),

                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 300,
                  child: FutureBuilder<CodeModel>(
                    future: fetchData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      } else if (!snapshot.hasData || snapshot.data!.booked_order == null) {
                        return Center(child: Text("No Data Available"));
                      } else {
                        final confirmData = snapshot.data!.booked_order!;
                        return ListView.builder(
                          itemCount: confirmData.length,
                          itemBuilder: (context, index) {
                            final item = confirmData[index];
                            return ListTile(
                              title: Text(item.product ?? "Unknown Product"),
                              subtitle: Text("Price: ${item.price} | Qty: ${item.qty}"),
                              trailing: Text(item.newCode ?? "No Code"),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
