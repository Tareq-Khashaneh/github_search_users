## Overview

This Flutter application allows users to search for GitHub profiles by username in real time.  
It provides detailed information about each user, including avatar, name, bio, company, location, number of followers, and public repositories.  
Users can also open the GitHub profile in their browser directly from the app.  

The app is built using GetX for state management and navigation, ensuring a reactive and smooth user experience.  
It includes unit, widget, and integration tests to maintain code quality and ensure proper functionality.

## Features

- **Real-time Search**: Fetch and display autocomplete suggestions from GitHub as users type.  
- **Debouncing**: Optimizes API calls to prevent unnecessary requests while typing.  
- **Dropdown Suggestions**: Displays the top 10 matching users dynamically below the search bar.  
- **User Selection**: Clicking a suggestion displays user details, including avatar and GitHub profile link.  
- **Error Handling**: Gracefully handles network failures, empty responses, and API errors.  
- **Testing**: Includes unit, widget, and integration tests to ensure proper functionality.  

- **Sorting Logic for Results**:
  - Users with 50+ public repositories are prioritized at the top.
  - Among those, users who have committed in the last 6 months appear first.
  - If both conditions are equal, results are sorted by GitHub's default relevance score.
