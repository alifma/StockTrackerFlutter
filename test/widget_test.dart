import 'package:bloc_flutter/bloc/watchlist/watchlist_bloc.dart';
import 'package:bloc_flutter/repository/token_repository.dart';
import 'package:bloc_flutter/screens/watchlist_screen.dart';
import 'package:bloc_flutter/theme.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTokenRepository extends Mock implements TokenRepository {}

class MockWatchlistBloc extends MockBloc<WatchlistEvent, WatchlistState>
    implements WatchlistBloc {}

class FakeWatchlistEvent extends Fake implements WatchlistEvent {}

class FakeWatchlistState extends Fake implements WatchlistState {}

void main() {
  late MockWatchlistBloc mockWatchlistBloc;

  setUpAll(() {
    registerFallbackValue(FakeWatchlistEvent());
    registerFallbackValue(FakeWatchlistState());
  });

  setUp(() {
    mockWatchlistBloc = MockWatchlistBloc();
  });

  testWidgets('Main.dart displays WatchlistScreen',
      (WidgetTester tester) async {
    when(() => mockWatchlistBloc.state).thenReturn(WatchlistInitial());
    const appTheme = MaterialTheme(TextTheme());

    await tester.pumpWidget(
      BlocProvider<WatchlistBloc>(
        create: (context) => mockWatchlistBloc,
        child: MaterialApp(
          theme: appTheme.light(),
          home: const WatchlistScreen(),
        ),
      ),
    );

    expect(find.byType(WatchlistScreen), findsOneWidget);
  });
}
