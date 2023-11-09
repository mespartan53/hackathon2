import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Models/employee_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminViewModel extends ChangeNotifier {
  final String pwd = '123456';
  bool isSignedIn = false; //needs to be set to false when deployed
  bool obscurePwd = true;
  late List<Employee> allEmployees = [];
  late List<Employee> filteredEmployees = [];

  TextEditingController searchController = TextEditingController();

  TextEditingController fNameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  late String department;

  List<String> departmentItems = [
    'Administrative Services',
    'Comprehensive Planning',
    'Engineering',
    'Environmental Services',
    'Human Resources',
    'Information Technology',
    'Maintenance',
    'NTP',
    'Operations',
    'RR&R',
    'Strategy and Communications',
    'Technology and Innovation'
  ];

  AdminViewModel() {
    getAllEmployees().then((_) {getEmployeesByFilter(''); notifyListeners();});
  }

  void setDepartment(String value) {
    department = value;
  }

  void signUserIn(BuildContext context, String input) {
    if (input == pwd) {
      isSignedIn = true;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully signed in')));
      notifyListeners();
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Incorrect Password')));
    }
  }

  Future<void> createEmployee(BuildContext context, Employee employee) async {
    CollectionReference employees =
        FirebaseFirestore.instance.collection('employees');
    employees
        .where('firstname', isEqualTo: employee.firstname)
        .where('lastname', isEqualTo: employee.lastname)
        .get()
        .then((value) {
      if (value.size > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Employee already exists')));
        return;
      }
      employees.add(employee.toMap()).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'Successfully added ${employee.firstname} ${employee.lastname}')));
        getAllEmployees().then((_) => getEmployeesByFilter(searchController.text));
        
        fNameController.text = '';
        lNameController.text = '';
        phoneController.text = '';
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error adding employee')));
      });
    });
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
            onTap: () {
              bool temp = element.onCall;
              element.onCall = !element.onCall;
              notifyListeners();
              DocumentReference employee = FirebaseFirestore.instance.collection('employees').doc(element.id);
    employee
    .withConverter<Employee>(
      fromFirestore: (snapshot, _) => Employee.fromJson(snapshot.data()!),
      toFirestore: (employee, _) => employee.toMap())
    .set(element)
    .then((value) {
      if (element.onCall) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${element.firstname} was switched to on call')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${element.firstname} is no longer on call')));
      }
    },)
    .onError((error, stackTrace) {
      element.onCall = temp; 
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error updating on call status')));
    });
            },
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
            trailing: InkWell(
              child: const Icon(Icons.delete_forever, color: Colors.red),
              onTap: () {
                showDialog(context: context, builder: (BuildContext context) => AlertDialog(
                  title: const Text('Delete Employee'),
                  content: Text('Are you sure you want to delete ${element.firstname} ${element.lastname}'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, 'Cancel'), child: const Text('Cancel')),
                    TextButton(onPressed: () async {removeEmployee(context, element.id!).then((_) => Navigator.pop(context, 'Delete'));}, child: const Text('Delete', style: TextStyle(color: Colors.red),)),
                  ],
                ));
              },
            ),
          ),
        ));
      }
      return allWidgets;
    }
  }

  Future<void> setOnCall(BuildContext context, String id) async {
    DocumentReference employee = FirebaseFirestore.instance.collection('employees').doc(id);
    employee.set({'onCall': true});
  }

  Future<void> removeEmployee(BuildContext context, String id) async {
    DocumentReference employee =
        FirebaseFirestore.instance.collection('employees').doc(id);

    if(allEmployees.isEmpty) {
      return;
    }

    employee.delete().then((value) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'Successfully removed employee')));
        getAllEmployees().then((_) => getEmployeesByFilter(searchController.text));
    }).onError((error, stackTrace) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'Error removing employee')));
    });
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
