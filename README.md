# MagicNumbers

**MagicNumbers** is an iOS application that provides interesting facts about numbers. Users can input any number to get a fact or fetch a random math fact. The app keeps a history of all viewed facts. Built with Swift and UIKit.

## Screenshots

<div style="display: flex; justify-content: space-between;">
  <img src="https://github.com/user-attachments/assets/0f1b0e7a-d9b9-4e69-bf13-7b2c5378cf3a" width="30%" />
  <img src="https://github.com/user-attachments/assets/32e54729-f0f0-4389-a135-2373703a6f33" width="30%" />
  <img src="https://github.com/user-attachments/assets/76c9af40-5260-4157-9c3d-c3df16be68e7" width="30%" />
</div>

## Features

- Fetch facts for any number via the Numbers API
- Get random math facts
- Local history of all fetched facts
- Async/await networking with error handling and popups
- MVVM architecture for clean code separation
- CoreData for persistent storage
- Activity indicators for network requests

## Architecture

- MVVM for separation of concerns
- Repository pattern for CoreData access
- NumbersAPIService handles API requests asynchronously
- Technologies & Frameworks
- Swift, UIKit
- CoreData
- REST APIs
- Async/Await networking
- Xcode 15+

## 🚀 Getting Started

### Minimum Requirements
- **iOS Version**: 18.0 or later  
- **Technologies Used**: Swift, UIKit 
- **Branch to Run**: `main`

### Installation

1. **Clone the repository**:  
   ```bash
   git clone https://github.com/dioksa/MagicNumbers.git
2. Open the project in Xcode:
   ```bash
   open MagicNumbers.xcodeproj
3. Build and run the app: Use the iOS Simulator or a physical device running iOS 18.0 or later.

## Usage

- Enter any number and tap "Get Fact" to retrieve a fact
- Tap "Random Fact" to fetch a random math fact
- View your history in the list below
- Tap a history item to see the detailed fact

## Error Handling

- Popups are shown for network errors or invalid inputs
- Invalid URLs or server issues do not save errors to history

## Contributing

Feel free to fork and submit pull requests. Ensure any new features follow MVVM principles and use async/await for networking.

