# CineVerse

**CineVerse** is a Flutter movie-discovery app (package name: `movie_app`) built with **Clean Architecture**, **BLoC**, and integrations for **The Movie Database (TMDB)**, **Firebase Auth**, **Cloud Firestore**, and local caching via **Hive**.

Display name on devices: **CineVerse**. The repository uses the standard Flutter package layout under `lib/`.

## Features

- Splash screen with full-screen artwork, then navigation to the home experience
- Popular movies with pull-to-refresh and infinite scroll
- Movie details, similar titles, and trailer links where available
- Search (via `SearchDelegate`)
- Favorites backed by Firestore and local persistence
- Firebase email/password authentication (register / login / logout)
- Dark UI theme aligned with the CineVerse brand

## Architecture

| Layer        | Role |
|-------------|------|
| **Domain**  | Entities, repository contracts, use cases |
| **Data**    | Remote (Dio + TMDB), local (Hive), repository implementations |
| **Presentation** | Screens, widgets, BLoCs |

Dependency injection is centralized in `lib/injection_container.dart`.

## Prerequisites

- [Flutter](https://docs.flutter.dev/get-started/install) (SDK constraint in `pubspec.yaml`, currently `^3.11.5`)
- A [TMDB](https://www.themoviedb.org/) API v3 key
- A [Firebase](https://firebase.google.com/) project with **Authentication** (email/password) and **Cloud Firestore** enabled, and platform apps configured (Android / iOS / Web as needed)

## Configuration

### TMDB API key (required)

The app does **not** ship with a TMDB key in source. Pass it at compile time:

```bash
flutter run --dart-define=TMDB_API_KEY=YOUR_TMDB_KEY
```

For release builds:

```bash
flutter build apk --dart-define=TMDB_API_KEY=YOUR_TMDB_KEY
```

See also `.env.example` for a short reminder (this project uses `--dart-define`, not runtime `.env` loading by default).

### Firebase

1. Create a Firebase project and register your app(s).
2. Place `google-services.json` under `android/app/` (Android).
3. Configure iOS as per Firebase docs (`GoogleService-Info.plist` in `ios/Runner/`).
4. Regenerate `lib/firebase_options.dart` with the FlutterFire CLI if you change projects:

   ```bash
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```

Do **not** commit private signing keys or `key.properties` with secrets. Those paths are listed in `.gitignore`.

### App launcher icons

Icons are generated from `assets/icons/app_icon.png` using [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons). After changing the source image:

```bash
dart run flutter_launcher_icons
```

## Getting started

```bash
git clone https://github.com/MahmoudAbogamihe/movie_app.git
cd movie_app
flutter pub get
flutter run --dart-define=TMDB_API_KEY=YOUR_TMDB_KEY
```

### Code generation (Hive adapters)

If you add Hive type adapters with codegen:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Project layout (high level)

```
lib/
  core/           # Theme, constants, network, shared widgets
  features/
    authentication/
    movies/
  firebase_options.dart
  injection_container.dart
  main.dart
assets/
  icons/          # Launcher icon source
  splash/         # In-app splash image
```

## Scripts and quality

```bash
flutter analyze
flutter test
```

## Security notes for public GitHub repos

- Never commit TMDB keys or Firebase server secrets in plain text.
- `ApiConstants.apiKey` is supplied only via `String.fromEnvironment('TMDB_API_KEY')`.
- Restrict Firebase API keys in the Google Cloud console where possible.

## License

This project is licensed under the MIT License — see [LICENSE](LICENSE).
