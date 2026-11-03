class Employee {
  final int id;
  final String firstName, lastName, email, phone, position, department, image;

  Employee({this.id = 0, required this.firstName, required this.lastName, required this.email,
      required this.phone, required this.position, required this.department, this.image = ''});

  String get fullName => '$firstName $lastName';

  factory Employee.fromJson(Map<String, dynamic> j) {
    final c = j['company'] as Map<String, dynamic>?;
    return Employee(
      id: j['id'] ?? 0,
      firstName: j['firstName'] ?? '',
      lastName: j['lastName'] ?? '',
      email: j['email'] ?? '',
      phone: j['phone'] ?? '',
      position: c?['title'] ?? '',
      department: c?['department'] ?? '',
      image: j['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phone': phone,
        'company': {'title': position, 'department': department},
      };

  Employee withId(int newId) => Employee(id: newId, firstName: firstName, lastName: lastName, email: email,
      phone: phone, position: position, department: department, image: image);
}
