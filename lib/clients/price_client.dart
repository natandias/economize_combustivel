import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class PriceClient {
  var uuid = const Uuid();

  CollectionReference gasStations =
      FirebaseFirestore.instance.collection('gas_stations');

  CollectionReference prices = FirebaseFirestore.instance.collection('prices');

  Future<Map<String, String>> getAverageFuelPricesByCity(
      String city, String state) async {
    double gasolinePrice = 0;
    double ethanolPrice = 0;
    double dieselPrice = 0;

    int gasStationsGasolineCount = 0;
    int gasStationsEthanolCount = 0;
    int gasStationsDieselCount = 0;

    await prices
        .where("city", isEqualTo: city)
        .where("state", isEqualTo: state)
        .get()
        .then((QuerySnapshot querySnapshot) => {
              // ignore: avoid_function_literals_in_foreach_calls
              querySnapshot.docs.forEach((gasStation) {
                Map<String, dynamic> data =
                    gasStation.data() as Map<String, dynamic>;
                double fuelPrice = data["price"];
                String fuelType = data["fuel_type"];

                if (fuelType == 'gasoline') {
                  gasolinePrice = gasolinePrice + fuelPrice;
                  gasStationsGasolineCount++;
                }

                if (fuelType == 'ethanol') {
                  ethanolPrice = ethanolPrice + fuelPrice;
                  gasStationsEthanolCount++;
                }

                if (fuelType == 'diesel') {
                  dieselPrice = dieselPrice + fuelPrice;
                  gasStationsDieselCount++;
                }
              }),

              if (gasStationsGasolineCount > 0)
                {gasolinePrice = gasolinePrice / gasStationsGasolineCount},

              if (gasStationsEthanolCount > 0)
                {ethanolPrice = ethanolPrice / gasStationsEthanolCount},

              if (gasStationsDieselCount > 0)
                {dieselPrice = dieselPrice / gasStationsDieselCount},
            });
    // .catchError((error) => print("Failed to get average prices: $error"));

    return Future(() => {
          "gasolinePrice": gasolinePrice.toStringAsFixed(3),
          "ethanolPrice": ethanolPrice.toStringAsFixed(3),
          "dieselPrice": dieselPrice.toStringAsFixed(3),
        });
  }

  Future<void> registerPrice(
    String gasStation,
    String city,
    String state,
    String fuelType,
    double price,
  ) async {
    await prices.doc(uuid.v4()).set({
      'gas_station': gasStation,
      'fuel_type': fuelType,
      'price': price,
      'date': DateTime.now(),
      'city': city,
      'state': state,
    }).catchError((error) => print("Failed to register price: $error"));
  }
}
