import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'change_pin_page.dart';

class NotePage extends StatefulWidget {
  final VoidCallback toggleTheme;
  final VoidCallback logout;

  const NotePage({required this.toggleTheme, required this.logout});

  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  final TextEditingController _noteController = TextEditingController();
  final box = GetStorage();
  DateTime _selectedDay = DateTime.now();
  Map<String, List<Map<String, String>>> allNotes = {};

  @override
  void initState() {
    super.initState();
    allNotes = Map<String, List<Map<String, String>>>.from(
      box.read('notes') ?? {},
    );
  }

  void _saveNote() {
    final noteText = _noteController.text.trim();
    if (noteText.isEmpty) return;

    final dateKey = DateFormat('yyyy-MM-dd').format(_selectedDay);
    final newNote = {
      'text': noteText,
      'time': DateFormat('HH:mm').format(DateTime.now()),
    };

    if (allNotes.containsKey(dateKey)) {
      allNotes[dateKey]!.add(newNote);
    } else {
      allNotes[dateKey] = [newNote];
    }

    box.write('notes', allNotes);
    _noteController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final dateKey = DateFormat('yyyy-MM-dd').format(_selectedDay);
    final todayNotes = allNotes[dateKey] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('My Notes'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.dark_mode),
            onPressed: widget.toggleTheme,
          ),
          IconButton(
            icon: Icon(Icons.lock),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChangePinPage()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: widget.logout,
          ),
        ],
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _selectedDay,
            selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
            onDaySelected: (selected, focused) {
              setState(() {
                _selectedDay = selected;
              });
            },
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _noteController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Write your notes...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: _saveNote,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
            ),
            child: Text('Save note'),
          ),
          Divider(height: 20),
          Expanded(
            child: todayNotes.isEmpty
                ? Center(child: Text('No notes for today'))
                : ListView.builder(
                    itemCount: todayNotes.length,
                    itemBuilder: (context, index) {
                      final note = todayNotes[index];
                      return Dismissible(
                        key: UniqueKey(),
                        background: Container(
                          color: Colors.redAccent,
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 20),
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (direction) {
                          setState(() {
                            todayNotes.removeAt(index);
                            allNotes[dateKey] = todayNotes;
                            box.write('notes', allNotes);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Note deleted')),
                          );
                        },
                        child: ListTile(
                          title: Text(note['text'] ?? ''),
                          subtitle: Text('Written at ${note['time']}'),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
