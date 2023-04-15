import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:todo_app/controllers/controllers.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/util/utils.dart';

class TaskController extends GetxController {
  /// Tasks State
  final List<Task> _tasks = [];

  /// Sorting Order
  final Rx<SortType> _sortType = SortType.creationTime.obs;

  /// Indicator whether there are more tasks or not.
  bool _moreTasks = false;

  /// Task Collection from Isar.
  late final IsarCollection<Task> _tasksCollection;

  /// Boolean indicator of loading state.
  bool _loadingTasks = false;

  /// Isar Database Instance.
  late final Isar _isar;

  /// Indicator whether there are more tasks or not.
  bool get moreTasks => _moreTasks;

  /// Get All the tasks
  List<Task> get tasks => _tasks;

  /// Task Loading State.
  bool get loadingTasks => _loadingTasks;

  /// Sort Type
  SortType get sortType => _sortType.value;

  /// Set the value of _sortType
  set setSortType(value) => _sortType.value = value;

  /* State Management functions */

  /// Set the task loading state.
  /// Or whether to notify UI or not.
  _setLoadingTasks(bool value, {bool notify = false}) {
    _loadingTasks = value;
    if (notify) {
      update();
    }
  }

  /* ******** */

  /* Isar Functions */

  /// Open the Isar Instance.
  Future<void> openIsar() async {
    _isar = await Isar.open([TaskSchema]);
    _tasksCollection = _getTaskCollection();
    "Isar instance open: ${_isar.name}".log();
  }

  /// Get all the tasks.
  /// Use  [skip],[limit] for pagination purpose.
  ///
  /// [notify]: whether to reflect the change in UI
  Future<void> getTasks(
    int skip, {
    int limit = 20,
    bool notify = false,
    bool sortByDueDate = false,
    bool sortByPriority = false,
  }) async {
    _setLoadingTasks(true, notify: notify);
    _moreTasks = false;
    if (skip == 0) {
      _tasks.clear();
    }
    late final List<Task> tasks;
    if (sortByDueDate) {
      "getting the tasks in order of due time".log();
      tasks = await _tasksCollection.where().sortByDueTime().offset(skip).limit(limit).findAll();
    } else if (sortByPriority) {
      "getting the tasks in order of priority".log();
      tasks = await _tasksCollection.where().sortByPriority().offset(skip).limit(limit).findAll();
    } else {
      "getting the tasks in order of creation time".log();
      final xtasks = await _tasksCollection.where().sortByCreationTime().offset(skip).limit(limit).findAll();
      tasks = xtasks.reversed.toList();
    }
    _moreTasks = tasks.length == limit;
    _tasks.addAll(tasks);
    "got all the tasks".log();
    _setLoadingTasks(false, notify: true);
  }

  IsarCollection<Task> _getTaskCollection() => _isar.collection<Task>();

  /// Adding a new Task
  Future<void> addTask({
    required String title,
    required String description,
    required DateTime? dueTime,
    TaskPriority taskPriority = TaskPriority.low,
  }) async {
    "adding the task...".log();
    final task = Task()
      ..creationTime = DateTime.now()
      ..dueTime = dueTime ?? DateTime.now().add(const Duration(hours: 3))
      ..priority = taskPriority
      ..title = title
      ..description = description;

    await _isar.writeTxn(() async => task.id = await _tasksCollection.put(task));
    if (_sortType.value != SortType.creationTime) {
      _tasks.add(task);
      _tasks.sort((t1, t2) {
        if (_sortType.value == SortType.dueTime) {
          return t1.dueTime.compareTo(t1.dueTime);
        }
        return t1.priority.index.compareTo(t2.priority.index);
      });
    } else {
      _tasks.insert(0, task);
    }
    "task inserted...".log();
    update();
  }

  Future<Task?> getTask(int id) async {
    return await _tasksCollection.get(id);
  }

  /// Update the task
  Future<void> updateTask(Task task) async {
    "updaing the task".log();
    await _isar.writeTxn(() async => await _tasksCollection.put(task));
    "updated the task".log();
    if (_sortType.value != SortType.creationTime) {
      _tasks.sort((t1, t2) {
        if (_sortType.value == SortType.dueTime) {
          return t1.dueTime.compareTo(t1.dueTime);
        }
        return t1.priority.index.compareTo(t2.priority.index);
      });
    }
    update();
  }

  /// Set the reminder time of a particular task.
  Future<void> setReminder(DateTime reminderTime, Task task) async {
    // set notification reminder with awesome notifications;
    // also update the task object with reminder time;
    final index = _tasks.indexOf(task);
    _tasks[index].reminderTime = reminderTime;
    await _isar.writeTxn(
      () async => await _tasksCollection.put(_tasks[index]),
    );
    update();
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: NotificationController.reminderNotificationKey,
        title: "Reminder! ${_tasks[index].title}",
        body: _tasks[index].description,
        wakeUpScreen: true,
        payload: {"taskId": _tasks[index].id.toString()},
      ),
      schedule: NotificationCalendar.fromDate(date: reminderTime),
    );
  }

  /// Delete a particular task.
  Future<void> deleteTask(Task task) async {
    "deleting the task: ${task.title}".log();
    await _isar.writeTxn(() async => await _tasksCollection.delete(task.id!));
    "deleted the task".log();
    _tasks.remove(task);
    update();
  }

  /// Search for the tasks by title
  Future<List<Task>> searchTask(String query) async =>
      _tasksCollection.where().titleWordsElementStartsWith(query).limit(10).findAll();

  /* ************ */
}
