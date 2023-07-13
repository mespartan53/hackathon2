import 'package:flutter/material.dart';
import 'package:metro_app/ViewModels/admin_viewmodel.dart';
import 'package:metro_app/ViewModels/home_viewmodel.dart';
import 'package:metro_app/ViewModels/main_viewmodel.dart';
import 'package:metro_app/ViewModels/on_call_viewmodel.dart';
import 'package:metro_app/Views/admin_view.dart';
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
  MainViewModel viewModel = MainViewModel();
  AdminViewModel adminVM = AdminViewModel();
  HomeViewModel homeVM = HomeViewModel();
  OnCallViewModel onCallVM = OnCallViewModel();

  final IconData homeIcon = Icons.home;
  final IconData favoriteIcon = Icons.phone_enabled;
  final IconData aboutIcon = Icons.adb_rounded;

  final String homeText = 'Home';
  final String favText = 'On Call';
  final String aboutText = 'Admin';

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
                backgroundColor: Colors.blueGrey[700],
              )
            : null,
        drawer: Drawer(
          width: 225,
          elevation: 0,
          child: Consumer<MainViewModel>(
            builder: (BuildContext context, value, Widget? child) {
              return ListView(
                children: [
                  const DrawerHeader(child: Center(child: Text('Metro'))),
                  ListTile(
                    title: HoverText(
                      text: homeText,
                      mainColor: Colors.black,
                      hoverColor: Colors.blueGrey,
                      onTap: () {
                        viewModel.updateIndex(0);
                      },
                    ),
                    leading: Icon(
                      homeIcon,
                      color: viewModel.selectedIndex == 0
                          ? Colors.blueGrey
                          : Colors.grey[350],
                    ),
                  ),
                  ListTile(
                    title: HoverText(
                      text: aboutText,
                      mainColor: Colors.black,
                      hoverColor: Colors.blueGrey,
                      onTap: () {
                        viewModel.updateIndex(1);
                      },
                    ),
                    leading: Icon(
                      aboutIcon,
                      color: viewModel.selectedIndex == 1
                          ? Colors.blueGrey
                          : Colors.grey[350],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        backgroundColor: Colors.grey[300],
        body: Row(
          children: [
            ResponsiveWrapper.of(context).isLargerThan(MOBILE)
                ? Consumer<MainViewModel>(
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
                        indicatorColor: Colors.black,
                        backgroundColor: Colors.blueGrey[700],
                        destinations: [
                          NavigationRailDestination(
                              icon: Icon(homeIcon, color: Colors.white),
                              label: Text(
                                homeText,
                                style: const TextStyle(color: Colors.white),
                              )),
                          NavigationRailDestination(
                              icon: Icon(aboutIcon, color: Colors.white),
                              label: Text(
                                aboutText,
                                style: const TextStyle(color: Colors.white),
                              )),
                        ],
                      );
                    },
                  )
                : const SizedBox.shrink(),
            Consumer<MainViewModel>(
                builder: (BuildContext context, value, Widget? child) {
              return Expanded(
                child: SizedBox(
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
        homeVM.getAllEmployees();
        return ChangeNotifierProvider.value(
          value: homeVM,
          child: const HomeView(),
        );
      case 1:
        adminVM.getAllEmployees();
        return ChangeNotifierProvider.value(
          value: adminVM,
          child: const AdminView(),
        );
      default:
        homeVM.getAllEmployees();
        return ChangeNotifierProvider.value(
          value: homeVM,
          child: const HomeView(),
        );
    }
  }
}
