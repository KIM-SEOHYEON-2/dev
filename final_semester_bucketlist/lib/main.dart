import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/bucket_list_provider.dart';
import 'services/storage_service.dart';
import 'screens/edit_bucket_list_screen.dart';
import 'widgets/bucket_list_item_widget.dart';
import 'widgets/celebration_overlay.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final prefs = await SharedPreferences.getInstance();
  
  runApp(
    ChangeNotifierProvider(
      create: (_) => BucketListProvider(StorageService(prefs)),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Bucketlist',
      locale: const Locale('ko', 'KR'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', 'KR'),
        Locale('en', 'US'), // 폴백(fallback) 로케일
      ],
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.light(
          background: Colors.white,
          surface: Colors.white,
          primary: Color(0xFF4A90E2),    // 메인 컬러: 모던한 블루
          secondary: Color(0xFF9B51E0),   // 서브 컬러: 세련된 퍼플
          onPrimary: Colors.white,
          onSecondary: Colors.white,
        ),
        textTheme: TextTheme(
          displayLarge: GoogleFonts.notoSans(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          titleLarge: GoogleFonts.notoSans(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          bodyLarge: GoogleFonts.notoSans(
            fontSize: 16,
            color: Colors.black54,
          ),
          bodyMedium: GoogleFonts.notoSans(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: GoogleFonts.notoSans(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          iconTheme: IconThemeData(color: Colors.black87),
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF4A90E2),
          foregroundColor: Colors.white,
          elevation: 4,
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _showCelebration(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CelebrationOverlay(
        onAnimationComplete: () => Navigator.of(context).pop(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('My Bucketlist'),
        backgroundColor: Colors.white,
      ),
      body: Consumer<BucketListProvider>(
        builder: (context, provider, child) {
          if (provider.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.list_alt,
                    size: 64,
                    color: Colors.grey[300],
                  ),
                  SizedBox(height: 16),
                  Text(
                    '버킷리스트를 추가해보세요!',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            );
          }
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                color: Colors.white,
                child: Column(
                  children: [
                    Text(
                      '달성률',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: 100,
                          width: 100,
                          child: CircularProgressIndicator(
                            value: provider.progress,
                            backgroundColor: Colors.grey[200],
                            strokeWidth: 8,
                          ),
                        ),
                        Text(
                          '${(provider.progress * 100).toInt()}%',
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ReorderableListView.builder(
                  padding: EdgeInsets.only(top: 8),
                  itemCount: provider.items.length,
                  onReorder: provider.reorderItem,
                  itemBuilder: (context, index) {
                    final item = provider.items[index];
                    return BucketListItemWidget(
                      key: ValueKey(item.id),
                      item: item,
                      onToggle: () {
                        final wasCompleted = item.isCompleted;
                        provider.toggleComplete(item.id);
                        if (!wasCompleted) {
                          _showCelebration(context);
                        }
                      },
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditBucketListScreen(item: item),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EditBucketListScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
