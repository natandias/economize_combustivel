import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:economize_combustivel/clients/price_client.dart';
import 'package:economize_combustivel/cubit/location_cubit.dart';
import 'package:economize_combustivel/ui/widgets/location_map.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:intl/intl.dart';

class GasStationInfoCard extends StatefulWidget {
  final String title;
  final String price;
  final String address;
  final String currentFuelType;
  final bool isPrimaryColor;
  final void Function() openMap;

  const GasStationInfoCard(
      {Key? key,
      required this.title,
      required this.price,
      required this.isPrimaryColor,
      required this.address,
      required this.currentFuelType,
      required this.openMap})
      : super(key: key);

  @override
  State<GasStationInfoCard> createState() => _GasStationInfoCard();
}

class _GasStationInfoCard extends State<GasStationInfoCard> {
  final priceClient = PriceClient();

  @override
  Widget build(BuildContext context) {
    final textTheme = widget.isPrimaryColor
        ? Theme.of(context).primaryTextTheme
        : Theme.of(context).textTheme;

    final currentFuelType = widget.currentFuelType == 'Gasolina'
        ? 'gasoline'
        : widget.currentFuelType == 'Etanol'
            ? 'ethanol'
            : 'diesel';

    return BlocBuilder<LocationCubit, LocationState>(
        builder: (locationCubitBuilderContext, state) {
      return SizedBox(
          height: 170,
          width: 600,
          child: FutureBuilder<Map<String, String>>(
              future: priceClient.getLastPrices(widget.title, currentFuelType,
                  state.citySelected, state.stateSelected),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Card(
                      elevation: 2,
                      color: widget.isPrimaryColor
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).cardColor,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(children: [
                          Container(
                              color: Theme.of(context).primaryColor,
                              width: 100,
                              height: 60,
                              child: const Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Carregando dados...',
                                  style: TextStyle(
                                      color: Colors.amber, fontSize: 25.0),
                                  textAlign: TextAlign.center,
                                ),
                              )),
                        ]),
                      ),
                    );
                  default:
                    if (snapshot.hasError) {
                      print('card gas station err: ${snapshot.error}');
                      return const SizedBox.shrink();
                      // return Card(
                      //   elevation: 2,
                      //   color: widget.isPrimaryColor
                      //       ? Theme.of(context).primaryColor
                      //       : Theme.of(context).cardColor,
                      //   shape: const RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.all(Radius.circular(8))),
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(10.0),
                      //     child: Row(children: [
                      //       Container(
                      //           color: Theme.of(context).primaryColor,
                      //           width: 100,
                      //           height: 60,
                      //           child: const Align(
                      //             alignment: Alignment.center,
                      //             child: Text(
                      //               'Erro ao carregar dados :(',
                      //               style: TextStyle(
                      //                   color: Colors.amber, fontSize: 25.0),
                      //               textAlign: TextAlign.center,
                      //             ),
                      //           )),
                      //     ]),
                      //   ),
                      // );
                    } else {
                      print('snapshot.data!!: ${snapshot.data}');
                      var price = snapshot.data!['price'];
                      var date = snapshot.data!['date'];
                      var dateParsed = DateFormat("yyyy-mm-dd").parse(date!);
                      var postDate = dateParsed.toString().split(' ')[0];
                      var username = snapshot.data!['username'];

                      return Card(
                        elevation: 2,
                        color: widget.isPrimaryColor
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).cardColor,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      color: Theme.of(context).primaryColor,
                                      width: 100,
                                      height: 60,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          widget.title,
                                          style: textTheme.bodyText1!
                                              .apply(fontFamily: 'Poppins'),
                                          textAlign: TextAlign.center,
                                        ),
                                      )),
                                  SizedBox(
                                      width: 100,
                                      height: 60,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: TextButton(
                                              style: TextButton.styleFrom(
                                                textStyle: const TextStyle(
                                                    fontSize: 20),
                                              ),
                                              onPressed: widget.openMap,
                                              child: Text('Ver no mapa',
                                                  style: textTheme.bodyText1!
                                                      .apply(
                                                    fontFamily: 'Poppins',
                                                    decoration: TextDecoration
                                                        .underline,
                                                  ),
                                                  textAlign: TextAlign.center),
                                            ),
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                              const SizedBox(width: 10),
                              Row(
                                children: <Widget>[
                                  Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                            width: 240,
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(
                                                          width: 220,
                                                          child: Row(
                                                            children: [
                                                              Icon(
                                                                Ionicons
                                                                    .location_outline,
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                                size: 15,
                                                              ),
                                                              const SizedBox(
                                                                  width: 5),
                                                              Expanded(
                                                                child: Text(
                                                                  widget
                                                                      .address,
                                                                  style: textTheme
                                                                      .bodyText1!
                                                                      .apply(
                                                                          fontFamily:
                                                                              'Poppins'),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(height: 20),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              Ionicons
                                                                  .person_outline,
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                              size: 15,
                                                            ),
                                                            const SizedBox(
                                                                width: 5),
                                                            Text(
                                                              username ??
                                                                  'Anônimo',
                                                              style: textTheme
                                                                  .bodyText1!
                                                                  .apply(
                                                                      fontFamily:
                                                                          'Poppins'),
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                    Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              Ionicons
                                                                  .calendar_outline,
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                              size: 15,
                                                            ),
                                                            const SizedBox(
                                                                width: 5),
                                                            Text(
                                                              postDate
                                                                  .toString(),
                                                              style: textTheme
                                                                  .bodyText1!
                                                                  .apply(
                                                                      fontFamily:
                                                                          'Poppins'),
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                )
                                              ],
                                            )),
                                        const SizedBox(height: 5),
                                        Container(
                                          width: 240,
                                          height: 40,
                                          color:
                                              Theme.of(context).backgroundColor,
                                          alignment: Alignment.center,
                                          child: Text(
                                            price != '' ? "R\$ ${price}" : '',
                                            style: textTheme.bodyText1!
                                                .apply(fontFamily: 'Poppins'),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ]),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                }
              }));
    });
  }
}
