
class LoginOrigami {
  final String emp_id;
  final String emp_code;
  final String emp_username;
  final String emp_password;
  final String emp_pic;
  final String comp_id;
  final String mny_permission_code;
  final String emp_type;
  final String stk_type_code;
  final String acrp_id;
  final String emp_tel;
  final String firstname;
  final String lastname;
  final String firstname_th;
  final String lastname_th;
  final String posi_description;
  final String email;
  final String comp_gps_tracking;
  final String comp_description;
  final String dept_id;
  final String phone_in;
  final String phone_out;
  final String min_id_type;
  final String comp_time;
  final String comp_activity;
  final String dept_time;
  final String dept_activity;
  final String emp_time;
  final String emp_activity;
  final String action;

  const LoginOrigami({
    required this.emp_id,
    required this.emp_code,
    required this.emp_username,
    required this.emp_password,
    required this.emp_pic,
    required this.comp_id,
    required this.mny_permission_code,
    required this.emp_type,
    required this.stk_type_code,
    required this.acrp_id,
    required this.emp_tel,
    required this.firstname,
    required this.lastname,
    required this.firstname_th,
    required this.lastname_th,
    required this.posi_description,
    required this.email,
    required this.comp_gps_tracking,
    required this.comp_description,
    required this.dept_id,
    required this.phone_in,
    required this.phone_out,
    required this.min_id_type,
    required this.comp_time,
    required this.comp_activity,
    required this.dept_time,
    required this.dept_activity,
    required this.emp_time,
    required this.emp_activity,
    required this.action,
  });

  factory LoginOrigami.fromJson(Map<String, dynamic> json) {
    return LoginOrigami(
      emp_id: json['emp_id'] ?? '',
      emp_code: json['emp_code'] ?? '',
      emp_username: json['emp_username'] ?? '',
      emp_password: json['emp_password'] ?? '',
      emp_pic: json['emp_pic'] ?? '',
      comp_id: json['comp_id'] ?? '',
      mny_permission_code: json['mny_permission_code'] ?? '',
      emp_type: json['emp_type'] ?? '',
      stk_type_code: json['stk_type_code'] ?? '',
      acrp_id: json['acrp_id'] ?? '',
      emp_tel: json['emp_tel'] ?? '',
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
      firstname_th: json['firstname_th'] ?? '',
      lastname_th: json['lastname_th'] ?? '',
      posi_description: json['posi_description'] ?? '',
      email: json['email'] ?? '',
      comp_gps_tracking: json['comp_gps_tracking'] ?? '',
      comp_description: json['comp_description'] ?? '',
      dept_id: json['dept_id'] ?? '',
      phone_in: json['phone_in'] ?? '',
      phone_out: json['phone_out'] ?? '',
      min_id_type: json['min_id_type'] ?? '',
      comp_time: json['comp_time'] ?? '',
      comp_activity: json['comp_activity'] ?? '',
      dept_time: json['dept_time'] ?? '',
      dept_activity: json['dept_activity'] ?? '',
      emp_time: json['emp_time'] ?? '',
      emp_activity: json['emp_activity'] ?? '',
      action: json['action'] ?? '',
    );
  }
}

class Employee {
  final String empId;
  final String empCode;
  final String empName;
  final String empImage;
  final String compId;
  final String compName;
  final String compLogo;
  final List<MemberData> memberData;

  Employee({
    required this.empId,
    required this.empCode,
    required this.empName,
    required this.empImage,
    required this.compId,
    required this.compName,
    required this.compLogo,
    required this.memberData,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    var memberDataList = json['member_data'] as List;
    List<MemberData> memberData = memberDataList.map((data) => MemberData.fromJson(data)).toList();

    return Employee(
      empId: json['emp_id'],
      empCode: json['emp_code'],
      empName: json['emp_name'],
      empImage: json['emp_image'],
      compId: json['comp_id'],
      compName: json['comp_name'],
      compLogo: json['comp_logo'],
      memberData: memberData,
    );
  }
}

class MemberData {
  final String empId;
  final String empCode;
  final String empName;
  final String empImage;
  final String compId;
  final String compName;
  final String compLogo;
  final String compDefault;
  final String deptDescription;

  MemberData({
    required this.empId,
    required this.empCode,
    required this.empName,
    required this.empImage,
    required this.compId,
    required this.compName,
    required this.compLogo,
    required this.compDefault,
    required this.deptDescription,
  });

  factory MemberData.fromJson(Map<String, dynamic> json) {
    return MemberData(
      empId: json['emp_id'],
      empCode: json['emp_code'],
      empName: json['emp_name'],
      empImage: json['emp_image'],
      compId: json['comp_id'],
      compName: json['comp_name'],
      compLogo: json['comp_logo'],
      compDefault: json['comp_default'],
      deptDescription: json['dept_description'],
    );
  }
}