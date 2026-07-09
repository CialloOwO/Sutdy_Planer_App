# Front-end Report Notes

## Front-end Scope
The front-end member is responsible for the user interface, screen layout, navigation flow, visual consistency, search/filter interface, task detail page, map page layout, multimedia page layout, screenshots, and screen recording flow.

## Screenshots To Capture
- Splash Screen
- Login Screen
- Register Screen
- Home / Dashboard Screen
- Study Tasks Screen
- Task Detail Screen
- Add / Edit Task Screen
- Search / Filter Screen
- Study Locations / Map Screen
- Focus Music / Multimedia Screen
- Profile Screen
- Settings Screen
- Help & FAQ Screen
- About Screen

## Navigation Flow For Recording
1. Open the app and show the Splash Screen.
2. Log in or create a new account.
3. Show the Home Dashboard and task statistics.
4. Add a new study task.
5. Open the task list and select a task.
6. Show the Task Detail Screen and edit the task.
7. Use Search / Filter to find a task.
8. Open the Study Locations page.
9. Open the Focus Music page and press Play / Pause / Stop.
10. Show Profile, Settings, Help, and About pages.

## Widget Hierarchy Explanation
The app starts from `StudyPlannerApp` in `main.dart`, which defines the global theme and route table. After login, `MainNavigationScreen` provides the main tab navigation using `NavigationBar`. Each main feature screen uses a `Scaffold` with an `AppBar`, scrollable body content, and reusable Material widgets such as `Card`, `ListTile`, `TextField`, `ChoiceChip`, and buttons.

## Front-end State Management
The front-end uses `StatefulWidget` and `setState` for local UI updates. Examples include dashboard refresh in `HomeScreen`, task loading in `TaskListScreen`, search filters in `SearchScreen`, splash navigation in `SplashScreen`, and playback preview state in `MediaScreen`.

## Back-end Member Handoff
- Replace the map placeholder in `MapScreen` with `flutter_map`, OpenStreetMap tiles, fixed location coordinates, and markers.
- Replace the playback preview in `MediaScreen` with `audioplayers` or `video_player`.
- Confirm SQLite task CRUD remains stable after task detail navigation.
- Optionally add a `DBHelper.searchTasks()` method if database-level search is preferred.
- Provide report explanations for SQLite, data models, CRUD methods, map plugin code, and multimedia plugin code.
