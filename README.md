<div align="center">
  <img src="ThalaXYa/Assets.xcassets/Logo%20Icon.imageset/logo_baru-removebg-preview.png" alt="ThalaXYa Logo" width="200" />
</div>

# ThalaXYa 🐟

A fish market management iOS application built natively using Swift and Core Data. 

**Note:** This is a group project developed to fulfill the requirements for the **MOBI6009001 - LAB** course at **Binus University**.

## What is this?
ThalaXYa is an iOS app built to handle fish market operations. We wanted to make something that works for both administrators (who manage the stock) and regular buyers (who buy the fish). It covers everything from logging in to keeping track of the inventory and handling the actual transactions.

## Features
- **Account System:** Register and log in securely.
- **Roles:** Separate views and controls for Admins and Buyers.
- **Inventory Management:** Admins can add, edit, or delete fish stocks.
- **Wallet/Balance:** Users can top-up their balance to buy things.
- **Transactions:** Keep track of who bought what and when.
- **Native UI:** Clean table views built with UIKit.

## Tech Stack
- **Language:** Swift 5
- **Framework:** UIKit
- **Database:** Core Data
- **Architecture:** MVC
- **Target:** iOS 14.0+

## Screenshots
Here's a quick look at the app in action:

| Login | User Home | Buying Fish |
|-------|-----------|-------------|
| <img src="Screenshot/LoginScreen.png" width="200"/> | <img src="Screenshot/HomeScreenUser.png" width="200"/> | <img src="Screenshot/BuyingFishScreen.png" width="200"/> |

| Admin Home | Add/Edit Fish | Transactions |
|------------|---------------|--------------|
| <img src="Screenshot/AdminHomeScreen.png" width="200"/> | <img src="Screenshot/AdminEditFish.png" width="200"/> | <img src="Screenshot/TransactionHistoryUser.png" width="200"/> |

## Getting Started
If you want to run this project locally:

1. Clone the repo:
   ```bash
   git clone https://github.com/ghtmarco/ThalaXYa.git
   ```
2. Open `ThalaXYa.xcodeproj` in Xcode.
3. Hit `Cmd + R` to build and run it on a simulator.

*Requires Xcode 12+ and iOS 14+.*

## License
MIT License