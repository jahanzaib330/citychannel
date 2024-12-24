class ProductModel {
  bool? success;
  List<Products>? products;

  ProductModel({this.success, this.products});

  ProductModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Products {
  String? productCode;
  String? productName;
  String? productPacking;
  String? productPrice;
  String? productQuantity;

  Products(
      {this.productCode,
      this.productName,
      this.productPacking,
      this.productPrice,
      this.productQuantity});

  Products.fromJson(Map<String, dynamic> json) {
    productCode = json['Product_Code'];
    productName = json['Product_Name'];
    productPacking = json['Product_Packing'];
    productPrice = json['Product_Price'];
    productQuantity = json['Product_Quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Product_Code'] = this.productCode;
    data['Product_Name'] = this.productName;
    data['Product_Packing'] = this.productPacking;
    data['Product_Price'] = this.productPrice;
    data['Product_Quantity'] = this.productQuantity;
    return data;
  }
}
