import 'dart:async';
import 'dart:collection';
import 'dart:ffi';
import 'dart:io';

//// DAY 1

Future<int> day1(int thisMany) async {
  return await File('input/input1.txt').readAsString().then((String content) {
    var elves = content.split("\n\n");
    var top = HashSet<int>();
    for (var element in elves) {
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
    }

    var total = 0;
    for (var element in top) {
      total += element;
    }

    return total;
  });
}

//// DAY2

int moveScore(var move) {
  switch (move) {
    case "X":
      return 1;
    case "Y":
      return 2;
    case "Z":
      return 3;
    default:
      return 0;
  }
}

String translate(var move) {
  switch (move) {
    case "A":
      return "X";
    case "B":
      return "Y";
    case "C":
      return "Z";
    default:
      return "H";
  }
}

int roundScore(var ownMove, var oppMove) {
  var ownScore = moveScore(ownMove);
  var oppScore = moveScore(translate(oppMove));
  var roundScore = 0;
  if (ownScore > oppScore) roundScore = 6;
  if (ownScore == oppScore) roundScore = 3;
  if (ownScore == 3 && oppScore == 1) roundScore = 0; // rock-scissors -cases
  if (ownScore == 1 && oppScore == 3) roundScore = 6;
  return roundScore + ownScore;
}

int getMove(var desiredResult, var oppScore) {
  switch (desiredResult) {
    case "X": // lose
      if (oppScore == 1) {
        return 3;
      } else {
        return oppScore - 1;
      }
    case "Y": // tie
      return oppScore;
    case "Z": // win
      if (oppScore == 3) {
        return 1;
      } else {
        return oppScore + 1;
      }
    default:
      return 0;
  }
}

int roundScore2(var desiredResult, var oppMove) {
  var ownScore = getMove(desiredResult, moveScore(translate(oppMove)));
  var oppScore = moveScore(translate(oppMove));
  var roundScore = 0;
  if (ownScore > oppScore) roundScore = 6;
  if (ownScore == oppScore) roundScore = 3;
  if (ownScore == 3 && oppScore == 1) roundScore = 0; // rock-scissors -cases
  if (ownScore == 1 && oppScore == 3) roundScore = 6;
  //print("round ${roundScore}, own ${ownScore}, total ${roundScore + ownScore}");
  return roundScore + ownScore;
}

Future<int> day2() async {
  return await File('input/input2.txt').readAsString().then((String content) {
    int score = 0;
    var rounds = content.split("\n");
    for (var round in rounds) {
      if (round.length > 0) {
        var split = round.split(" ");
        score += roundScore(split[1], split[0]);
      }
    }

    return score;
  });
}

Future<int> day2_2() async {
  return await File('input/input2.txt').readAsString().then((String content) {
    int score = 0;
    var rounds = content.split("\n");
    for (var round in rounds) {
      if (round.length > 0) {
        var split = round.split(" ");
        score += roundScore2(split[1], split[0]);
      }
    }

    return score;
  });
}

//// DAY 3

Future<int> day3() async {
  String lowerPriorities = "abcdefghijklmnopqrstuvwxyz";
  String higherPriorities = lowerPriorities.toUpperCase();
  return await File('input/input3.txt').readAsString().then((String content) {
    var sacks = content.split("\n");
    int prioritiesSum = 0;
    for (var content in sacks) {
      var middle = (content.length / 2).round();
      var compartA = content.substring(0, middle).split('');
      var compartB = content.substring(middle).split('');
      var doubles = Set.from(compartA.where((element) => compartB.contains(element)));
      for (var item in doubles) {
        if (lowerPriorities.indexOf(item) > 0) {
          prioritiesSum += 1 + lowerPriorities.indexOf(item);
        } else {
          prioritiesSum += 27 + higherPriorities.indexOf(item);
        }
      }
    }
    return prioritiesSum;
  });
}

Future<int> day3_2() async {
  String lowerPriorities = "abcdefghijklmnopqrstuvwxyz";
  String higherPriorities = lowerPriorities.toUpperCase();
  return await File('input/input3.txt').readAsString().then((String content) {
    var sacks = content.split("\n");
    int prioritiesSum = 0;
    for (int l = 0; l < sacks.length; l += 3) {
      List<String> elfGroup = [sacks[l], sacks[l + 1], sacks[l + 2]];
      var groupContent = HashSet<String>();
      for (var content in elfGroup) {
        var items = content.split('');
        if (groupContent.isEmpty) {
          groupContent.addAll(items);
        } else {
          groupContent.removeWhere((groupItem) => !items.contains(groupItem));
        }
      }

      for (var item in groupContent) {
        if (lowerPriorities.indexOf(item) > 0) {
          prioritiesSum += 1 + lowerPriorities.indexOf(item);
        } else {
          prioritiesSum += 27 + higherPriorities.indexOf(item);
        }
      }
    }
    return prioritiesSum;
  });
}

///// DAY 4

Future<int> day4() async {
  return await File('input/input4.txt').readAsString().then((String content) {
    var assignments = content.split("\n");
    int score = 0;
    for (var assignment in assignments) {
      var pairs = assignment.split(",");
      var rangesUnfold = List<String>.empty(growable: true);
      for (var pair in pairs) {
        int start = int.parse(pair.split("-")[0]);
        int end = int.parse(pair.split("-")[1]);
        String unfold = "";
        for (int i = start; i <= end; i++) {
          unfold += "-${i}-:";
        }
        rangesUnfold.add(unfold.substring(0, unfold.length - 1));
      }

      if (rangesUnfold[0].contains(rangesUnfold[1]) || rangesUnfold[1].contains(rangesUnfold[0])) {
        score++;
      }
    }

    return score;
  });
}

