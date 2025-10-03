# ThalaXYa

A fish market management iOS application built with Swift and Core Data.

## Overview

ThalaXYa is an iOS application designed for fish market operations. It provides user authentication, inventory management, and transaction processing capabilities for both administrators and buyers.

## Features

- User registration and authentication
- Role-based access control (Admin/Buyer)
- Fish inventory management (CRUD operations)
- User balance and top-up system
- Transaction history tracking
- Responsive table view interfaces

## Technical Stack

- **Language**: Swift 5
- **Framework**: UIKit
- **Database**: Core Data
- **Architecture**: MVC
- **Platform**: iOS 14.0+

## Project Structure

```
ThalaXYa/
├── AppDelegate.swift              # App lifecycle management
├── SceneDelegate.swift            # Scene configuration
├── CoreDataManager.swift          # Core Data operations
├── LoginViewController.swift      # Authentication interface
├── FishListTableViewController.swift    # Fish inventory management
├── AddEditFishViewController.swift      # Fish CRUD operations
├── AdminHomeViewController.swift        # Admin dashboard
├── BuyerHomeViewController.swift        # Buyer interface
├── TransactionTableViewController.swift # Transaction history
└── TopUpViewController.swift            # Balance management
```

## Installation

1. Clone the repository
   ```
   git clone https://github.com/your-username/ThalaXYa.git
   ```

2. Open `ThalaXYa.xcodeproj` in Xcode

3. Build and run the project (Cmd + R)

## Requirements

- Xcode 12.0+
- iOS 14.0+
- Swift 5.0+

## Core Data Model

The application uses three main entities:
- **User**: Authentication and role management
- **Fish**: Inventory items with name, weight, price, and date
- **Transaction**: Purchase and payment records

## Usage

1. Launch the app and register/login
2. Navigate to role-specific dashboard
3. Manage fish inventory (Admin) or browse/purchase (Buyer)
4. View transaction history and manage account balance

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

MIT License

## Author

Created by Hush (September 2025)