//import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:metro_app/Models/employee_model.dart';
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
  final TextStyle txtStyle = GoogleFonts.raleway(
    fontSize: 32,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, homeVM, child) {
        return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: const AlwaysScrollableScrollPhysics(),
            child: ResponsiveRowColumn(
              layout: ResponsiveWrapper.of(context).isSmallerThan(DESKTOP)
                  ? ResponsiveRowColumnType.COLUMN
                  : ResponsiveRowColumnType.ROW,
              rowCrossAxisAlignment: CrossAxisAlignment.start,
              rowMainAxisAlignment: MainAxisAlignment.center,
              columnCrossAxisAlignment: CrossAxisAlignment.center,
              columnMainAxisAlignment: MainAxisAlignment.center,
              rowPadding: const EdgeInsets.all(15),
              columnPadding: const EdgeInsets.all(15),
              rowSpacing: 15,
              columnSpacing: 15,
              children: [
                ResponsiveRowColumnItem(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Column(
                      children: [
                            Text(
                              'All Employees',
                              style: GoogleFonts.raleway(
                                textStyle: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 36,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: 400,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15.0)),
                                  border: Border.all(color: Colors.blue)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5.0),
                              child: TextField(
                                controller: homeVM.searchController,
                                decoration:
                                    const InputDecoration(hintText: 'Search'),
                                onChanged: (value) {
                                  homeVM.getEmployeesByFilter(value);
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ] +
                          homeVM.getAllEmployeesAsWidget(context) +
                          const [
                            SizedBox(
                              height: 30,
                            ),
                          ],
                    ),
                  ),
                ),
                ResponsiveRowColumnItem(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                            Text(
                              'On Call Employees',
                              style: GoogleFonts.raleway(
                                textStyle: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 36,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ] +
                          homeVM.getAllOnCallEmployeesAsWidget(context) +
                          const [
                            SizedBox(
                              height: 30,
                            ),
                          ],
                    ),
                  ),
                ),
              ],
            ));
      },
    );
  }

  int getColumnCount() {
    if (ResponsiveWrapper.of(context).isTablet) {
      return 3;
    }
    if (ResponsiveWrapper.of(context).isMobile) {
      return 2;
    }
    if (ResponsiveWrapper.of(context).isPhone) {
      return 2;
    }
    return 4;
  }
}

class EmployeeHomeView extends StatefulWidget {
  final Employee employee;

  const EmployeeHomeView({Key? key, required this.employee}) : super(key: key);

  @override
  State<EmployeeHomeView> createState() => _EmployeeHomeViewState();
}

class _EmployeeHomeViewState extends State<EmployeeHomeView> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: widget.employee.onCall ? 15 : 2,
      shadowColor: widget.employee.onCall ? Colors.cyan : Colors.blueGrey,
      child: AnimatedContainer(
        //height: isExpanded ? 100 : 75,
        //width: 200,
        padding: const EdgeInsets.all(10),
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
        child: Column(
          children: [
            TextButton(
              onPressed: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              child: Text(
                '${widget.employee.firstname} ${widget.employee.lastname}',
                style: GoogleFonts.raleway(
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            AnimatedCrossFade(
                firstChild: SelectableText(widget.employee.phone
                    .replaceAllMapped(RegExp(r'(\d{3})(\d{3})(\d+)'),
                        (Match m) => "(${m[1]}) ${m[2]}-${m[3]}")),
                secondChild: const SizedBox(
                  height: 0,
                  //width: 150,
                ),
                crossFadeState: isExpanded
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                duration: const Duration(milliseconds: 350)),
          ],
        ),
      ),
    );
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
