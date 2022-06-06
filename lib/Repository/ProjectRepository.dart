import 'dart:convert';

import 'package:urbanico_app/enum/futureState.dart';
import 'package:urbanico_app/model/phaseModel.dart';
import 'package:urbanico_app/Repository/BaseNotifierRepo.dart';
import 'package:urbanico_app/Request/costcode_api.dart';
import 'package:urbanico_app/Request/project_api.dart';
import 'package:urbanico_app/model/costCodeModel.dart';
import 'package:urbanico_app/model/projectModel.dart';

class ProjectRepository extends BaseNotifierRepo {
  final List<Project> _projects = [];
  final List<Phase> _phases = [];
  late Phase _onlyPhase;
  String _message = "";
  ProjectRepository(authRepo) : super(authRepo) {
    _onlyPhase = Phase();
    // getAllProjects();
  }

  List<Project> get listProjects => _projects;
  List<Phase> get listPhases => _phases;
  Phase get onlyPhase => _onlyPhase;
  String get message => _message;

  set setOnlyPhase(Phase phase) {
    _onlyPhase = phase;
    notifyListeners();
  }

  set setProjects(Project project) {
    _projects.add(project);
    notifyListeners();
  }

  set setPhase(Phase phase) {
    _phases.add(phase);
    notifyListeners();
  }

  set setMessage(String msg) {
    _message = msg;
    notifyListeners();
  }

  Future<void> getAllProjects({bool resync = false}) async {
    try {
      if (_projects.isNotEmpty && !resync) {
        setState = FutureState.Loaded;
      } else {
        setState = FutureState.Loading;
        _projects.clear();
        var response = await ProjectApi().fetchAllProjects();
        if (checkAuthenticationCode(response.statusCode)) {
          setState = FutureState.Unauthenticated;
        } else if (response.statusCode == 200) {
          var projectCode = '';
          var responseBody = jsonDecode(response.body);
          for (var project in responseBody["response"]) {
            Project newProject = Project.fromJson(project);
            if (projectCode != newProject.projectCode) _projects.add(newProject);
            projectCode = newProject.projectCode;
          }
          setState = FutureState.Loaded;
        } else {
          setState = FutureState.Loaded;
        }
      }
    } catch (err) {
      setState = FutureState.Loaded;
    }
  }

  Future<void> getPhasesForProject(String proID, {bool resync = false}) async {
    try {
      if (_phases.isNotEmpty && !resync) {
        setState = FutureState.Loaded;
      } else {
        setState = FutureState.Loading;
        _onlyPhase = Phase();
        _phases.clear();
        var response = await ProjectApi().fetchProjectPhases(proID);
        if (checkAuthenticationCode(response.statusCode)) {
          setState = FutureState.Unauthenticated;
        } else if (response.statusCode == 200) {
          var phaseCode = '';
          var responseBody = jsonDecode(response.body);
          for (var phase in responseBody["phase"]) {
            Phase newPhase = Phase.fromJson(phase);
            if (phaseCode != newPhase.phasecode) _phases.add(newPhase);
            phaseCode = newPhase.phasecode;
          }
          if (_phases.length == 1) {
            _onlyPhase = _phases[0];
          }
          setState = FutureState.Loaded;
        } else {
          setState = FutureState.Loaded;
        }
      }
    } catch (err) {
      setState = FutureState.Loaded;
    }
  }
}

class CostCodeRepository extends BaseNotifierRepo {
  final List<CostCode> _costCodes = [];
  final List<CostCode> _costCodeById = [];
  String _message = "";
  CostCodeRepository(authRepo) : super(authRepo);
  List<CostCode> get listCostCode => _costCodes;
  List<CostCode> get listProjectCostCode => _costCodeById;

  String get message => _message;

  set setProjectCostCodes(CostCode costcode) {
    _costCodeById.add(costcode);
    notifyListeners();
  }

  set setCostCodes(CostCode costcode) {
    _costCodes.add(costcode);
    notifyListeners();
  }

  set setMessage(String msg) {
    _message = msg;
    notifyListeners();
  }

