class MenuCategories {
  String menu_id;
  String menu_cat_name;
  String menu_cat_img;

  MenuCategories({
    required this.menu_id,
    required this.menu_cat_name,
    required this.menu_cat_img,
  });

  factory MenuCategories.fromJson(Map<String, dynamic> json) {
    return MenuCategories(
      menu_id: json['menu_id'],
      menu_cat_name: json['menu_cat_name'],
      menu_cat_img: json['menu_cat_img'],
    );
  }

  Map<String, dynamic> toJson() => {
    'menu_id': menu_id,
    'menu_cat_name': menu_cat_name,
    'menu_cat_img': menu_cat_img,
  };
}
