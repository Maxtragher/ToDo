import 'package:flutter/material.dart';

class TodoDialog extends StatefulWidget {
  const TodoDialog({
    required this.title,
    required this.buttonName,
    super.key,
    this.todoText,
  });
  final String? todoText;
  final String title;
  final String buttonName;

  @override
  State<TodoDialog> createState() => _TodoDialogState();
}

class _TodoDialogState extends State<TodoDialog> {
  late final TextEditingController _textFieldController;

  @override
  void initState() {
    super.initState();

    _textFieldController = TextEditingController(text: widget.todoText);
  }

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(widget.title),
      content: TextField(
        controller: _textFieldController,
        maxLines: null,
        decoration: InputDecoration(
          hintText: 'Type your todo',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        autofocus: true,
      ),
      actions: <Widget>[
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            //Close alert dialog
            Navigator.of(context).pop();
          },
          child: Text(
            'Cancel',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            //Close alert dialog and send text from textField to
            //the text on _displayDialog() and put it in _addTodoItem()
            Navigator.of(context).pop(_textFieldController.text);
          },
          child: Text(
            widget.buttonName,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onInverseSurface,
            ),
          ),
        ),
      ],
    );
  }
}
