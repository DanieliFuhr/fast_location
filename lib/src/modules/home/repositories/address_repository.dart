
import '../../../http/viacep_client.dart';
import '../../../shared/storage/local_storage.dart';
import '../model/address_model.dart';

class AddressRepository {
  final ViaCepClient _client = ViaCepClient();

  Future<AddressModel> searchByCep(String cep) async {
    final result = await _client.searchByCep(cep);

    final address = AddressModel.fromJson(result);

    await _saveAddress(address);

    return address;
  }

  Future<List<AddressModel>> searchByAddress({
    required String state,
    required String city,
    required String street,
  }) async {
    final results = await _client.searchByAddress(
      state: state,
      city: city,
      street: street,
    );

    final addresses = results
        .map((item) => AddressModel.fromJson(item))
        .toList();

    for (final address in addresses) {
      await _saveAddress(address);
    }

    return addresses;
  }

  Future<void> _saveAddress(AddressModel address) async {
    await LocalStorage.saveHistory({
      ...address.toJson(),
      'searchedAt': DateTime.now().toIso8601String(),
    });
  }
}
