import "package:test/test.dart";

import "package:traindown/src/scanner.dart";
import "package:traindown/src/token.dart";

void main() {
  group("Constructor", () {
    test("No args causes an exception", () {
      try { Scanner(); }
      catch(e) {
        expect(e, "You must pass either a filename or string");
        return;
      }
      throw "Should have failed init";
    });

    test("Both args causes an exception", () {
      try { Scanner(filename: "yay", string: "your mom"); }
      catch(e) {
        expect(e, "You may only pass a filename OR a string");
        return;
      }
      throw "Should have failed init";
    });
  });

  group("scan()", () {
    test("With ':' it returns the correct TokenLiteral", () {
      var s = Scanner(string: ":");
      expect(s.scan(), TokenLiteral(Token.COLON, ":"));
    });

    test("With '123' it returns the correct TokenLiteral", () {
      var s = Scanner(string: "123");
      expect(s.scan(), TokenLiteral(Token.UNIT, "123"));
    });

    test("With '123 ' it returns the correct TokenLiteral", () {
      var s = Scanner(string: "123 ");
      expect(s.scan(), TokenLiteral(Token.UNIT, "123"));
    });

    test("With '\n' it returns the correct TokenLiteral", () {
      var s = Scanner(string: "\n");
      expect(s.scan(), TokenLiteral(Token.LINEBREAK, ""));
    });

    test("With '\r' it returns the correct TokenLiteral", () {
      var s = Scanner(string: "\r");
      expect(s.scan(), TokenLiteral(Token.LINEBREAK, ""));
    });

    test("With '#' it returns the correct TokenLiteral", () {
      var s = Scanner(string: "#");
      expect(s.scan(), TokenLiteral(Token.POUND, "#"));
    });

    test("With ';' it returns the correct TokenLiteral", () {
      var s = Scanner(string: ";");
      expect(s.scan(), TokenLiteral(Token.SEMICOLON, ";"));
    });

    test("With '*' it returns the correct TokenLiteral", () {
      var s = Scanner(string: "*");
      expect(s.scan(), TokenLiteral(Token.STAR, "*"));
    });

    test("With ' ' it returns the correct TokenLiteral", () {
      var s = Scanner(string: " ");
      expect(s.scan(), TokenLiteral(Token.WHITESPACE, ""));
    });

    test("With '\t' it returns the correct TokenLiteral", () {
      var s = Scanner(string: "\t");
      expect(s.scan(), TokenLiteral(Token.WHITESPACE, ""));
    });

    test("With '    ' it returns the correct TokenLiteral", () {
      var s = Scanner(string: "    ");
      expect(s.scan(), TokenLiteral(Token.WHITESPACE, ""));
    });

    test("With '\t\t\t\t' it returns the correct TokenLiteral", () {
      var s = Scanner(string: "\t\t\t\t");
      expect(s.scan(), TokenLiteral(Token.WHITESPACE, ""));
    });

    test("With 'mom' it returns the correct TokenLiteral", () {
      var s = Scanner(string: "mom");
      expect(s.scan(), TokenLiteral(Token.IDENT, "mom"));
    });

    test("With '' it returns the correct TokenLiteral", () {
      var s = Scanner(string: "");
      expect(s.scan(), TokenLiteral(Token.EOF, ""));
    });
  });

  group("uncan()", () {
    test("It correctly rewinds the scan", () {
      var s = Scanner(string: ":");
      expect(s.scan(), TokenLiteral(Token.COLON, ":"));
      s.unscan();
      expect(s.scan(), TokenLiteral(Token.COLON, ":"));
    });
  });
}
