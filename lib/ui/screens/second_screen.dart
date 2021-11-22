import 'package:flutter/material.dart';
import 'package:flutter_production_boilerplate/ui/widgets/header.dart';
import 'package:flutter_production_boilerplate/ui/widgets/second_screen/grid_item.dart';
import 'package:flutter_production_boilerplate/ui/widgets/second_screen/link_card.dart';
import 'package:flutter_production_boilerplate/ui/widgets/second_screen/text_divider.dart';
import 'package:ionicons/ionicons.dart';

class SecondScreen extends StatelessWidget {
  const SecondScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).backgroundColor,
      child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          physics: const BouncingScrollPhysics(),
          children: [
            const Header(text: 'bottom_nav_second'),
            const LinkCard(
                title: 'github_card_title',
                icon: Ionicons.logo_github,
                url:
                    'https://github.com/anfeichtinger/flutter_production_boilerplate'),
            const TextDivider(text: 'author_divider_title'),
            const SizedBox(height: 8),
            GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 2 / 1,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              shrinkWrap: true,
              children: const [
                GridItem(
                  title: 'instagram_card_title',
                  icon: Ionicons.logo_instagram,
                  url: 'https://www.instagram.com/anfeichtinger',
                ),
              ],
            ),
            const TextDivider(text: 'packages_divider_title'),
            GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 2 / 1,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              shrinkWrap: true,
              children: const [
                GridItem(
                  title: 'flutter_bloc',
                  icon: Ionicons.apps_outline,
                  url: 'https://pub.dev/packages/flutter_bloc',
                ),
              ],
            ),
            const SizedBox(height: 36),
          ]),
    );
  }
}
