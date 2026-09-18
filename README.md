# Khata — Expense Ledger 💰

A calm and minimal **expense-tracking mobile application built with Flutter**. Khata provides a simple way to record, search, filter, and review daily expenses without requiring an account, server, or internet connection.

> **Simple spending. Clear records. No unnecessary complexity.**

---

## 📱 About the Project

**Khata** is a Flutter-based expense ledger designed to make personal expense tracking quick and straightforward.

Users can add expenses with details such as title, amount, category, date, and notes. The app provides a dashboard for an overview of spending and a history screen where expenses can be searched and filtered.

Currently, all expense data is stored **in memory**, so the data is cleared when the application is restarted.

---

## ✨ Features

### 🏠 Dashboard

* Monthly spending overview
* Clean and minimal interface
* Empty state for new users
* Quick access to add expenses

### ➕ Add Expense

Users can record an expense with:

* Expense title
* Amount
* Category
* Date
* Notes
* Live expense preview
* Form validation
* Save button enabled only when required fields are completed

### 📋 Expense History

* Displays all saved expenses
* Newest expenses appear first
* Search expenses by title
* Filter expenses by category
* Running total of expenses in **PKR**
* Live count showing how many expenses are currently displayed

**Available categories:**

* 🍔 Food
* 🚗 Transport
* 🛍️ Shopping
* 💡 Bills
* 📦 Other

### 🧭 Bottom Navigation

A floating navigation bar provides quick access to:

* Home
* Add Expense
* History

### 🎨 Custom UI

* Warm, minimal color palette
* Serif typography for headings
* Roboto for body text
* Custom wallet/card icon created using Flutter's `CustomPaint`
* No image assets required for the main wallet icon

---

## 🖼️ Screens

| Screen          | Description                                             |
| --------------- | ------------------------------------------------------- |
| Splash Screen   | Branded introduction screen shown when the app launches |
| Welcome Screen  | First-time onboarding screen with a Get Started button  |
| Dashboard       | Overview of monthly spending                            |
| Add Expense     | Form for recording a new expense                        |
| Expense History | Searchable and filterable expense list                  |

### Navigation Flow

```text
Splash Screen
      │
      ▼
Welcome Screen
      │
      ▼
Dashboard
   ┌──┴──────────┐
   ▼             ▼
Add Expense   History
   ▲             │
   └─────────────┘
```

---

## 🧠 Data Management

Khata currently uses a lightweight in-memory data store:

```text
lib/expense_store.dart
```

The `ExpenseStore` is implemented as a singleton using `ChangeNotifier`.

It is shared between the Add Expense and History screens.

### How it works

```text
Add Expense Screen
        │
        │ Save Expense
        ▼
   ExpenseStore
        │
        │ Notify listeners
        ▼
 History Screen
        │
        ▼
 Updated Expense List
```

### Current Limitation

⚠️ **Expenses are not persistent yet.**

Because the application currently stores data only in memory, all expenses are removed when the app is closed or restarted.

### Planned Persistence

The app can later be connected to a local storage solution such as:

* `sqflite` — for structured local database storage
* `shared_preferences` — for simple key-value storage
* `hive` — for lightweight local data persistence

---

## 🎨 Design System

Khata uses a warm and calm visual design.

| Design Token    | Value     | Usage                             |
| --------------- | --------- | --------------------------------- |
| Background      | `#F7F1E7` | Main page background              |
| Card Background | `#FBF7EF` | Cards and panels                  |
| Coral           | `#C97B5B` | Primary buttons and active states |
| Coral Soft      | `#EFE3D8` | Icon backgrounds                  |
| Olive           | `#8C9A5B` | Spending totals                   |
| Dark Text       | `#1E1B18` | Headings and primary text         |
| Grey Text       | `#7A756E` | Secondary text                    |
| Outline         | `#D9CFBE` | Borders and dividers              |

### Typography

* **Headings:** Serif font family
* **Body:** Roboto / default Flutter font

