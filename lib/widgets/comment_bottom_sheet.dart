import 'package:cached_network_image/cached_network_image.dart';
import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:flutter/material.dart';
import 'package:opazar/enums/status.dart';
import 'package:opazar/models/Comment.dart';
import 'package:opazar/models/User.dart';
import 'package:opazar/services/db.dart';

class CommentBottomSheet extends StatelessWidget {
  final List<Comment> comments;
  final Status status;

  CommentBottomSheet({this.comments, @required this.status});

  final db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    if (status == Status.done) {
      return Wrap(
        children: List.generate(comments.length, (index) {
          var currentComment = comments[index];
          return EnhancedFutureBuilder<User>(
            future: db.getUser(currentComment.buyerUid),
            rememberFutureResult: false,
            whenDone: (snapshotData) => CommentCard(comment: currentComment, user: snapshotData, status: Status.done),
            whenNotDone: CommentCard(status: Status.waiting),
            whenError: (error) => CommentCard(status: Status.error),
          );
        }),
      );
    } else if (status == Status.waiting) {
      return Expanded(child: Center(child: CircularProgressIndicator()));
    } else {
      return Expanded(child: Center(child: Text('Henüz yorum yapılmamış gibi görünüyor')));
    }
  }
}

class CommentCard extends StatelessWidget {
  final Comment comment;
  final User user;
  final Status status;

  CommentCard({this.comment, this.user, @required this.status});

  @override
  Widget build(BuildContext context) {
    var userImageWidget;
    var commentContentWidget;

    if (status == Status.done) {
      userImageWidget = CachedNetworkImage(
        imageUrl: user.imageUrl,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        placeholder: (context, url) => Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => Icon(Icons.error),
      );
      commentContentWidget = Text('${user.name} ${user.sureName}:\n${comment.content}\npuanım: ${comment.rate}');
    } else if (status == Status.waiting) {
      userImageWidget = commentContentWidget = Center(child: CircularProgressIndicator());
    } else {
      userImageWidget = commentContentWidget = Center(child: Icon(Icons.error));
    }

    return Container(
      child: Row(
        children: <Widget>[
          Container(margin: EdgeInsets.only(left: 10.0), width: 50, height: 50, child: userImageWidget),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: 50.0,
                ),
                child: commentContentWidget,
              ),
              decoration: BoxDecoration(color: Colors.greenAccent, borderRadius: BorderRadius.all(Radius.circular(10))),
            ),
          )
        ],
      ),
    );
  }
}
