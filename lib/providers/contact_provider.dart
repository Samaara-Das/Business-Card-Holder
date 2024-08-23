import 'package:flutter/material.dart';
import 'package:virtual_card_holder/db/db_helper.dart';
import '../models/contact_model.dart';

class ContactProvider extends ChangeNotifier {
  List<ContactModel> contactList = [];
  final db = DbHelper();

  Future<int> insertContact(ContactModel contactModel) async {
    final rowId = await db.insertContact(contactModel);
    contactModel.id = rowId;
    contactList.add(contactModel);
    notifyListeners();
    return rowId;
  }

  Future<void> getAllContacts() async {
    contactList = await db.getAllContacts();
    notifyListeners();
  }

  Future<ContactModel> getContactById(int id) => db.getContactById(id);


  Future<void> getAllFavoriteContacts() async {
    contactList = await db.getAllFavoriteContacts();
    notifyListeners();
  }

  Future<int> deleteContact(ContactModel contactModel) async {
    int row = await db.deleteContact(contactModel.id);
    final index = contactList.indexOf(contactModel); // find the index of this deleted ContactModel object
    contactList.removeAt(index);
    notifyListeners();
    return row;
  }

  Future<void> updateFavorite(ContactModel contactModel) async {
    int val = contactModel.favorite ? 0:1;
    await db.updateFavorite(contactModel.id, val);
    final index = contactList.indexOf(contactModel);
    contactList[index].favorite = !contactList[index].favorite;
    notifyListeners();
  }
}

