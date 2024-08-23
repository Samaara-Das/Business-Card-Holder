import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:virtual_card_holder/pages/contact_details_page.dart';
import 'package:virtual_card_holder/pages/scan_page.dart';
import 'package:virtual_card_holder/providers/contact_provider.dart';
import 'package:virtual_card_holder/utils/helper_functions.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  @override
  void didChangeDependencies() {
    Provider.of<ContactProvider>(context, listen: false).getAllContacts();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Contact list')),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.goNamed(ScanPage.routeName);
        },
        child: Icon(Icons.add),
        shape: CircleBorder(),
      ),
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.zero,
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        clipBehavior: Clip.antiAlias,
        child: BottomNavigationBar(
          selectedItemColor: Colors.lightBlue.shade900,
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
            _fetchData();
          },
          currentIndex: selectedIndex,
          backgroundColor: Colors.lightBlue.shade100,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'All'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites')
          ]
        ),
      ),
      body: Consumer<ContactProvider>(
        builder: (context, provider, child) => ListView.builder(
          itemCount: provider.contactList.length,
          itemBuilder: (context, index) {
            final contact = provider.contactList[index];
            return Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.endToStart,
              confirmDismiss: _showConfirmationDialog,
              onDismissed: (_) async {
                await provider.deleteContact(contact);
                showMsg(context, 'Deleted');
              },
              background: Container(
                color: Colors.red,
                alignment: FractionalOffset.centerRight,
                child: Icon(Icons.delete, color: Colors.white),
              ),
              child: ListTile(
                onTap: () {
                  context.goNamed(ContactDetailsPage.routeName, extra: contact.id);
                },
                title: Text(contact.name),
                trailing: IconButton(
                  onPressed: () { provider.updateFavorite(contact); },
                  icon: Icon(contact.favorite ? Icons.favorite:Icons.favorite_border)
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<bool?> _showConfirmationDialog(DismissDirection direction) {
    return showDialog(context: context, builder: (context) => AlertDialog(
      title: Text('Delete Contact'),
      content: Text('Are you sure you want to delete this contact?'),
      actions: [
        OutlinedButton(
          onPressed: () { context.pop(false); },
          child: Text('No')
        ),

        OutlinedButton(
          onPressed: () { context.pop(true); },
          child: Text('Yes')
        )
      ],
    ));
  }

  void _fetchData() {
    switch(selectedIndex) {
      case 0:
        Provider.of<ContactProvider>(context, listen: false).getAllContacts();
        break;
      case 1:
        Provider.of<ContactProvider>(context, listen: false).getAllFavoriteContacts();
        break;
    }
  }

}
