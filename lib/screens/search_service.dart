import 'package:cloud_firestore/cloud_firestore.dart';

class SearchService {
  searchByName(String searchField) {
    return Firestore.instance
        .collection('clients')
        .where('placeKey', isEqualTo: searchField.substring(0, 1))
        .getDocuments();

        // https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=Museum%20of%20Contemporary%20Art%20Australia&inputtype=textquery&fields=photos,formatted_address,name,rating,opening_hours,geometry&key=AIzaSyAjEEvjICii16tE0Nq4wEVM2Z8GKuOEgx4
  }
}
