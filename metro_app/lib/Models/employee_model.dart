class Employee {
  String? id;
  final String firstname;
  final String lastname;
  final String phone;
  final String department;
  final bool onCall;

  Employee({
    this.id,
    required this.firstname,
    required this.lastname,
    required this.phone,
    required this.department,
    required this.onCall,
  });

  Employee.fromJson(Map<String, Object?> json) : 
  this(
    firstname: json['firstname']! as String,
    lastname: json['lastname']! as String,
    phone: json['phone']! as String,
    department: json['department']! as String,
    onCall: json['onCall']! as bool,
  );

  Map<String, Object?> toMap() {
    return {
      'firstname': firstname,
      'lastname': lastname,
      'phone': phone,
      'department': department,
      'onCall': onCall,
    };
  }

  void setID(String id) {
    this.id = id;
  }

  @override String toString() {
    return 'Employee{firstname: $firstname, lastname: $lastname, phone: $phone, department: $department, onCall: $onCall}';
  }
}

