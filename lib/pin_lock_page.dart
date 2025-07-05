import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'note_page.dart';

class PinLockPage extends StatefulWidget {
  final VoidCallback toggleTheme;
  final VoidCallback? logout;

  const PinLockPage({required this.toggleTheme, this.logout});

  @override
  _PinLockPageState createState() => _PinLockPageState();
}

class _PinLockPageState extends State<PinLockPage> {
  final TextEditingController _pinController = TextEditingController();
  final box = GetStorage();

  void _checkPin() {
    final storedPin = box.read('pin') ?? '1234';
    if (_pinController.text == storedPin) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => NotePage(
            toggleTheme: widget.toggleTheme,
            logout: widget.logout ?? () {},
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Wrong PIN! Please Try Again')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login with PIN'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.dark_mode),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock, size: 80, color: Colors.blueAccent),
              SizedBox(height: 20),
              Text('Enter your 4 digit PIN',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              SizedBox(height: 30),
              TextField(
                controller: _pinController,
                obscureText: true,
                keyboardType: TextInputType.number,
                maxLength: 4,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock_outline),
                  labelText: '4-digit PIN',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _checkPin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                ),
                child: Text('Unlock'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
