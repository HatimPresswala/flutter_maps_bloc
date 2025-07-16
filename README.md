
# Flutter Maps App with BLoC & HydratedBloc

This Flutter application demonstrates:

- 📍 Google Maps integration  
- 🚶 Real-time location tracking  
- 📌 Drop pins by tapping the map  
- 💾 Persistent pin storage using HydratedBloc  
- 🔁 Refresh map + location manually or on app resume  
- ✅ Clean BLoC architecture with MVVM-style folder structure

---

## 🔧 Setup Instructions

1. **Clone the Repository**

```bash
git clone https://github.com/HatimPresswala/flutter_maps_bloc.git
cd flutter_maps_bloc
```

2. **Install Dependencies**

```bash
flutter pub get
```

3. **Configure Google Maps API Key**

- Open `android/app/src/main/AndroidManifest.xml`
- Replace `YOUR_GOOGLE_MAP_API_KEY_HERE` with your actual API key:

```xml
<meta-data
  android:name="com.google.android.geo.API_KEY"
  android:value="YOUR_GOOGLE_MAP_API_KEY_HERE"/>
```

4. **Run the App**

```bash
flutter run
```

> ⚠️ For best results, run on a real Android device or emulator with Google Play Services.

---

## 🧠 BLoC Usage Overview

This app uses **flutter_bloc** for reactive state management and **hydrated_bloc** for local persistence.

### ▶️ HomeBloc
- Manages:
  - Current user location (real-time)
  - All pins shown on the map
- Events handled:
  - `LoadUserLocationEvent`
  - `DropPinEvent`
  - `StartLocationUpdatesEvent`
  - `LocationChangedEvent`

### ▶️ SavedLocationsBloc (Hydrated)
- Stores user-dropped pins persistently using local storage.
- Rehydrates saved pins on app restart without any extra setup.

---

## 💡 Features

- 📍 Tap the map to drop pins
- 💾 Pins are saved to disk and restored after app restart
- 🔄 Refresh button in AppBar reloads location and saved pins
- 📡 Tracks current location with permission prompts
- 🧱 Modular folder structure: `features/`, `core/`, `data/`

---

## 📸 Screenshots & Demo Video

```
assets/screenshots/livemap.jpg
assets/screenshots/savedlocation.jpg
assets/video/Demo_flutter_google_map.mp4
```

---

## 📁 Project Structure

```
lib/
├── app.dart
├── main.dart
├── core/services/location_service.dart
├── data/models/pinned_location.dart
├── features/
│   ├── home/
│   │   ├── bloc/
│   │   └── ui/
│   └── saved_locations/
│       ├── bloc/
│       └── ui/
```

---

## ✅ Submission Info

- GitHub Repo: [flutter_maps_bloc](https://github.com/HatimPresswala/flutter_maps_bloc)
- Submitted by: Hatim Presswala
- Role: Flutter Developer

---

## 📜 License

MIT License. Free to use, modify, and build on.
