const String tableContact = 'tbl_contact';
const String tblContactColId = 'id';
const String tblContactColName = 'name';
const String tblContactColMobile = 'mobile';
const String tblContactColEmail = 'email';
const String tblContactColAddress = 'address';
const String tblContactColCompany = 'company';
const String tblContactColDesignation = 'designation';
const String tblContactColWebsite = 'website';
const String tblContactColImage = 'image';
const String tblContactColFavorite = 'favorite';

class ContactModel {
  int id;
  String name;
  String mobile;
  String email;
  String address;
  String company;
  String designation;
  String website;
  String image;
  bool favorite;

  ContactModel({
    this.id = -1,
    required this.name,
    required this.mobile,
    this.email = '',
    this.address = '',
    this.company = '',
    this.designation = '',
    this.website = '',
    this.image = '',
    this.favorite = false,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      tblContactColName: name,
      tblContactColMobile: mobile,
      tblContactColEmail: email,
      tblContactColAddress: address,
      tblContactColCompany: company,
      tblContactColDesignation: designation,
      tblContactColWebsite: website,
      tblContactColImage: image,
      tblContactColFavorite: favorite ? 1:0,
    };
    if(id > 0) map[tblContactColId] = id;
    return map;
  }

  factory ContactModel.fromMap(Map<String, dynamic> map) => ContactModel(
    name: map[tblContactColName],
    mobile: map[tblContactColMobile],
    website: map[tblContactColWebsite],
    email: map[tblContactColEmail],
    designation: map[tblContactColDesignation],
    company: map[tblContactColCompany],
    address: map[tblContactColAddress],
    favorite: map[tblContactColFavorite] == 1 ? true:false,
    id: map[tblContactColId],
    image: map[tblContactColImage]
  );

  @override
  String toString() {
    return 'ContactModel{id: $id, name: $name, mobile: $mobile, email: $email, address: $address, company: $company, designation: $designation, website: $website, image: $image, favorite: $favorite}';
  }
}
