import 'package:intl/intl.dart';

int formatPrice(String str) {
  str = str.replaceAll('PHP', '');
  str = str.replaceAll('.00', '');
  str = str.replaceAll(' ', '');
  return int.parse(str);
}

final priceInCurrency = NumberFormat.currency(locale: 'en_US', name: "PHP");
