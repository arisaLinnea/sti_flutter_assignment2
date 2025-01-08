import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:parking_user/blocs/auth/auth_bloc.dart';
import 'package:shared_client/shared_client.dart';

import '../mocks/mock_data.dart';

class MockUserLoginRepository extends Mock implements UserLoginRepository {}

void main() {
  late MockUserLoginRepository mockUserLoginRepository;
  late AuthBloc authBloc;

  setUp(() {
    mockUserLoginRepository = MockUserLoginRepository();
    authBloc = AuthBloc(userLoginRepository: mockUserLoginRepository);
  });

  setUpAll(() {
    registerFallbackValue(mockOwner);
    registerFallbackValue(mockUserLogin);
  });

  tearDown(() {
    authBloc.close();
  });

  group('AuthBloc Tests', () {
    test('initial state is AuthInitialState', () {
      expect(authBloc.state, equals(AuthInitialState()));
    });

    blocTest<AuthBloc, AuthState>(
      'emits AuthAuthenticatedState when login is successful',
      build: () {
        when(() =>
                mockUserLoginRepository.canUserLogin(user: any(named: 'user')))
            .thenAnswer((_) async => mockOwner);
        return authBloc;
      },
      act: (bloc) => bloc.add(
        AuthLoginEvent(email: username, password: password),
      ),
      expect: () => [
        AuthLoadingState(),
        AuthAuthenticatedState(newUser: mockOwner),
      ],
      verify: (_) {
        verify(() =>
                mockUserLoginRepository.canUserLogin(user: any(named: 'user')))
            .called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits AuthFailedState when login is unsuccessful',
      build: () {
        when(() =>
                mockUserLoginRepository.canUserLogin(user: any(named: 'user')))
            .thenAnswer((_) async => null);
        return authBloc;
      },
      act: (bloc) => bloc.add(
        AuthLoginEvent(email: username, password: password),
      ),
      expect: () => [
        AuthLoadingState(),
        AuthFailedState(message: 'Login Failed'),
        AuthUnauthorizedState(),
      ],
      verify: (_) {
        verify(() =>
                mockUserLoginRepository.canUserLogin(user: any(named: 'user')))
            .called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits AuthUnauthorizedState when logout is successful',
      build: () => authBloc,
      act: (bloc) => bloc.add(AuthLogoutEvent()),
      expect: () => [
        AuthUnauthorizedState(),
      ],
    );
  });
}
