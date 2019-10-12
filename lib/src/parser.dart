import "./metadata.dart";
import "./movement.dart";
import "./performance.dart";
import "./scanner.dart";
import "./token.dart";

/// Parser uses the provided Scanner to create an intermediate representation of the training session.
class Parser {
  bool hasParsed = false;
  Metadata metadata = Metadata();
  List<Movement> movements = [];

  Scanner _scanner;

  Parser(this._scanner);

  void _handleKVP() {
    var endKVP = false;
    var key = StringBuffer("");
    var keyComplete = false;
    var value = StringBuffer("");

    while (!_scanner.eof && !endKVP) {
      var tokenLiteral = _scanner.scan();

      if (tokenLiteral.token == Token.LINEBREAK) { endKVP = true; }
      if (tokenLiteral.token == Token.COLON) { keyComplete = true; continue; }
      if (tokenLiteral.token != Token.WHITESPACE) {
        var buffer = !keyComplete ? key : value;
        buffer.write("${tokenLiteral.literal} ");
      }
    }

    metadata.addKVP(key.toString().trimRight(), value.toString().trimRight());
  }

  void _handleMovement(TokenLiteral initial) {
    String currentUnit;
    var mustUnit = false;
    Movement movement;
    var name = StringBuffer("${initial.literal} ");
    Performance performance;

    while (!_scanner.eof) {
      var tokenLiteral = _scanner.scan();
      
      // TODO: Eventually need to support line breaks in movements...
      if (tokenLiteral.token == Token.LINEBREAK) { break; }
      if (tokenLiteral.token == Token.WHITESPACE) {
        if (currentUnit != null) {
          performance.load = num.tryParse(currentUnit);
          currentUnit = null;
        }
        continue;
      }

      if (tokenLiteral.token == Token.SEMICOLON) {
        if (currentUnit != null) {
          performance.load = num.tryParse(currentUnit);
          currentUnit = null;
        }
        movement.performances.add(performance);
        performance = Performance();
        mustUnit = true;
        continue;
      }

      // This should indicate end of movement...
      if (mustUnit && tokenLiteral.token != Token.UNIT) {
        break;
      }

      if (tokenLiteral.token == Token.UNIT) {
        currentUnit = tokenLiteral.literal;
        mustUnit = false;
        continue;
      }

      if (tokenLiteral.token == Token.COLON) {
        movement = Movement(name.toString().trimRight());
        mustUnit = true;
        performance = Performance();
      }

      if (tokenLiteral.token == Token.IDENT) {
        if (movement == null) {
          name.write("${tokenLiteral.literal} ");
          continue;
        } else {
          if (tokenLiteral.literal == "s") {
            performance.repeat = num.tryParse(currentUnit);
          }
          if (tokenLiteral.literal == "r") {
            performance.reps = num.tryParse(currentUnit);
          }
          currentUnit = null;
        }
      }
    }

    movements.add(movement);
  }

  void _handleNote() {
    var endNote = false;
    var note = StringBuffer("");

    while (!_scanner.eof && !endNote) {
      var tokenLiteral = _scanner.scan();

      if (tokenLiteral.token == Token.LINEBREAK) { endNote = true; }
      if (tokenLiteral.token != Token.WHITESPACE) { note.write("${tokenLiteral.literal} "); }
    }

    metadata.addNote(note.toString().trimRight());
  }

  void set scanner(Scanner newScanner) {
    hasParsed = false;
    metadata = Metadata();
    movements = [];
    _scanner = newScanner;
  }

  /// parse runs the provided Scanner until eof signal and stores the metadata and movements.
  void parse() {
    if (hasParsed) { return; }
    if (_scanner == null) { throw "Needs a scanner, dummy"; }

    while (!_scanner.eof) {
      var tokenLiteral = _scanner.scan();
      
      if (tokenLiteral.token == Token.POUND) { _handleKVP(); }
      else if (tokenLiteral.token == Token.STAR) { _handleNote(); }
      else { _handleMovement(tokenLiteral); }
    }
    hasParsed = true;
  }
}
