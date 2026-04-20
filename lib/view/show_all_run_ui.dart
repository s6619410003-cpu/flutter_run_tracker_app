import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'add_run_ui.dart';
import 'update_delete_run_ui.dart';

class ShowAllRunUi extends StatefulWidget {
  const ShowAllRunUi({super.key});

  @override
  State<ShowAllRunUi> createState() => _ShowAllRunUiState();
}

class _ShowAllRunUiState extends State<ShowAllRunUi> {
  // ฟังก์ชันดึงข้อมูลจาก Supabase
  Future<List<Map<String, dynamic>>> _getRunData() async {
    try {
      final response = await Supabase.instance.client
          .from('run_tb')
          .select()
          .order('id', ascending: false);
      return response as List<Map<String, dynamic>>;
    } catch (e) {
      throw Exception('ไม่สามารถดึงข้อมูลได้: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Run Tracker'),
        backgroundColor: const Color(0xFF091442),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/images/werunning.png',
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 180,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image, size: 50),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _getRunData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                      child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'));
                }

                final data = snapshot.data ?? [];
                if (data.isEmpty) {
                  return const Center(child: Text('ยังไม่มีข้อมูลการวิ่ง'));
                }

                return ListView.builder(
                  itemCount: data.length,
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 100),
                  itemBuilder: (context, index) {
                    final runItem = data[index];
                    bool isEven = index % 2 == 0;
                    return _buildRunItem(isEven, runItem);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // ย้ายไปหน้าเพิ่มข้อมูล
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddRunUi()),
          ).then((value) => setState(() {}));
        },
        backgroundColor: const Color(0xFF091442),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }

  Widget _buildRunItem(bool isLightGreen, Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: isLightGreen ? const Color(0xFFE8F5E9) : const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Colors.white,
          child: const Icon(Icons.directions_run, color: Color(0xFF091442)),
        ),
        title: Text(
          'วิ่งที่ไหน: ${item['runWhere'] ?? 'ไม่ระบุ'}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        subtitle: Text(
          'วิ่งไปเท่าไหร่: ${item['runDistance'] ?? '0'} กม.',
          style: TextStyle(color: Colors.grey[700], fontSize: 13),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.info, color: Colors.redAccent, size: 20),
          onPressed: () {
            // ย้ายไปหน้าแก้ไข/ลบ โดยส่งตัวแปร runItem ไปด้วย
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UpdateDeleteRunUi(runItem: item),
              ),
            ).then((value) => setState(() {}));
          },
        ),
      ),
    );
  }
}
