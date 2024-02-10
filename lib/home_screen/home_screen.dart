import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:provider/provider.dart';
import 'package:task/home_screen/home_screen_viewing_model.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key});

  @override
  Widget build(BuildContext context) {
    AddContactsProvider addContacts = Provider.of<AddContactsProvider>(context);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      addContacts.getAllContacts();
    });
    bool isSearching = addContacts.searchController.text.isNotEmpty;
    List<Contact> contacts = isSearching ? addContacts.contactsFilter : addContacts.contacts;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: 100,
                child: TextFormField(
                  controller: addContacts.searchController,
                  decoration: InputDecoration(
                    labelText: 'Search',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
              if (contacts.isEmpty)
                const Center(child: CircularProgressIndicator())
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    Contact contact = contacts[index];
                    return ListTile(
                      title: Text(contact.displayName),
                      subtitle: Text(
                        contact.phones.isNotEmpty ? contact.phones.elementAt(0).number : '',
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
