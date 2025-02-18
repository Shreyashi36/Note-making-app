import 'package:flutter/material.dart';
import 'package:notes_app/model/notes_model.dart';
import 'package:notes_app/screens/add_edit_screen.dart';
import 'package:notes_app/services/database_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Note> _notes = [];

  final List<Color> _noteColors = [
    Colors.amber,
    Color(0xFF50C878),
    Colors.redAccent,
    Colors.blueAccent,
    Colors.purpleAccent,
    Colors.indigo,
    Colors.purpleAccent,
    Colors.pinkAccent,
  ];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final notes = await _databaseHelper.getNotes();
    setState(() {
      _notes = notes;
    });
  }

  /// **Fix: Move `_formatDateTime` outside `_loadNotes()`**
  String _formatDateTime(String dateTime) {
    final DateTime dt = DateTime.parse(dateTime);
    final now = DateTime.now();

    if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
      return 'Today, ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    }

    return '${dt.day}/${dt.month}/${dt.year}, ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text("My Notes"),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: _notes.length,
        itemBuilder: (context, index) {
          final note = _notes[index];
          final color = Color(int.parse(note.color));

          return GestureDetector(
            onTap: () async {
              _loadNotes();
            },
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    note.content,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Text(
                    _formatDateTime(note.dateTime),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddEditNoteScreen()),
        );
  
  // Reload notes after returning from AddEditNoteScreen
        if (result == true) {
           print("Refreshing notes..."); 
          _loadNotes();
        }
},
        child: const Icon(Icons.add),
        backgroundColor: const Color(0xFF50C878),
        foregroundColor: Colors.white,
      ),
    );
  }
}
