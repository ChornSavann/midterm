# Flutter GetX Employee App

GetX + REST API (dummyjson.com) + Repository Pattern + JWT Auth.

## Run
```
flutter create flutter_getx_app
cd flutter_getx_app
# replace pubspec.yaml and the lib/ folder with the ones from this project
flutter pub get
flutter run
```
Android release builds need in android/app/src/main/AndroidManifest.xml:
`<uses-permission android:name="android.permission.INTERNET"/>`

## Demo login
username: `emilys`  password: `emilyspass`

## Structure
- core/         Dio client, JWT interceptor, error messages
- models/       Product, Employee, UserProfile
- repositories/ abstract interface + implementation per feature
- controllers/  GetX controllers (state, loading, errors)
- views/        Login, Home (tabs), Products, Employees, Employee form
- routes/       GetPages and Bindings

## Note
dummyjson only simulates POST/PUT/DELETE (nothing is saved on the server),
so the controller updates the local list after each successful call.
