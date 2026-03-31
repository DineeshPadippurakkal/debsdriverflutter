import 'package:phone_numbers_parser/phone_numbers_parser.dart';

class Phone {
  Phone({required this.international, required this.nsn});

  final String international, nsn;

  factory Phone.fromString(String phone) {
    final parsed = PhoneNumber.parse(phone, callerCountry: IsoCode.KW);

    return Phone(international: parsed.international, nsn: parsed.nsn);
  }

  // Override toString for better readability

  @override
  String toString() => international;
}
