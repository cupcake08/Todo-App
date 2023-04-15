import 'package:isar/isar.dart';
import 'package:todo_app/util/utils.dart';

part 'task.g.dart';

@collection
class Task {
  /// Id for Isar DB
  Id? id;

  /// Title of Task
  late String title;

  /// Description of task
  late String description;

  /// words separed list help in searching the task.
  @Index(type: IndexType.value, caseSensitive: false)
  List<String> get titleWords => Isar.splitWords(title);

  /// Creation time of task
  @Index()
  late DateTime creationTime;

  /// Reminder DateTime
  DateTime? reminderTime;

  /// Due Time For The Task
  @Index()
  late DateTime dueTime;

  /// Priority of task (High, Medium, Low)
  @Enumerated(EnumType.ordinal)
  @Index()
  late TaskPriority priority;
}
