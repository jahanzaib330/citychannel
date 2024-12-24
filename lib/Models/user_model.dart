
class UserModel {
  final int bookerCode;
  final String bookerName;
  final String bookerEmail;
  final String bookerContact;
  final String bookerPassword;
  final String newcode;

  UserModel({
    required this.bookerCode,
    required this.bookerName,
    required this.bookerEmail,
    required this.bookerContact,
    required this.bookerPassword,
    required this.newcode,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      bookerCode: int.parse(json["BookerCode"].toString()),
      bookerName: json["BookerName"],
      bookerEmail: json["BookerEmail"],
      bookerContact: json["BookerContact"],
      bookerPassword: json["BookerPassword"],
      newcode: json["NewCode"]
    );
  }
}
