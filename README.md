# Post Midterm Homework Assignments
**Name:** Gunata Prajna Putra Sakri  
**NPM:** 2406453461  
**Kelas:** KKI  

---

<details>
  <summary><b>Assignment 7</b></summary>

  **1.** A widget tree in Flutter shows how all widgets are structured in a hierarchy.  
  The parent widget controls how its child widgets are placed or behave (for example, a `Column` arranges its children vertically).  
  Each widget can also have its own children, forming the full UI.  
  When the state changes, Flutter rebuilds parts of this tree to update what’s shown on screen.  

  **2.** The widgets I used are:  
  - **Scaffold** → main page layout (has AppBar and body).  
  - **AppBar** → shows the title “Grady.”  
  - **Padding**, **SizedBox**, **Container** → for spacing and layout.  
  - **Column** and **Row** → arrange widgets vertically and horizontally.  
  - **GridView.count** → shows the menu items in 3 columns.  
  - **Card** → for info boxes (NPM, Name, Class).  
  - **Text** and **Icon** → display text and icons.  
  - **Material** and **InkWell** → make the cards tappable with visual feedback.  
  - **SnackBar** and **ScaffoldMessenger** → show messages when buttons are pressed.  
  - **InfoCard** and **ItemCard** → my custom widgets for displaying info and menu items.  

  **3.** MaterialApp is the main widget that sets up the app’s basic structure.  
  It provides navigation, themes, and text direction, so everything in the app follows Material Design rules.  
  It’s usually the root widget because it wraps the whole app and makes sure all widgets inside have access to those settings.  

  **4.** StatelessWidget is used when the UI doesn’t change — it only depends on the input data.  
  StatefulWidget is used when the UI can change dynamically (like when data or user interaction updates the screen).  
  I’d use StatelessWidget for static pages and StatefulWidget when I need something that can update its state.

  **5.** BuildContext gives information about where a widget is located in the widget tree.  
  It’s important because it lets widgets access theme data, navigate, or show SnackBars through the context.  
  In the build method, it’s used to build the UI based on that widget’s position and surrounding data.

  **6.** Hot reload updates the code while keeping the current app state.  
  It's used to quickly see UI or logic changes without restarting the app.  
  Hot restart rebuilds the entire app from scratch and resets all states.  
  In short, hot reload is faster and keeps your progress, while hot restart fully restarts the app.  


</details>

