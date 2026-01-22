import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant/Controller/table_controller.dart';
import 'package:restaurant/Model/table_Model.dart' as tableModel;

class TableView extends StatelessWidget {
  final TableController controller = Get.put(TableController());

  TableView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tables'),
        backgroundColor: Colors.blue[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tables Management',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: () => _showAddDialog(),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Table'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.tables.isEmpty) {
                  return const Center(child: Text('No tables found'));
                }
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Column(
                      children: [
                        // Table Header
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            border: Border(
                              bottom: BorderSide(color: Colors.grey[300]!),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: _buildTableHeader('Table No'),
                              ),
                              Expanded(
                                flex: 2,
                                child: _buildTableHeader('Capacity'),
                              ),
                              Expanded(
                                flex: 2,
                                child: _buildTableHeader('Status'),
                              ),
                              Expanded(
                                flex: 2,
                                child: _buildTableHeader('Actions'),
                              ),
                            ],
                          ),
                        ),
                        // Table Rows
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.tables.length,
                          separatorBuilder: (context, index) =>
                              Divider(height: 0, color: Colors.grey[200]),
                          itemBuilder: (context, index) {
                            final table = controller.tables[index];
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text(table.table_no),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(table.Table_Capacity),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: table.Table_statue == 'available'
                                            ? Colors.green[100]
                                            : Colors.red[100],
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        table.Table_statue,
                                        style: TextStyle(
                                          color:
                                              table.Table_statue == 'available'
                                              ? Colors.green[700]
                                              : Colors.red[700],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            Icons.edit,
                                            color: Colors.blue[700],
                                          ),
                                          onPressed: () =>
                                              _showEditDialog(table),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          onPressed: () => _deleteTable(table),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 13,
        color: Colors.grey,
      ),
    );
  }

  void _showAddDialog() {
    final noCtrl = TextEditingController();
    final capacityCtrl = TextEditingController();
    final statusCtrl = TextEditingController(text: 'available');

    Get.dialog(
      AlertDialog(
        title: const Text('Add Table'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: noCtrl,
                decoration: const InputDecoration(labelText: 'Table Number'),
              ),
              TextField(
                controller: capacityCtrl,
                decoration: const InputDecoration(labelText: 'Capacity'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: statusCtrl,
                decoration: const InputDecoration(labelText: 'Status'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              if (noCtrl.text.isNotEmpty && capacityCtrl.text.isNotEmpty) {
                controller.addTable(
                  tableModel.Table(
                    table_no: noCtrl.text,
                    Table_Capacity: capacityCtrl.text,
                    Table_statue: statusCtrl.text,
                  ),
                );
                Get.back();
              } else {
                Get.snackbar('Error', 'Please fill all fields');
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(tableModel.Table table) {
    final noCtrl = TextEditingController(text: table.table_no);
    final capacityCtrl = TextEditingController(text: table.Table_Capacity);
    final statusCtrl = TextEditingController(text: table.Table_statue);

    Get.dialog(
      AlertDialog(
        title: const Text('Edit Table'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: noCtrl,
                decoration: const InputDecoration(labelText: 'Table Number'),
              ),
              TextField(
                controller: capacityCtrl,
                decoration: const InputDecoration(labelText: 'Capacity'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: statusCtrl,
                decoration: const InputDecoration(labelText: 'Status'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              controller.updateTable(
                table.table_no,
                tableModel.Table(
                  table_no: noCtrl.text,
                  Table_Capacity: capacityCtrl.text,
                  Table_statue: statusCtrl.text,
                ),
              );
              Get.back();
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _deleteTable(table) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Table'),
        content: Text('Delete table ${table.table_no}?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              controller.deleteTable(table.table_no);
              Get.back();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
