import 'dart:async';
import 'dart:collection';
import 'dart:io';

//// DAY 1

Future<int> day1(int thisMany) async {
  return await File('input/input1.txt').readAsString().then((String content) {
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
    rounds.forEach((round) {
      if (round.length > 0) {
        var split = round.split(" ");
        score += roundScore(split[1], split[0]);
      }
    });

    return score;
  });
}

Future<int> day2_2() async {
  return await File('input/input2.txt').readAsString().then((String content) {
    int score = 0;
    var rounds = content.split("\n");
    rounds.forEach((round) {
      if (round.length > 0) {
        var split = round.split(" ");
        score += roundScore2(split[1], split[0]);
      }
    });

    return score;
  });
}
