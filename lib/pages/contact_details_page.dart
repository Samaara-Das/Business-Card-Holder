import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:virtual_card_holder/providers/contact_provider.dart';
import 'package:virtual_card_holder/utils/helper_functions.dart';

class ContactDetailsPage extends StatefulWidget {
  static const String routeName = 'details';
  final int id;
  const ContactDetailsPage({super.key, required this.id});

  @override
  State<ContactDetailsPage> createState() => _ContactDetailsPageState();
}

class _ContactDetailsPageState extends State<ContactDetailsPage> {
  late int id;
  @override
  void initState() {
    id = widget.id;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Details')),
      body: Consumer<ContactProvider>(
        builder: (context, provider, child) => FutureBuilder(
          future: provider.getContactById(id),
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              final contact = snapshot.data!;
              return ListView(
                padding: const EdgeInsets.all(8),
                children: [
                  Image.file(File(contact.image), width: double.infinity, height: 250, fit: BoxFit.cover),
                  ListTile(
                    title: Text(contact.mobile),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(onPressed: () {
                          _launchUrl('tel:${contact.mobile}');
                        }, icon: Icon(Icons.call)),
                        IconButton(onPressed: () {
                          _launchUrl('sms:${contact.mobile}');
                        }, icon: Icon(Icons.sms))
                      ],
                    ),
                  ),

                  ListTile(
                    title: Text(contact.email),
                    trailing: IconButton(onPressed: () {
                      _launchUrl('mailto:${contact.email}');
                    }, icon: Icon(Icons.mail))
                  ),

                  ListTile(
                    title: Text(contact.address),
                    trailing: IconButton(onPressed: () {

                    }, icon: Icon(Icons.map))
                  ),

                  ListTile(
                    title: Text(contact.website),
                    trailing: IconButton(onPressed: () {
                      _launchUrl('https:${contact.website}');
                    }, icon: Icon(Icons.web))
                  ),
                ],
              );
            }

            if(snapshot.hasData) {
              return const Center(child: Text('Failed to load data'));
            }

            return const Center(child: Text('Please wait'));
          }
        ),
      ),
    );
  }

  void _launchUrl(String url) async {
    if(await canLaunchUrlString(url)) {
      await launchUrlString(url);
    }
    else {
      showMsg(context, 'Cannot perform this task');
    }
  }

  void _openMap(String address) async {
    String url = '';
    if (Platform.isAndroid) {
      url = 'geo:0,0?q=$address';
    } else {
      url = 'http://maps.apple.com/?q=$address';
    }
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      showMsg(context, 'Could not perform this operation');
    }
  }

}
