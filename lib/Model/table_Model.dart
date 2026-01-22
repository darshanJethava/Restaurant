class Table {
  String table_no;
  String Table_Capacity;
  String Table_statue;

  Table({
    required this.table_no,
    required this.Table_Capacity,
    required this.Table_statue,
  });

  factory Table.fromJson(Map<String, dynamic> json) {
    return Table(
      table_no: json['table_no'],
      Table_Capacity: json['Table_Capacity'],
      Table_statue: json['Table_statue'],
    );
  }

  Map<String, dynamic> toJson() => {
    'table_no': table_no,
    'Table_Capacity': Table_Capacity,
    'Table_statue': Table_statue,
  };
}
