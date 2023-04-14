import 'package:isar/isar.dart';
import 'package:todo_app/util/utils.dart';

@collection
class Task {
  /// Id for Isar DB
  int? id;

  /// Title of Task
  late String title;

  /// Description of task
  late String description;

  /// words separed list help in searching the task.
  @Index(caseSensitive: false)
  List<String> get titleWords => Isar.splitWords(title);

  /// Creation time of task
  late DateTime creationTime;

  /// Due Time For The Task
  @Index()
  late DateTime dueTime;

  /// Priority of task (High, Medium, Low)
  @Enumerated(EnumType.ordinal)
  late TaskPriority priority;
}
