import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/controllers/controllers.dart';
import 'package:todo_app/util/utils.dart';

class HomeScreenHeaderWidget extends StatefulWidget {
  const HomeScreenHeaderWidget({super.key});

  @override
  State<HomeScreenHeaderWidget> createState() => _HomeScreenHeaderWidgetState();
}

class _HomeScreenHeaderWidgetState extends State<HomeScreenHeaderWidget> {
  late final List<DropdownMenuItem<SortType>> _sortingList;

  @override
  void initState() {
    super.initState();
    _sortingList = List.generate(SortType.values.length, (index) {
      final type = SortType.values[index];
      return DropdownMenuItem(
        value: type,
        child: Text(_getString(type)),
      );
    });
  }

  _getString(SortType type) {
    switch (type) {
      case SortType.creationTime:
        return "Creation Date";
      case SortType.dueTime:
        return "Due Date";
      case SortType.priority:
        return "Priority";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(
              "Sort By :",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Obx(
                () => DropdownButton<SortType>(
                  value: Get.find<TaskController>().sortType,
                  items: _sortingList,
                  borderRadius: BorderRadius.circular(10),
                  style: Theme.of(context).textTheme.labelLarge,
                  underline: const SizedBox.shrink(),
                  onChanged: (value) {
                    final controller = Get.find<TaskController>();
                    if (value == controller.sortType) {
                      return;
                    }
                    switch (value!) {
                      case SortType.creationTime:
                        controller.getTasks(0);
                        break;
                      case SortType.dueTime:
                        controller.getTasks(0, sortByDueDate: true);
                        break;
                      case SortType.priority:
                        controller.getTasks(0, sortByPriority: true);
                        break;
                    }
                    controller.setSortType = value;
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
