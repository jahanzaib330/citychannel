class CustomerModel {
  bool? success;
  List<Customers>? customers;

  CustomerModel({this.success, this.customers});

  CustomerModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['customers'] != null) {
      customers = <Customers>[];
      json['customers'].forEach((v) {
        customers!.add(Customers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.customers != null) {
      data['customers'] = this.customers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Customers {
  String? bookerCode;
  String? customerCode;
  String? customerName;
  String? customerAddress;

  Customers({this.bookerCode, this.customerCode, this.customerName, this.customerAddress});

  Customers.fromJson(Map<String, dynamic> json) {
    bookerCode = json['Booker_code'];
    customerCode = json['Customer_Code'];
    customerName = json['Customer_Name'];
    customerAddress = json['Customer_Address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Booker_code'] = this.bookerCode;
    data['Customer_Code'] = this.customerCode;
    data['Customer_Name'] = this.customerName;
    data['Customer_Address'] = this.customerAddress;
    return data;
  }
}