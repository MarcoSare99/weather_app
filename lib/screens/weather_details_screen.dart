import 'package:flutter/material.dart';
import 'package:weather_app/models/weather_data.dart';
import 'package:weather_app/network/api_weather.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class WeatherDetailsScreen extends StatefulWidget {
  WeatherData weatherData;
  WeatherDetailsScreen({super.key, required this.weatherData});

  @override
  State<WeatherDetailsScreen> createState() => _WeatherDetailsScreen();
}

class _WeatherDetailsScreen extends State<WeatherDetailsScreen> {
  ApiWeather apiWeather = ApiWeather();
  Future<WeatherData?> getWeatherData() async {
    //WeatherData? response = await apiWeather.getWeatherData(lat: 20.5279721, lon: -100.8112995);
    //return apiWeather.getWeather();
    WeatherData? response = await apiWeather.getWeather();
    /* 
    print(response!.listWeek.length);
    for (int i = 0; 5 > i; i++) {
      print(response!.listWeek[i].date);
    }
    */
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.weatherData.name),
      ),
      body: ListView(padding: const EdgeInsets.all(10), children: [
        Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 30),
              padding: const EdgeInsets.all(20),
              height: 175,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(28, 28, 115, 0.726),
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            '${widget.weatherData.main.temp}°C',
                            style: const TextStyle(
                                color: Color.fromRGBO(255, 255, 255, 0.536),
                                fontSize: 38,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    )),
                    Text(widget.weatherData.weather[0].main,
                        style: const TextStyle(
                            color: Color.fromRGBO(255, 255, 255, 0.825),
                            fontSize: 22,
                            fontWeight: FontWeight.bold)),
                    Text(widget.weatherData.weather[0].description,
                        style: const TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 0.536),
                          fontSize: 14,
                        ))
                  ]),
            ),
            Positioned(
                top: 0,
                left: 20,
                child: Container(
                  width: 125,
                  height: 125,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                            'assets/icons/${widget.weatherData.weather[0].icon}.png'),
                        fit: BoxFit.fill),
                  ),
                  padding: const EdgeInsets.all(20),
                ))
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: cardDetailsTemp(
                      title: 'Max Temp.',
                      icon: const Icon(
                        Icons.thermostat,
                        size: 30,
                        color: Colors.white,
                      ),
                      text: '${widget.weatherData.main.tempMax.toString()}°C')),
              Expanded(
                  child: cardDetailsTemp(
                      title: 'Min Temp.',
                      icon: const Icon(
                        Icons.thermostat,
                        size: 30,
                        color: Colors.white,
                      ),
                      text: '${widget.weatherData.main.tempMin.toString()}°C')),
              Expanded(
                  child: cardDetailsTemp(
                      title: 'Hume.',
                      icon: const Icon(
                        Icons.ac_unit,
                        size: 30,
                        color: Colors.white,
                      ),
                      text: widget.weatherData.main.humidity.toString())),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          child: Text(
            'Hoy',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          width: double.infinity,
          height: 100,
          child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Container(
                  height: 110,
                  width: 110,
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color:
                            const Color.fromARGB(255, 8, 8, 8).withOpacity(0.9),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${widget.weatherData.listWeek[index].main.temp}°C'
                            .toString(),
                        style: const TextStyle(
                            color: Color.fromRGBO(104, 104, 251, 0.722),
                            fontWeight: FontWeight.bold),
                      ),
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                  'assets/icons/${widget.weatherData.listWeek[index].weather[0].icon}.png'),
                              fit: BoxFit.fill),
                        ),
                      ),
                      Text(
                        widget.weatherData.listWeek[index].date
                            .split(' ')[1]
                            .toString(),
                        style: const TextStyle(
                          color: Color.fromRGBO(104, 104, 251, 0.722),
                        ),
                      ),
                    ],
                  ),
                );
              },
              itemCount: 5),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          child: Text(
            'Esta semana',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
            child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    height: 110,
                    width: 110,
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(155, 47, 47, 147),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 0, 0, 0)
                              .withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    'assets/icons/${widget.weatherData.listWeek[index + 5].weather[0].icon}.png'),
                                fit: BoxFit.fill),
                          ),
                        ),
                        Expanded(
                          child: Column(children: [
                            Column(
                              children: [
                                Text(
                                  '${widget.weatherData.listWeek[index + 5].main.temp}°C'
                                      .toString(),
                                  style: const TextStyle(
                                      color:
                                          Color.fromRGBO(255, 255, 255, 0.536),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Max: ${widget.weatherData.listWeek[index + 5].main.tempMax}°C'
                                            .toString(),
                                        style: const TextStyle(
                                            color: Color.fromRGBO(
                                                255, 255, 255, 0.536),
                                            fontSize: 12),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Min: ${widget.weatherData.listWeek[index + 5].main.tempMin}°C'
                                            .toString(),
                                        style: const TextStyle(
                                            color: Color.fromRGBO(
                                                255, 255, 255, 0.536),
                                            fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  formatDate(widget
                                      .weatherData.listWeek[index + 5].date
                                      .toString()),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                )
                              ],
                            )
                          ]),
                        ),
                        /* 
                              Text(
                                snapshot.data!.listWeek[index + 5].date
                                    .toString(),
                                style: const TextStyle(
                                  color: Color.fromRGBO(28, 28, 115, 0.726),
                                ),
                              ),
                             */
                      ],
                    ),
                  );
                },
                itemCount: widget.weatherData.listWeek.length - 5))
      ]),
    );
  }

/* 
Text(snapshot.data!.listWeek[index].date)
*/
  Widget cardDetailsTemp(
      {required String title, required Icon icon, required String text}) {
    return Column(
      children: [
        Text(title),
        Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(28, 28, 115, 0.726),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: icon),
        Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  String formatDate(String date) {
    DateTime fecha = DateTime.parse(date);
    String fechaFormateada = DateFormat('d MMM hh:mm a').format(fecha);
    return fechaFormateada;
  }
}
