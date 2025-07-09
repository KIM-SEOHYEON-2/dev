import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '마지막 학기의 버킷리스트',
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: const Color(0xFFA3CEF1), // 메인 컬러: 파스텔 블루
          secondary: const Color(0xFF9ADBC5), // 포인트 컬러: 민트 그린
          surface: const Color(0xFFFFF6E5), // 서브 컬러: 라이트 베이지
        ),
        textTheme: TextTheme(
          displayLarge: GoogleFonts.notoSans(
            fontWeight: FontWeight.w600,
            fontSize: 24,
            color: Colors.black87,
          ),
          bodyLarge: GoogleFonts.notoSans(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double progressValue = 0.45; // 진행률 예시값

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          '마지막 학기의 버킷리스트',
          style: Theme.of(context).textTheme.displayLarge,
        ),
        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  '나의 버킷리스트 진행률',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 10),
                CircularProgressIndicator(
                  value: progressValue,
                  backgroundColor: Colors.grey.withOpacity(0.2),
                  color: Theme.of(context).colorScheme.primary,
                ),
                Text(
                  '${(progressValue * 100).toInt()}%',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.all(20),
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              children: [
                _buildMenuCard(
                  context,
                  '나의 버킷리스트',
                  Icons.list_alt_rounded,
                  () {},
                ),
               
                _buildMenuCard(
                  context,
                  '목표 추가하기',
                  Icons.add_circle_outline_rounded,
                  () {},
                ),
                _buildMenuCard(
                  context,
                  '달성 현황',
                  Icons.emoji_events_rounded,
                  () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
