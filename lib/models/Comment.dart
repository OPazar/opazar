import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String get uid => _uid;
  String _uid;

  String buyerUid;
  String content;
  double rate;

  DocumentReference referance;

  Comment({uid, this.buyerUid, this.content, this.rate}) : this._uid = uid;

  factory Comment.fromMap(Map data) {
    data = data ?? {};
    return Comment(
      buyerUid: data['buyerUid'] ?? '',
      content: data['content'] ?? '',
      rate: data['rate'].toDouble() ?? 0,
    );
  }

  factory Comment.fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data;
    return Comment(
      uid: snapshot.documentID ?? '',
      buyerUid: data['buyerUid'] ?? '',
      content: data['content'] ?? '',
      rate: data['rate'].toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'buyerUid': buyerUid,
      'content': content,
      'rate': rate,
    };
  }
}
