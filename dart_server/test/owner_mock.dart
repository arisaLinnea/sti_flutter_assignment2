import 'package:shared/shared.dart';

Owner owner = Owner(
    name: 'Test Testsson',
    ssn: '1234567890',
    id: 'f8f1c441-eab5-419f-817d-f8afe719f7f1');

List<Owner> ownerList = [owner];

List<Map<String, dynamic>> ownerJsonList = [owner.toJson()];