<details>
  <summary><b>Assignment 8</b></summary>

  **1.** **Difference between `Navigator.push()` and `Navigator.pushReplacement()`:**
  
  - **`Navigator.push()`**: Adds a new route on top of the current route stack. The user can go back to the previous page using the back button. This is useful when you want to allow users to navigate back (e.g., viewing details, filling a form that can be cancelled).
  
  - **`Navigator.pushReplacement()`**: Replaces the current route with a new route. The previous route is removed from the stack, so users cannot go back to it. This is useful for login screens, splash screens, or navigation between main sections where going back doesn't make sense.
  
  **In my application:**
  - I use `Navigator.push()` in the "Create Product" button on the home page because users might want to go back to the home page after viewing the form.
  - I use `Navigator.pushReplacement()` in the drawer navigation (Home and Add News) because these are main navigation actions where replacing the current page makes more sense for a cleaner navigation flow.

  **2.** **Using hierarchy widgets (Scaffold, AppBar, Drawer) for consistent page structure:**
  
  I use these widgets to create a consistent structure across all pages:
  
  - **Scaffold**: The main container that provides the basic structure for every page (AppBar, body, drawer, floating action button, etc.). Both `MyHomePage` and `ItemListFormPage` use Scaffold as their root widget.
  
  - **AppBar**: Provides a consistent header across all pages with the app title "Grady" or "Add New News", styled with green text and the theme's primary color as background. This gives users a clear indication of where they are in the app.
  
  - **Drawer**: Included in both pages using the `LeftDrawer` widget, providing consistent navigation options (Home and Add News) accessible from anywhere in the app. This creates a uniform navigation experience.
  
  This structure ensures that every page has the same look and feel, making the app more intuitive and professional.

  **3.** **Advantages of layout widgets (Padding, SingleChildScrollView, ListView) for form elements:**
  
  - **Padding**: Provides consistent spacing around form elements, making the UI more readable and visually appealing. In my form, I use `Padding` with `EdgeInsets.all(16.0)` for the main form container and `EdgeInsets.only(bottom: 8.0)` between form fields to create proper spacing.
  
  - **SingleChildScrollView**: Essential for forms because it allows users to scroll when the form content exceeds the screen height (especially on smaller devices or when the keyboard appears). Without it, form fields might be hidden or inaccessible. I use it in `ItemListFormPage` to wrap the entire form so users can scroll through all input fields comfortably.
  
  - **ListView**: Used in the drawer to display a scrollable list of navigation options. It's efficient for rendering lists and automatically handles scrolling when content overflows.
  
  **Usage examples from my application:**
  - In `ItemListFormPage`, I wrap the form in `SingleChildScrollView` with `Padding` to ensure all form fields are accessible and properly spaced, even on smaller screens.
  - In `LeftDrawer`, I use `ListView` to display the navigation menu items, allowing smooth scrolling if more items are added in the future.
  - Throughout the app, I use `Padding` widgets consistently to maintain proper spacing between UI elements.

  **4.** **Setting color theme for consistent visual identity:**
  
  I set the color theme in `main.dart` using `ThemeData` with a `ColorScheme`:
  
  ```dart
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.green,
    backgroundColor: const Color(0xFFF8F5EF), // soft beige background
  ).copyWith(
    primary: const Color(0xFF3C5B41), // deep forest green
    secondary: const Color(0xFF7A8E67), // muted olive accent
    surface: const Color(0xFFF8F5EF), // light cream surface
    onPrimary: Colors.white, // for text/icons on green
    onSecondary: Colors.white,
    onSurface: const Color(0xFF1F2D20), // dark greenish text
  ),
  ```
  
  This creates a consistent green theme throughout the app:
  - **Primary color** (deep forest green) is used for AppBar backgrounds and important buttons
  - **Green text** (`Colors.green`) is used for app titles to reinforce the brand
  - **Soft beige background** provides a pleasant, readable surface
  - **White text** on green backgrounds ensures good contrast and readability
  - All pages automatically use these theme colors, ensuring visual consistency across the entire Football News application

  This theme creates a cohesive visual identity that reflects the nature of the app (football/news) while maintaining good usability and readability.

</details>

