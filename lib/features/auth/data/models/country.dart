/// This file defines the CountryModel class, which represents a country with a dial code and country code in the Zarpay application.

/// The CountryModel class represents a country with a dial code and country code.
class CountryModel {
  final String dialCode;
  final String code;

  /// Constructor for the CountryModel class.
  ///
  /// [dialCode] The dial code of the country.
  /// [code] The country code.
  CountryModel(this.dialCode, this.code);

  /// Factory constructor to create a CountryModel instance from a JSON map.
  ///
  /// [json] The JSON map containing country data.
  /// Returns a CountryModel instance.
  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(json["dial_code"], json["code"]);
  }

  /// Converts the CountryModel instance to a JSON map.
  ///
  /// Returns a JSON map representing the country data.
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = <String, dynamic>{};
    json["dial_code"] = dialCode;
    json["code"] = code;
    return json;
  }
}
