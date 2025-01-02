import 'package:eiviznho/app/data/repositories/alert/alert_repository.dart';
import 'package:eiviznho/app/domain/entities/alert_entity.dart';
import 'package:eiviznho/app/ui/alert_list/alert_list_injection.dart';
import 'package:eiviznho/app/ui/alert_list/interfaces/alert_list_interface.dart';
import 'package:flutter/material.dart';
import 'package:june/june.dart';

class AlertsState extends JuneState {
  List<AlertEntity> alerts = [];
  bool isLoading = false;
}

class AlertListContainer extends StatefulWidget {
  const AlertListContainer({super.key});

  @override
  State<AlertListContainer> createState() => _AlertListContainerState();
}

class _AlertListContainerState extends State<AlertListContainer> {
  late AlertRepository _alertRepository;

  @override
  void initState() {
    super.initState();
    _alertRepository = alertListInject.get<AlertRepository>();
    _fetchAlerts();
  }

  Future<void> _fetchAlerts() async {
    var alertsState = June.getState(() => AlertsState());

    try {
      alertsState
        ..isLoading = true
        ..setState(); 

      final result = await _alertRepository.getAllAlerts();

      alertsState
        ..alerts = result
        ..isLoading = false
        ..setState(); 
    } catch (e) {
      alertsState
        ..alerts = []
        ..isLoading = false
        ..setState(); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return JuneBuilder(
      () => AlertsState(), 
      builder: (AlertsState state) {
        return AlertListInterface(
          isLoading: state.isLoading,
          alerts: state.alerts,
        );
      },
    );
  }
}
