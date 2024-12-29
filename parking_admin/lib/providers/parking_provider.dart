import 'package:flutter/material.dart';
import 'package:shared/shared.dart';
import 'package:shared_client/shared_client.dart';

class ParkingProvider extends ChangeNotifier {
  List<Parking> _parkings = [];
  List<ParkingLot> _parkingsLots = [];
  bool _isParkingLoading = false;
  bool _isLotsLoading = false;
  double sumParking = 0;

  List<Parking> get parkings => _parkings;
  List<ParkingLot> get parkingsLots => _parkingsLots;
  bool get isParkLoading => _isParkingLoading;
  bool get isLotsLoading => _isLotsLoading;

  ParkingProvider() {
    // Automatically fetch the parking- and parkinglot list when the provider is created
    fetchParkings();
    fetchParkingsLots();
  }

  // Fetch the parking list from the repository
  Future<void> fetchParkings() async {
    _isParkingLoading = true;
    notifyListeners();

    try {
      _parkings = await ParkingRepository().getList();
      DateTime now = DateTime.now();
      for (var parking in _parkings) {
        if (parking.endTime != null &&
            parking.endTime!.isBefore(now) &&
            parking.parkinglot?.hourlyPrice != null) {
          Duration differenceTime =
              parking.endTime!.difference(parking.startTime);
          int minutes = differenceTime.inMinutes;
          int startedHours = (minutes / 60).ceil();
          double cost = parking.parkinglot!.hourlyPrice * startedHours;
          sumParking += cost;
        }
      }
    } catch (e) {
      _parkings = [];
    } finally {
      _isParkingLoading = false;
      notifyListeners();
    }
  }

// Fetch the parkinglot list from the repository
  Future<void> fetchParkingsLots() async {
    _isLotsLoading = true;
    notifyListeners();

    try {
      _parkingsLots = await ParkingLotRepository().getList();
    } catch (e) {
      _parkingsLots = [];
    } finally {
      _isLotsLoading = false;
      notifyListeners();
    }
  }

  List<ParkingLot> getFreeParkingLots() {
    List<ParkingLot> freeLots = _parkingsLots.where((lot) {
      return !_parkings.any((parking) => parking.parkinglot?.id == lot.id);
    }).toList();
    return freeLots;
  }

  List<ParkingLot> getPopularParkingLots() {
    if (parkings.isEmpty) return [];

    Map<String, int> parkingLotCount = {};

    for (var parking in _parkings) {
      var lotId = parking.parkinglot?.id;
      if (lotId != null) {
        parkingLotCount[lotId] = (parkingLotCount[lotId] ?? 0) + 1;
      }
    }
    // Find the maximum occurrence
    int maxCount = parkingLotCount.values.isEmpty
        ? 0
        : parkingLotCount.values.reduce((a, b) => a > b ? a : b);

    // Get all parking lots with the max occurrence
    List<String> maxIds = [];
    parkingLotCount.forEach((lot, count) {
      if (count == maxCount) {
        maxIds.add(lot);
      }
    });
    List<ParkingLot> mostCommon =
        _parkingsLots.where((lot) => maxIds.contains(lot.id)).toList();
    return mostCommon;
  }

  int getSumParkings() {
    int sum = 0;

    return sum;
  }

  // Method to update the list
  Future<void> updateParkinglist() async {
    await fetchParkings();
  }

  // Method to update the lot list
  Future<void> updateParkingsLots() async {
    await fetchParkingsLots();
  }
}