Future<int> day4_2() async {
  return await File('input/input4.txt').readAsString().then((String content) {
    var assignments = content.split("\n");
    int score = 0;
    for (var assignment in assignments) {
      var pairs = assignment.split(",");
      var rangesUnfold = List<Set>.empty(growable: true);
      for (var pair in pairs) {
        int start = int.parse(pair.split("-")[0]);
        int end = int.parse(pair.split("-")[1]);
        var unfold = Set<int>();
        for (int i = start; i <= end; i++) {
          unfold.add(i);
        }
        rangesUnfold.add(unfold);
      }

      if (-1 != rangesUnfold[0].firstWhere((element) => rangesUnfold[1].contains(element), orElse: () => -1)) {
        score++;
      }
    }

    return score;
  });
}

//// DAY5

Future<String> day5() async {
  return await File('input/input5.txt').readAsString().then((String content) {
    var result = "";
    var stacks = List<List<String>>.empty(growable: true);
    stacks.add(["C", "Q", "B"]);
    stacks.add(["Z", "W", "Q", "R"]);
    stacks.add(["V", "L", "R", "M", "B"]);
    stacks.add(["W", "T", "V", "H", "Z", "C"]);
    stacks.add(["G", "V", "N", "B", "H", "Z", "D"]);
    stacks.add(["Q", "V", "F", "J", "C", "P", "N", "H"]);
    stacks.add(["S", "Z", "W", "R", "T", "G", "D"]);
    stacks.add(["P", "Z", "W", "B", "N", "M", "G", "C"]);
    stacks.add(["P", "F", "Q", "W", "M", "B", "J", "N"]);
    var moves = content.split("\n");
    for (var move in moves) {
      var split = move.split(" ");
      int amount = int.parse(split[1]);
      var from = int.parse(split[3]) - 1;
      var to = int.parse(split[5]) - 1;
      for (var i = 0; i < amount; i++) {
        var transit = stacks[from].removeAt(0);
        stacks[to].insert(0, transit);
      }
    }

    var i = 1;
    for (var stack in stacks) {
      print("${i++}: ${stack}");
    }

    return result;
  });
}

Future<String> day5_2() async {
  return await File('input/input5.txt').readAsString().then((String content) {
    var result = "";
    var stacks = List<List<String>>.empty(growable: true);
    stacks.add(["C", "Q", "B"]);
    stacks.add(["Z", "W", "Q", "R"]);
    stacks.add(["V", "L", "R", "M", "B"]);
    stacks.add(["W", "T", "V", "H", "Z", "C"]);
    stacks.add(["G", "V", "N", "B", "H", "Z", "D"]);
    stacks.add(["Q", "V", "F", "J", "C", "P", "N", "H"]);
    stacks.add(["S", "Z", "W", "R", "T", "G", "D"]);
    stacks.add(["P", "Z", "W", "B", "N", "M", "G", "C"]);
    stacks.add(["P", "F", "Q", "W", "M", "B", "J", "N"]);
    var moves = content.split("\n");
    for (var move in moves) {
      var split = move.split(" ");
      int amount = int.parse(split[1]);
      var from = int.parse(split[3]) - 1;
      var to = int.parse(split[5]) - 1;
      var transit = List<String>.empty(growable: true);
      for (var i = 0; i < amount; i++) {
        transit.add(stacks[from].removeAt(0));
      }
      var rev = List<String>.from(transit.reversed);
      for (var i = 0; i < amount; i++) {
        stacks[to].insert(0, rev[i]);
      }
    }

    var i = 1;
    for (var stack in stacks) {
      print("${i++}: ${stack}");
    }

    return result;
  });
}

///// DAY6

Future<int> day6(int frameLen) async {
  return await File('input/input6.txt').readAsString().then((String content) {
    var input = content.split('');
    for (int i = frameLen; i < input.length; i++) {
      var frame = input.sublist(i - frameLen, i);
      if (frame.toSet().length == frame.length) {
        return i;
      }
    }
    return 0;
  });
}

//// DAY 7

String getFullPath(List<String> currentPath) {
  var path = "";
  for (String dir in currentPath) {
    path += "${dir}/";
  }
  return path;
}

Future<int> day7() async {
  return await File('input/input7.txt').readAsString().then((String content) {
    var input = content.split("\n");
    var currentPath = List<String>.empty(growable: true);
    Map<String, int> directorySizes = HashMap<String, int>();
    for (var input in input) {
      if (input[0] == "\$") {
        // a command
        var split = input.split(' ');
        if (split[1] == "cd") {
          if (split[2] == "..") {
            currentPath.removeLast();
          } else {
            currentPath.add(split[2]);
            // if (!directorySizes.containsKey(split[2])) {
            //   directorySizes[split[2]] = 0;
            // }
          }
        }
      } else {
        // surely in list mode
        var split = input.split(" ");
        if (split[0] == "dir") {
          if (!directorySizes.containsKey(split[0])) {
            directorySizes[split[0]] = 0;
          }
        } else {
          // ls output
          int size = int.parse(split[0]);
          print("size ${size}");
          for (var dirName in currentPath) {
            //var fullPath = getFullPath(currentPath);
            var useDirName = dirName;
            if (directorySizes.containsKey(dirName)) {
              useDirName = "${dirName}${dirName}";
            }
            int currentDirSize = directorySizes[useDirName] ?? 0;
            currentDirSize += size;
            directorySizes[useDirName] = currentDirSize;
            //print("${fullPath}");
          }
        }
      }
    }
    // print(directorySizes);
    var result = 0;
    for (var dir in directorySizes.keys) {
      print("dir ${dir} total size is ${directorySizes[dir]}");
      if ((directorySizes[dir] ?? 0) <= 100000) {
        //print("adding");
        result += directorySizes[dir] ?? 0;
      }
    }

    return result;
  });
}
