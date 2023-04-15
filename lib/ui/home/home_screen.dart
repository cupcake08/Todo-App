import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/controllers/controllers.dart';
import 'package:todo_app/ui/delagates/task_search_delegate.dart';
import 'package:todo_app/ui/widgets/widget.dart';
import 'package:todo_app/util/utils.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final ScrollController _scrollController;
  late final double _previousMaxScrollExtent;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _previousMaxScrollExtent = 0.0;
    final taskController = Get.find<TaskController>();
    taskController.openIsar().then((_) => taskController.getTasks(0));
    _scrollController.addListener(() => _pagination());
  }

  _pagination() {
    final controller = Get.find<TaskController>();
    final double maxScrollExtent = _scrollController.position.maxScrollExtent;
    final double distanceFromLast = (maxScrollExtent / controller.tasks.length);
    if (!controller.loadingTasks &&
        _scrollController.position.pixels > maxScrollExtent - distanceFromLast &&
        maxScrollExtent >= _previousMaxScrollExtent) {
      _previousMaxScrollExtent = maxScrollExtent;
      int skip = controller.tasks.length;
      if (controller.moreTasks) {
        switch (controller.sortType) {
          case SortType.creationTime:
            controller.getTasks(skip);
            break;
          case SortType.dueTime:
            controller.getTasks(skip, sortByDueDate: true);
            break;
          case SortType.priority:
            controller.getTasks(skip, sortByPriority: true);
            break;
        }
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(() => _pagination());
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("TODO's"),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: TaskSearchDelegate(),
              );
            },
            icon: const Icon(Icons.search_rounded),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            const HomeScreenHeaderWidget(),
            Expanded(
              child: GetBuilder<TaskController>(
                builder: (controller) {
                  if (controller.loadingTasks) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (controller.tasks.isEmpty) {
                    return Center(
                      child: Text(
                        "No Tasks For Now",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: controller.tasks.length,
                    itemBuilder: (context, index) => TaskItem(task: controller.tasks[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.dialog(
            AlertDialog(
              titlePadding: const EdgeInsets.only(top: 0),
              title: AppBar(
                shadowColor: Colors.transparent,
                backgroundColor: Colors.transparent,
                title: Text(
                  "Create Task",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                leading: IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(
                    Icons.close,
                    color: Colors.black,
                  ),
                ),
              ),
              content: const TaskForm(),
            ),
            name: "Add Task Dialogue",
            barrierDismissible: false,
            barrierColor: Colors.teal.shade100.withOpacity(.3),
          );
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.grey[600],
            ),
            children: const <TextSpan>[
              TextSpan(text: 'Made with '),
              TextSpan(text: "💙"),
              TextSpan(text: ' by Ankit Bhankharia'),
            ],
          ),
        ),
      ),
    );
  }
}
