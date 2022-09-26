import 'dart:convert';

double getBalanceValue(double balance, price) {
  if (price == null || price == null) {
    return 0.0;
  }
  return balance * price;
}

extension CapitalizeExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

extension ShortenExtension on String {
  String shorten() {
    return "${substring(0, 2)}...${substring(length - 5)}";
  }
}

String toAmountDisplayBigInt(BigInt decimalsVal,
    {int decimals = 18, int fractionDigits = 4}) {
  BigInt divisor = BigInt.from(10).pow(decimals);
  String intPart = (decimalsVal ~/ BigInt.from(10).pow(decimals)).toString();
  if (fractionDigits == 0) return intPart;
  String fractionalPart =
      decimalsVal.remainder(divisor).toString().padLeft(decimals, "0");
  fractionalPart = fractionalPart.length < fractionDigits
      ? fractionalPart.padRight(fractionDigits, "0")
      : fractionalPart.substring(0, fractionDigits);
  return "$intPart.$fractionalPart";
}

double decimalsToDouble(BigInt decimalsVal, {int decimals = 18}) =>
    (decimalsVal / BigInt.from(10).pow(decimals)).toDouble();

String toStringWithoutDecimals(String amount, int decimals) {
  var arr = amount.split(".");

  var intPart = arr[0];
  if (arr.length == 1) {
    for (int i = 0; i < decimals; i++) {
      intPart += "0";
    }
    return intPart;
  }

  while (intPart.startsWith("0")) {
    intPart = intPart.substring(1);
  }

  var fractionalPart = arr[1];
  while (fractionalPart.length < decimals) {
    fractionalPart += "0";
  }

  return intPart + fractionalPart;
}

// To check for valid checksum use JS utility
bool isEvmAddress(String address) {
  return RegExp(r'^(0x|0X)([0-9a-fA-F]{40})$').hasMatch(address);
}

// To check for valid checksum use JS utility
bool isSubstrateAddress(String address) {
  if (address.isEmpty || !address.startsWith("5")) {
    return false;
  }
  return RegExp(r'^[A-z\d]{48}$').hasMatch(address);
}

// If url is base64 encoded, returns decoded value
// String processImageUrl(String value) {
//   if (!value.startsWith("data:image/svg+xml;base64,")) {
//     return value;
//   }
//   value = value.substring(26);
//   Codec<String, String> stringToBase64 = utf8.fuse(base64);
//   String base64Decoded = stringToBase64.decode(value);
//   String uriEncoded = Uri.encodeComponent(base64Decoded);
//   return "data:image/svg+xml,$uriEncoded";
// }

String decodeSvg(String value) {
  value = value.substring(26);
  Codec<String, String> stringToBase64 = utf8.fuse(base64);
  String base64Decoded = stringToBase64.decode(value);
  if (base64Decoded.contains("<defs")) {
    // Defs are required to be at the beginning of the SVG
    String defs = base64Decoded.substring(
        base64Decoded.indexOf("<defs"), base64Decoded.indexOf("</defs>") + 7);
    base64Decoded = base64Decoded.replaceAll(defs, "");
    base64Decoded = base64Decoded.substring(0, base64Decoded.indexOf(">") + 1) +
        defs +
        base64Decoded.substring(base64Decoded.indexOf(">") + 1);
  }
  return base64Decoded;
}
