import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String price;
  final bool isPrimaryColor;

  const InfoCard(
      {Key? key,
      required this.title,
      required this.icon,
      required this.price,
      required this.isPrimaryColor})
      : super(key: key);

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
                    height: 90,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        title,
                        style:
                            textTheme.headline6!.apply(fontFamily: 'Poppins'),
                        textAlign: TextAlign.center,
                      ),
                    )),
              ],
            ),
            const SizedBox(width: 100),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  price != '' ? "R\$ $price" : 'Sem média',
                  style: textTheme.headline6!.apply(fontFamily: 'Poppins'),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
