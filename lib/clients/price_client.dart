import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class PriceClient {
  var uuid = const Uuid();

  CollectionReference gasStations =
      FirebaseFirestore.instance.collection('gas_stations');
  
  CollectionReference prices = FirebaseFirestore.instance.collection('prices');

  Future<Map<String, String>> getAverageFuelPricesByCity(String city) async {
    double gasolinePrice = 0;
    double ethanolPrice = 0;
    double dieselPrice = 0;
    int gasStationsCount = 0;

    await gasStations
        .where("city", isEqualTo: city)
        .get()
        .then((QuerySnapshot querySnapshot) => {
              // ignore: avoid_function_literals_in_foreach_calls
              querySnapshot.docs.forEach((gasStation) {
                Map<String, dynamic> data =
                    gasStation.data() as Map<String, dynamic>;
                Map<String, dynamic> fuelData = data["average_price"];
                gasolinePrice = gasolinePrice + fuelData['gasoline'];
                ethanolPrice = ethanolPrice + fuelData['ethanol'];
                dieselPrice = dieselPrice + fuelData['diesel'];
                gasStationsCount++;
              }),
              if (gasStationsCount > 0)
                {
                  gasolinePrice = gasolinePrice / gasStationsCount,
                  ethanolPrice = ethanolPrice / gasStationsCount,
                  dieselPrice = dieselPrice / gasStationsCount,
                }
            })
        .catchError((error) => print("Failed to get average prices: $error"));

    return Future(() => {
          "gasolinePrice": gasolinePrice.toStringAsFixed(3),
          "ethanolPrice": ethanolPrice.toStringAsFixed(3),
          "dieselPrice": dieselPrice.toStringAsFixed(3),
        });
  }

  Future<void> registerPrice(
    String gasStation,
    String fuelType,
    double price,
  ) async {
    await prices.doc(uuid.v4()).set({
      'gas_station': gasStation,
      'fuel_type': fuelType,
      'price': price,
      'date': DateTime.now(),
    }).catchError((error) => print("Failed to register price: $error"));
  }
}
