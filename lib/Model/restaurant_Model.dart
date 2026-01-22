class Restaurant{
  String res_name;
  String res_add;
  String res_phone;

  Restaurant({
    required this.res_name,
    required this.res_add,
    required this.res_phone});

  factory Restaurant.fromJson(Map<String,dynamic>json){
    return Restaurant(res_name: json['res_name'], res_add: json['res_add'], res_phone: json['res_phone']);
  }

  Map<String,dynamic> tojson() {
return{
  'res_name': res_name,
  'res_add' : res_add,
  'res_phone' : res_phone
};
  }
}