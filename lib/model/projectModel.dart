class Project {
  late String projectSetupID;
  late String projectID;
  late String projectCode;
  late String projectName;
  late String projectDesc;
  late String startDate;
  late String endDate;
  late String projectStatus;
  late String projectOwner;
  late String location;
  late String status;
  late String createdDate;
  late String modifiedDate;
  late String modifiedBy;
  late String macAddress;

  Project() {
    projectSetupID = '';
    projectID = '';
    projectCode = '';
    projectName = '';
    projectOwner = '';
    projectDesc = '';
    location = '';
    projectStatus = '';
    startDate = '';
    endDate = '';
    status = '';
    projectOwner = '';
    createdDate = '';
    modifiedBy = '';
    modifiedDate = '';
    macAddress = '';
  }

  Project.fromJson(Map<String, dynamic> json) {
    projectSetupID = json['projectsetupID'] ?? "";
    projectID = json['projectID'] ?? "";
    projectCode = json['projectCode'] ?? "";
    projectName = json['projectName'] ?? "";
    projectOwner = json['projectOwner'] ?? "";
    projectDesc = json['projectDesc'] ?? "";
    location = json['location'] ?? "";
    projectStatus = json['projectStatus'] ?? "";
    startDate = json['startDate'] ?? "";
    endDate = json['endDate'] ?? "";
    status = json['status'] ?? "";
    projectOwner = json['projectOwner'] ?? "";
    createdDate = json['projectOwner'] ?? "";
    modifiedBy = json['modifiedBy'] ?? "";
    modifiedDate = json['modifiedDate'] ?? "";
    macAddress = json['macAddress'] ?? "";
  }
}
