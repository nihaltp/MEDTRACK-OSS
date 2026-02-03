# MedTrack OSS 🏥 – Open Medication & Health Reminder System

MedTrack OSS is a production-ready, open-source medication management and adherence tracking system. Designed for individuals and caregivers, it provides a reliable way to manage medication schedules, receive timely reminders, and monitor adherence with privacy-first principles.

---

## 🚀 Key Features

- **Multi-User Support**: Individual profiles for multiple patients.
- **Dynamic Scheduling**: Support for daily, weekly, and custom medication intervals.
- **Caregiver Monitoring**: Real-time adherence tracking for caregivers (opt-in).
- **Notification Engine**: Pluggable system for Email, SMS, and Push notifications.
- **ML Privacy**: Localized AI for pill recognition (Optional Module).
- **Cross-Platform**: Modern Astro/React web interface + Vanilla JS fallback.

## 🛠️ Technology Stack

- **Backend**: Python 3.10+, FastAPI, PostgreSQL/MongoDB, Celery/APScheduler.
- **Mobile App**: Flutter (Dart)
- **Infrastructure**: Docker, Nginx.
- **Monitoring**: Prometheus & Grafana ready.

## 📋 Table of Contents

- [Prerequisites](#prerequisites)
- [Installation & Setup](#installation--setup)
- [Project Structure](#project-structure)
- [Backend Connection](#backend-connection)
- [Running the App](#running-the-app)
- [Building for Production](#building-for-production)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)

---

## Prerequisites

Before you begin, ensure you have the following installed on your system:

- **Flutter SDK** (3.0.0 or higher)
  - Download from: https://docs.flutter.dev/get-started/install
  - Verify installation: `flutter --version`
  
- **Dart SDK** (included with Flutter)

- **IDE** (choose one):
  - Android Studio (recommended) with Flutter & Dart plugins
  - VS Code with Flutter extension
  - IntelliJ IDEA with Flutter plugin

- **Platform-specific requirements**:
  - **For Android**: Android Studio, Android SDK (API level 21+)
  - **For iOS**: Xcode 14+ (macOS only), CocoaPods
  - **For Web**: Chrome browser

- **Git** for version control

---

## Installation & Setup

### 1. Clone the Repository
```bash
git clone https://github.com/R3ACTR/MEDTRACK-OSS.git
cd MEDTRACK-OSS/mobile_app
```

### 2. Install Dependencies

Run the following command to install all required Flutter packages:
```bash
flutter pub get
```

This command reads the `pubspec.yaml` file and downloads all dependencies.

### 3. Verify Flutter Installation

Check that Flutter is properly configured:
```bash
flutter doctor
```

This will show you any missing dependencies or configuration issues. Follow the recommendations to resolve them.

### 4. Configure Environment Variables

Create a `.env` file in the `mobile_app` directory (if not already present):
```bash
cp .env.example .env
```

Update the `.env` file with your configuration:
```env
# Backend API Configuration
API_BASE_URL=http://localhost:8000/api
API_TIMEOUT=30000

# Environment (development/staging/production)
ENVIRONMENT=development

# Optional: Push Notification Keys
FCM_SERVER_KEY=your_firebase_server_key_here
```

### 5. Platform-Specific Setup

#### Android Setup

1. Open `android/app/build.gradle` and verify `minSdkVersion` is set to 21 or higher
2. If using Firebase, place `google-services.json` in `android/app/`

#### iOS Setup (macOS only)

1. Navigate to iOS directory:
```bash
   cd ios
   pod install
   cd ..
```
2. If using Firebase, place `GoogleService-Info.plist` in `ios/Runner/`

---

## Project Structure

Here's an overview of the Flutter app's folder structure:
```
mobile_app/
├── android/                 # Android-specific configuration
├── ios/                     # iOS-specific configuration
├── lib/                     # Main application code
│   ├── main.dart           # App entry point
│   ├── models/             # Data models (User, Medication, etc.)
│   ├── screens/            # UI screens (Home, Reminders, Profile)
│   ├── widgets/            # Reusable UI components
│   ├── services/           # Business logic & API services
│   │   ├── api_service.dart      # HTTP client for backend
│   │   ├── notification_service.dart
│   │   └── auth_service.dart
│   ├── providers/          # State management (Provider/Riverpod)
│   ├── utils/              # Helper functions & constants
│   └── config/             # App configuration
├── assets/                  # Images, fonts, and static files
│   ├── images/
│   ├── icons/
│   └── fonts/
├── test/                    # Unit and widget tests
├── pubspec.yaml            # Package dependencies
├── .env.example            # Environment variables template
└── README.md               # This file
```

### Key Directories Explained

- **lib/models/**: Contains data classes representing medications, users, schedules, etc.
- **lib/screens/**: Full-page widgets (e.g., Login, Dashboard, Medication List)
- **lib/services/**: Backend communication, local storage, and notifications
- **lib/providers/**: State management using Provider or Riverpod pattern
- **lib/widgets/**: Reusable components like custom buttons, cards, and forms

---

## Backend Connection

The mobile app communicates with the MedTrack FastAPI backend. Here's how it's configured:

### API Service Configuration

The app uses `lib/services/api_service.dart` to handle all HTTP requests. Key endpoints include:
```dart
// Example API endpoints
POST   /api/auth/login          # User authentication
GET    /api/medications         # Fetch user's medications
POST   /api/medications         # Add new medication
PUT    /api/medications/{id}    # Update medication
DELETE /api/medications/{id}    # Delete medication
GET    /api/reminders           # Fetch reminders
POST   /api/adherence           # Log medication intake
```

### Connecting to Backend

1. **Local Development**: 
   - Ensure the backend is running (see `backend/README.md`)
   - Default backend URL: `http://localhost:8000`
   - For Android emulator: Use `http://10.0.2.2:8000`
   - For iOS simulator: Use `http://localhost:8000`
   - For physical device: Use your computer's IP (e.g., `http://192.168.1.100:8000`)

2. **Update API Base URL**:
   Edit `.env` file:
```env
   API_BASE_URL=http://10.0.2.2:8000/api  # For Android emulator
   # or
   API_BASE_URL=http://192.168.1.100:8000/api  # For physical device
```

3. **Testing Backend Connection**:
   The app includes a health check endpoint. On first launch, it will display connectivity status.

### Authentication Flow

1. User enters credentials on Login screen
2. App sends POST request to `/api/auth/login`
3. Backend returns JWT token
4. Token is stored securely using `flutter_secure_storage`
5. All subsequent API requests include the token in headers

---

## Running the App

### Development Mode

#### Run on Connected Device/Emulator
```bash
# List available devices
flutter devices

# Run on specific device
flutter run -d <device_id>

# Run in debug mode (default)
flutter run

# Run in profile mode (better performance testing)
flutter run --profile

# Run in release mode
flutter run --release
```

#### Hot Reload

While the app is running, press:
- `r` to hot reload (preserves state)
- `R` to hot restart (resets state)
- `q` to quit

### Platform-Specific Commands
```bash
# Run on Android
flutter run -d android

# Run on iOS (macOS only)
flutter run -d ios

# Run on Web
flutter run -d chrome

# Run on all connected devices
flutter run -d all
```

---

## Building for Production

### Android APK
```bash
# Build APK
flutter build apk

# Build APK with split per ABI (smaller size)
flutter build apk --split-per-abi

# Output location: build/app/outputs/flutter-apk/app-release.apk
```

### Android App Bundle (for Play Store)
```bash
flutter build appbundle

# Output location: build/app/outputs/bundle/release/app-release.aab
```

### iOS (macOS only)
```bash
# Build for iOS
flutter build ios

# Build IPA for distribution
flutter build ipa
```

### Web
```bash
flutter build web

# Output location: build/web/
```

---

## Troubleshooting

### Common Issues

#### 1. "Doctor found issues"
```bash
flutter doctor
```
Follow the instructions to fix any reported issues.

#### 2. Dependency Conflicts
```bash
flutter pub cache repair
flutter clean
flutter pub get
```

#### 3. Cannot Connect to Backend

- Verify backend is running: `curl http://localhost:8000/health`
- Check firewall settings
- For physical devices, ensure they're on the same network
- Verify `API_BASE_URL` in `.env`

#### 4. Build Errors on iOS
```bash
cd ios
pod deintegrate
pod install
cd ..
flutter clean
flutter run
```

#### 5. "Gradle Build Failed" (Android)

- Update `android/gradle/wrapper/gradle-wrapper.properties`
- Check `android/build.gradle` for compatible versions
- Ensure Android SDK is up to date

### Getting Help

- Check existing [GitHub Issues](https://github.com/R3ACTR/MEDTRACK-OSS/issues)
- Review [Flutter Documentation](https://docs.flutter.dev/)
- Join our community 
- Read the main [Contributing Guide](../CONTRIBUTING.md)

---

## Testing

### Run All Tests
```bash
flutter test
```

### Run Specific Test File
```bash
flutter test test/models/medication_test.dart
```

### Integration Tests
```bash
flutter drive --target=test_driver/app.dart
```

---

## Contributing

We welcome contributions! Please follow these steps:

1. Read the main [CONTRIBUTING.md](../CONTRIBUTING.md) guide
2. Fork the repository
3. Create a feature branch: `git checkout -b feature/amazing-feature`
4. Make your changes
5. Write/update tests
6. Run `flutter analyze` and fix any warnings
7. Format code: `flutter format lib/`
8. Commit: `git commit -m 'Add amazing feature'`
9. Push: `git push origin feature/amazing-feature`
10. Open a Pull Request

### Code Style

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Use `flutter analyze` before committing
- Format code with `flutter format`
- Write meaningful commit messages

---

## Additional Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Flutter Cookbook](https://docs.flutter.dev/cookbook)
- [MedTrack API Documentation](../docs/API.md)
- [Main Project README](../README.md)

---

## 🤝 Contributing

We welcome contributions! Please read our [CONTRIBUTING.md](./CONTRIBUTING.md) and [CODE_OF_CONDUCT.md](./CODE_OF_CONDUCT.md) for details.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](./LICENSE) file for details.

## ⚠️ Disclaimer

**Not a Medical Device.** MedTrack OSS is a reminder tool and should not be used for life-critical medication management without professional medical supervision.
