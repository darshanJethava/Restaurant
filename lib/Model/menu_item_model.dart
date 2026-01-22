class MenuItem {
  String menu_item_id;
  String menu_item_name;
  String item_price;
  String category_id;
  String item_img;

  MenuItem({
    required this.menu_item_id,
    required this.menu_item_name,
    required this.item_price,
    required this.category_id,
    required this.item_img,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      menu_item_id: json['menu_item_id'],
      menu_item_name: json['menu_item_name'],
      item_price: json['item_price'],
      category_id: json['category_id'],
      item_img: json['item_img'],
    );
  }

  Map<String, dynamic> toJson() => {
    'menu_item_id': menu_item_id,
    'menu_item_name': menu_item_name,
    'item_price': item_price,
    'category_id': category_id,
    'item_img': item_img,
  };
}
