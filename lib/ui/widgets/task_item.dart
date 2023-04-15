import 'package:flutter/material.dart';
import 'package:todo_app/models/models.dart';
import 'package:todo_app/ui/widgets/widget.dart';
import 'package:todo_app/util/utils.dart';

class TaskItem extends StatelessWidget {
  const TaskItem({super.key, required this.task});
  final Task task;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(),
      ),
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ExpansionTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text(
          task.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.teal),
        ),
        trailing: Common.getPriorityWidget(task),
        childrenPadding: const EdgeInsets.symmetric(horizontal: 10),
        children: [
          ExpandedTaskWidget(task: task),
        ],
      ),
    );
  }
}
