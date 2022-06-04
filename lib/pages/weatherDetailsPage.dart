// ignore_for_file: file_names

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:gotour/models/destination_model.dart';
import 'package:gotour/weatherAssistant/weatherAssistant.dart';
import 'package:gotour/weatherAssistant/weatherIconsManager.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weather/weather.dart';

class WeatherDetailsPage extends StatefulWidget {
  final Destination destination;
  final Weather weather;

  const WeatherDetailsPage({Key key, this.destination, this.weather})
      : super(key: key);

  @override
  _WeatherDetailsPageState createState() => _WeatherDetailsPageState();
}

class _WeatherDetailsPageState extends State<WeatherDetailsPage> {
  bool loading = false;
  ScrollController _scrollController;
  bool lastStatus = true;
  //BannerAd banner;
  List<Weather> weatherForecasts = [];
  List<Weather> todayForecasts = [];
  WeatherAssistant weatherAssistant = WeatherAssistant();
  WeatherIconsManager weatherIconsManager = WeatherIconsManager();
  bool forecastShowed = false;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    getForecast();
  }

  getForecast() async {
    setState(() {
      loading = true;
    });

    weatherForecasts = await weatherAssistant.getWeatherForecastInfo(
        widget.destination.city, widget.destination.country);

    weatherForecasts.forEach((forecast) {
      if (DateFormat('EEEEE', 'en_US').format(forecast.date) ==
          DateFormat('EEEEE', 'en_US').format(DateTime.now())) {
        todayForecasts.add(forecast);
      }
    });

    setState(() {
      loading = false;
      forecastShowed = true;
    });
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();

  //   final adState = Provider.of<AdState>(context);
  //   adState.initialization.then((status) {
  //     setState(() {
  //       banner = BannerAd(
  //           size: adState.adSize,
  //           adUnitId: adState.bannerAdUnitId,
  //           listener: adState.adListener,
  //           request: adState.request
  //       )..load();
  //     });
  //   });
  // }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    //banner?.dispose();
    super.dispose();
  }

  _scrollListener() {
    if (isShrink != lastStatus) {
      setState(() {
        lastStatus = isShrink;
      });
    }
  }

  bool get isShrink {
    return _scrollController.hasClients &&
        _scrollController.offset > (200 - kToolbarHeight);
  }

  String showDate() {
    return DateFormat.yMMMMEEEEd().format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isBright = DynamicTheme.of(context).brightness == Brightness.light;

    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        physics: BouncingScrollPhysics(),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              elevation: 0.0,
              pinned: true,
              title: AnimatedOpacity(
                  opacity: isShrink ? 1.0 : 0.0,
                  duration: Duration(seconds: 1),
                  child: Text(
                    "Weather",
                    style: TextStyle(
                        color: isBright ? Colors.black : Colors.white),
                  )),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              leading: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  decoration: BoxDecoration(
                      color: isShrink
                          ? Colors.transparent
                          : Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(30.0),
                          bottomRight: Radius.circular(30.0))),
                  child: Center(
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_rounded,
                        color: Colors.grey,
                      ),
                      //iconSize: 25.0,
                      color: Colors.grey,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ),
              expandedHeight: size.height * 0.25,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: [
                    Hero(
                      tag: widget.destination.imageUrl,
                      // child: CachedNetworkImage(
                      //   imageUrl: widget.destination.imageUrl,
                      //   height: MediaQuery.of(context).size.height * 0.3,
                      //   width: MediaQuery.of(context).size.width,
                      //   fit: BoxFit.cover,
                      //   progressIndicatorBuilder:
                      //       (context, url, downloadProgress) => Center(
                      //     child: Container(
                      //       height: 50.0,
                      //       width: 50.0,
                      //       child: CircularProgressIndicator(
                      //           strokeWidth: 1.0,
                      //           value: downloadProgress.progress,
                      //           valueColor:
                      //               AlwaysStoppedAnimation(Colors.grey)),
                      //     ),
                      //   ),
                      //   errorWidget: (context, url, error) => Icon(
                      //     Icons.error_outline_rounded,
                      //     color: Colors.grey,
                      //   ),
                      // ),
                      child: FadeInImage.assetNetwork(
                        placeholder: "assets/images/loader.gif",
                        placeholderScale: 0.5,
                        image: widget.destination.imageUrl,
                        height: MediaQuery.of(context).size.height * 0.3,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        height: size.height * 0.2,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                              Theme.of(context).scaffoldBackgroundColor,
                              Colors.transparent
                            ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter)),
                      ),
                    ),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      top: 0.0,
                      child: Container(
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Weather",
                                style: TextStyle(
                                    fontSize: 25.0, color: Colors.white),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                "${widget.destination.city}, ${widget.destination.country}",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ];
        },
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15.0, top: 15.0),
                child: Text(
                  showDate(),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 10.0),
                child: Container(
                  width: size.width,
                  decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black12,
                            spreadRadius: 6.0,
                            blurRadius: 6.0,
                            offset: Offset(2.0, 2.0))
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Image.network(
                            "http://openweathermap.org/img/w/${widget.weather.weatherIcon}.png",
                            height: 50.0,
                            width: 50.0,
                          ), //weatherIconsManager.manageIcon(widget.weather, 25.0),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "${widget.weather.temperature.celsius.round().toString()} \u2103",
                                style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 20.0),
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Icon(
                                Icons.circle,
                                size: 5.0,
                                color: Colors.grey,
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text(
                                "${widget.weather.weatherDescription}",
                                style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 20.0),
                              ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${widget.destination.city}, ${widget.destination.country}",
                                //style: TextStyle(color: Colors.white70),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                "Temp (High): ${widget.weather.tempMax.celsius.round().toString()} \u2103",
                                style: TextStyle(color: Colors.grey),
                              ),
                              Text(
                                "Temp (Low): ${widget.weather.tempMin.celsius.round().toString()} \u2103",
                                style: TextStyle(color: Colors.grey),
                              )
                            ],
                          ),
                        ),
                        loading
                            ? Container(
                                height: 20.0,
                                width: 20.0,
                                child: CircularProgressIndicator(
                                    strokeWidth: 1.0,
                                    //value: downloadProgress.progress,
                                    valueColor:
                                        AlwaysStoppedAnimation(Colors.grey)),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: todayForecasts.length,
                                itemBuilder: (context, index) {
                                  Weather weather = todayForecasts[index];
                                  //bool isNoon = DateFormat('HH:mm a').format(weather.date) == "12:00 PM";

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: InkWell(
                                      onTap: () {
                                        print(weather);
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          // Text(
                                          //   DateFormat('EEEEE', 'en_US').format(weather.date),
                                          //   style: TextStyle(fontWeight: FontWeight.w700),
                                          // ),
                                          Text(
                                              DateFormat('HH:mm a')
                                                  .format(weather.date),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700)),
                                          Image.network(
                                            "http://openweathermap.org/img/w/${weather.weatherIcon}.png",
                                            height: 30.0,
                                            width: 30.0,
                                          ),
                                          //weatherIconsManager.manageIcon(weather, 16.0),
                                          Text(
                                            "${weather.tempMax.celsius.round().toString()} \u2103/${weather.tempMin.celsius.round().toString()} \u2103",
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 10.0),
                child: AnimatedContainer(
                  duration: Duration(microseconds: 1500),
                  width: size.width,
                  decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black12,
                            spreadRadius: 6.0,
                            blurRadius: 6.0,
                            offset: Offset(2.0, 2.0))
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: const Text(
                            "Weather Forecast",
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                          trailing: loading
                              ? Container(
                                  height: 20.0,
                                  width: 20.0,
                                  child: const CircularProgressIndicator(
                                      strokeWidth: 1.0,
                                      //value: downloadProgress.progress,
                                      valueColor:
                                          AlwaysStoppedAnimation(Colors.grey)),
                                )
                              : IconButton(
                                  onPressed: () async {
                                    if (forecastShowed) {
                                      setState(() {
                                        forecastShowed = false;
                                      });
                                    } else if (forecastShowed == false &&
                                        weatherForecasts.isEmpty) {
                                      await getForecast();
                                    } else {
                                      setState(() {
                                        forecastShowed = true;
                                      });
                                    }
                                  },
                                  icon: Icon(
                                    forecastShowed
                                        ? Icons.keyboard_arrow_up_rounded
                                        : Icons.keyboard_arrow_down_rounded,
                                    color: Colors.grey,
                                  ),
                                ),
                        ),
                        forecastShowed
                            ? ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: weatherForecasts.length,
                                itemBuilder: (context, index) {
                                  Weather weather = weatherForecasts[index];
                                  bool isNoon = DateFormat('HH:mm a')
                                          .format(weather.date) ==
                                      "12:00 PM";

                                  return isNoon
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: InkWell(
                                            onTap: () {
                                              print(weather);
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  DateFormat('EEEEE', 'en_US')
                                                      .format(weather.date),
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                //Text(DateFormat('HH:mm a').format(weather.date)),
                                                Image.network(
                                                  "http://openweathermap.org/img/w/${weather.weatherIcon}.png",
                                                  height: 30.0,
                                                  width: 30.0,
                                                ),
                                                //weatherIconsManager.manageIcon(weather, 16.0),
                                                Text(
                                                  "${weather.tempMax.celsius.round().toString()} \u2103/${weather.tempMin.celsius.round().toString()} \u2103",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      : Container();
                                },
                              )
                            : Container()
                      ],
                    ),
                  ),
                ),
              ),
              // Center(
              //   child: banner == null ? Container() : Container(
              //     height: banner.size.height.toDouble(),
              //       width: banner.size.width.toDouble(),
              //       child: AdWidget(ad: banner)),
              // ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 10.0),
                child: Container(
                  width: size.width,
                  decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black12,
                            spreadRadius: 6.0,
                            blurRadius: 6.0,
                            offset: Offset(2.0, 2.0))
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "About ${widget.destination.city}",
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Text(widget.destination.description)
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
