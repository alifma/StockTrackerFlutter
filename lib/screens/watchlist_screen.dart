import 'package:bloc_flutter/constants.dart';
import 'package:bloc_flutter/helpers.dart';
import 'package:bloc_flutter/models/token_list.dart';
import 'package:bloc_flutter/screens/info_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_flutter/bloc/watchlist/watchlist_bloc.dart';
import 'package:intl/intl.dart';
import 'details_screen.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  _WatchlistScreenState createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  @override
  void initState() {
    super.initState();
    context.read<WatchlistBloc>().add(LoadWatchlist());
  }

  void _showAddTokenDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Token'),
          content: SizedBox(
            width: double.maxFinite,
            child: BlocBuilder<WatchlistBloc, WatchlistState>(
              builder: (BuildContext context, state) {
                final watchedTokens =
                    state is WatchlistLoaded ? state.subscribedTokens : [];
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: tokenRefList.length,
                  itemBuilder: (BuildContext context, int index) {
                    final tokenRef = tokenRefList[index];
                    final isToggled = watchedTokens.contains(tokenRef.symbol);
                    return ListTile(
                      leading: Hero(
                        tag: 'hero-image',
                        child: Image.network(
                          tokenRef.imageUrl,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(tokenRef.symbol),
                      subtitle: Text(tokenRef.name),
                      trailing: Switch(
                        value: isToggled,
                        onChanged: (bool isOn) {
                          if (isOn) {
                            context
                                .read<WatchlistBloc>()
                                .add(AddTokenToWatchlist(tokenRef.symbol));
                          } else {
                            context
                                .read<WatchlistBloc>()
                                .add(UnsubscribeFromToken(tokenRef.symbol));
                          }
                          Navigator.of(context).pop();
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Home",
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        iconTheme:
            IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            icon: Icon(Icons.info,
                color: Theme.of(context).colorScheme.onPrimary),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InfoScreen(),
                  ));
            },
          ),
          const SizedBox(
            width: AppSizes.mediumPadding,
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Column(
              children: [
                Container(
                  height: AppSizes.largePadding * 2,
                  color: Theme.of(context).colorScheme.primary,
                ),
                Expanded(
                  child: Container(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: AppSizes.smallPadding,
            left: AppSizes.smallPadding,
            right: AppSizes.smallPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  surfaceTintColor: Colors.transparent,
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Container(
                          child: Column(
                            children: [
                              const Text(
                                'Your Balance',
                                style: TextStyle(fontSize: AppFontSizes.body),
                              ),
                              Text(
                                NumberFormat.simpleCurrency(decimalDigits: 3)
                                    .format(0),
                                style: const TextStyle(
                                    fontSize: AppFontSizes.heading,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {
                                showToast("Top-up will be available soon!");
                              },
                              child: const Column(
                                children: [
                                  Icon(Icons.account_balance_wallet),
                                  Text("TopUp")
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                showToast("Check-out will be available soon!");
                              },
                              child: const Column(
                                children: [
                                  Icon(Icons.file_download),
                                  Text("Checkout")
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                showToast("History will be available soon!");
                              },
                              child: const Column(
                                children: [
                                  Icon(Icons.history),
                                  Text("History")
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.mediumPadding),
                Padding(
                  padding: const EdgeInsets.only(
                      left: AppSizes.smallPadding,
                      right: AppSizes.smallPadding),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text(
                            "Watchlist",
                            style: TextStyle(
                              fontSize: AppFontSizes.title,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            color: Theme.of(context).colorScheme.primary,
                            icon: const Icon(Icons.settings),
                            onPressed: _showAddTokenDialog,
                          ),
                        ],
                      ),
                      const Divider(
                        height: AppSizes.smallMargin,
                      ),
                      Row(
                        children: [
                          Text(
                            "Token Code",
                            style: TextStyle(
                                fontSize: AppFontSizes.body,
                                color: Theme.of(context).colorScheme.secondary),
                          ),
                          const Spacer(),
                          Text(
                            "Performance",
                            style: TextStyle(
                                fontSize: AppFontSizes.body,
                                color: Theme.of(context).colorScheme.secondary),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned.fill(
            top: 270,
            child: BlocBuilder<WatchlistBloc, WatchlistState>(
              builder: (context, state) {
                if (state is WatchlistLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is WatchlistLoaded) {
                  return ListView.separated(
                    separatorBuilder: (BuildContext context, int index) {
                      return const Padding(
                        padding: EdgeInsets.only(left: 16, right: 16),
                        child: Divider(
                          thickness: 1,
                        ),
                      );
                    },
                    itemCount: state.tokens.length,
                    itemBuilder: (context, index) {
                      final token = state.tokens[index];
                      final isNegative = token.dayChange.startsWith('-');
                      final isNeutral = token.dayChange == '0.0';
                      final tokenRef = tokenRefList.firstWhere(
                          (tokenRef) => tokenRef.symbol == token.symbol,
                          orElse: () => const TokenRef(
                              symbol: 'N/A', name: 'Unknown', imageUrl: ''));
                      return ListTile(
                        leading: Image.network(
                          tokenRef.imageUrl,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                        title: Text(
                          token.symbol,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(tokenRef.name),
                        trailing: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              NumberFormat.currency(
                                      symbol: "\$", decimalDigits: 3)
                                  .format(double.parse(token.price)),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: AppFontSizes.body,
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isNegative
                                      ? Icons.keyboard_arrow_down
                                      : Icons.keyboard_arrow_up,
                                  color: conditionalTextColor(
                                      context, isNegative, isNeutral),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${parseAndFormatAbsolute(token.dayChangeDollar)} (${roundToTwoDecimalPlaces(token.dayChange)} %)',
                                  style: TextStyle(
                                    color: conditionalTextColor(
                                        context, isNegative, isNeutral),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        onTap: () async {
                          try {
                            context.read<WatchlistBloc>().add(
                                UnsubscribeFromOtherTokens([token.symbol]));

                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailsScreen(
                                  symbol: token.symbol,
                                ),
                              ),
                            );

                            if (result == null) {
                              context
                                  .read<WatchlistBloc>()
                                  .add(LoadWatchlist());
                            }
                          } catch (e) {
                            if (kDebugMode) {
                              print('Error during navigation: $e');
                            }
                          }
                        },
                      );
                    },
                  );
                } else if (state is WatchlistError) {
                  return const Center(child: Text('Failed to load watchlist'));
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}
