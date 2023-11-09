import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Models/employee_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeViewModel extends ChangeNotifier {
  late List<Employee> allEmployees = [];
  late List<Employee> filteredEmployees = [];

  late List<Employee> OnCallEmployees = [];

  TextEditingController searchController = TextEditingController();

  HomeViewModel() {
    getAllEmployees().then((_) {getEmployeesByFilter(''); notifyListeners();});
  }

  Future<void> getAllEmployees() async {
    CollectionReference employees =
        FirebaseFirestore.instance.collection('employees');

    employees
        .withConverter<Employee>(
            fromFirestore: (snapshot, _) => Employee.fromJson(snapshot.data()!),
            toFirestore: (employee, _) => employee.toMap())
        .orderBy('department')
        .orderBy('lastname')
        .get()
        .then((value) {
      allEmployees = [];
      for (var element in value.docs) {
        Employee temp = element.data();
        temp.setID(element.id);
        allEmployees.add(temp);
      }
      filteredEmployees = allEmployees;
      notifyListeners();
    });
  }

  //TODO: refoctor to not include UI elements
  //      create a widget that takes in an employee class
  List<Widget> getAllEmployeesAsWidget(BuildContext context) {
    List<Employee> tempEmployees;
    if (filteredEmployees.isEmpty) {
      tempEmployees = allEmployees;
    } else {
      tempEmployees = filteredEmployees;
    }
    if (tempEmployees.isEmpty) {
      return const [CircularProgressIndicator()];
    } else {
      List<Widget> allWidgets = [];
      for (var element in tempEmployees) {
        allWidgets.add(Card(
          child: ListTile(
            title: Text('${element.firstname} ${element.lastname}'),
            subtitle: Text('${element.department}: ${element.phone.replaceAllMapped(
                RegExp(r'(\d{3})(\d{3})(\d+)'),
                (Match m) => "(${m[1]}) ${m[2]}-${m[3]}")}'),
            tileColor: element.onCall ? Colors.blue[100] : Colors.white,
            leading: InkWell(
              child: const Icon(
                Icons.copy,
                color: Colors.blue,
              ),
              onTap: () async {
                await Clipboard.setData(ClipboardData(text: element.phone));
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        'Copied ${element.firstname} phone # to clipboard')));
              },
            ),
            trailing: Text(
              element.onCall
              ? 'On Call'
              : '',
              style: GoogleFonts.raleway(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.grey[500],
              ),
            ),
          ),
        ));
      }
      return allWidgets;
    }
  }

  //TODO: refoctor to not include UI elements
  List<Widget> getAllOnCallEmployeesAsWidget(BuildContext context) {
    List<Employee> tempEmployees = [];
    for(var e in allEmployees) {
      if (e.onCall) {
        tempEmployees.add(e);
      }
    }
    if (tempEmployees.isEmpty) {
      return const [CircularProgressIndicator()];
    } else {
      List<Widget> allWidgets = [];
      for (var element in tempEmployees) {
        allWidgets.add(Card(
          child: ListTile(
            title: Text('${element.firstname} ${element.lastname}'),
            subtitle: Text('${element.department}: ${element.phone.replaceAllMapped(
                RegExp(r'(\d{3})(\d{3})(\d+)'),
                (Match m) => "(${m[1]}) ${m[2]}-${m[3]}")}'),
            tileColor: element.onCall ? Colors.blue[100] : Colors.white,
            leading: InkWell(
              child: const Icon(
                Icons.copy,
                color: Colors.blue,
              ),
              onTap: () async {
                await Clipboard.setData(ClipboardData(text: element.phone));
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        'Copied ${element.firstname} phone # to clipboard')));
              },
            ),
            trailing: Text(
              element.onCall
              ? 'On Call'
              : '',
              style: GoogleFonts.raleway(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.grey[500],
              ),
            ),
          ),
        ));
      }
      return allWidgets;
    }
  }

  void getEmployeesByFilter(String filter) {
    if (filter.isEmpty) {
      filteredEmployees = allEmployees;
      notifyListeners();
      return;
    }
    filteredEmployees = [];
    for(var e in allEmployees) {
      var combinedText = e.firstname + e.lastname;
      if (combinedText.toLowerCase().contains(filter.toLowerCase())) {
        filteredEmployees.add(e);
      }
    }

    notifyListeners();
  }
}