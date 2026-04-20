import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/run.dart';

class SupabaseService {
  final _supabase = Supabase.instance.client;

  // 1. ดึงข้อมูลทั้งหมด (Read)
  Future<List<Run>> getRuns() async {
    final response = await _supabase
        .from('runs')
        .select()
        .order('created_at', ascending: false);

    return (response as List).map((data) => Run.fromJson(data)).toList();
  }

  // 2. เพิ่มข้อมูลใหม่ (Create)
  Future<void> insertRun(Run run) async {
    await _supabase.from('runs').insert(run.toJson());
  }

  // 3. แก้ไขข้อมูล (Update)
  Future<void> updateRun(Run run) async {
    await _supabase.from('runs').update(run.toJson()).eq('id', run.id!);
  }

  // 4. ลบข้อมูล (Delete)
  Future<void> deleteRun(int id) async {
    await _supabase.from('runs').delete().eq('id', id);
  }
}
