  Database Design

   Users Collection

* userId
* name
* email
* password

 Workouts Collection

* workoutId
* userId
* type
* duration
* caloriesBurned
* date

 Progress Collection

* progressId
* userId
* weight
* date

 Relationships

* One user → many workouts
* One user → many progress records
