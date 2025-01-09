# sti_flutter_assignment2

Fourth assignment on my Dart/Flutter course at STI

# 1. Start applications

## 1.1 Admin

- Dependancies updated with `flutter pub get`.
- Make sure server is running with `dart run` in /dart_server root.
- This application I have started with `flutter run -d "macOS" ` in /parking_admin root.
  (It's been tested in Mac OS Desktop simulator).

## 1.2 User

- Dependancies updated with `flutter pub get`.
- Make sure server is running with `dart run` in /dart_server root.
- This application I have started with `flutter run -d "IPhone 16"` in /parking_user root.
  (It's been tested in IPhone 16 simulator.)

# 2 Features

Changes since previous version/assignment:

- Replaced providers with BLoC (see section about BLoC)
- Test for all BLoCs
- Some new editing options. It's now possible to edit a Vehicle in the user application, and edit Parking lot in the admin application.

## 2.1 BLoCs

All providers except theme provider has been replaced with BloC.

1. **Admin**:

- Auth Bloc: handles login in admin (verify simple since there is no check that username and password is correct)

2. **User**:

- Auth Bloc: Handles login in user application (Login- and logout event)
- User Bloc: Handles registration of user/owner. (Only create event. No option to update, delete or list users/owners)
- Vehicle Bloc: Handles add/list/update/delete (CRUD) of vehicles.

3. **Shared_client** (shared blocs between admin and user)

- Parking Lot Bloc: Handles CRUD for parking lots
- Parking Bloc: Handles CRUD for parkings

# 3. Limits

BlocProviders not always on right level in code tree.

Limits left from previous assignment

- There are no checks that username doesn't already exist when creating a new useraccount/owner.
- No validation on admin login. (User can write whatever he/she wants)
- Not the best responsive design
- No option to edit the user/owner.
