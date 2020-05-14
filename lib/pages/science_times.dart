import 'package:flutter/material.dart';
import 'package:fluttertimesweb/helpers/responsive_helper.dart';
import 'package:fluttertimesweb/services/APIServices.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ScienceTimes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return SingleChildScrollView(
      child: Container(
        child: FutureBuilder(
          future: _fetchArticles(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Loading...'),
                      SizedBox(
                        height: 20,
                      ),
                      CircularProgressIndicator(),
                    ],
                  ),
                );
              default:
                if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');
                else
                  return Column(
                    children: <Widget>[
                      SizedBox(height: 80.0),
                      Center(
                        child: Text(
                          'The New York Times\nTop Science Articles',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.tinos(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      SizedBox(height: 30.0),
                      createGridView(context, snapshot, mediaQuery),
                    ],
                  );
            }
          },
        ),
      ),
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
        await APIService().fetchArticlesBySection('science');

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
