class Owner {
  String? _id;
  String name;
  String ssn;

  Owner({required this.name, required this.ssn, String? id}) : _id = id;

  String get id => _id ?? '-1';

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      id: json['id'],
      name: json['name'],
      ssn: json['ssn'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': _id,
        'name': name,
        'ssn': ssn,
      };

  @override
  String toString() {
    return 'Name: $name, ssn: $ssn, id: $_id';
  }

  bool isValid() {
    return true;
  }
}
