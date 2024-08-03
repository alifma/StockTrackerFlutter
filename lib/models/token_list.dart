class TokenRef {
  final String symbol;
  final String name;
  final String imageUrl;

  const TokenRef({
    required this.symbol,
    required this.name,
    required this.imageUrl,
  });
}

const List<TokenRef> tokenRefList = [
  TokenRef(
      symbol: 'BTC-USD',
      name: 'Bitcoin',
      imageUrl: 'https://api.geckode.my.id/btc.png'),
  TokenRef(
      symbol: 'ETH-USD',
      name: 'Ethereum',
      imageUrl: 'https://api.geckode.my.id/eth.png'),
];
