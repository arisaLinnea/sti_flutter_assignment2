import 'package:shared/shared.dart';

Vehicle newVehicle = Vehicle(
  id: 'af75d24f-68d3-4e81-8001-59df5454fbb7',
  registrationNo: 'MMM111',
  type: CarBrand.BMW,
  owner: mockOwner,
);

Owner mockOwner = Owner(id: '123', ssn: '', name: '');
UserLogin mockUserLogin = UserLogin(ownerId: '123', userName: '', pwd: '');

const mockUsername = 'test@example.com';
const mockPassword = 'test123';
const mockName = 'Test Testsson';
const mockSsn = '9901011234';
