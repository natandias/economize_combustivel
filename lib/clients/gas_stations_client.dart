import 'package:cloud_firestore/cloud_firestore.dart';

class GasStationsClient {
  CollectionReference gasStations =
      FirebaseFirestore.instance.collection('gas_stations');

  Future<List<Map<String, dynamic>>> getGasStations(String city) async {
    List<Map<String, dynamic>> gasStationsList = [];

    await gasStations
        .where("city", isEqualTo: city)
        .get()
        .then((QuerySnapshot querySnapshot) => {
              // ignore: avoid_function_literals_in_foreach_calls
              querySnapshot.docs.forEach((gasStation) {
                Map<String, dynamic> data =
                    gasStation.data() as Map<String, dynamic>;
                gasStationsList.add(data);
              }),
            })
        .catchError((error) => print("Failed to get average prices: $error"));

    return Future(() => gasStationsList);
  }
}
