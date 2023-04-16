## Brief Description of how the app is made.

- More Details about Database, Notification, and State Management are below this.
```
Firstly, I decided to use Flutter as the framework for developing this app because of its cross-platform nature and ability to create beautiful UI. I also chose Isar database for data storage because of its simplicity and fast performance.

The app has basic CRUD (Create, Read, Update, Delete) functionality to manage tasks. Users can add, edit and delete tasks as well as mark them as complete. The tasks are sorted by their priority levels (high, medium, low) and users can search for specific tasks using a search delegate.

To enhance the user experience, I added a date-time picker for setting task due dates and used Awesome Notifications to create reminders for upcoming tasks. To handle state management, I utilized the GetX package which provides an easy-to-use and lightweight state management solution.

For the UI design, I kept it simple and clean with a minimalist approach. The app consists of a bottom navigation bar for easy navigation between screens and a floating action button for adding new tasks. I also added loader widgets to show progress while fetching data from the database or performing other async operations.

Overall, I wanted to create a simple and functional app with a clean design that would help users manage their daily tasks more efficiently.
```

## Database Work

In this Todo app, I used Isar database to store all the tasks created by the user. I created a Task model which has fields like id, title, description, creationDate, dueDate, priority, and reminder.

I created indexes on **CreationDate**, **DueDate**, and **Priority** fields using the **`@Index()`** decorator in the Task model. This helps in sorting the tasks by these fields for displaying them in the task list and the sorting widget.

For example, when the user selects "Sort by Priority" in the sorting widget, Isar uses the priority index to retrieve all tasks sorted by priority, and then the UI updates with the new order.

To help with searching tasks, I used **Isar.splitwords()** method to split the title field of each Task object into individual words, and stored them in a separate field called **titleWords**. I then created an index on this field as well.

When the user types in the search bar, the app uses **Isar.where().filter().startsWith()** method to query the database for tasks where searchWords starts with the search query. This allows for fast and efficient searching of tasks.

Overall, using Isar database with indexes and almost allheavy lifting done by Isar Generator helped in optimizing the performance of the app, making it faster and more responsive for the user.

## Reminder Notification

I used **awesome_notifications** plugin as it provides the scheduling a notification feature, which i can use when user set the reminder time for a specific task and then the user get a reminder notification on that time.

After tapping the notification the app opens and show the task details on screen.

## State Management

I used **GetX** for state management in the Todo app as it provides a simple and efficient way of managing state in Flutter applications. With GetX, I was able to easily manage the state of the application and update the UI based on changes to the state.

In the app, I used GetX to manage the state of the tasks, such as creating, editing, and deleting tasks. I also used GetX for managing the search results and for showing the loader while fetching data from the database.

GetX also allowed me to separate the business logic from the UI code, making the code more organized and easier to maintain. By using GetX for state management, I was able to reduce the amount of boilerplate code required for state management and focus on building the core functionality of the app.
