part of 'watchlist_bloc.dart';

abstract class WatchlistEvent extends Equatable {
  const WatchlistEvent();

  @override
  List<Object> get props => [];
}

class LoadWatchlist extends WatchlistEvent {}

class UpdateTokenPrice extends WatchlistEvent {
  final Map<String, dynamic> data;

  const UpdateTokenPrice(this.data);

  @override
  List<Object> get props => [data];
}

class AddTokenToWatchlist extends WatchlistEvent {
  final String tokenSymbol;

  const AddTokenToWatchlist(this.tokenSymbol);

  @override
  List<Object> get props => [tokenSymbol];
}

class UnsubscribeFromOtherTokens extends WatchlistEvent {
  final List<String> currentTokens;

  const UnsubscribeFromOtherTokens(this.currentTokens);

  @override
  List<Object> get props => [currentTokens];
}

class UnsubscribeFromToken extends WatchlistEvent {
  final String tokenSymbol;

  const UnsubscribeFromToken(this.tokenSymbol);

  @override
  List<Object> get props => [tokenSymbol];
}
