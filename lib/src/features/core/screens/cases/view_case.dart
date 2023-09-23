import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:integritylink/src/features/core/screens/cases/view_image.dart';

class ViewCaseScreen extends StatefulWidget {
  final String caseId;

  const ViewCaseScreen({required this.caseId});

  @override
  _ViewCaseScreenState createState() => _ViewCaseScreenState();
}

class _ViewCaseScreenState extends State<ViewCaseScreen> {
  late Future<DocumentSnapshot<Map<String, dynamic>>> _caseFuture;

  @override
  void initState() {
    super.initState();
    _caseFuture =
        FirebaseFirestore.instance.collection('cases').doc(widget.caseId).get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Case'),
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: _caseFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data available'));
          }

          final caseData = snapshot.data!.data();
          final evidenceUrls = caseData!['evidenceUrl'];

          List<String>? castedEvidenceUrls;
          if (evidenceUrls is List<dynamic>) {
            castedEvidenceUrls = evidenceUrls.cast<String>().toList();
          }

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (castedEvidenceUrls != null &&
                      castedEvidenceUrls.isNotEmpty)
                    SizedBox(
                      height: 300,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: castedEvidenceUrls.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Stack(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MyImageWidget(
                                          imageUrl: castedEvidenceUrls![index],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Image.network(
                                    castedEvidenceUrls![index],
                                    width: 225,
                                    height: 300,
                                    fit: BoxFit.fill,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      } else {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                  // Display the case properties
                  SizedBox(height: 16.0),
                  Container(
                    color: Colors.grey[300],
                    width: double.infinity,
                    padding: EdgeInsets.all(15.0),
                    child: Center(
                      child: RichText(
                        text: TextSpan(
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: Colors.black,
                              ),
                          children: [
                            TextSpan(
                              text: 'Case ID    :   ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: '${caseData['caseID']}',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.headlineSmall,
                        children: [
                          TextSpan(
                            text: 'Status   :   ',
                          ),
                          TextSpan(
                            text: '${caseData['status']}',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  color: caseData['status'] == 'Open'
                                      ? Colors.yellow
                                      : Colors.green,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Center(
                      child: Text(
                        'Case Details',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              decoration: TextDecoration.underline,
                            ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.headlineSmall,
                        children: [
                          TextSpan(
                            text: 'Location   :   ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: '${caseData['location']}',
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Text(
                      'Date Committed   :     ${caseData['dateCommitted']}',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Text(
                      'Date Reported    :     ${caseData['dateReported']}',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: Center(
                      child: Text(
                        'Persons Involved',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              decoration: TextDecoration.underline,
                            ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Text(
                      '${caseData['personsInvolved']}',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Text(
                      'Supporting Evidence    :    ${caseData['supportingEvidence']}',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: Center(
                      child: Text(
                        'Report Details',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              decoration: TextDecoration.underline,
                            ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Text(
                      '${caseData['reportDetails']}',
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Text(
                      'Reported on Behalf Of Other Person   :     ${caseData['onBehalfOf']}',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Text(
                      'Awareness Details    :    ${caseData['awarenessDetails']}',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Text(
                      'Additional Evidence    :     ${caseData['additionalEvidence']}',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Text(
                      'Additional Witnesses   :     ${caseData['additionalWitnesses']}',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Text(
                      'Desired Outcome    :     ${caseData['desiredOutcome']}',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Text(
                      'Outcome if reported before  :     ${caseData['reportingOutcome']}',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Text(
                      'Resolution Details   :     ${caseData['resolutionDetails']}',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: Center(
                      child: Text(
                        'Selected Offences',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              decoration: TextDecoration.underline,
                            ),
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: caseData['selectedOffences'].length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Icon(Icons.circle),
                        title: Text(caseData['selectedOffences'][index]),
                      );
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: Center(
                      child: Text(
                        'How It Was Resolved',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              decoration: TextDecoration.underline,
                            ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.headlineMedium,
                          children: [
                            WidgetSpan(
                              child: SizedBox(
                                width: double.infinity,
                                child: Text(
                                  '${caseData['howItWasResolved']}',
                                  textAlign: TextAlign.justify,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
