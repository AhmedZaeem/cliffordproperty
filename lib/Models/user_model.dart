

class UserModel {
  String? id;
  String? name;
  String? email;
  String? password;
  String? City;
  String? image;
  String? phone;
  String? fcm;
  String? permission;


  UserModel({
    this.id,
    this.name,
    this.email,
    this.password,
    this.City,
    this.image,
    this.phone,
    this.fcm,
    this.permission,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    City = json['City'];
    image = json['image'];
    phone = json['phone'];
    fcm = json['fcm'];
    permission = json['permission'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = id;
    json['name'] = name;
    json['email'] = email;
    json['password'] = password;
    json['City'] = City;
    json['image'] = image;
    json['phone'] = phone;
    json['fcm'] = fcm;
    json['permission'] = permission;
    return json;
  }
}
