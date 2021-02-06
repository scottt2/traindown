import "dart:convert";

import "package:traindown/src/presenter.dart";
import "package:traindown/src/session.dart";

class JsonPresenter extends Presenter {
  JsonPresenter(Session session) : super(session);

  @override
  String present() {
    return jsonEncode(
        {"metadata": kvps, "movements": _movementsHash(), "notes": notes});
  }

  List _movementsHash() {
    return movements.fold(List(), (acc, movement) {
      acc.add({
        "name": movement.name,
        "performances": movement.performances.fold(List(), (pacc, performance) {
          pacc.add({
            "load": performance.load,
            "reps": performance.reps,
            "sets": performance.sets,
            "unit": performance.unit
          });
          return pacc;
        })
      });
      return acc;
    });
  }
}
