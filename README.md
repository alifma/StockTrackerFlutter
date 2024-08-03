# Crypto Watchlist App
<p align="center">
  <img src="android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png" alt="App Icon" width="200"/>
</p>

**Stock Tracker** is a Flutter-based application designed to help users track cryptocurrency prices and view detailed historical data. The app uses real-time WebSocket updates and displays data in a user-friendly interface. Data is sourced from [EOD Historical Data](https://eodhd.com/financial-apis/new-real-time-data-api-websockets). The app has been tested on iOS (iPhone X) and Android (API 34 and latest).

## Features
- Real-time cryptocurrency price tracking
- Detailed historical data with updates every second
- Select token to watch

## Screenshots

![Watchlist](https://api.geckode.my.id/StockTracker-Home.png)
![Historical Data](https://api.geckode.my.id/StockTracker-HomeSelect.png)
![Info Screen](https://api.geckode.my.id/StockTracker-Details.png)


# Getting Started
To get started with Stock Tracker, follow these steps:

### Prerequisites
- Flutter 3.16.0
- Dart 3.2.0

## Installation

1. Clone the repository:
    ```sh
    git clone https://github.com/alifma/StockTrackerFlutter.git
    ```

2. Navigate to the project directory:
    ```sh
    cd StockTrackerFlutter
    ```

3. Install dependencies:
    ```sh
    flutter pub get
    ```

4. Run the app:
    ```sh
    flutter run
    ```

## Usage

1. Launch the app on your device.
2. On the home/watchlist screen, you can see the latest prices of your selected tokens. 
3. Configure the watched stock by pressing the settings button.
4. Tap on a token to view detailed historical data.


## Packages Used
- **cupertino_icons** - ^1.0.2
- **flutter_bloc** - ^8.1.6
- **web_socket_channel** - ^2.4.0
- **equatable** - ^2.0.5
- **bloc** - ^8.1.4
- **intl** - ^0.19.0
- **syncfusion_flutter_charts** - 25.2.4
- **fluttertoast** - ^8.2.5
- **url_launcher** - ^6.3.0

