# Indian Language Learning App

A gamified, interactive Flutter app for learning Indian languages (Hindi & Telugu) with a focus on reading, writing, listening, and speaking.

## MVP Features

- **Language Courses**: Beginner-level Hindi and Telugu with 4 modules each
- **Gamification**: XP/points, daily streaks, levels, and badges
- **Exercises**: Multiple-choice, fill-in-the-blank, listening, and speaking
- **Progress Tracking**: Dashboard with XP, level, streak, and weak areas
- **Social Features**: Global leaderboard and friend challenges
- **Cultural Context**: Festival and tradition examples throughout lessons
- **Audio**: TTS vocabulary + native speaker sentences
- **Offline**: Download content for offline learning

## Tech Stack

- **Frontend**: Flutter 3.x+ with Provider state management
- **Backend**: Supabase (PostgreSQL)
- **Auth**: Email/password + Google OAuth
- **Local Storage**: SQLite and Hive
- **Audio**: just_audio (playback) and record (recording)

## Project Setup

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run

# Build for iOS
flutter build ios

# Build for Android
flutter build apk
```

## Configuration

Update Supabase credentials in `lib/main.dart`:
```dart
await Supabase.initialize(
  url: 'your-supabase-url',
  anonKey: 'your-anon-key',
);
```

## Architecture

- **Providers**: State management (auth, user, courses, progress)
- **Services**: Auth and database operations via Supabase
- **Models**: Data structures for users, courses, exercises, progress
- **Screens**: UI components for all app features
- **Data**: Hardcoded Hindi and Telugu course content

## MVP Success Criteria

✓ User authentication (email + Google OAuth)
✓ Browse Hindi and Telugu courses by modules
✓ Complete lessons with vocabulary, grammar, examples
✓ Take 4 exercise types with immediate feedback
✓ Earn XP and level up
✓ Track daily learning streaks
✓ Collect badges for achievements
✓ View progress statistics
✓ Global and friends leaderboards
✓ Support for iOS and Android
✓ Offline functionality

## Future Enhancements

- More Indian languages (Tamil, Kannada, Marathi, Bengali)
- Spaced repetition algorithms
- Advanced grammar and idioms
- Story-based learning scenarios
- AI-powered pronunciation feedback
- Admin content management system
- Advanced analytics