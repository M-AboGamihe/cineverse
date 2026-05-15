# 🎬 CineVerse — Movie Discovery App

<p align="center">
  <img src="assets/icons/app_icon.png" width="120" />
</p>

<p align="center">
  <b>CineVerse</b> — A modern movie discovery app built with Flutter using Clean Architecture, BLoC, Firebase, and TMDB API.
</p>

---

## 🚀 Features

- 🎬 Browse trending & popular movies (TMDB API)
- 🔍 Search movies instantly
- ❤️ Add/remove favorites
- 👤 Firebase Authentication (Login/Register)
- ☁️ Cloud Firestore integration
- 🧠 Clean Architecture (scalable & maintainable)
- ⚡ BLoC state management
- 📦 Local caching with Hive
- 🖼️ Cached Network Images for performance
- 📱 Responsive UI for Android & iOS

---

## 🎬 Demo

### ▶️ Video Demo

<video width="100%" controls>
  <source src="https://raw.githubusercontent.com/M-AboGamihe/movie_app/main/assets/demo/app_demo.mp4" type="video/mp4">
</video>

> If video does not work in GitHub preview, use GIF or YouTube link.

---

## 📸 Screenshots

<p align="center">
  <img src="assets/app_images/1.png" width="200"/>
  <img src="assets/app_images/2.png" width="200"/>
  <img src="assets/app_images/3.png" width="200"/>
</p>

---

## 🧱 Architecture

This project follows Clean Architecture:








### Layers:

- Presentation Layer (UI + BLoC)
- Domain Layer (Use Cases + Entities)
- Data Layer (Repositories + API + Models)

---

## 🛠️ Tech Stack

- Flutter
- Dart
- Firebase (Auth + Firestore)
- TMDB API
- BLoC (State Management)
- Hive (Local Storage)
- Dio (Networking)
- GetIt (Dependency Injection)
- Shared Preferences
- Cached Network Image

---

## 📦 Dependencies

```yaml
flutter_bloc: ^9.1.1
equatable: ^2.0.8
dio: ^5.9.2
firebase_core: ^4.7.0
firebase_auth: ^6.4.0
cloud_firestore: ^6.3.0
hive: ^2.2.3
hive_flutter: ^1.1.0
shared_preferences: ^2.5.5
cached_network_image: ^3.4.1
youtube_player_flutter: ^9.1.3
url_launcher: ^6.3.2
rxdart: ^0.28.0
bloc_concurrency: ^0.3.0
get_it: ^9.2.1
dartz: ^0.10.1













# Clone repository
git clone https://github.com/M-AboGamihe/movie_app.git

# Navigate to project
cd movie_app

# Install dependencies
flutter pub get

# Run application
flutter run
