
import 'package:mobx/mobx.dart';

import '../model/address_model.dart';
import '../service/home_service.dart';

class HomeController {
  final HomeService _service = HomeService();

  final Observable<bool> _isLoading = Observable(false);
  final Observable<String?> _errorMessage = Observable(null);
  final ObservableList<AddressModel> _results =
      ObservableList<AddressModel>();
  final Observable<AddressModel?> _selectedAddress =
      Observable(null);

  bool get isLoading => _isLoading.value;

  String? get errorMessage => _errorMessage.value;

  List<AddressModel> get results => _results.toList();

  AddressModel? get selectedAddress => _selectedAddress.value;

  Future<void> searchByCep(String cep) async {
    runInAction(() {
      _isLoading.value = true;
      _errorMessage.value = null;
      _results.clear();
      _selectedAddress.value = null;
    });

    try {
      final address = await _service.searchByCep(cep);

      runInAction(() {
        _results.add(address);
        _selectedAddress.value = address;
      });
    } catch (error) {
      runInAction(() {
        _errorMessage.value = error.toString().replaceFirst(
          'Exception: ',
          '',
        );
      });
    } finally {
      runInAction(() {
        _isLoading.value = false;
      });
    }
  }

  Future<void> searchByAddress({
    required String state,
    required String city,
    required String street,
  }) async {
    runInAction(() {
      _isLoading.value = true;
      _errorMessage.value = null;
      _results.clear();
      _selectedAddress.value = null;
    });

    try {
      final addresses = await _service.searchByAddress(
        state: state,
        city: city,
        street: street,
      );

      runInAction(() {
        _results.addAll(addresses);

        if (addresses.isNotEmpty) {
          _selectedAddress.value = addresses.first;
        }
      });
    } catch (error) {
      runInAction(() {
        _errorMessage.value = error.toString().replaceFirst(
          'Exception: ',
          '',
        );
      });
    } finally {
      runInAction(() {
        _isLoading.value = false;
      });
    }
  }
}
