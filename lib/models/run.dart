class Run {
  int? id;
  String? runWhere;
  String? runPerson;
  String? runDistance;

  Run({
    this.id,
    this.runWhere,
    this.runPerson,
    this.runDistance,
  });

  // ฟังก์ชันสำหรับแปลงข้อมูลจาก Map (ที่ได้จาก Supabase) มาเป็น Object ในแอป
  factory Run.fromJson(Map<String, dynamic> json) {
    return Run(
      id: json['id'],
      runWhere: json['runWhere'],
      runPerson: json['runPerson'],
      runDistance: json['runDistance'],
    );
  }

  // ฟังก์ชันสำหรับแปลงจาก Object ในแอป ไปเป็น Map (เพื่อส่งไปเก็บใน Supabase)
  Map<String, dynamic> toJson() {
    return {
      'runWhere': runWhere,
      'runPerson': runPerson,
      'runDistance': runDistance,
    };
  }
}
