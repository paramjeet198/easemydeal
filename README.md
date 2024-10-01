# Flutter Data Fetching and Filtering Task by easemydeal

### Overview
This Flutter application fetches data from a given API, displays the data in a ListView, and provides filtering options to sort the data by week, date, and month. The app demonstrates effective use of state management and modern Flutter practices.

### Features
- **API Integration**: Fetches data from the specified API.
- **Data Display**: Presents fetched data in a clean and responsive ListView.
- **Filtering Options**: Sorts data based on week, date, and month.
- **State Management**: Utilizes Riverpod for managing app state effectively.
- **UI Enhancements**: Implements loading indicators and error handling for a smooth user experience.

### API
- **Data Source**: The application retrieves data from https://ixifly.in/flutter/task1.
- **Data Format**: The API returns a JSON array of items, where each item contains:
  - **title**: String
  - **date**: String (formatted as YYYY-MM-DD)
  - **description**: String

```
[
  {
    "title": "Event 1",
    "date": "2024-06-01",
    "description": "Description for Event 1"
  },
  {
    "title": "Event 2",
    "date": "2024-06-03",
    "description": "Description for Event 2"
  }
]
```

### Implementation Steps
### 1. Setup
- Created a new Flutter project.
- Added dependencies for HTTP requests, date handling, and state management.
### 2. API Integration
- Developed a Dart model class to represent the data structure.
- Implemented data fetching using the dio package to handle API requests.
- Parsed the fetched data and stored it in a list.
### 3. ListView Display
- Used a ListView to display the list of events.
- Each item is presented using ListTile, showcasing the title, date, and description.
### 4. Filtering Functionality
- Added bottomsheet with checkboxes to filter data by:
 - Week
 - Date
 - Month
- Implemented logic to dynamically filter and update the displayed data based on user selections.
5. Bonus Features
- Incorporated pull-to-refresh functionality to allow users to update data easily.
- Managed loading and error states with visual feedback using shimmer effects.
