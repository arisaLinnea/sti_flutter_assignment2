// import 'package:flutter/material.dart';

// // Builds the welcome text section
// Widget _buildWelcomeText(BuildContext context) {
//   return Column(
//     children: [
//       Text(
//         'Welcome to',
//         style: Theme.of(context).textTheme.headlineLarge,
//       ),
//       Text(
//         'Find Me A Spot',
//         style: Theme.of(context).textTheme.headlineLarge,
//       ),
//     ],
//   );
// }

// // Builds the username input field
// Widget _buildUsernameField(
//   FocusNode usernameFocus,
//   AuthState authState,
//   Function(String?) onSaved,
// ) {
//   return TextFormField(
//     focusNode: usernameFocus,
//     onSaved: onSaved,
//     enabled: authState.status != AuthStatus.loading,
//     decoration: const InputDecoration(
//       labelText: 'Username',
//       prefixIcon: Icon(Icons.person),
//     ),
//     validator: (value) =>
//         value?.isValidEmail() ?? true ? null : 'Please enter a username/email',
//     onFieldSubmitted: (_) =>
//         FocusScope.of(usernameFocus.context).requestFocus(passwordFocus),
//   );
// }
