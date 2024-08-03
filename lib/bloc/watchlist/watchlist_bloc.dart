import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:bloc_flutter/models/token.dart';
import 'package:bloc_flutter/repository/token_repository.dart';
import 'package:equatable/equatable.dart';

part 'watchlist_event.dart';
part 'watchlist_state.dart';

class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {
  final TokenRepository tokenRepository;
  late StreamSubscription<Map<String, dynamic>> _subscription;
  final Map<String, List<Token>> _historicalData = {};
  final Map<String, int> _lastUpdateTimestamps = {};
  final List<String> _watchedTokens = [];
  final Set<String> _subscribedTokens = {};

  WatchlistBloc(this.tokenRepository, {List<String>? initialTokens})
      : super(WatchlistInitial()) {
    if (initialTokens != null && initialTokens.isNotEmpty) {
      _watchedTokens.addAll(initialTokens);
    }
    on<LoadWatchlist>(_onLoadWatchlist);
    on<UpdateTokenPrice>(_onUpdateTokenPrice);
    on<AddTokenToWatchlist>(_onAddTokenToWatchlist);
    on<UnsubscribeFromOtherTokens>(_onUnsubscribeFromOtherTokens);
    on<UnsubscribeFromToken>(_onUnsubscribeFromToken);

    _subscription = tokenRepository.tokenUpdates.listen((data) {
      add(UpdateTokenPrice(data));
    });
  }

  void _onLoadWatchlist(LoadWatchlist event, Emitter<WatchlistState> emit) {
    emit(WatchlistLoading());

    if (_watchedTokens.isEmpty) {
      _watchedTokens.add('BTC-USD');
      _watchedTokens.add('ETH-USD');
    }

    final currentTokens = _watchedTokens
        .map((symbol) => Token(
              symbol: symbol,
              price: '0.0',
              quantity: '0.0',
              dayChange: '0.0',
              dayChangeDollar: '0.0',
              timestamp: 0,
            ))
        .toList();

    emit(
      WatchlistLoaded(
        currentTokens,
        _historicalData,
        _watchedTokens,
      ),
    );

    _subscribeToTokens(_watchedTokens);
  }

  void _onUpdateTokenPrice(
      UpdateTokenPrice event, Emitter<WatchlistState> emit) {
    if (state is WatchlistLoaded) {
      final updatedTokens = (state as WatchlistLoaded).tokens.map((token) {
        if (token.symbol == event.data['s']) {
          final updatedToken = Token.fromJson(event.data);
          final currentTimestamp = updatedToken.timestamp ~/ 1000 * 1000;
          if (!_lastUpdateTimestamps.containsKey(updatedToken.symbol) ||
              _lastUpdateTimestamps[updatedToken.symbol] != currentTimestamp) {
            _lastUpdateTimestamps[updatedToken.symbol] = currentTimestamp;
            if (_historicalData.containsKey(updatedToken.symbol)) {
              _historicalData[updatedToken.symbol]?.add(updatedToken);
              if (_historicalData[updatedToken.symbol]!.length > 1000) {
                _historicalData[updatedToken.symbol]!.removeAt(0);
              }
            } else {
              _historicalData[updatedToken.symbol] = [updatedToken];
            }
          }

          return updatedToken;
        }
        return token;
      }).toList();

      emit(WatchlistLoaded(updatedTokens, _historicalData, _watchedTokens));
    }
  }

  void _onAddTokenToWatchlist(
      AddTokenToWatchlist event, Emitter<WatchlistState> emit) {
    if (state is WatchlistLoaded) {
      if (!_watchedTokens.contains(event.tokenSymbol)) {
        _watchedTokens.add(event.tokenSymbol);

        final newToken = Token(
          symbol: event.tokenSymbol,
          price: '0.0',
          quantity: '0.0',
          dayChange: '0.0',
          dayChangeDollar: '0.0',
          timestamp: 0,
        );

        final updatedTokens =
            List<Token>.from((state as WatchlistLoaded).tokens)..add(newToken);

        tokenRepository.subscribeToTokens([event.tokenSymbol]);

        emit(WatchlistLoaded(updatedTokens, _historicalData, _watchedTokens));
      }
    }
  }

  void _onUnsubscribeFromOtherTokens(
      UnsubscribeFromOtherTokens event, Emitter<WatchlistState> emit) {
    if (state is WatchlistLoaded) {
      final watchedTokensSet = _watchedTokens.toSet();
      final currentTokensSet = event.currentTokens.toSet();

      final tokensToUnsubscribe = watchedTokensSet
          .where((token) => !currentTokensSet.contains(token))
          .toList();
      if (tokensToUnsubscribe.isNotEmpty) {
        tokenRepository.unsubscribeFromTokens(tokensToUnsubscribe);
        _subscribedTokens.removeAll(tokensToUnsubscribe);
      }
    }
  }

  void _subscribeToTokens(List<String> tokens) {
    final tokensToSubscribe =
        tokens.where((symbol) => !_subscribedTokens.contains(symbol)).toList();
    if (tokensToSubscribe.isNotEmpty) {
      tokenRepository.subscribeToTokens(tokensToSubscribe);
      _subscribedTokens.addAll(tokensToSubscribe);
    }
  }

  void _onUnsubscribeFromToken(
      UnsubscribeFromToken event, Emitter<WatchlistState> emit) {
    if (state is WatchlistLoaded) {
      final symbol = event.tokenSymbol;
      if (_watchedTokens.contains(symbol)) {
        _watchedTokens.remove(symbol);
        _subscribedTokens.remove(symbol);
        tokenRepository.unsubscribeFromTokens([symbol]);
        final updatedTokens =
            List<Token>.from((state as WatchlistLoaded).tokens)
              ..removeWhere((token) => token.symbol == symbol);

        emit(WatchlistLoaded(updatedTokens, _historicalData, _watchedTokens));
      }
    }
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
