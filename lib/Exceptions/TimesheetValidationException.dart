class EquipmentReadingException implements Exception {
  String message = "equipmentmeterreadingvalidation";
  String equipmentname;
  double previousReading;
  EquipmentReadingException({required this.equipmentname, required this.previousReading});
}

class EquipmentTotalHourException implements Exception {
  String message = "equipmenttotalhourvalidation";
  String equipmentname;
  EquipmentTotalHourException({required this.equipmentname});
}

class WorkHourException implements Exception {
  String message = "workhourvalidation";
}
