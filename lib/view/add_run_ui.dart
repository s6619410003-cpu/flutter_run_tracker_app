import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddRunUi extends StatefulWidget {
  const AddRunUi({super.key});

  @override
  State<AddRunUi> createState() => _AddRunUiState();
}

class _AddRunUiState extends State<AddRunUi> {
  // สร้าง Controller สำหรับรับค่าจาก TextField
  final TextEditingController _runWhereCtrl = TextEditingController();
  final TextEditingController _runPersonCtrl = TextEditingController();
  final TextEditingController _runDistanceCtrl = TextEditingController();

  // ฟังก์ชันแสดง Alert Dialog สำหรับแจ้งเตือน
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

  // ฟังก์ชันบันทึกข้อมูลลง Supabase
  Future<void> _saveRunData() async {
    // 1. Validate: ตรวจสอบว่ากรอกข้อมูลครบไหม
    if (_runWhereCtrl.text.isEmpty || _runDistanceCtrl.text.isEmpty) {
      showMessage('กรุณากรอกข้อมูล "สถานที่" และ "ระยะทาง" ให้ครบถ้วน');
      return;
    }

    try {
      // 2. ส่งข้อมูลไปที่ตาราง run_tb
      await Supabase.instance.client.from('run_tb').insert({
        'runWhere': _runWhereCtrl.text,
        'runPerson': _runPersonCtrl.text,
        'runDistance': int.parse(_runDistanceCtrl.text), // แปลงเป็นตัวเลข
      });

      // 3. เมื่อสำเร็จ ให้กลับหน้าก่อนหน้า
      if (mounted) Navigator.pop(context);
    } catch (e) {
      showMessage('เกิดข้อผิดพลาดในการบันทึก: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Run Tracker (เพิ่ม)'),
        backgroundColor: const Color(0xFF091442),
        foregroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            const SizedBox(height: 40),
            // โลโก้ด้านบน (เปลี่ยนเป็น Image.asset ของคุณ)
            Image.asset('assets/images/running.png', height: 300),
            const SizedBox(height: 40),

            // ช่องกรอก: วิ่งที่ไหน
            _buildInputLabel('วิ่งที่ไหน'),
            _buildTextField(
                _runWhereCtrl, 'เช่น สวนสาธารณะ, สนามกีฬา หรือ อื่นๆ'),

            // ช่องกรอก: วิ่งกับใคร
            _buildInputLabel('วิ่งกับใคร'),
            _buildTextField(_runPersonCtrl, 'เช่น เพื่อน 3 คน, แฟน หรือ อื่นๆ'),

            // ช่องกรอก: ระยะทาง
            _buildInputLabel('ระยะทาง (กม.)'),
            _buildTextField(_runDistanceCtrl, 'เช่น 1, 5, 11 หรือ อื่นๆ',
                isNumber: true),

            const SizedBox(height: 40),

            // ปุ่มบันทึกข้อมูล
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _saveRunData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('บันทึกข้อมูล',
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),

            const SizedBox(height: 15),

            // ปุ่มยกเลิก
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF44336),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('ยกเลิก',
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Widget ช่วยสร้าง Label
  Widget _buildInputLabel(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8, top: 15),
        child: Text(label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    );
  }

  // Widget ช่วยสร้าง TextField
  Widget _buildTextField(TextEditingController ctrl, String hint,
      {bool isNumber = false}) {
    return TextField(
      controller: ctrl,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      ),
    );
  }
}
