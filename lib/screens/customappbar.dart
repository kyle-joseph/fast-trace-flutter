import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color color;

  CustomAppbar({Key key, this.title, this.color}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 6.5),
      alignment: Alignment.bottomCenter,
      decoration: BoxDecoration(
        color: color,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            iconSize: 25.0,
            color: Colors.white,
          ),
          Text(
            title,
            style: TextStyle(
                color: Colors.white,
                fontSize: 25.0,
                fontWeight: FontWeight.w700),
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () => {},
            iconSize: 25.0,
            color: Colors.white,
          )
        ],
      ),
    );
  }
}
