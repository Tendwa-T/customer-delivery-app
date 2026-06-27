# Customer Delivery App

A Flutter mobile application that allows customers to create, manage, and track package delivery requests with a local SQLite database.

---

## Project Overview

The project demonstrates clean architecture, local data persistence, and effective state management.

Users can submit new delivery requests, track their status, edit pending requests, and delete them. The app is designed with a focus on:

- **Clean Architecture** - clear separation between data, domain, and presentation layers
- **Local Persistence** - all data survives app restarts using SQLite (`sqflite`)
- **State Management** - Provided by `flutter_bloc` for predictable, testable state flows
- **Theming** - supports both light and dark mode.

---

## Features

### Core Features

| Feature                     | Description                                                                                  |
| --------------------------- | -------------------------------------------------------------------------------------------- |
| **Create Delivery Request** | Submit a new request with pickup address, delivery address, package description, and weight  |
| **View All Requests**       | Browse all delivery requests in a scrollable list with key details at a glance               |
| **Delivery Detail View**    | Tap any request to see its full details including package code, status, and timestamps       |
| **Edit Pending Requests**   | Modify a delivery request (Only allowed when its status is `Pending`)                        |
| **Delete Pending Requests** | Remove a delivery request (Restricted to `Pending` status only)                              |
| **Status Management**       | Update delivery status through the lifecycle: `Pending → In Transit → Delivered / Cancelled` |
| **Form Validation**         | All fields are required with inline validation feedback                                      |

### Bonus Features

| Feature                  | Description                                                                                |
| ------------------------ | ------------------------------------------------------------------------------------------ |
| **Search**               | Real-time search across delivery requests                                                  |
| **Filter by Status**     | Filter the list to show only `Pending`, `In Transit`, `Delivered`, or `Cancelled` requests |
| **Pull-to-Refresh**      | Swipe down on the list to manually reload data                                             |
| **Dark Mode**            | Toggle between light and dark themes from the Settings screen                              |
| **Empty & Error States** | UI for empty lists, no-result searches, and data errors                                    |

---

## Architecture

The project follows a **feature-first clean architecture** pattern with a clear separation of concerns across three layers:

```
lib/
├── app.dart                        # Root widget (BlocProviders + MaterialApp.router)
├── main.dart                       # App entry point
│
├── common/
│   └── widgets/                    # Shared reusable UI widgets (EmptyStateWidget, ErrorStateWidget)
│
├── core/
│   ├── bloc_observer.dart          # Global BLoC event/state observer
│   ├── database/
│   │   └── database_helper.dart    # Singleton SQLite database manager
│   ├── error/
│   │   └── failures.dart           # Domain failure types (AppFailure)
│   ├── navigation/
│   │   ├── app_shell.dart          # Bottom navigation bar shell
│   │   └── router.dart             # GoRouter route configuration
│   ├── theme/
│   │   ├── theme.dart              # Light & dark ThemeData (FlexColorScheme)
│   │   └── theme_cubit.dart        # ThemeCubit for mode toggling
│   └── utils/                      # Utility helpers
│
└── features/
    └── deliveries/
        ├── data/
        │   ├── models/             # DeliveryRequestModel (DB ↔ Entity mapping)
        │   └── repositories/
        │       └── delivery_request_repository_impl.dart  # SQLite CRUD implementation
        ├── domain/
        │   ├── entity/
        │   │   └── delivery_request.dart   # Core entity + DeliveryStatus enum
        │   └── repository/
        │       └── delivery_request_repository.dart       # Abstract repository interface
        └── presentation/
            ├── bloc/
            │   ├── delivery_bloc.dart      # Business logic (load, add, update, delete, search, filter)
            │   ├── delivery_event.dart     # All BLoC events
            │   └── delivery_state.dart     # All BLoC states
            ├── screens/
            │   ├── delivery_list_screen.dart    # Main list with search & filters
            │   ├── delivery_detail_screen.dart  # Full detail + status update actions
            │   ├── delivery_form_screen.dart    # Create & edit form
            │   └── settings_screen.dart         # Dark mode toggle
            └── widgets/
                ├── delivery_card.dart       # List item card
                └── filter_chips_row.dart    # Status filter chips
```

### Layer Responsibilities

| Layer            | Responsibility                                                                                                   |
| ---------------- | ---------------------------------------------------------------------------------------------------------------- |
| **Domain**       | Pure Dart entities, enums, and abstract repository contracts. There are no Flutter or database dependencies here |
| **Data**         | SQLite models, CRUD operations, and concrete repository implementation                                           |
| **Presentation** | BLoC for state management; screens and widgets for UI rendering                                                  |
| **Core**         | Database singleton, router, theming, error types, and shared utilities                                           |

---

## Database Schema

The SQLite database (`delivery_app.db`) contains the single table:

