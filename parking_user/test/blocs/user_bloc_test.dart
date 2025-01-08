import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:parking_user/blocs/user/user_reg_bloc.dart';
import 'package:shared_client/shared_client.dart';

import '../mocks/mock_data.dart';

class MockUserLoginRepository extends Mock implements UserLoginRepository {}

class MockOwnerRepository extends Mock implements OwnerRepository {}

void main() {
  late MockUserLoginRepository mockUserLoginRepository;
  late MockOwnerRepository mockOwnerRepository;
  late UserRegBloc userRegBloc;

  setUp(() {
    mockUserLoginRepository = MockUserLoginRepository();
    mockOwnerRepository = MockOwnerRepository();
    userRegBloc = UserRegBloc(
        userLoginRepository: mockUserLoginRepository,
        ownerRepository: mockOwnerRepository);
  });

  setUpAll(() {
    registerFallbackValue(mockOwner);
    registerFallbackValue(mockUserLogin);
  });

  tearDown(() {
    userRegBloc.close();
  });

  group('UserRegBloc Tests', () {
    test('initial state is UserRegInitialState', () {
      expect(userRegBloc.state, equals(UserRegInitialState()));
    });

    blocTest<UserRegBloc, UserRegState>(
      'emits AuthRegistrationState when registration is successful',
      build: () {
        when(() => mockOwnerRepository.addToList(item: any(named: 'item')))
            .thenAnswer((_) async => 'owner-123');
        when(() => mockUserLoginRepository.addToList(item: any(named: 'item')))
            .thenAnswer((_) async => 'user-123');
        return userRegBloc;
      },
      act: (bloc) => bloc.add(
        UserRegisterEvent(
          username: username,
          password: password,
          name: name,
          ssn: ssn,
        ),
      ),
      expect: () => [
        UserRegLoadingState(),
        AuthRegistrationState(),
      ],
      verify: (_) {
        verify(() => mockOwnerRepository.addToList(item: any(named: 'item')))
            .called(1);
        verify(() =>
                mockUserLoginRepository.addToList(item: any(named: 'item')))
            .called(1);
      },
    );

    blocTest<UserRegBloc, UserRegState>(
      'emits UserRegFailedState when OwnerRepository fails to add owner',
      build: () {
        when(() => mockOwnerRepository.addToList(item: any(named: 'item')))
            .thenAnswer((_) async => null); // Simulate failure to add owner
        return userRegBloc;
      },
      act: (bloc) => bloc.add(
        UserRegisterEvent(
          username: username,
          password: password,
          name: name,
          ssn: ssn,
        ),
      ),
      expect: () => [
        UserRegLoadingState(),
        UserRegFailedState(message: 'Failed to add account'),
      ],
      verify: (_) {
        verify(() => mockOwnerRepository.addToList(item: any(named: 'item')))
            .called(1);
        verifyNever(
            () => mockUserLoginRepository.addToList(item: any(named: 'item')));
      },
    );

    blocTest<UserRegBloc, UserRegState>(
      'emits UserRegFailedState when UserLoginRepository fails to add user login',
      build: () {
        when(() => mockOwnerRepository.addToList(item: any(named: 'item')))
            .thenAnswer((_) async => 'uuid-123');
        when(() => mockUserLoginRepository.addToList(item: any(named: 'item')))
            .thenAnswer(
                (_) async => null); // Simulate failure to add login user
        return userRegBloc;
      },
      act: (bloc) => bloc.add(
        UserRegisterEvent(
          username: username,
          password: password,
          name: name,
          ssn: ssn,
        ),
      ),
      expect: () => [
        UserRegLoadingState(),
        UserRegFailedState(message: 'Failed to add account'),
      ],
      verify: (_) {
        verify(() => mockOwnerRepository.addToList(item: any(named: 'item')))
            .called(1);
        verify(() =>
                mockUserLoginRepository.addToList(item: any(named: 'item')))
            .called(1);
      },
    );
  });
}
