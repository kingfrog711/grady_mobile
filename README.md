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
  It’s used to quickly see UI or logic changes without restarting the app.  
  Hot restart rebuilds the entire app from scratch and resets all states.  
  In short, hot reload is faster and keeps your progress, while hot restart fully restarts the app.  


</details>
