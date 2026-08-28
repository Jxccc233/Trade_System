import 'package:intl/intl.dart';

final NumberFormat _money = NumberFormat('#,##0.00');
final NumberFormat _pct = NumberFormat('0.00');

String money(double v) => _money.format(v);

String signedMoney(double v) => v > 0 ? '+${money(v)}' : money(v);

String pct(double v) => '${_pct.format(v)}%';

String signedPct(double v) => v > 0 ? '+${pct(v)}' : pct(v);
