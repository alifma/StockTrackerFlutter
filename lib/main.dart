import 'package:bloc_flutter/bloc/watchlist/watchlist_bloc.dart';
import 'package:bloc_flutter/repository/token_repository.dart';
import 'package:bloc_flutter/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'screens/watchlist_screen.dart';

void main() {
  final tokenRepository = TokenRepository(
    'wss://ws.eodhistoricaldata.com/ws/crypto?api_token=demo',
  );

  runApp(MyApp(tokenRepository: tokenRepository));
}

class MyApp extends StatelessWidget {
  final TokenRepository tokenRepository;

  const MyApp({Key? key, required this.tokenRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const appTheme = MaterialTheme(TextTheme());
    return BlocProvider(
      create: (context) => WatchlistBloc(tokenRepository),
      child: MaterialApp(
        title: 'Crypto Watchlist',
        theme: appTheme.light(),
        home: WatchlistScreen(),
      ),
    );
  }
}
