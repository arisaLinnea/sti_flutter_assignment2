import 'package:flutter/material.dart';
import 'package:shared/shared.dart';
import 'package:shared_client/shared_client.dart';

class ParkingProvider extends ChangeNotifier {
  List<Parking> _myParkings = [];
  List<Parking> _allParkings = [];
  List<ParkingLot> _parkingsLots = [];
  bool _isParkingLoading = false;
  bool _isLotsLoading = false;
  Owner? _owner;

  List<Parking> get parkings => _myParkings;
  List<ParkingLot> get parkingsLots => _parkingsLots;
  bool get isParkLoading => _isParkingLoading;
  bool get isLotsLoading => _isLotsLoading;

  ParkingProvider() {
    // Automatically fetch the vehicle list when the provider is created
    fetchParkings();
    fetchParkingsLots();
  }

  void setOwner(Owner? newOwner) {
    _owner = newOwner;
  }

  // Fetch the vehicle list from the repository
  Future<void> fetchParkings() async {
    _isParkingLoading = true;
    notifyListeners();

    try {
      _allParkings = await ParkingRepository().getList();
      _myParkings = _allParkings
          .where((park) => park.vehicle?.owner?.id == _owner?.id)
          .toList();
    } catch (e) {
      _allParkings = [];
      _myParkings = [];
    } finally {
      _isParkingLoading = false;
      notifyListeners();
    }
  }

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
    List<Parking> activeParkings = _allParkings
        .where((lot) =>
            (lot.endTime == null || lot.endTime!.isAfter(DateTime.now())))
        .toList();
    List<ParkingLot> freeLots = _parkingsLots.where((lot) {
      return !activeParkings.any((parking) => parking.parkinglot?.id == lot.id);
    }).toList();
    return freeLots;
  }

  List<Parking> getMyActiveParkings() {
    List<Parking> freeLots = _myParkings
        .where((lot) =>
            (lot.endTime == null || lot.endTime!.isAfter(DateTime.now())))
        .toList();
    return freeLots;
  }

  List<Parking> getMyOldParkings() {
    List<Parking> freeLots = _myParkings
        .where((lot) =>
            (lot.endTime != null && lot.endTime!.isBefore(DateTime.now())))
        .toList();
    return freeLots;
  }

  // Method to update the list
  Future<void> updateParkinglist() async {
    await fetchParkings();
  }
}
