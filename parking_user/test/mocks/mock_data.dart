import 'package:shared/shared.dart';

Vehicle newVehicle = Vehicle(
  id: 'af75d24f-68d3-4e81-8001-59df5454fbb7',
  registrationNo: 'MMM111',
  type: CarBrand.BMW,
  owner: mockOwner,
);

Owner mockOwner = Owner(id: '123', ssn: '', name: '');
UserLogin mockUserLogin = UserLogin(ownerId: '123', userName: '', pwd: '');

const username = 'test@example.com';
const password = 'test123';
const name = 'Test Testsson';
const ssn = '9901011234';
