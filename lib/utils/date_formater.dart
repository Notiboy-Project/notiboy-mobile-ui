import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

applicationDateFormatter(DateTime inputTime) {
  if (DateTime.now().difference(inputTime).inDays <= 3) {
    return timeago.format(inputTime);
  } else {
    return DateFormat('dd MMM yyyy').format(inputTime);
  }
}