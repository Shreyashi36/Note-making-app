import 'package:flutter/material.dart';
import 'package:notes_app/model/notes_model.dart';
import 'package:notes_app/services/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class AddEditNoteScreen extends StatefulWidget {
  final Note? note;
  const AddEditNoteScreen({this.note});

  @override
  State<AddEditNoteScreen> createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends State<AddEditNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Color _selectedColor = Colors.amber;
  final List<Color> _colors = [
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
    if(widget.note != null){
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
      _selectedColor = Color(int.parse(widget.note!.color));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(widget.note == null ? 'Add Note' : "Edit Note"),
      ),
      body: Form(
        key: _formKey,
        child: Column(children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  )
                ),
                validator: (value) {
                  if(value == null || value.isEmpty){
                    return "Please enter a title";  
                  }
                  return null;
                },
              ),
              SizedBox(height: 16,),
              TextFormField(
                controller: _contentController,
                decoration: InputDecoration(
                  hintText: 'Content',
                   border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  )
                ),

                maxLines: 10,
                validator: (value) {
                  if(value == null || value.isEmpty){
                    return 'Please enter a content';
                  }
                  return null;
                },
              ),
              Padding(padding: EdgeInsets.all(16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _colors.map((color) {
                    return GestureDetector(
                      onTap: () =>
                        setState(() => _selectedColor = color),
                      child: Container(
                        width: 40,
                        height: 40,
                        margin: EdgeInsets.only(right:8),
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _selectedColor == color 
                            ? Colors.white 
                            : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      ),
                    );
                  }).toList(),
                ),
              )
            ),
            InkWell(
              onTap: () async {
              bool saved = await _saveNote();  // ✅ Wait for the save operation
              if (saved) {
                Navigator.pop(context, true);  // ✅ Notify HomeScreen that a note was added/updated
              }
            },
              child: Container(
                margin: EdgeInsets.only(top: 16),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFF50C878),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text("Save Note",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

              ),
            )

            ],
          )
          )
        ],)
      ),
    );
  }
 Future<bool> _saveNote() async {
  if (_formKey.currentState!.validate()) {
    final note = Note(
      id: widget.note?.id,  
      title: _titleController.text,
      content: _contentController.text,
      dateTime: DateTime.now().toIso8601String(),
      color: _selectedColor.value.toString(),
    );

    if (widget.note == null) {
      await _databaseHelper.insertNote(note);
    } else {
      await _databaseHelper.updateNote(note);
    }

    return true;  
  }
  return false;  
}


}