class Token {
  static const AMOUNT = "Amount";
  static const AT = "At";
  static const COLON = "Colon";
  static const EOF = "EOF";
  static const FAILS = "Fails";
  static const ILLEGAL = "Illegal";
  static const LINEBREAK = "Linebreak";
  static const REPS = "Reps";
  static const POUND = "Pound";
  static const SETS = "Sets";
  static const STAR = "Star";
  static const WHITESPACE = "Whitespace";
  static const WORD = "Word";
}

class TokenLiteral {
  String literal;
  String token;

  TokenLiteral(this.token, this.literal);

  TokenLiteral.eof() {
    literal = "";
    token = Token.EOF;
  }

  TokenLiteral.illegal() {
    literal = "";
    token = Token.ILLEGAL;
  }

  bool get isAmount => token == Token.AMOUNT;
  bool get isAt => token == Token.AT;
  bool get isColon => token == Token.COLON;
  bool get isEmpty => token == Token.LINEBREAK || token == Token.WHITESPACE;
  bool get isFails => token == Token.FAILS;
  bool get isIllegal => token == Token.ILLEGAL;
  bool get isLinebreak => token == Token.LINEBREAK;
  bool get isPound => token == Token.POUND;
  bool get isReps => token == Token.REPS;
  bool get isSets => token == Token.SETS;
  bool get isStar => token == Token.STAR;
  bool get isWhitespace => token == Token.WHITESPACE;
  bool get isWord => token == Token.WORD;

  @override
  bool operator ==(tl) => tl.token == token && tl.literal == literal;

  @override
  String toString() => "$token: $literal";
}
