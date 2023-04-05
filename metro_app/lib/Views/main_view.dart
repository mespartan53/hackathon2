import 'package:flutter/material.dart';
import 'package:metro_app/ViewModels/main_viewmodel.dart';
import 'package:metro_app/Views/home_view.dart';
import '../Widgets/hover_text.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  HomeViewModel viewModel = HomeViewModel();

  final IconData homeIcon = Icons.home;
  final IconData favoriteIcon = Icons.star;
  final IconData aboutIcon = Icons.info_sharp;

  final String homeText = 'Home';
  final String favText = 'Favorites';
  final String aboutText = 'About';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: Scaffold(
        appBar: ResponsiveWrapper.of(context).isSmallerThan(TABLET)
            ? AppBar(
                title: const SelectableText('The Metro App'),
                elevation: 0,
                centerTitle: true,
                backgroundColor: Colors.green,
              )
            : null,
        drawer: Drawer(
          width: 225,
          elevation: 0,
          child: Consumer<HomeViewModel>(
            builder: (BuildContext context, value, Widget? child) {
              return ListView(
                children: [
                  const DrawerHeader(child: Center(child: Text('Metro'))),
                  ListTile(
                    title: HoverText(
                      text: homeText,
                      mainColor: Colors.black,
                      hoverColor: Colors.blue,
                      onTap: () {
                        viewModel.updateIndex(0);
                      },
                    ),
                    leading: Icon(
                      homeIcon,
                      color: viewModel.selectedIndex == 0
                          ? Colors.blue
                          : Colors.grey,
                    ),
                  ),
                  ListTile(
                    title: HoverText(
                      text: favText,
                      mainColor: Colors.black,
                      hoverColor: Colors.blue,
                      onTap: () {
                        viewModel.updateIndex(1);
                      },
                    ),
                    leading: Icon(
                      favoriteIcon,
                      color: viewModel.selectedIndex == 1
                          ? Colors.blue
                          : Colors.grey,
                    ),
                  ),
                  ListTile(
                    title: HoverText(
                      text: aboutText,
                      mainColor: Colors.black,
                      hoverColor: Colors.blue,
                      onTap: () {
                        viewModel.updateIndex(2);
                      },
                    ),
                    leading: Icon(
                      aboutIcon,
                      color: viewModel.selectedIndex == 2
                          ? Colors.blue
                          : Colors.grey,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        body: Row(
          children: [
            ResponsiveWrapper.of(context).isLargerThan(MOBILE)
                ? Consumer<HomeViewModel>(
                    builder: (BuildContext context, value, Widget? child) {
                      return NavigationRail(
                        selectedIndex: viewModel.selectedIndex,
                        useIndicator: true,
                        elevation: 8,
                        onDestinationSelected: (val) {
                          viewModel.updateIndex(val);
                        },
                        minWidth: 65,
                        labelType: NavigationRailLabelType.all,
                        indicatorColor: Colors.blueGrey[50],
                        backgroundColor: Colors.green,
                        destinations: [
                          NavigationRailDestination(
                              icon: Icon(homeIcon),
                              label: Text(
                                homeText,
                                style: const TextStyle(color: Colors.black),
                              )),
                          NavigationRailDestination(
                              icon: Icon(favoriteIcon),
                              label: Text(
                                favText,
                                style: const TextStyle(color: Colors.black),
                              )),
                          NavigationRailDestination(
                              icon: Icon(aboutIcon),
                              label: Text(
                                aboutText,
                                style: const TextStyle(color: Colors.black),
                              )),
                        ],
                      );
                    },
                  )
                : const SizedBox.shrink(),
            Consumer<HomeViewModel>(
                builder: (BuildContext context, value, Widget? child) {
              return Expanded(
                child: SizedBox(
                  height: double.infinity,
                  width: double.infinity,
                  child: Stack(
                    alignment: AlignmentDirectional.topCenter,
                    children: [
                      buildPage(viewModel.selectedIndex),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget buildPage(index) {
    switch (index) {
      case 0:
        return const HomeView();
      case 1:
        return const Center(
          child: Text('Favorites View'),
        );
      case 2:
        return const Center(
          child: Text('About View'),
        );
      default:
        return const HomeView();
    }
  }
}
