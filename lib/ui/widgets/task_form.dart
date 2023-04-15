import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/controllers/controllers.dart';
import 'package:todo_app/models/models.dart';
import 'package:todo_app/util/utils.dart';

class TaskForm extends StatefulWidget {
  const TaskForm({super.key, this.task});
  final Task? task;

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _dueDate;
  TaskPriority _selectedPriority = TaskPriority.low;

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate != null ? _dueDate! : DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
    );

    TimeOfDay? time;
    if (picked != null && mounted) {
      time = await showTimePicker(
        context: context,
        cancelText: null,
        initialTime: _dueDate != null ? TimeOfDay.fromDateTime(_dueDate!) : TimeOfDay.now(),
      );
    }

    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = DateTime(
          picked.year,
          picked.month,
          picked.day,
          time!.hour,
          time.minute,
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _dueDate = widget.task?.dueTime;
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
      _selectedPriority = widget.task!.priority;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _titleController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a title';
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: 'Title',
            ),
          ),
          TextFormField(
            controller: _descriptionController,
            maxLines: 5,
            minLines: 2,
            decoration: const InputDecoration(
              labelText: 'Description',
            ),
          ),
          DropdownButtonFormField<TaskPriority>(
            value: _selectedPriority,
            onChanged: (value) {
              setState(() {
                _selectedPriority = value!;
              });
            },
            decoration: const InputDecoration(labelText: "Priority"),
            borderRadius: BorderRadius.circular(10),
            items: TaskPriority.values.map((TaskPriority priority) {
              return DropdownMenuItem<TaskPriority>(
                value: priority,
                child: Text(priority.name.toUpperCase()),
              );
            }).toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Due Date:'),
              TextButton(
                onPressed: () {
                  _selectDueDate(context);
                },
                child: Text(_dueDate == null ? 'Pick a date' : '${_dueDate!.year}-${_dueDate!.month}-${_dueDate!.day}'),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final title = _titleController.text;
                final description = _descriptionController.text;
                final controller = Get.find<TaskController>();
                if (widget.task == null) {
                  controller.addTask(
                    title: title,
                    description: description,
                    dueTime: _dueDate,
                    taskPriority: _selectedPriority,
                  );
                } else {
                  widget.task!.title = _titleController.text;
                  widget.task!.description = _descriptionController.text;
                  widget.task!.dueTime = _dueDate!;
                  widget.task!.priority = _selectedPriority;
                  controller.updateTask(widget.task!);
                }
                Get.back();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
