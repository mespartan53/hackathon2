//import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:metro_app/ViewModels/home_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../Widgets/moving_widg.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  HomeViewModel homeVM = HomeViewModel();

  //Probably best to use a map for keys to let the
  //string be a description or some unique identifier
  Map<String, GlobalKey<MovingWidgState>> widgKeys = {
    'moveUp': GlobalKey(),
    'moveRight': GlobalKey(),
    'moveLeft': GlobalKey()
  };

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: homeVM,
      child: GridView.count(
        padding: ResponsiveWrapper.of(context).isSmallerThan(DESKTOP)
            ? const EdgeInsets.all(15.0)
            : const EdgeInsets.all(50.0),
        mainAxisSpacing: ResponsiveWrapper.of(context).isSmallerThan(DESKTOP) ? 8 : 15,
        crossAxisSpacing: ResponsiveWrapper.of(context).isSmallerThan(DESKTOP) ? 8 : 15,
        crossAxisCount: getColumnCount(),
        children: [
          CardWithAnimatedWidg(
            content: "Home",
            btnText: "Move it",
            offsetY: -1,
            widgKey: widgKeys['moveUp']!,
          ),
          CardWithAnimatedWidg(
            content: "New Animated Widg",
            btnText: "Move it again",
            offsetX: 1,
            widgKey: widgKeys['moveRight']!,
          ),
          CardWithAnimatedWidg(
            content: "Newer Widg",
            btnText: "You know the deal",
            offsetX: -1,
            widgKey: widgKeys['moveLeft']!,
          ),
          const Card(
            elevation: 5,
          ),
          const Card(
            elevation: 5,
          ),
        ],
      ),
    );
  }

  int getColumnCount() {
    if (ResponsiveWrapper.of(context).isTablet) {
      return 3;
    }
    if (ResponsiveWrapper.of(context).isMobile) {
      return 2;
    }
    return 4;
  }
}

class CardWithAnimatedWidg extends StatelessWidget {
  const CardWithAnimatedWidg({
    super.key,
    required this.content,
    this.btnText,
    this.duration,
    this.offsetX,
    this.offsetY,
    this.curve,
    required this.widgKey,
  });

  final String content;
  final String? btnText;
  final int? duration;
  final double? offsetX;
  final double? offsetY;
  final Curve? curve;
  final GlobalKey<MovingWidgState> widgKey;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: 300,
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MovingWidg(
              key: widgKey,
              duration: duration,
              offsetX: offsetX,
              offsetY: offsetY,
              curve: curve,
            ),
            SelectableText(content),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () => widgKey.currentState?.playWidgetAnimation(),
                child: Text(btnText ?? "Submit"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
