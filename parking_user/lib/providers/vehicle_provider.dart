import 'package:flutter/material.dart';
import 'package:shared/shared.dart';
import 'package:shared_client/shared_client.dart';

class VehicleListProvider extends ChangeNotifier {
  List<Vehicle> _vehicles = [];
  bool _isLoading = false;
  Owner? _owner;

  List<Vehicle> get vehicles => _vehicles;
  bool get isLoading => _isLoading;

  VehicleListProvider() {
    // Automatically fetch the vehicle list when the provider is created
    fetchVehicles();
  }

  void setOwner(Owner? newOwner) {
    _owner = newOwner;
  }

  // Fetch the vehicle list from the repository
  Future<void> fetchVehicles() async {
    _isLoading = true;
    notifyListeners();

    try {
      List<Vehicle> list = await VehicleRepository().getList();
      _vehicles = list.where((v) => v.owner?.id == _owner?.id).toList();
    } catch (e) {
      _vehicles = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Method to update the list
  Future<void> updateVehicleList() async {
    await fetchVehicles();
  }
}
