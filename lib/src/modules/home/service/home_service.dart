
import '../model/address_model.dart';
import '../repositories/address_repository.dart';

class HomeService {
  final AddressRepository _repository = AddressRepository();

  Future<AddressModel> searchByCep(String cep) async {
    return await _repository.searchByCep(cep);
  }

  Future<List<AddressModel>> searchByAddress({
    required String state,
    required String city,
    required String street,
  }) async {
    return await _repository.searchByAddress(
      state: state,
      city: city,
      street: street,
    );
  }
}
