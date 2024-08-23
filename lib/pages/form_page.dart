import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:virtual_card_holder/models/contact_model.dart';
import 'package:virtual_card_holder/pages/home_page.dart';
import 'package:virtual_card_holder/providers/contact_provider.dart';
import 'package:virtual_card_holder/utils/constants.dart';
import 'package:virtual_card_holder/utils/helper_functions.dart';

class FormPage extends StatefulWidget {
  static const String routeName = 'form';
  final ContactModel contactModel;
  const FormPage({super.key, required this.contactModel});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var mobileController = TextEditingController();
  var emailController = TextEditingController();
  var addressController = TextEditingController();
  var companyController = TextEditingController();
  var designationController = TextEditingController();
  var webController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Form Page'),
        actions: [
          IconButton(onPressed: saveContact, icon: Icon(Icons.save))
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                icon: Icon(Icons.person),
                labelText: 'Contact Name'
              ),
              validator: (value) {
                if(value == null || value.isEmpty) return emptyFieldErrMsg;
                return null;
              },
            ),
            TextFormField(
              keyboardType: TextInputType.phone,
              controller: mobileController,
              decoration: InputDecoration(
                icon: Icon(Icons.numbers),
                labelText: 'Mobile'
              ),
              validator: (value) {
                if(value == null || value.isEmpty) return emptyFieldErrMsg;
                return null;
              },
            ),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                  icon: Icon(Icons.email),
                  labelText: 'Email Address'
              ),
              validator: (value) {
                if(value == null || value.isEmpty) return emptyFieldErrMsg;
                return null;
              },
            ),
            TextFormField(
              controller: addressController,
              decoration: InputDecoration(
                  icon: Icon(Icons.location_on),
                  labelText: 'Street Address'
              ),
              validator: (value) => null
            ),
            TextFormField(
              controller: companyController,
              decoration: InputDecoration(
                  icon: Icon(Icons.business),
                  labelText: 'Company Name'
              ),
              validator: (value) => null
            ),
            TextFormField(
              controller: designationController,
              decoration: InputDecoration(
                  icon: Icon(Icons.description),
                  labelText: 'Designation'
              ),
              validator: (value) => null
            ),
            TextFormField(
              controller: webController,
              decoration: InputDecoration(
                  icon: Icon(Icons.web),
                  labelText: 'Website'
              ),
              validator: (value) => null
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    nameController.text = widget.contactModel.name;
    mobileController.text = widget.contactModel.mobile;
    emailController.text = widget.contactModel.email;
    addressController.text = widget.contactModel.address;
    companyController.text = widget.contactModel.company;
    designationController.text = widget.contactModel.designation;
    webController.text = widget.contactModel.website;
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    mobileController.dispose();
    emailController.dispose();
    addressController.dispose();
    companyController.dispose();
    designationController.dispose();
    webController.dispose();
    super.dispose();
  }

  void saveContact() async {
    if(_formKey.currentState!.validate()) {
      widget.contactModel.name = nameController.text;
      widget.contactModel.mobile = mobileController.text;
      widget.contactModel.email = emailController.text;
      widget.contactModel.address = addressController.text;
      widget.contactModel.company = companyController.text;
      widget.contactModel.designation = designationController.text;
      widget.contactModel.website = webController.text;

      Provider.of<ContactProvider>(context, listen: false)
        .insertContact(widget.contactModel)
        .then((value) {
          if(value > 0) {
            showMsg(context, 'Saved');
            context.goNamed(HomePage.routeName);
          }
        })
        .catchError((error) {
          showMsg(context, 'Failed to Saved');
        });
    }
  }
}
