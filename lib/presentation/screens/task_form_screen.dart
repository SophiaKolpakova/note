import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';

import '../../domain/entities/task.dart';
import '../../domain/usecases/create_task.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? task;

  const TaskFormScreen({super.key, this.task});

  @override
  TaskFormScreenState createState() => TaskFormScreenState();
}

class TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  String? _imageBase64;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _nameController.text = widget.task!.name;
      _descriptionController.text = widget.task!.description ?? '';
      _selectedDate = widget.task!.finishDate;
      _imageBase64 = widget.task!.file;
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await File(pickedFile.path).readAsBytes();
      setState(() {
        _imageBase64 = base64Encode(bytes);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.task == null ? 'Нове завдання' : 'Редагувати завдання'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Назва'),
                validator: (value) => value!.isEmpty ? 'Введіть назву' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Опис'),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: _pickImage,
                child: const Text('Додати зображення'),
              ),
              if (_imageBase64 != null)
                Image.memory(base64Decode(_imageBase64!),
                    height: 150, width: 150),
              TextButton(
                onPressed: () async {
                  final selected = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (selected != null) {
                    setState(() => _selectedDate = selected);
                  }
                },
                child: Text(
                  _selectedDate == null
                      ? 'Виберіть дату'
                      : 'Дата: ${_selectedDate!.toLocal()}'.split(' ')[0],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newTask = Task(
                      taskId: DateTime.now().toString(),
                      status: 1,
                      name: _nameController.text,
                      type: 1,
                      description: _descriptionController.text,
                      finishDate: _selectedDate,
                      urgent: 0,
                      file: _imageBase64,
                    );
                    context.read<CreateTask>().call(newTask);
                    Navigator.pop(context);
                  }
                },
                child: Text(widget.task == null ? 'Створити' : 'Зберегти'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
