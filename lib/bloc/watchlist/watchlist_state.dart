part of 'watchlist_bloc.dart';

abstract class WatchlistState extends Equatable {
  const WatchlistState();

  @override
  List<Object> get props => [];
}

class WatchlistInitial extends WatchlistState {}

class WatchlistLoading extends WatchlistState {}

class WatchlistLoaded extends WatchlistState {
  final List<Token> tokens;
  final Map<String, List<Token>> historicalData;
  final List<String> subscribedTokens;

  const WatchlistLoaded(
      this.tokens, this.historicalData, this.subscribedTokens);

  @override
  List<Object> get props => [tokens, historicalData, subscribedTokens];
}

class WatchlistError extends WatchlistState {
  final String message;

  const WatchlistError(this.message);

  @override
  List<Object> get props => [message];
}
