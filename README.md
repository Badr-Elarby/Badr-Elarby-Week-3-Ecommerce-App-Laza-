# Laza E-commerce App
[![Ask DeepWiki](https://devin.ai/assets/askdeepwiki.png)](https://deepwiki.com/Badr-Elarby/Badr-Elarby-Week-3-Ecommerce-App-Laza-)

Laza is a stylish and modern e-commerce mobile application built with Flutter. It provides a seamless shopping experience for users to browse, favorite, and purchase fashion products. The app features a clean user interface, robust state management, and a feature-rich, scalable architecture.

## Key Features

- **User Authentication:** Secure login and registration flow with email and password. Session management is handled using access and refresh tokens, with automatic token renewal via a Dio interceptor.
- **Personalized Onboarding:** A gender selection screen to tailor the initial product discovery experience.
- **Product Discovery:**
    - **Home Screen:** Displays a curated list of products.
    - **Brand Filtering:** Easily filter products by popular brands like Adidas, Nike, Fila, and Puma.
    - **Search:** A functional search bar to quickly find items.
- **Product Details:** A comprehensive detail screen for each product, showcasing multiple images, description, price, ratings, and stock availability.
- **Favorites / Wishlist:** Users can "like" products and save them to a persistent favorites list for later viewing.
- **Shopping Cart:** A fully functional shopping cart where users can add items, update quantities, remove items, and view a summary of their order before proceeding to checkout.
- **Order Confirmation:** A confirmation screen to notify the user that their order has been placed successfully.
- **Declarative Routing:** A clean and maintainable navigation system built with `go_router`, including a shell route for the main screens with a persistent bottom navigation bar.

## Architecture & Tech Stack

This project follows a clean, feature-first architecture to ensure scalability and maintainability.

- **Architecture:** Feature-based layered architecture (`data`, `presentation`).
- **State Management:** `flutter_bloc` / `Cubit` for predictable and reactive state management.
- **Dependency Injection:** `get_it` for managing dependencies and decoupling components.
- **Networking:** `dio` for handling HTTP requests, with a custom interceptor for handling authentication and token refreshes.
- **Routing:** `go_router` for a robust, declarative navigation system.
- **Local Storage:**
  - `flutter_secure_storage` for securely persisting authentication tokens.
  - `shared_preferences` for storing user preferences like favorites, cart items, and gender selection.
- **UI:**
  - `flutter_screenutil` for creating responsive UIs that adapt to different screen sizes.
  - `google_fonts` for custom typography.
  - `flutter_animate` and `shimmer` for engaging animations and loading effects.
- **Utilities:** `equatable` for simplifying model comparisons.

## Getting Started

To get a local copy up and running, follow these simple steps.

### Prerequisites

- Flutter SDK (version 3.8.1 or higher)
- A compatible IDE (like VS Code or Android Studio)
- An emulator or physical device to run the app

### Installation & Setup

1.  **Clone the repository:**
    ```sh
    git clone https://github.com/badr-elarby/badr-elarby-week-3-ecommerce-app-laza-.git
    ```
2.  **Navigate to the project directory:**
    ```sh
    cd badr-elarby-badr-elarby-week-3-ecommerce-app-laza-
    ```
3.  **Install dependencies:**
    ```sh
    flutter pub get
    ```
4.  **Run the application:**
    ```sh
    flutter run
    ```

## Project Structure

The project's `lib` directory is organized to separate concerns and features, making it easy to navigate and extend.

```
lib/
├── core/                  # Shared utilities, services, and widgets
│   ├── di/                # Dependency injection setup (get_it)
│   ├── network/           # Dio configuration and interceptors
│   ├── routing/           # App routing with GoRouter
│   ├── services/          # Core services (e.g., local storage)
│   ├── utils/             # App-wide constants (colors, styles)
│   └── widgets/           # Common widgets (e.g., BottomNavBar)
├── features/              # Individual feature modules
│   ├── auth/              # Authentication (login, signup)
│   ├── Cart/              # Shopping cart functionality
│   ├── Favorites/         # Wishlist/favorites management
│   ├── home/              # Home screen and product listing
│   ├── onboarding/        # Initial setup screens (gender selection)
│   ├── ProductDetails/    # Product details screen
│   └── spalsh/            # Splash screen
└── main.dart              # Application entry point
```


## 📸 Screenshots

### 🟢 Splash & Onboarding
| Splash | Onboarding |
|:--:|:--:|
| ![Splash](screenshots&demo/splash.png) | ![Onboarding](screenshots&demo/onboarding.png) |

---

### 🔐 Authentication
| Login | Signup |
|:--:|:--:|
| ![Login](screenshots&demo/login.png) | ![Signup](screenshots&demo/signup.png) |

---

### 🏠 Home Screens
| Home 1 | Home 2 | Home 3 |
|:--:|:--:|:--:|
| ![Home1](screenshots&demo/home0.png) | ![Home2](screenshots&demo/home1.png) | ![Home3](screenshots&demo/home2.png) |

---

### 💖 Favorites & Product Details
| Favorites | Product Details |
|:--:|:--:|
| ![Favorites](screenshots&demo/favorite.png) | ![Product Details](screenshots&demo/ProductDetails.png) |

---

### 🛒 Cart & Order Confirmation
| Cart | Order Confirmation |
|:--:|:--:|
| ![Cart](screenshots&demo/cart.png) | ![Order Confirmation](screenshots&demo/OrderConfirmation.png) |

