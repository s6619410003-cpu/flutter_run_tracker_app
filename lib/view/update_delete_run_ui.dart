import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// 1. ชื่อ Class ต้องตรงกับที่ show_all เรียกหาเป๊ะๆ
class UpdateDeleteRunUi extends StatefulWidget {
  // 2. ต้องมีตัวแปรรับค่าจากหน้า show_all
  final Map<String, dynamic> runItem;

  const UpdateDeleteRunUi({super.key, required this.runItem});

  @override
  State<UpdateDeleteRunUi> createState() => _UpdateDeleteRunUiState();
}

class _UpdateDeleteRunUiState extends State<UpdateDeleteRunUi> {
  late TextEditingController _runWhereCtrl;
  late TextEditingController _runPersonCtrl;
  late TextEditingController _runDistanceCtrl;

  @override
  void initState() {
    super.initState();
    // นำข้อมูลเดิมมาแสดงในช่องพิมพ์
    _runWhereCtrl = TextEditingController(text: widget.runItem['runWhere']);
    _runPersonCtrl = TextEditingController(text: widget.runItem['runPerson']);
    _runDistanceCtrl =
        TextEditingController(text: widget.runItem['runDistance'].toString());
  }

  void showMessage(String msg) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('แจ้งเตือน'),
        content: Text(msg),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('ตกลง'))
        ],
      ),
    );
  }

  // ฟังก์ชันอัปเดตข้อมูล
  Future<void> _updateData() async {
    try {
      await Supabase.instance.client.from('run_tb').update({
        'runWhere': _runWhereCtrl.text,
        'runPerson': _runPersonCtrl.text,
        'runDistance': int.parse(_runDistanceCtrl.text),
      }).eq('id', widget.runItem['id']);

      if (mounted) Navigator.pop(context); // กลับหน้าเดิม
    } catch (e) {
      showMessage('เกิดข้อผิดพลาดในการแก้ไข: $e');
    }
  }

  // ฟังก์ชันลบข้อมูล
  Future<void> _deleteData() async {
    try {
      await Supabase.instance.client
          .from('run_tb')
          .delete()
          .eq('id', widget.runItem['id']);

      if (mounted) Navigator.pop(context); // กลับหน้าเดิม
    } catch (e) {
      showMessage('เกิดข้อผิดพลาดในการลบ: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Run Tracker (แก้ไข/ลบ)'),
        backgroundColor: const Color(0xFF091442),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            const SizedBox(height: 30),
            Image.asset('assets/images/running.png', height: 300),
            const SizedBox(height: 30),

            _buildInputLabel('วิ่งที่ไหน'),
            _buildTextField(_runWhereCtrl, 'ระบุสถานที่'),

            _buildInputLabel('วิ่งกับใคร'),
            _buildTextField(_runPersonCtrl, 'ระบุผู้ร่วมวิ่ง'),

            _buildInputLabel('ระยะทาง (กม.)'),
            _buildTextField(_runDistanceCtrl, 'ระบุตัวเลขระยะทาง',
                isNumber: true),

            const SizedBox(height: 40),

            // ปุ่มบันทึกการแก้ไข (สีเขียว)
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _updateData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('บันทึกแก้ไขข้อมูล',
                    style: TextStyle(color: Colors.white)),
              ),
            ),

            const SizedBox(height: 15),

            // ปุ่มลบข้อมูล (สีแดง)
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _deleteData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF44336),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('ลบข้อมูล',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8, top: 15),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildTextField(TextEditingController ctrl, String hint,
      {bool isNumber = false}) {
    return TextField(
      controller: ctrl,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      ),
    );
  }
}
