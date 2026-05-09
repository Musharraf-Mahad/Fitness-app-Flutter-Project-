# FitTrack Manual Test Cases

## Test Cases Table

| Test ID | Feature | Test Description | Steps | Expected Result | Status |
|---|---|---|---|---|---|
| TC01 | Registration | Register new user | Enter name, email, password and press register | User account is created successfully | Pass |
| TC02 | Login | Login with valid credentials | Enter correct email and password | User is logged in and redirected to dashboard | Pass |
| TC03 | Login Validation | Login with wrong password | Enter correct email but wrong password | Error message displayed | Pass |
| TC04 | Dashboard | View dashboard data | Login successfully | Dashboard shows steps, calories, distance | Pass |
| TC05 | Navigation | Navigate to Step Tracker | Click Steps icon in bottom navigation | Step Tracker screen opens | Pass |
| TC06 | Step Tracker | View step progress | Open Step Tracker screen | Progress circle and step count displayed | Pass |
| TC07 | Workout Start | Start workout session | Click "Start Workout" button | Workout session starts | Pass |
| TC08 | Workout Stop | Stop workout session | Click stop button | Workout session ends and time is recorded | Pass |
| TC09 | Goals | Set daily step goal | Enter goal value and save | Goal is stored and displayed | Pass |
| TC10 | Profile | View user profile | Open profile screen | Profile information displayed | Pass |
| TC11 | Edit Profile | Update profile information | Click edit profile and modify data | Updated information saved | Pass |
| TC12 | Logout | Logout user | Click logout button | User is redirected to login screen | Pass |
| TC13 | Dark Mode | Enable dark mode | Toggle dark mode switch | App theme changes successfully | Pass |
| TC14 | Realtime Sync | Sync dashboard and workout | Complete workout session | Dashboard updates instantly | Pass |
| TC15 | Firebase Firestore | Store user data | Save user profile/workout data | Data stored successfully in Firestore | Pass |

---

## Testing Summary

- All core modules were tested manually.
- Authentication and Firestore integration worked successfully.
- Realtime synchronization between Dashboard, Workout, and Steps screens was verified.
- User profile management and dark mode functionality worked correctly.