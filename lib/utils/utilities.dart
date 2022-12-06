import 'package:bibliasacra/vers/vkQueries.dart';

VkQueries vkQueries = VkQueries();

class Utilities {
  String reduceLength(int l, String t) {
    return (t.length > l) ? t.substring(0, l) : t;
  }

  int getTime() {
    return DateTime.now().microsecondsSinceEpoch;
  }

  // void getDialogeHeight() {
  //   vkQueries.getActiveVerCount().then(
  //     (value) {
  //       double dialogHeight = (value.toDouble() * 40.00);
  //       if (dialogHeight > 300.00) {
  //         dialogHeight = 300.00;
  //       }
  //       Globals.dialogHeight = dialogHeight;
  //     },
  //   );
  // }
}
