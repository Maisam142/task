import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home_screen/home_screen_viewing_model.dart';

class CallLogScreen extends StatelessWidget {
  const CallLogScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    final retrieveCallLogs = Provider.of<RetrieveCallLogsProvider>(context);

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      retrieveCallLogs.getCallLogs();

    });

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: retrieveCallLogs.callLogs.length,
                itemBuilder: (context, index) {
                  final callLog = retrieveCallLogs.callLogs[index];
                  final title = callLog.name ?? callLog.number ?? 'Unknown';
                  final subtitle = 'Duration: ${callLog.duration} seconds';
                  final isSaved = callLog.name != null;

                  return ListTile(
                    title: Text(title),
                    subtitle: Text(subtitle),
                    trailing: isSaved
                        ? null
                        : IconButton(
                      onPressed: () async {
                        await retrieveCallLogs.saveNumber(context, callLog.number!);
                        retrieveCallLogs.notifyListeners();
                        Provider.of<AddContactsProvider>(context, listen: false).getAllContacts();
                      },
                      icon: const Icon(Icons.add),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