The design focuses on readability, simplicity, and a warm editorial aesthetic.

---

## 🛠️ Tech Stack

| Technology       | Purpose                 |
| ---------------- | ----------------------- |
| Flutter          | Application development |
| Dart             | Programming language    |
| Material         | UI components           |
| StatefulWidget   | Local screen state      |
| `ChangeNotifier` | Shared expense state    |
| `CustomPaint`    | Custom wallet/card icon |

### Dependencies

The project currently requires **no external Flutter packages**.

It is built using Flutter's core widgets and APIs.

---

## 📂 Project Structure

```text
lib/
├── main.dart
├── expense_store.dart
│
└── screens/
    ├── splash_screen.dart
    ├── welcome_screen.dart
    ├── dashboard_screen.dart
    ├── add_expense_screen.dart
    └── history_screen.dart
```

### Main Files

**`main.dart`**
Application entry point and main app configuration.

**`expense_store.dart`**
Shared in-memory expense store using `ChangeNotifier`.

**`splash_screen.dart`**
Displays the branded splash screen before entering the application.

**`welcome_screen.dart`**
First-time onboarding screen.

**`dashboard_screen.dart`**
Displays the user's spending overview.

**`add_expense_screen.dart`**
Allows users to create and save expenses.

**`history_screen.dart`**
Displays, searches, and filters saved expenses.

---

## 🚀 Getting Started

### Prerequisites

Make sure you have installed:

* Flutter SDK
* Dart SDK
* Android Studio / Android SDK, or another supported Flutter device
* VS Code or Android Studio

You can verify your Flutter installation with:

```bash
flutter doctor
```

### Installation

Clone the repository:

```bash
git clone <your-repository-url>
```

Navigate into the project:

```bash
cd khata_tracker
```

Install dependencies:

```bash
flutter pub get
```

Run the application:

```bash
flutter run
```

To run it specifically in Chrome:

```bash
flutter run -d chrome
```

---

## 🔄 Application Flow

```text
Launch App
    │
    ▼
Splash Screen
    │
    ▼
Welcome Screen
    │
    ▼
Dashboard
    │
    ├───────────────┐
    ▼               ▼
Add Expense      History
    │               │
    ▼               ▼
Save Expense     Search /
    │             Filter
    │               │
    └───────┬───────┘
            ▼
      Updated Expenses
```

---

## 🔍 Expense History Filtering

The History screen supports:

### Search

Users can search expenses using the expense title.

### Category Filter

Expenses can be filtered using:

```text
Food
Transport
Shopping
Bills
Other
```

### Expense Count

The application displays the number of visible expenses compared with the total number of saved expenses.

Example:

```text
3 of 8 shown
```

### Total

A running total of saved expenses is displayed in **PKR**.

---

## 🔮 Future Improvements

The project can be extended with several features:

* [ ] Persistent local storage
* [ ] Month-based filtering
* [ ] Category-wise spending totals
* [ ] Spending charts and visual analytics
* [ ] Edit existing expenses
* [ ] Delete expenses
* [ ] Swipe-to-delete expense rows
* [ ] Monthly spending summaries
* [ ] Budget tracking
* [ ] Export expense records
* [ ] Dark mode

---

## 🎯 Project Goals

Khata was designed with three main goals:

1. **Simplicity** — quickly record an expense without unnecessary steps.
2. **Clarity** — make spending history easy to understand.
3. **Privacy** — keep the application simple and local without requiring an account or server.

---

## 📌 Current Status

**Project Status:** 🚧 In Development

The core expense-tracking functionality is implemented, including:

* Splash screen
* Welcome/onboarding flow
* Dashboard
* Expense creation
* Expense history
* Search
* Category filtering
* Expense totals
* Bottom navigation

Persistent data storage is planned for a future version.

---

## 👩‍💻 Author

**Meerab Batool**

Flutter Developer | BSIT Graduate

---

## 📄 License

This project is created for learning, portfolio, and development purposes.
