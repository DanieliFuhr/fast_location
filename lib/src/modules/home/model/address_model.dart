
class AddressModel {
  final String cep;
  final String street;
  final String neighborhood;
  final String city;
  final String state;
  final String? complement;

  AddressModel({
    required this.cep,
    required this.street,
    required this.neighborhood,
    required this.city,
    required this.state,
    this.complement,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      cep: json['cep']?.toString() ?? '',
      street: json['logradouro']?.toString() ?? '',
      neighborhood: json['bairro']?.toString() ?? '',
      city: json['localidade']?.toString() ?? '',
      state: json['uf']?.toString() ?? '',
      complement: json['complemento']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cep': cep,
      'logradouro': street,
      'bairro': neighborhood,
      'localidade': city,
      'uf': state,
      'complemento': complement ?? '',
    };
  }
}
