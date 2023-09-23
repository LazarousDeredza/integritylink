import 'package:cloud_firestore/cloud_firestore.dart';

class CaseModel {
  //id
  final String? id;
  final String location;
  final String dateCommitted;
  final String dateReported;
  final String personsInvolved;
  final String supportingEvidence;
  final String reportDetails;
  final String onBehalfOf;
  final String awarenessDetails;
  final String additionalEvidence;
  final String additionalWitnesses;
  final String? reportedBy;
  final List<String>? evidenceUrl;
  final String? caseID;
  final String? status;
  final String? howItWasResolved;
  final String desiredOutcome;
  final String reportingOutcome;
  final String resolutionDetails;
  final List<String> selectedOffences; // Adding the selected offences list

  CaseModel(
      {this.id,
      this.evidenceUrl,
      this.status,
      this.howItWasResolved,
      this.caseID,
      this.reportedBy,
      required this.location,
      required this.dateCommitted,
      required this.dateReported,
      required this.personsInvolved,
      required this.supportingEvidence,
      required this.reportDetails,
      required this.onBehalfOf,
      required this.awarenessDetails,
      required this.additionalEvidence,
      required this.additionalWitnesses,
      required this.desiredOutcome,
      required this.reportingOutcome,
      required this.resolutionDetails,
      required this.selectedOffences});

  //to json
  Map<String, dynamic> toJson() => {
        'id': id,
        'evidenceUrl': evidenceUrl,
        'status': status,
        'caseID': caseID,
        'reportedBy': reportedBy,
        'howItWasResolved': howItWasResolved,
        'location': location,
        'dateCommitted': dateCommitted,
        'dateReported': dateReported,
        'personsInvolved': personsInvolved,
        'supportingEvidence': supportingEvidence,
        'reportDetails': reportDetails,
        'onBehalfOf': onBehalfOf,
        'awarenessDetails': awarenessDetails,
        'additionalEvidence': additionalEvidence,
        'additionalWitnesses': additionalWitnesses,
        'desiredOutcome': desiredOutcome,
        'reportingOutcome': reportingOutcome,
        'resolutionDetails': resolutionDetails,
        'selectedOffences': selectedOffences
      };

  //from json
  factory CaseModel.fromJson(Map<String, dynamic> json) => CaseModel(
        id: json['id'],
        caseID: json["caseID"],
        evidenceUrl: json['evidenceUrl'],
        status: json['status'],
        reportedBy: json['reportedBy'],
        howItWasResolved: json['howItWasResolved'],
        location: json['location'],
        dateCommitted: json['dateCommitted'],
        dateReported: json['dateReported'],
        personsInvolved: json['personsInvolved'],
        supportingEvidence: json['supportingEvidence'],
        reportDetails: json['reportDetails'],
        onBehalfOf: json['onBehalfOf'],
        awarenessDetails: json['awarenessDetails'],
        additionalEvidence: json['additionalEvidence'],
        additionalWitnesses: json['additionalWitnesses'],
        desiredOutcome: json['desiredOutcome'],
        reportingOutcome: json['reportingOutcome'],
        resolutionDetails: json['resolutionDetails'],
        selectedOffences: json['selectedOffences'],
      );

  factory CaseModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return CaseModel(
      id: document.id,
      evidenceUrl: data['evidenceUrl'],
      status: data['status'],
      caseID: data['caseID'],
      reportedBy: data['reportedBy'],
      howItWasResolved: data['howItWasResolved'],
      location: data['location'],
      dateCommitted: data['dateCommitted'],
      dateReported: data['dateReported'],
      personsInvolved: data['personsInvolved'],
      supportingEvidence: data['supportingEvidence'],
      reportDetails: data['reportDetails'],
      onBehalfOf: data['onBehalfOf'],
      awarenessDetails: data['awarenessDetails'],
      additionalEvidence: data['additionalEvidence'],
      additionalWitnesses: data['additionalWitnesses'],
      desiredOutcome: data['desiredOutcome'],
      reportingOutcome: data['reportingOutcome'],
      resolutionDetails: data['resolutionDetails'],
      selectedOffences: data['selectedOffences'],
    );
  }
}
