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
