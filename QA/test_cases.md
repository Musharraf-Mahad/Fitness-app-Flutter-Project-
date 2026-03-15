# FitTrack – Test Cases

## 1. Introduction

This document contains the test cases used to verify the functionality of the **FitTrack Fitness Tracker Application**. Each test case ensures that a specific feature behaves as expected.

---

# 2. Test Cases Table

| Test ID | Feature          | Test Description             | Steps                                          | Expected Result                               | Status  |
| ------- | ---------------- | ---------------------------- | ---------------------------------------------- | --------------------------------------------- | ------- |
| TC01    | Registration     | Register new user            | Enter name, email, password and press register | User account is created successfully          | Pending |
| TC02    | Login            | Login with valid credentials | Enter correct email and password               | User is logged in and redirected to dashboard | Pending |
| TC03    | Login Validation | Login with wrong password    | Enter correct email but wrong password         | Error message displayed                       | Pending |
| TC04    | Dashboard        | View dashboard data          | Login successfully                             | Dashboard shows steps, calories, distance     | Pending |
| TC05    | Navigation       | Navigate to Step Tracker     | Click Steps icon in bottom navigation          | Step Tracker screen opens                     | Pending |
| TC06    | Step Tracker     | View step progress           | Open Step Tracker screen                       | Progress circle and step count displayed      | Pending |
| TC07    | Workout Start    | Start workout session        | Click "Start Workout" button                   | Workout session starts                        | Pending |
| TC08    | Workout Stop     | Stop workout session         | Click stop button                              | Workout session ends and time is recorded     | Pending |
| TC09    | Goals            | Set daily step goal          | Enter goal value and save                      | Goal is stored and displayed                  | Pending |
| TC10    | Profile          | View user profile            | Open profile screen                            | Profile information displayed                 | Pending |
| TC11    | Edit Profile     | Update profile information   | Click edit profile and modify data             | Updated information saved                     | Pending |
| TC12    | Logout           | Logout user                  | Click logout button                            | User is redirected to login screen            | Pending |

---

# 3. Test Case Status Legend

| Status  | Meaning                 |
| ------- | ----------------------- |
| Pending | Test not executed yet   |
| Passed  | Feature works correctly |
| Failed  | Feature has an error    |

---


