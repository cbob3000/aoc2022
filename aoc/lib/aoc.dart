import 'dart:async';
import 'dart:collection';
import 'dart:io';

Future<int> day1(int thisMany) async {
  var result = await File('input/input1.txt').readAsString().then((String content) {
    var elves = content.split("\n\n");
    var top = HashSet<int>();
    elves.forEach((element) {
      int totalCals = 0;
      element.split("\n").forEach((food) {
        if (food.length > 1) totalCals += int.parse(food);
      });
      if (top.length < thisMany) {
        top.add(totalCals);
      } else {
        var high = top.firstWhere((element) => element < totalCals, orElse: () => -1);
        if (high > -1) {
          top.remove(high);
          top.add(totalCals);
        }
      }
    });

    var total = 0;
    top.forEach((element) {
      total += element;
    });

    return total;
  });

  return result;
}
