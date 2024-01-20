import 'package:intl/intl.dart';

String getDateTime(){
  DateTime now= DateTime.now();
  var formatter =DateFormat('yyyy-MM-dd');
  String formattedDate = formatter.format(now);
  return formattedDate;
}
