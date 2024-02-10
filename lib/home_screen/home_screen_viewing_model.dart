
import 'package:call_log/call_log.dart';
import 'package:contacts_service/contacts_service.dart' as i1;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart' as i2;
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';



class AdMobBannerProvider extends ChangeNotifier {

  late BannerAd bannerAd;
  bool isAdLoaded = false;
  var adUnitID = 'ca-app-pub-3940256099942544/6300978111';
  AdMobBannerProvider(){
    initBannerAd();
  }
  initBannerAd (){
    bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: adUnitID,
      listener:  BannerAdListener(
          onAdLoaded:(ad){
              isAdLoaded = true;
              notifyListeners();
              },
          onAdFailedToLoad: (ad,error){
            ad.dispose();
            print(error);
          }
      ),
      request: AdRequest() ,);
    bannerAd.load();
  }

}
class AddContactsProvider extends ChangeNotifier {


  AddContactsProvider() {
    requestPermissions1();
    getAllContacts();
    searchController.addListener(() {
      filtering();
    });
  }

  List<i2.Contact> contacts = [];
  List<i2.Contact> contactsFilter = [];
  Future<void> requestPermissions1() async {
    if (await Permission.contacts
        .request()
        .isGranted) {
      print('Permission granted -------------------------------------');
    } else {
      print('Permission denied -------------------------------------');
    }
  }


  getAllContacts() async {
    List<i2.Contact> _contacts = await i2.FlutterContacts.getContacts(
        withProperties: true, withPhoto: true);
    contacts = _contacts;
    notifyListeners();
  }

  TextEditingController searchController = TextEditingController();


  filtering() {
    if (searchController.text.isNotEmpty) {
      List<i2.Contact> filteredContacts = contacts.where((contact) {
        String searchTerm = searchController.text.toLowerCase();
        String contactName = contact.displayName.toLowerCase();
        return contactName.contains(searchTerm);
      }).toList();
      contactsFilter = filteredContacts;
    } else {
      contactsFilter = List.from(contacts);
    }
    notifyListeners();
  }

}

class RetrieveCallLogsProvider extends ChangeNotifier {
  List<CallLogEntry> callLogs = [];
  Set<String> savedNumbers = {};
  Map<String, String> savedContacts = {};
  RetrieveCallLogsProvider() {
    requestPermissions2();
    loadLastNumber();
    getCallLogs();
  }

  Future<void> requestPermissions2() async {

    Permission.phone.request().then((permissionStatus) {
      if (permissionStatus == PermissionStatus.granted) {
        print('Permission granted ======================================');
      } else {
        print('Permission denied =======================================');
      }
    });
  }
  Future<void> getCallLogs() async {
    try {
      Iterable<CallLogEntry> entries = await CallLog.get();
      callLogs = entries.toList();
      notifyListeners();
    } catch (e) {
      print('Error retrieving call logs: $e');
    }
  }
  int _lastNumber = 0;

  int get lastNumber => _lastNumber;

  Future<void> loadLastNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _lastNumber = prefs.getInt('lastNumber') ?? 0;

    notifyListeners();
  }

  Future<void> updateLastNumber(int newNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _lastNumber = newNumber;
    await prefs.setInt('lastNumber', newNumber);
    notifyListeners();
  }


  Future<void> saveNumber(BuildContext context, String number) async {
    savedNumbers.add(number);

    String contactName = 'maisam test';
    int newNumber = lastNumber + 1;
    contactName = '$contactName $newNumber';
    updateLastNumber(newNumber);
    notifyListeners();
    print(lastNumber);
    print(newNumber);


    savedContacts[number] = contactName;

    i1.Contact contact = i1.Contact(
      displayName: contactName,
      phones: [i1.Item(label: 'mobile', value: number,)],
      familyName: contactName,
    );


    await i1.ContactsService.addContact(contact);
    await getCallLogs();
    notifyListeners();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Contact "$contactName" added to contacts.'),
      ),
    );
  }
  bool isNumberSaved(String number) {
    return savedNumbers.contains(number);
  }

  String getContactNameForNumber(String phoneNumber) {
    if (savedContacts.containsKey(phoneNumber)) {
      return savedContacts[phoneNumber]!;

    } else {
      return 'maisam test';
    }
  }
}
