import '../app_utils/z_models.dart';

class Address {
  String country;
  String address1;
  String address2;
  String city;
  String state;
  String zip;

  Address({
    this.country,
    this.address1,
    this.address2,
    this.city,
    this.state,
    this.zip,
  });

  Map<String, dynamic> toMap() {
    return {
      'country': country,
      'address1': address1,
      'address2': address2,
      'city': city,
      'state': state,
      'zip': zip,
    };
  }

  factory Address.fromMap(Map<String, dynamic> map) {
    if (map == null)
      return Address(
        country: '',
        address1: '',
        address2: '',
        city: '',
        state: '',
        zip: '',
      );

    return Address(
      country: ZModelString.toStr(map['country']),
      address1: ZModelString.toStr(map['address1']),
      address2: ZModelString.toStr(map['address2']),
      city: ZModelString.toStr(map['city']),
      state: ZModelString.toStr(map['state']),
      zip: ZModelString.toStr(map['zip']),
    );
  }

  Address copyWith({
    String country,
    String address1,
    String address2,
    String city,
    String state,
    String zip,
  }) {
    return Address(
      country: country ?? this.country,
      address1: address1 ?? this.address1,
      address2: address2 ?? this.address2,
      city: city ?? this.city,
      state: state ?? this.state,
      zip: zip ?? this.zip,
    );
  }
}
