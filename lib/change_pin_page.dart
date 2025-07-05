import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class ChangePinPage extends StatefulWidget {
  @override
  _ChangePinPageState createState() => _ChangePinPageState();
}

class _ChangePinPageState extends State<ChangePinPage> {
  final TextEditingController _newPinController = TextEditingController();
  final box = GetStorage();

  void _saveNewPin() {
    final newPin = _newPinController.text;
    if (newPin.length == 4) {
      box.write('pin', newPin);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Success! Your PIN has been changed successfully')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PIN must be 4 digits')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Change PIN'), backgroundColor: Colors.blueAccent),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: _newPinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 4,
              decoration: InputDecoration(
                labelText: 'New PIN (4 digit)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveNewPin,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
              child: Text('Save New PIN'),
            ),
          ],
        ),
      ),
    );
  }
}
