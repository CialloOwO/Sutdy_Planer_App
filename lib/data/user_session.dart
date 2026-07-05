class UserSession {
  static String displayName = 'Student User';
  static String email = '';
  static String programme = 'Software Engineering';
  static String year = 'Year 3';

  static bool get isLoggedIn => email.isNotEmpty;

  static void setUser({
    required String name,
    required String userEmail,
    String userProgramme = 'Software Engineering',
    String userYear = 'Year 3',
  }) {
    displayName = name.trim().isNotEmpty ? name.trim() : 'Student User';
    email = userEmail.trim();
    programme = userProgramme;
    year = userYear;
  }

  static void clear() {
    displayName = 'Student User';
    email = '';
    programme = 'Software Engineering';
    year = 'Year 3';
  }

  static String get firstName {
    return displayName.split(' ').first;
  }

  static String get timeBasedGreeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  static String get formattedToday {
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    final now = DateTime.now();
    return '${weekdays[now.weekday - 1]}, ${now.day} ${months[now.month - 1]} ${now.year}';
  }
}
