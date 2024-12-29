import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:parking_user/blocs/vehicle/vehicle_bloc.dart';

import 'package:shared/shared.dart';
import 'package:shared_client/shared_client.dart';

import '../mocks/vehicle_mocks.dart';

class FakeVehicle extends Fake implements Vehicle {}

class MockVehicleRepo extends Mock implements VehicleRepository {}

void main() {
  late VehicleBloc vehicleBloc;
  late MockVehicleRepo mockVehicleRepository;

  setUp(() {
    mockVehicleRepository = MockVehicleRepo();
    vehicleBloc = VehicleBloc(vehicleRepository: mockVehicleRepository);
  });

  setUpAll(() {
    registerFallbackValue(newVehicle);
  });

  tearDown(() {
    vehicleBloc.close();
  });

  group('VehicleBloc Tests', () {
    test('initial state is VehicleInitial', () {
      expect(vehicleBloc.state, equals(VehicleInitial()));
    });

    blocTest<VehicleBloc, VehicleState>(
      'emits VehicleSuccess when RemoveVehicleEvent is successful',
      setUp: () {
        // Arrange: Mock the repository to return true for remove
        when(() => mockVehicleRepository.remove(id: any(named: 'id')))
            .thenAnswer((_) async => true);
        when(() => mockVehicleRepository.getList())
            .thenAnswer((_) async => [newVehicle]);
      },
      build: () => vehicleBloc,
      act: (bloc) => bloc.add(RemoveVehicleEvent(vehicleId: '123')),
      expect: () => [
        VehicleLoading(),
        VehicleSuccess('Vehicle removed successfully'),
        VehicleLoaded(vehicles: [newVehicle]),
      ],
    );

    blocTest<VehicleBloc, VehicleState>(
      'emits VehicleFailure when RemoveVehicleEvent fails',
      setUp: () {
        // Arrange: Mock the repository to return false for remove
        when(() => mockVehicleRepository.remove(id: any(named: 'id')))
            .thenAnswer((_) async => false);
      },
      build: () => vehicleBloc,
      act: (bloc) => bloc.add(RemoveVehicleEvent(vehicleId: '123')),
      expect: () => [
        VehicleLoading(),
        VehicleFailure('Failed to remove vehicle'),
      ],
    );

    blocTest<VehicleBloc, VehicleState>(
      'emits VehicleSuccess when AddVehicleEvent is successful',
      setUp: () {
        // Arrange: Mock the repository to return a valid vehicle ID
        when(() => mockVehicleRepository.addToList(item: any(named: 'item')))
            .thenAnswer((_) async => 'new_vehicle_id');
      },
      build: () => vehicleBloc,
      act: (bloc) => bloc.add(AddVehicleEvent(vehicle: newVehicle)),
      expect: () => [
        VehicleLoading(),
        VehicleSuccess('Vehicle added successfully'),
      ],
    );

    blocTest<VehicleBloc, VehicleState>(
      'emits VehicleFailure when AddVehicleEvent fails',
      setUp: () {
        // Arrange: Mock the repository to return null for add
        when(() => mockVehicleRepository.addToList(item: any(named: 'item')))
            .thenAnswer((_) async => null);
      },
      build: () => vehicleBloc,
      act: (bloc) => bloc.add(AddVehicleEvent(vehicle: newVehicle)),
      expect: () => [
        VehicleLoading(),
        VehicleFailure('Failed to add vehicle'),
      ],
    );
  });
}


/*
blocTest<ItemsBloc, ItemsState>("create item test",
          setUp: () {
            when(() => itemRepository.create(any()))
                .thenAnswer((_) async => newItem);
            when(() => itemRepository.getAll())
                .thenAnswer((_) async => [newItem]);
          },
          build: () => ItemsBloc(repository: itemRepository),
          seed: () => ItemsLoaded(items: []),
          act: (bloc) => bloc.add(CreateItem(item: newItem)),
          expect: () => [
                ItemsLoaded(items: [newItem])
              ],
          verify: (_) {
            verify(() => itemRepository.create(newItem)).called(1);
          });
    });
*/