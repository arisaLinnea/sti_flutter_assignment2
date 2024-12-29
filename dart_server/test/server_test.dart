import 'dart:convert';
import 'dart:io';

import 'package:dart_server/api/handle.dart';
import 'package:dart_server/repositories/owner_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';
import 'package:logger/logger.dart';

import 'owner_mock.dart';
import 'server_test.mocks.dart';

@GenerateMocks([OwnerRepository, Logger])
void main() {
  final port = '8080';
  final host = 'http://0.0.0.0:$port';

  group('Add owner - ', () {
    late Process p;
    late MockOwnerRepository mockOwnerRepo;
    late MockLogger mockLogger;
    Request mockRequest;

    setUp(() async {
      mockOwnerRepo = MockOwnerRepository();
      mockLogger = MockLogger();
      p = await Process.start(
        'dart',
        [
          'run',
          'bin/server.dart',
          '--mockRepo=$mockOwnerRepo'
        ], // Pass the mock repository
        mode: ProcessStartMode.detached,
      );
      await Future.delayed(Duration(seconds: 1));
      // Wait for server to start and print to stdout.
      // await p.stdout.first;
    });
    tearDown(() => p.kill());
    // test('get the list', () async {
    //   when(await mockOwnerRepo.getList()).thenAnswer((_) => ownerJsonList);
    //   when(mockOwnerRepo.serialize(ownerList[0]))
    //       .thenAnswer((_) => ownerList[0].toJson());
    //   final response = await get(Uri.parse('$host/api/owner'));
    //   print('response: ${response.body}');
    //   expect(response.statusCode, 200);
    //   // expect(response.body, [ownerList[0].toJson()]);
    // });

    test('add to list -  should return 200 on success', () async {
      when(mockOwnerRepo.itemAsString()).thenAnswer((_) => 'owner');
      when(mockOwnerRepo.addToList(json: anyNamed('json')))
          .thenAnswer((_) async => '1');

      mockRequest = Request('POST', Uri.parse('$host/api/owner'),
          body: jsonEncode(owner.toJson()));

      var response = await addItemHandler(mockRequest, mockOwnerRepo);

      expect(response.statusCode, 200);
    });

    test('add to list - decode error', () async {
      when(mockOwnerRepo.itemAsString()).thenAnswer((_) => 'owner');

      mockRequest =
          Request('POST', Uri.parse('$host/api/owner'), body: 'invalid-json');

      var response = await addItemHandler(mockRequest, mockOwnerRepo);

      expect(response.statusCode, 400);
      expect(await response.readAsString(), contains('Failed to decode JSON'));
    });
    test('add to list - file error', () async {
      when(mockOwnerRepo.itemAsString()).thenAnswer((_) => 'owner');
      when(mockOwnerRepo.addToList(json: anyNamed('json')))
          .thenThrow(FileSystemException('File error'));

      mockRequest = Request('POST', Uri.parse('$host/api/owner'),
          body: jsonEncode(owner.toJson()));

      var response = await addItemHandler(mockRequest, mockOwnerRepo);

      expect(response.statusCode, 500);
      expect(await response.readAsString(), contains('Error with file'));
    });
  });

  // test('Echo', () async {
  //   final response = await get(Uri.parse('$host/echo/hello'));
  //   expect(response.statusCode, 200);
  //   expect(response.body, 'hello\n');
  // });

  // test('404', () async {
  //   final response = await get(Uri.parse('$host/foobar'));
  //   expect(response.statusCode, 404);
  // });
}
