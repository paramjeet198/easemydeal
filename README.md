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
