import '../Models/Department.dart';

class FilterDepartment {

  String? departmentName;




  FilterDepartment({this.departmentName});


  bool applyFiltersDepartment(Department department) {

      // Assuming any department matches if no specific name is given
      if (departmentName == null || departmentName!.isEmpty || departmentName == "Any" || departmentName == "Speciality") {
        return true;
      }
      return department.name.toLowerCase().contains(departmentName!.toLowerCase());
    }
}