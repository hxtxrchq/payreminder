import 'package:intl/intl.dart';

final _pen = NumberFormat.currency(locale: 'es_PE', symbol: 'S/ ');
String formatMoney(num v) => _pen.format(v);
