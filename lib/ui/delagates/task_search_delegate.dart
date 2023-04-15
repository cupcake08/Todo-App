import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/controllers/controllers.dart';
import 'package:todo_app/models/models.dart';
import 'package:todo_app/ui/widgets/widget.dart';
import 'package:todo_app/util/utils.dart';

class TaskSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          onPressed: () => query = '',
          icon: const Icon(Icons.close),
        ),
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        onPressed: () => close(context, null),
        icon: const Icon(Icons.arrow_back_ios),
      );

  @override
  Widget buildResults(BuildContext context) => _buildTaskList();

  @override
  Widget buildSuggestions(BuildContext context) => _buildTaskList();

  _buildTaskList() {
    final controller = Get.find<TaskController>();
    if (query.isEmpty) return _helperList(controller.tasks);
    return FutureBuilder<List<Task>>(
      future: Get.find<TaskController>().searchTask(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final data = snapshot.data;
        return data!.isEmpty
            ? Center(
                child: Text(
                  "No matching results found!",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              )
            : _helperList(data);
      },
    );
  }

  _helperList(List<Task> data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        final task = data[index];
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          child: ListTile(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            minVerticalPadding: 10,
            onTap: () {
              close(context, null);
              Get.dialog(AlertDialog(
                content: TaskDetail(task: task),
              ));
            },
            trailing: Common.getPriorityWidget(task),
            title: Text(task.title),
            subtitle: Text(
              task.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      },
    );
  }
}