  Future<void> getAllCostCodes() async {
    try {
      setState = FutureState.Loading;
      var response = await CostCodeApi().fetchAllCostCodes();
      if (checkAuthenticationCode(response.statueCode)) {
        setState = FutureState.Unauthenticated;
      } else if (response.statusCode == 200) {
        var costCodeCode = '';
        _costCodes.clear();
        var responseBody = jsonDecode(response.body);
        for (var costCode in responseBody["response"]) {
          CostCode newCostCode = CostCode.fromJson(costCode);
          if (costCodeCode != newCostCode.costcodeName) _costCodes.add(newCostCode);
          costCodeCode = newCostCode.costcodeName;
        }
        setState = FutureState.Loaded;
      } else {
        setState = FutureState.Loaded;
      }
    } catch (err) {
      setState = FutureState.Loaded;
    }
  }

  Future<void> getCostCodesByProjectID(String projectid) async {
    try {
      setState = FutureState.Loading;
      var response = await CostCodeApi().fetchCostCodesByProjectID(projectid);
      if (checkAuthenticationCode(response.statusCode)) {
        setState = FutureState.Unauthenticated;
      } else if (response.statusCode == 200) {
        _costCodeById.clear();
        var costCodeCode = '';
        var responseBody = jsonDecode(response.body);
        for (var costCode in responseBody["response"]) {
          CostCode newCostCode = CostCode.fromJson(costCode);
          if (costCodeCode != newCostCode.costcodeName) _costCodeById.add(newCostCode);
          costCodeCode = newCostCode.costcodeName;
        }
        setState = FutureState.Loaded;
      } else {
        setState = FutureState.Loaded;
      }
    } catch (err) {
      setState = FutureState.Loaded;
    }
  }
}

class SelectProjectRepository extends BaseNotifierRepo {
  Project _currentProject = Project();

  Map<Project, List<CostCode>> _selectedProject = <Project, List<CostCode>>{};
  SelectProjectRepository(authRepo) : super(authRepo);
  Map<Project, List<CostCode>> get getMap => _selectedProject;
  Project get getCurrentProject => _currentProject;

  set setCurrentProject(Project project) {
    _currentProject = project;
    notifyListeners();
  }

  void setCostCode(Project project, CostCode costcode) {
    if (!_selectedProject.containsKey(project)) {
      _selectedProject.addEntries([
        MapEntry(project, [costcode].toList())
      ]);
    } else {
      _selectedProject[project]!.add(costcode);
    }
    notifyListeners();
  }

  void removeCostCode(Project project, CostCode costcode) {
    _selectedProject[project]!.remove(costcode);
    if (_selectedProject[project]!.isEmpty) _selectedProject.remove(project);
    notifyListeners();
  }

  void destroyMap() {
    _selectedProject = <Project, List<CostCode>>{};
    notifyListeners();
  }
}

class SelectPhaseRepository extends BaseNotifierRepo {
  Phase _currentPhase = Phase();

  Map<Phase, List<CostCode>> _selectedPhase = <Phase, List<CostCode>>{};

  SelectPhaseRepository(authRepo) : super(authRepo);

  Map<Phase, List<CostCode>> get getMap => _selectedPhase;
  Phase get getCurrentPhase => _currentPhase;

  set setCurrentPhase(Phase phase) {
    _currentPhase = phase;
    notifyListeners();
  }

  void setCostCode(Phase phase, CostCode costcode) {
    if (!_selectedPhase.containsKey(phase)) {
      _selectedPhase.addEntries([
        MapEntry(phase, [costcode].toList())
      ]);
    } else {
      _selectedPhase[phase]!.add(costcode);
    }
    notifyListeners();
  }

  void removeCostCode(Phase phase, CostCode costcode) {
    _selectedPhase[phase]!.remove(costcode);
    if (_selectedPhase[phase]!.isEmpty) _selectedPhase.remove(phase);
    notifyListeners();
  }

  void destroyMap() {
    _selectedPhase = <Phase, List<CostCode>>{};
    notifyListeners();
  }
}
