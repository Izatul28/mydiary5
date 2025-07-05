import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'login_page.dart';
import 'pin_lock_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  final box = GetStorage();
  final hasPin = box.hasData('pin');

  runApp(MyApp(showPinLock: hasPin));
}

class MyApp extends StatefulWidget {
  final bool showPinLock;

  const MyApp({required this.showPinLock});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final box = GetStorage();
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    isDarkMode = box.read('darkMode') ?? false;
  }

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
      box.write('darkMode', isDarkMode);
    });
  }

  void logout() {
    box.erase(); 
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Diary',
      debugShowCheckedModeBanner: false,
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light().copyWith(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.lightBlue[50],
      ),
      home: widget.showPinLock
          ? PinLockPage(toggleTheme: toggleTheme, logout: logout)
          : LoginPage(),
    );
  }
}
