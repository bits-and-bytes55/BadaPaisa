class LoanApplicationModel {
  final String id;
  final String loanType;
  final String gender;
  final String city;
  final String purpose;
  final String employmentType;
  final double monthlySalary;
  final double loanAmount;
  final String fullName;
  final String email;
  final String mobile;
  final String status;
  final DateTime createdAt;

  const LoanApplicationModel({
    required this.id,
    required this.loanType,
    required this.gender,
    required this.city,
    required this.purpose,
    required this.employmentType,
    required this.monthlySalary,
    required this.loanAmount,
    required this.fullName,
    required this.email,
    required this.mobile,
    required this.createdAt,
    this.status = 'Under Review',
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'loanType': loanType,
    'gender': gender,
    'city': city,
    'purpose': purpose,
    'employmentType': employmentType,
    'monthlySalary': monthlySalary,
    'loanAmount': loanAmount,
    'fullName': fullName,
    'email': email,
    'mobile': mobile,
    'status': status,
    'createdAt': createdAt.toIso8601String(),
  };

  factory LoanApplicationModel.fromJson(Map<String, dynamic> json) =>
      LoanApplicationModel(
        id: json['id'] as String? ?? '',
        loanType: json['loanType'] as String? ?? '',
        gender: json['gender'] as String? ?? '',
        city: json['city'] as String? ?? '',
        purpose: json['purpose'] as String? ?? '',
        employmentType: json['employmentType'] as String? ?? '',
        monthlySalary: (json['monthlySalary'] as num?)?.toDouble() ?? 0,
        loanAmount: (json['loanAmount'] as num?)?.toDouble() ?? 0,
        fullName: json['fullName'] as String? ?? '',
        email: json['email'] as String? ?? '',
        mobile: json['mobile'] as String? ?? '',
        status: json['status'] as String? ?? 'Under Review',
        createdAt:
            DateTime.tryParse(json['createdAt'] as String? ?? '') ??
            DateTime.now(),
      );
}
