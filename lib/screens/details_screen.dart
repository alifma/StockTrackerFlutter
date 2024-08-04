import 'package:bloc_flutter/bloc/watchlist/watchlist_bloc.dart';
import 'package:bloc_flutter/constants.dart';
import 'package:bloc_flutter/helpers.dart';
import 'package:bloc_flutter/models/token.dart';
import 'package:bloc_flutter/models/token_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DetailsScreen extends StatelessWidget {
  final String symbol;

  const DetailsScreen({Key? key, required this.symbol}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tokenRef = tokenRefList.firstWhere(
        (tokenRef) => tokenRef.symbol == symbol,
        orElse: () => TokenRef(symbol: 'N/A', name: 'Unknown', imageUrl: ''));
    return Scaffold(
      appBar: AppBar(
        iconTheme:
            IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
        title: Text(
          symbol,
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      backgroundColor: Colors.white,
      body: BlocBuilder<WatchlistBloc, WatchlistState>(
        builder: (context, state) {
          if (state is WatchlistLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is WatchlistLoaded) {
            final token =
                state.tokens.firstWhere((token) => token.symbol == symbol);
            final historicalData = state.historicalData[symbol] ?? [];

            final chartData = historicalData.length > 30
                ? historicalData.sublist(historicalData.length - 30)
                : historicalData;

            final isNegative = token.dayChange.startsWith('-');
            final isNeutral = token.dayChange == '0.0';

            final lastPrice = NumberFormat.currency(
              symbol: "\$",
              decimalDigits: 3,
            ).format(double.parse(token.price));

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Hero(
                    tag: 'hero-image',
                    child: Image.network(
                      tokenRef.imageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Text(
                    tokenRef.name,
                    style: const TextStyle(fontSize: AppFontSizes.body),
                  ),
                  Text(
                    lastPrice,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: AppFontSizes.title,
                    ),
                  ),
                  Chip(
                    backgroundColor:
                        isNegative ? Colors.red[100] : Colors.greenAccent[100],
                    side: BorderSide.none,
                    avatar: Icon(
                      isNegative
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_up,
                      color:
                          conditionalTextColor(context, isNegative, isNeutral),
                    ),
                    label: Text(
                      '${parseAndFormatAbsolute(token.dayChangeDollar)} (${roundToTwoDecimalPlaces(token.dayChange)} %)',
                      style: TextStyle(
                        color: conditionalTextColor(
                            context, isNegative, isNeutral),
                        fontSize: AppFontSizes.sub,
                      ),
                    ),
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.brightness_1,
                        color: Colors.blue,
                        size: 10,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Last Price',
                        style: TextStyle(
                          fontSize: AppFontSizes.body,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: SfCartesianChart(
                      primaryXAxis: DateTimeAxis(
                        interval: 5,
                        dateFormat: DateFormat.Hms(),
                        majorGridLines: const MajorGridLines(
                            width: 1, dashArray: [1, 5], color: Colors.grey),
                        majorTickLines: const MajorTickLines(
                            size: 5, width: 2, color: Colors.grey),
                        minorGridLines: const MinorGridLines(
                            width: 1, dashArray: [1, 5], color: Colors.grey),
                      ),
                      primaryYAxis: NumericAxis(
                        interval: 1,
                        labelStyle:
                            const TextStyle(fontSize: 12, color: Colors.black),
                        numberFormat:
                            NumberFormat.simpleCurrency(decimalDigits: 0),
                        majorGridLines: const MajorGridLines(width: 1),
                        axisLine: const AxisLine(width: 0),
                      ),
                      zoomPanBehavior: ZoomPanBehavior(
                          enablePanning: true, zoomMode: ZoomMode.xy),
                      series: <CartesianSeries>[
                        SplineAreaSeries<Token, DateTime>(
                          dataSource: chartData,
                          xValueMapper: (Token token, int index) =>
                              DateTime.fromMillisecondsSinceEpoch(
                                  token.timestamp),
                          yValueMapper: (Token token, _) =>
                              double.parse(token.price),
                          gradient: LinearGradient(
                            colors: <Color>[
                              Colors.blue.withOpacity(0.2),
                              Colors.blue.withOpacity(0.01),
                            ],
                            stops: const [0.0, 1.0],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderColor: Colors.blue,
                          borderWidth: 2,
                        ),
                        ScatterSeries<Token, DateTime>(
                          dataSource:
                              chartData.isNotEmpty ? [chartData.last] : [],
                          xValueMapper: (Token token, int index) =>
                              DateTime.fromMillisecondsSinceEpoch(
                                  token.timestamp),
                          yValueMapper: (Token token, _) =>
                              double.parse(token.price),
                          color: Colors.blue,
                          markerSettings: const MarkerSettings(
                            isVisible: true,
                            shape: DataMarkerType.circle,
                            width: 10,
                            height: 10,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          } else if (state is WatchlistError) {
            return const Center(child: Text('Failed to load details'));
          }
          return Container();
        },
      ),
    );
  }
}
