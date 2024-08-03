class Token {
  final String symbol;
  final String price;
  final String quantity;
  final String dayChange;
  final String dayChangeDollar;
  final int timestamp;

  Token({
    required this.symbol,
    required this.price,
    required this.quantity,
    required this.dayChange,
    required this.dayChangeDollar,
    required this.timestamp,
  });

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      symbol: json['s'] as String,
      price: json['p'] as String? ?? '0',
      quantity: json['q'] as String? ?? '0',
      dayChange: json['dc'] as String? ?? '0',
      dayChangeDollar: json['dd'] as String? ?? '0',
      timestamp: json['t'] as int,
    );
  }

  @override
  String toString() {
    return 'Token(symbol: $symbol, price: $price, quantity: $quantity, dayChange: $dayChange, dayChangeDollar: $dayChangeDollar, timestamp: $timestamp)';
  }
}
