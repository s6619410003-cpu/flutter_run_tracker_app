import 'package:flutter/material.dart';
import 'package:flutter_run_tracker_app/view/show_all_run_ui.dart'; // อย่าลืม import ไฟล์หน้าโชว์ออลของคุณ

class SplashScreenUi extends StatefulWidget {
  const SplashScreenUi({super.key});

  @override
  State<SplashScreenUi> createState() => _SplashScreenUiState();
}

class _SplashScreenUiState extends State<SplashScreenUi> {
  @override
  void initState() {
    super.initState();

    // สั่งให้รอ 3 วินาทีแล้วค่อยเปลี่ยนหน้า
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        // ใช้ pushReplacement เพื่อไม่ให้ผู้ใช้กด back กลับมาหน้า Splash ได้อีก
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ShowAllRunUi()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF091442),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // โลโก้คนวิ่ง
                Image.asset('assets/images/running.png', width: 300),
                const SizedBox(height: 24),

                const Text(
                  'RUN TRACKER',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 30),

                // ตัว Loading
                const SizedBox(
                  width: 30,
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
                    minHeight: 3,
                  ),
                ),
              ],
            ),
          ),

          // ข้อความเครดิตด้านล่าง
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '© 2026 RUN TRACKER',
                    style: TextStyle(
                      // ignore: deprecated_member_use
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Created by Professor X SAU TEAM',
                    style: TextStyle(
                      // ignore: deprecated_member_use
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
