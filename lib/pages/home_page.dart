import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertimesweb/helpers/responsive_helper.dart';
import 'package:fluttertimesweb/models/Article.dart';
import 'package:fluttertimesweb/pages/art_times.dart';
import 'package:fluttertimesweb/pages/home_times.dart';
import 'package:fluttertimesweb/pages/science_times.dart';
import 'package:fluttertimesweb/pages/tech_times.dart';
import 'package:fluttertimesweb/pages/world_times.dart';
import 'package:fluttertimesweb/services/APIServices.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> _screenList = [
    HomeTimes(),
    TechTimes(),
    ScienceTimes(),
    WorldTimes(),
    ArtTimes(),
  ];

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      bottomNavigationBar: ConvexAppBar(
        items: [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.memory, title: 'Technology'),
          TabItem(icon: Icons.network_check, title: 'Science'),
          TabItem(icon: Icons.public, title: 'World'),
          TabItem(icon: Icons.color_lens, title: 'Art'),
        ],
        initialActiveIndex: _currentIndex, //optional, default as 0
        onTap: (int i) {
          setState(() {
            _currentIndex = i;
          });
          print(_currentIndex);
        },
      ),
      body: _screenList[_currentIndex],
    );
  }

  Widget createGridView(
      BuildContext context, AsyncSnapshot snapshot, MediaQueryData mediaQuery) {
    var values = snapshot.data;

    return GridView.builder(
      itemCount: values["results"].length,
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: responsiveNumGridTiles(mediaQuery),
      ),
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: GestureDetector(
            onTap: () {
              _launchUrl(values['results'][index]["url"]);
            },
            child: Column(
              children: <Widget>[
                Container(
                  height: responsiveImageHeight(mediaQuery),
                  alignment: Alignment.bottomCenter,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(
                        values["results"][index]["multimedia"][0]["url"],
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  alignment: Alignment.center,
                  height: responsiveTitleHeight(mediaQuery),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, 1),
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                  child: Text(
                    values["results"][index]['title'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
//                        maxLines: 2,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> _fetchArticles() async {
    Map<String, dynamic> data =
        await APIService().fetchArticlesBySection('arts');

    return data;
  }

  _launchUrl(String url) async {
    if (await canLaunch((url))) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
