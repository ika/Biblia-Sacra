import 'package:bibliasacra/globals/globals.dart';
import 'package:bibliasacra/vers/vkQueries.dart';

VkQueries vkQueries = VkQueries();

class Utilities {
  String reduceLength(int l, String t) {
    return (t.length > l) ? t.substring(0, l) : t;
  }

  int getTime() {
    return DateTime.now().microsecondsSinceEpoch;
  }

  void getDialogeHeight() {
    vkQueries.getActiveVersionCount().then(
      (value) {
        double dialogHeight = (value.toDouble() * 50.00);
        if (dialogHeight > 400.00) {
          dialogHeight = 400.00;
        }
        Globals.dialogHeight = dialogHeight;
      },
    );
  }
}
