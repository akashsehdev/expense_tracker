# expense_tracker

A new Flutter project. This is a simple expense tracker app built with Flutter. The app allows users to log their daily expenses, view a summary of their expenses, and set daily reminders to log their expenses.

## Features

- **User Authentication:** Sign up and login functionality.
- **Expense Management:** Add, update, delete, and view expenses.
- **Expense Summary:** View a summary of total expenses.
- **Daily Reminder:** Set a daily reminder to log expenses using local notifications.
- **Profile Management:** View and update user profile information.

## Getting Started

This project is a starting point for a Flutter application.

### Prerequisites

- Flutter SDK: [Install Flutter](https://flutter.dev/docs/get-started/install)
- Dart SDK: Comes bundled with Flutter
- Android Studio or Visual Studio Code for development

### Installation

1. **Clone the repository:**

    ```bash
    git clone https://github.com/yourusername/expense_tracker.git
    cd expense_tracker
    ```

2. **Install dependencies:**

    ```bash
    flutter pub get
    ```

3. **Run the app:**

    ```bash
    flutter run
    ```

## Usage

1. **Sign Up / Login:**
   - New users can sign up by providing their details.
   - Existing users can log in using their email and password.
   - Existing users' login details are also stored using shared preferences.

2. **Manage Expenses:**
   - Add new expenses by providing a description, amount, and date.
   - View a list of all expenses.
   - Update or delete existing expenses.

3. **Daily Reminder:**
   - Set a daily reminder to log expenses using the toggle button on the profile screen.
   - Choose the time for the reminder using the time picker.

4. **Profile Management:**
   - View profile information.
   - Sign out or delete the account.

## Project Structure

The project follows a typical Flutter project structure:

- `lib/`
  - `data/`: Contains models, providers, and services.
    - `services/`: Database and notification services.
  - `domain/`: Contains models, providers, and services.
    - `models/`: Data models used in the app.
    - `provider/`: State management using Provider.
  - `presentation/`: Contains the UI components and screens.
    - `components/`: Reusable UI components.
    - `screens/`: Different screens of the app.

## Dependencies

- `flutter_local_notifications`: For scheduling local notifications.
- `provider`: For state management.
- `timezone`: For handling time zones.
- `google_fonts`: For text fonts, I have used poppins.
- `sqflite`: For storing data locally.
- `path`: The path package provides common operations for manipulating paths
- `provider`: user for state management and helps the consumer to access and update the state.
- `shared_preferences`: For storing user-id locally for login.
- `intl`: User to implement dates feature.