```sql
CREATE TABLE delivery_requests (
    id                  INTEGER PRIMARY KEY AUTOINCREMENT,
    pickup_address      TEXT    NOT NULL,
    delivery_address    TEXT    NOT NULL,
    package_code        TEXT    NOT NULL UNIQUE,
    package_description TEXT    NOT NULL,
    package_weight      REAL    NOT NULL CHECK (package_weight > 0),
    status              TEXT    NOT NULL DEFAULT 'pending',
    created_at          TEXT    NOT NULL
);

-- Indexed columns for fast filtering and lookup
CREATE INDEX idx_delivery_status ON delivery_requests (status);
CREATE INDEX idx_code ON delivery_requests (package_code);
```

### Delivery Statuses

| Status     | DB Value     | Can Edit / Delete |
| ---------- | ------------ | ----------------- |
| Pending    | `pending`    | ✅ Yes            |
| In Transit | `in_transit` | ❌ No             |
| Delivered  | `delivered`  | ❌ No             |
| Cancelled  | `cancelled`  | ❌ No             |

---

## Dependencies

| Package             | Version   | Purpose                                               |
| ------------------- | --------- | ----------------------------------------------------- |
| `flutter_bloc`      | `^9.1.1`  | State management (BLoC + Cubit)                       |
| `equatable`         | `^2.0.8`  | Value equality for BLoC states/events                 |
| `sqflite`           | `^2.4.3`  | Local SQLite database                                 |
| `go_router`         | `^17.3.0` | Declarative navigation with deep linking              |
| `flex_color_scheme` | `^8.4.0`  | Sophisticated Material 3 theming                      |
| `fpdart`            | `^1.2.0`  | Functional programming (`Either` for error handling)  |
| `stream_transform`  | `^2.1.1`  | Stream debounce for search                            |
| logger              | `^2.7.0`  | Structured, colorised console logging with log levels |
| `path`              | `^1.9.1`  | File path utilities for database                      |

---

## Setup & Installation

### Prerequisites

| Tool                   | Requirement                            |
| ---------------------- | -------------------------------------- |
| Flutter SDK            | **3.44.4** (pinned via FVM)            |
| Dart SDK               | `^3.12.0`                              |
| FVM                    | Latest (optional but recommended)      |
| Android Studio / Xcode | For Android / iOS targets respectively |

> **Recommended:** This project uses [FVM (Flutter Version Manager)](https://fvm.app/) to pin the Flutter version. If you use FVM, prefix all `flutter` commands below with `fvm`.

---

### 1. Clone the Repository

```bash
git clone https://github.com/Tendwa-T/customer-delivery-app.git
cd customer_delivery_app
```

### 2. Install the Pinned Flutter Version (FVM — Recommended)

```bash
# Install FVM if you don't have it
dart pub global activate fvm

# Install and activate the project's pinned Flutter version
fvm install
fvm use
```

### 3. Install Dependencies

```bash
flutter pub get
# or with FVM:
fvm flutter pub get
```

### 4. Run the App

```bash
flutter run
# or with FVM:
fvm flutter run
```

> Make sure you have a connected device or a running Android emulator / iOS simulator.

### 5. Run Tests

```bash
flutter test
# or with FVM:
fvm flutter test
```

---

## Running on a Specific Platform

```bash
# Android
flutter run -d android

# iOS (macOS only)
# The app does have support for iOS, but was not tested on iOS during development
flutter run -d ios

# List all available devices
flutter devices
```

---

## Navigation Routes

| Route Name        | Path                   | Screen                          |
| ----------------- | ---------------------- | ------------------------------- |
| `delivery-list`   | `/deliveries`          | All delivery requests           |
| `delivery-detail` | `/deliveries/:id`      | Single delivery detail          |
| `delivery-edit`   | `/deliveries/:id/edit` | Edit a pending delivery         |
| `delivery-create` | `/create`              | New delivery form               |
| `settings`        | `/settings`            | App settings (dark mode toggle) |

Navigation is handled by **GoRouter** and presented through a **bottom navigation bar** with three tabs: Deliveries, Create, and Settings.

---

## Theming

The app uses `FlexColorScheme` to generate fully adaptive Material 3 light and dark themes. The active theme mode is managed by `ThemeCubit` and can be toggled at any time from the **Settings** screen.

---

## Key Design Decisions

- **`Either<AppFailure, T>`** — All repository methods return an `Either` type from `fpdart`, making error handling explicit and forcing the BLoC to handle both success and failure paths without throwing exceptions.
- **Edit/Delete Guard** — The `canEdit` flag is computed on the `DeliveryStatus` enum, keeping business rules in the domain layer rather than scattered across the UI.
- **Search Debounce** — The `SearchDeliveries` event uses a transformer to cancel in-flight searches and avoid excessive database queries while the user is still typing.
- **Singleton Database** — `DatabaseHelper.instance` ensures a single, reused database connection throughout the app's lifecycle.
- **Indexed Queries** — The `status` and `package_code` columns are indexed to keep filtering and lookup operations fast as the number of records grows.