<details>
  <summary><b>Assignment 9</b></summary>

  ## Assignment 9: Integration of Django Web Service with Flutter Application

  ### 1. Why do we need to create a Dart model when fetching/sending JSON data? What are the consequences of directly mapping `Map<String, dynamic>` without using a model?

  **Why we need Dart models:**
  - **Type Safety**: Models provide compile-time type checking, preventing runtime errors from accessing non-existent fields or wrong data types.
  - **Null Safety**: Models allow us to explicitly define which fields can be null, making null handling more predictable and safe.
  - **Code Maintainability**: Models serve as documentation, making it clear what data structure is expected. Changes to the API can be tracked through model updates.
  - **IDE Support**: With models, we get autocomplete, type hints, and better refactoring support in the IDE.
  - **Data Validation**: Models can include validation logic to ensure data integrity before use.

  **Consequences of using `Map<String, dynamic>` directly:**
  - **No Type Safety**: Accessing fields like `map['name']` returns `dynamic`, which can lead to runtime errors if the field doesn't exist or has the wrong type.
  - **No Null Safety**: We can't guarantee which fields are nullable, leading to potential null pointer exceptions.
  - **Poor Maintainability**: Without a clear structure, it's hard to understand what data is available and what changes when the API evolves.
  - **Error-Prone**: Typos in field names (e.g., `map['nmae']` instead of `map['name']`) won't be caught until runtime.
  - **No IDE Support**: No autocomplete or type checking, making development slower and more error-prone.

  **Example from my implementation:**
  ```dart
  // With model (safe and clear)
  Shop shop = Shop.fromJson(jsonData);
  String name = shop.name; // Type-safe, IDE knows this is a String
  
  // Without model (risky)
  Map<String, dynamic> data = json.decode(response);
  String name = data['name']; // Could be null, wrong type, or missing
  ```

  ### 2. What is the purpose of the *http* and *CookieRequest* packages in this assignment? Explain the difference between their roles.

  **`http` package:**
  - **Purpose**: Provides low-level HTTP client functionality for making HTTP requests (GET, POST, PUT, DELETE).
  - **Role**: Used for general API calls that don't require cookie-based authentication, such as fetching product lists from the JSON endpoint.
  - **Example**: Fetching shop items from `http://10.0.2.2:8000/json/`

  **`CookieRequest` package (from `pbp_django_auth`):**
  - **Purpose**: Extends HTTP functionality to handle cookie-based authentication sessions with Django.
  - **Role**: Manages session cookies automatically, allowing authenticated requests to Django's authentication endpoints. It stores and sends cookies with each request, maintaining the user's login state.
  - **Example**: Login, register, and logout operations that require session management.

  **Key Differences:**
  - **Cookie Management**: `CookieRequest` automatically handles session cookies, while `http` requires manual cookie management.
  - **Authentication**: `CookieRequest` is specifically designed for Django's session-based authentication, while `http` is a general-purpose HTTP client.
  - **Session Persistence**: `CookieRequest` maintains login state across requests through cookies, while `http` is stateless.

  **In my implementation:**
  - I use `CookieRequest` for authentication operations (login, register, logout) and for publishing products (requires authentication) to maintain session state.
  - I use `http` for fetching product data from the JSON endpoint, as it doesn't require authentication.

  ### 3. Explain why the *CookieRequest* instance needs to be shared across all components in the Flutter application.

  **Why shared CookieRequest instance:**
  - **Session Consistency**: All components need to use the same cookie store to maintain the user's login session. If each component creates its own instance, they won't share cookies, causing authentication to fail.
  - **State Management**: A single instance ensures that login/logout actions in one part of the app are immediately reflected everywhere.
  - **Cookie Persistence**: The shared instance maintains cookies across navigation, so users stay logged in when moving between pages.

  **How I implemented it:**
  ```dart
  // In main.dart
  Provider(
    create: (_) {
      CookieRequest request = CookieRequest();
      return request;
    },
    child: MaterialApp(...)
  )
  ```
  - Using `Provider`, I create a single `CookieRequest` instance at the app root.
  - All widgets access it via `context.watch<CookieRequest>()` or `context.read<CookieRequest>()`.
  - This ensures all components share the same authentication state and cookies.

  **Consequences if not shared:**
  - Each page would have its own cookie store, causing login to be lost when navigating.
  - Authentication state would be inconsistent across the app.
  - Users would need to log in repeatedly when switching pages.

  ### 4. Explain the connectivity configuration required for Flutter to communicate with Django. Why do we need to add 10.0.2.2 to ALLOWED_HOSTS, enable CORS and SameSite/cookie settings, and add internet access permission in Android? What would happen if these configurations were not set correctly?

  **Required Configurations:**

  **1. ALLOWED_HOSTS (Django settings.py):**
  ```python
  ALLOWED_HOSTS = ["localhost", "127.0.0.1", "10.0.2.2", "gunata-prajna-grady.pbp.cs.ui.ac.id"]
  ```
  - **Why 10.0.2.2**: This is the special IP address that Android emulators use to access the host machine's localhost. When Flutter runs on an Android emulator, `localhost` or `127.0.0.1` refers to the emulator itself, not the host machine. `10.0.2.2` maps to the host's `127.0.0.1`.
  - **What happens without it**: Django would reject requests from the emulator with a "DisallowedHost" error.

  **2. CORS Settings (Django settings.py):**
  ```python
  CORS_ALLOW_ALL_ORIGINS = True
  CORS_ALLOW_CREDENTIALS = True
  ```
  - **Why needed**: Cross-Origin Resource Sharing (CORS) allows the Flutter app (running on a different origin) to make requests to Django. `CORS_ALLOW_CREDENTIALS = True` is needed for cookie-based authentication.
  - **What happens without it**: Browser/Flutter would block requests due to CORS policy, preventing any API calls.

  **3. Cookie Settings (Django settings.py):**
  ```python
  SESSION_COOKIE_HTTPONLY = True
  SESSION_COOKIE_SAMESITE = 'Lax'
  CSRF_COOKIE_SAMESITE = 'Lax'
  ```
  - **Why needed**: `SAMESITE = 'Lax'` allows cookies to be sent in cross-site requests (needed for Flutter app). `HTTPONLY` prevents JavaScript access for security.
  - **What happens without it**: Cookies wouldn't be sent with requests, breaking authentication.

  **4. Internet Permission (AndroidManifest.xml):**
  ```xml
  <uses-permission android:name="android.permission.INTERNET"/>
  ```
  - **Why needed**: Android requires explicit permission for apps to access the internet.
  - **What happens without it**: The app cannot make any network requests, causing all API calls to fail.

  **Consequences of missing configurations:**
  - **No ALLOWED_HOSTS**: Django rejects all requests → 400 Bad Request
  - **No CORS**: Browser blocks requests → Network error
  - **No Cookie Settings**: Cookies not sent → Authentication fails
  - **No Internet Permission**: No network access → All requests fail

  ### 5. Describe the data transmission mechanism—from user input to being displayed in Flutter.

  **Step-by-step data flow (Fetching Products):**

  1. **User Action (Flutter)**
     - User taps "All Products" or "My Products" in the Flutter app.

  2. **HTTP Request (Flutter)**
     - Flutter makes an HTTP GET request to Django endpoint (`http://localhost:8000/json/` for web).
     - Request includes headers (Content-Type: application/json, Accept: application/json).

  3. **Network Transmission**
     - Request travels through the network (Flutter web → Django server).
     - For authenticated requests, cookies are automatically included by `CookieRequest`.

  4. **Django Processing**
     - Django receives the request at the `/json/` endpoint.
     - `show_json()` view queries the database for all Shop items.
     - Data is serialized to JSON format with all fields including `user_id` and `user_username`.

  5. **Response Reception (Flutter)**
     - Flutter receives the HTTP response (status 200).
     - Response body contains JSON array of product objects.

  6. **Model Conversion (Flutter)**
     - JSON data is converted to Dart model objects using `shopListFromJson()`.
     - Each product becomes a `Shop` object with type-safe fields.
     - Example: `List<Shop> shops = shopListFromJson(response.body)`

  7. **Filtering (Flutter)**
     - If "My Products" is selected, client-side filtering is applied.
     - Products are filtered by `userUsername` matching the logged-in user.

  8. **State Update (Flutter)**
     - Flutter updates the UI state with the product list.
     - `FutureBuilder` rebuilds with the new data.

  9. **Display (Flutter)**
     - `ListView.builder` renders each `Shop` as a `Card`.
     - Thumbnails are loaded via Django proxy endpoint to avoid CORS issues.
     - User sees the product list on screen.

  **Step-by-step data flow (Publishing Products):**

  1. **User Input (Flutter)**
     - User fills out the product form in `ItemListFormPage`.
     - Data is captured in form fields (name, price, description, thumbnail, category, size, stock, is_featured).

  2. **Data Preparation (Flutter)**
     - Form data is validated.
     - Numeric values are converted to strings for `CookieRequest.post()` compatibility.
     - Empty thumbnail is omitted (not sent as empty string).

  3. **HTTP Request (Flutter)**
     - `CookieRequest.post()` sends POST request to `http://localhost:8000/publish_product_ajax/`.
     - Request includes session cookies for authentication.
     - Data is sent as form-encoded format.

  4. **Django Processing**
     - `publish_product_ajax` view receives the request.
     - Data is parsed (handles both JSON and form data).
     - Type conversion: strings to integers for price, size, stock.
     - Form validation using `ShopForm`.
     - Product is saved to database with current user and timestamp.

  5. **Response (Django → Flutter)**
     - Django returns JSON: `{"status": "success", "message": "...", "id": "..."}`
     - Or error response with validation errors.

  6. **State Update (Flutter)**
     - Flutter receives success response.
     - Form is cleared.
     - User is navigated back to home page.
     - New product will appear in product list on next fetch.

  **Example from my implementation:**
  ```
  Fetching Products:
  User taps "All Products" 
  → Flutter calls fetchShop() 
  → HTTP GET to http://localhost:8000/json/
  → Django returns JSON array
  → Flutter parses JSON to List<Shop>
  → ListView.builder displays each Shop as a Card
  → Thumbnails loaded via /proxy/image/?url=<image_url>

  Publishing Products:
  User fills form and taps "Publish Product"
  → Flutter validates and prepares data
  → CookieRequest.post() to /publish_product_ajax/
  → Django validates and saves to database
  → Success response returned
  → Flutter navigates to home page
  ```

  ### 6. Explain the authentication mechanism for login, registration, and logout—from entering account data in Flutter to Django's authentication process and displaying the menu in Flutter.

  **Login Flow:**

  1. **User Input (Flutter)**
     - User enters username and password in `LoginPage`.
     - Form validation ensures fields are not empty.

  2. **Authentication Request (Flutter)**
     - `CookieRequest.login()` is called with credentials.
     - POST request sent to `http://10.0.2.2:8000/auth/login/` with username and password.

  3. **Django Authentication (Django)**
     - `login_flutter` view receives the request.
     - `authenticate()` verifies credentials against Django's user database.
     - If valid, `login()` creates a session and sets session cookies.

  4. **Response (Django → Flutter)**
     - Django returns JSON: `{"status": true, "username": "...", "message": "Login successful!"}`
     - Session cookies are automatically stored by `CookieRequest`.

  5. **State Update (Flutter)**
     - Flutter receives success response.
     - `CookieRequest` now has the session cookies stored.

  6. **Navigation (Flutter)**
     - User is navigated to `MyHomePage` (main menu).
     - Menu displays authenticated options.

  **Registration Flow:**

  1. **User Input (Flutter)**
     - User enters username, password, and password confirmation in `RegisterPage`.
     - Form validates password length and matching.

  2. **Registration Request (Flutter)**
     - `CookieRequest.post()` sends data to `http://10.0.2.2:8000/auth/register/`.

  3. **Django Processing (Django)**
     - `register_flutter` view validates passwords match and length.
     - `User.objects.create_user()` creates new user account.
     - Returns success response.

  4. **Navigation (Flutter)**
     - User is redirected to `LoginPage` to log in with new credentials.

  **Logout Flow:**

  1. **User Action (Flutter)**
     - User taps "Logout" in the drawer menu.

  2. **Logout Request (Flutter)**
     - `CookieRequest.logout()` sends request to `http://10.0.2.2:8000/auth/logout/`.

  3. **Django Processing (Django)**
     - `logout_flutter` view calls Django's `logout()` function.
     - Session is destroyed, cookies are cleared.

  4. **Navigation (Flutter)**
     - User is redirected to `LoginPage`.
     - `CookieRequest` no longer has valid session cookies.

  **Session Persistence:**
  - `CookieRequest` automatically includes session cookies in all subsequent requests.
  - This allows authenticated API calls without re-logging in.
  - Cookies persist until logout or session expiration.

  ### 7. Explain how you implemented the checklist above step-by-step (not just following a tutorial).

  **Step 1: Updated Dependencies**
  - Added `http`, `provider`, and `pbp_django_auth` to `pubspec.yaml`.
  - Ran `flutter pub get` to install packages.

  **Step 2: Created Shop Model**
  - Created `lib/models/shop.dart` with `Shop` class matching Django's Shop model.
  - Implemented `fromJson()` and `toJson()` methods for JSON serialization.
  - Added helper functions `shopFromJson()` and `shopListFromJson()` for parsing.

  **Step 3: Django Authentication Endpoints**
  - Added `login_flutter()`, `register_flutter()`, and `logout_flutter()` views in `main/views.py`.
  - Used `@csrf_exempt` decorator to allow Flutter requests.
  - Added URL routes in `main/urls.py` for `/auth/login/`, `/auth/register/`, `/auth/logout/`.

  **Step 4: Django Configuration**
  - Updated `ALLOWED_HOSTS` to include `10.0.2.2` for Android emulator.
  - Added CORS settings (`CORS_ALLOW_ALL_ORIGINS`, `CORS_ALLOW_CREDENTIALS`).
  - Configured cookie settings (`SAMESITE = 'Lax'`) for cross-origin cookie support.

  **Step 5: Android Permissions**
  - Added `<uses-permission android:name="android.permission.INTERNET"/>` to `AndroidManifest.xml`.

  **Step 6: Flutter Authentication Pages**
  - Created `lib/screens/login.dart` with form validation and `CookieRequest.login()` integration.
  - Created `lib/screens/register.dart` with password validation and registration logic.
  - Both pages show loading states and error messages.

  **Step 7: Provider Setup**
  - Updated `main.dart` to wrap app with `Provider<CookieRequest>`.
  - This shares the `CookieRequest` instance across all widgets.

  **Step 8: Shop List Page**
  - Created `lib/screens/shop_list.dart` that fetches data from `/json/` endpoint.
  - Used `http.get()` to retrieve shop items.
  - Implemented filtering logic to show only user's items when `showMyItemsOnly = true`.
  - Displayed items in a `ListView` with cards showing name, price, category, description, and thumbnail.
  - Added error handling with retry button and loading states.

  **Step 9: Shop Detail Page**
  - Created `lib/screens/shop_detail.dart` to show full product details.
  - Displays all Shop model attributes (name, price, description, category, size, stock, released date, seller).
  - Added "Back to List" button for navigation.
  - Thumbnail displayed with proper error handling.

  **Step 10: Publish Product Feature**
  - Updated `lib/itemlist_form.dart` to actually publish products to Django.
  - Integrated with `CookieRequest.post()` to send product data to `/publish_product_ajax/` endpoint.
  - Added form fields for all product attributes (name, price, description, thumbnail, category, size, stock, is_featured).
  - Implemented proper data type conversion (strings to integers for numeric fields).
  - Added loading states and error handling.
  - Form clears and navigates to home after successful publication.

  **Step 11: Image Proxy Endpoint (CORS Solution)**
  - Created `proxy_image` view in Django to solve CORS issues with external image URLs.
  - Django fetches images from external URLs and serves them with proper CORS headers.
  - Flutter uses proxy URL (`/proxy/image/?url=<encoded_url>`) instead of direct image URLs.
  - This allows thumbnails to display properly in Flutter web without CORS errors.

  **Step 12: Navigation Integration**
  - Updated `menu.dart` to navigate to `ShopListPage` when "All Products" or "My Products" is tapped.
  - Updated `left_drawer.dart` to add "All Products", "My Products", and "Logout" options.
  - Logout functionality calls `CookieRequest.logout()` and redirects to login.
  - "Create Product" button navigates to `ItemListFormPage` for publishing products.

  **Step 13: JSON Endpoint Enhancement**
  - Updated `show_json()` view to include `user_id` and `user_username` in the response.
  - This enables filtering by user in the Flutter app.
  - Added proper handling for null thumbnail values.

  **Step 14: Django Publish Product Endpoint**
  - Created `publish_product_ajax` view in Django to handle product creation from Flutter.
  - Handles both JSON and form data formats.
  - Properly converts data types (strings to integers, boolean handling).
  - Returns appropriate error messages for validation failures.
  - Includes CORS headers for Flutter web compatibility.

  **Key Implementation Decisions:**
  - Used `localhost:8000` for Flutter web (Chrome) instead of `10.0.2.2` (which is for Android emulator).
  - Implemented client-side filtering for "My Products" using `SharedPreferences` to store username.
  - Used `FutureBuilder` for async data loading with proper error handling.
  - Created image proxy endpoint to solve CORS issues with external image URLs.
  - Maintained consistent UI theme across all new pages.
  - Added proper loading states and error messages for better UX.
  - Implemented robust data type conversion to handle form data properly.

</details>
