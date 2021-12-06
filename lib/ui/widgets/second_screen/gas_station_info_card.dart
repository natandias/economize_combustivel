import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class GasStationInfoCard extends StatelessWidget {
  final String title;
  final String price;
  final String address;
  final String user;
  final String postDate;
  final bool isPrimaryColor;

  const GasStationInfoCard({
    Key? key,
    required this.title,
    required this.price,
    required this.isPrimaryColor,
    required this.address,
    required this.user,
    required this.postDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = isPrimaryColor
        ? Theme.of(context).primaryTextTheme
        : Theme.of(context).textTheme;
    return Card(
      elevation: 2,
      color: isPrimaryColor
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
                        title,
                        style:
                            textTheme.bodyText1!.apply(fontFamily: 'Poppins'),
                        textAlign: TextAlign.center,
                      ),
                    )),
              ],
            ),
            const SizedBox(width: 10),
            Row(
              children: <Widget>[
                Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          width: 240,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 220,
                                        child: Row(
                                          children: [
                                            Icon(
                                              Ionicons.location_outline,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              size: 15,
                                            ),
                                            const SizedBox(width: 5),
                                            Expanded(
                                              child: Text(
                                                address,
                                                style: textTheme.bodyText1!
                                                    .apply(
                                                        fontFamily: 'Poppins'),
                                                textAlign: TextAlign.left,
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
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Ionicons.person_outline,
                                            color:
                                                Theme.of(context).primaryColor,
                                            size: 15,
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            user,
                                            style: textTheme.bodyText1!
                                                .apply(fontFamily: 'Poppins'),
                                            textAlign: TextAlign.left,
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
                                            Ionicons.calendar_outline,
                                            color:
                                                Theme.of(context).primaryColor,
                                            size: 15,
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            postDate,
                                            style: textTheme.bodyText1!
                                                .apply(fontFamily: 'Poppins'),
                                            textAlign: TextAlign.left,
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
                        color: Theme.of(context).backgroundColor,
                        alignment: Alignment.center,
                        child: Text(
                          price != '' ? "R\$ $price" : '',
                          style:
                              textTheme.bodyText1!.apply(fontFamily: 'Poppins'),
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
