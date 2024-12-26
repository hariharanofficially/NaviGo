Map countryCodes = {"ARE": "AE", "IND": "IN"};

String getAlpha2CountryCode(String code) {
  String ret = countryCodes[code];
  return ret;
}
