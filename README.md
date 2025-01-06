# E-Commerce App Frontend

## Overview

This document outlines the planned features and functionality for the frontend of an e-commerce application. The design focuses on delivering a user-friendly and dynamic shopping experience, with several components still under development.

---

## Key Features

1. **Language Selection**

   - Allows users to select their preferred language during the onboarding process.

2. **Optional Permission Popups**

   - Users can grant permissions for optional features such as location services.

3. **Login Flow**

   - Offers a guest session option for users who prefer not to log in.
   - Skipping login redirects users directly to the product catalog.

4. **Product Catalog**

   - Products are organized into categories, with options for filtering and sorting search results.

5. **Product Rating and Reviews** *(Planned)*

   - Enables users to view and leave reviews and ratings for products.

6. **Cart Flow**

   - Includes item management, fee calculations, and checkout options *(checkout functionality is not yet implemented)*.

7. **Deep Linking for Products** *(Planned)*

   - Provides direct links to specific products for sharing or external navigation.

8. **Togglable Themes**

   - Offers light and dark mode options for a customizable user experience.

9. **Offline Data Storage**

   - Ensures essential data is stored locally for smoother performance during offline sessions.

10. **Dynamic and Configurable Widgets** *(Planned)*

    - Features a separate widget service to manage and update widgets dynamically.

---

## Screens and Flows

### 1. Splash/Logo Screen

- Displays the app logo along with the current version number at the bottom.

### 2. Welcome and Onboarding Flow

- Introduces users to the app and its key features.

### 3. Language Selection

- Allows users to choose their preferred language.

### 4. Signup/Login Flow

- Provides optional signup or login functionality.
- Guest users see localized products based on their current location.

### 5. Home Page

- **Back to Top Button** (optional).
- **App Bar:** Features a hamburger menu, profile icon, and cart icon.
- **Search Bar:** Opens a dedicated screen for product search, with filtering and sorting options.
- **Horizontal Offer Carousel:** Highlights deals and promotions.
- **Categories Grid:** Displays product categories (no separate categories page due to the limited number of categories).

### 6. Profile Details *(Planned)*

- Displays user information such as name, phone number, and address.

### 7. Cart Info Page

- Shows current cart items with options to add, remove, or modify them.
- Includes checkout functionality *(not implemented yet)*.

### 8. Order History *(Planned)*

- Allows users to view details of their past orders.

### 9. Support *(Planned)*

- Provides assistance for common issues and queries.

### 10. Terms and Conditions *(Planned)*

- Includes a dedicated page for app terms and policies.

---

## Current Gaps

- **Checkout Option:** Not yet implemented.
- **Order History:** Planned for future versions.
- **Support Section:** Under development.
- **Terms and Conditions Page:** Yet to be added.
- **Optional Permission Popups:** Partial integration.
- **Profile Details:** Work in progress.
- **Deep Linking for Products:** Not yet available.
- **Product Rating and Reviews:** Planned for future updates.

---

## Future Enhancements

- **Dynamic Widgets:** Enable widget configuration through an external service for improved flexibility.
- **Enhanced Localization:** Fully localize all components for a broader range of languages.
- **Improved Offline Capabilities:** Expand offline functionality to include additional features.

---

## Notes

This README is a work in progress and will be updated as new features are implemented.
