import 'package:cached_network_image/cached_network_image.dart';
import 'package:evamp_saanga/Models/UserInfo.dart';
import 'package:evamp_saanga/res/colors.dart';
import 'package:evamp_saanga/screen/HomeScreen.dart';
import 'package:evamp_saanga/screen/LoginScreen.dart';
import 'package:evamp_saanga/services/auth_service.dart';
import 'package:flutter/material.dart';

class ProfileDetail extends StatefulWidget {
  @override
  _ProfileDetailState createState() => _ProfileDetailState();
}

class _ProfileDetailState extends State<ProfileDetail> {
  late UserInfo getuserdata;
  bool isloading = false;
  @override
  void initState() {
    super.initState();
    AuthService().fetchAlbum().then((userdata) {
      setState(() {
        getuserdata = userdata;
        print('checking the userinfo ${getuserdata}');
      });
      isloading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'PROFILE',
            style: TextStyle(
              color: Colors.blue.shade700,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(
                Icons.menu,
                size: 30,
                color: Colors.blue.shade700,
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.search,
                  color: userinfocolor,
                  size: 30,
                ))
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                    'Logout',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                  leading: Icon(
                    Icons.logout,
                    size: 30,
                  ),
                  onTap: () {
                    AuthService().logout();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                ),
              )
            ],
          ),
        ),
        body: SafeArea(
          child: Center(
              child: SingleChildScrollView(
                  child: isloading
                      ? Container(
                          padding: EdgeInsets.only(left: 50, right: 50),
                          child: Column(
                            children: [
                              Container(
                                width: size.width / 2.8,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(80),
                                  child: CachedNetworkImage(
                                    imageUrl: getuserdata.userInfo!.profileImage
                                        .toString(),
                                    placeholder: (context, url) => Center(
                                        child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              Text(
                                getuserdata.userInfo!.name.toString(),
                                style: TextStyle(
                                    color: userinfocolor,
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                getuserdata.userInfo!.email.toString(),
                                style: TextStyle(
                                  color: userinfocolor,
                                ),
                              ),
                              SizedBox(
                                height: 60,
                              ),
                              Text(
                                getuserdata.userInfo!.welcomeMessage.toString(),
                                style: TextStyle(
                                  letterSpacing: 4,
                                  wordSpacing: 2,
                                ),
                                textAlign: TextAlign.center,
                                softWrap: true,
                              ),
                              SizedBox(
                                height: 100,
                              ),
                              Container(
                                width: size.width,
                                child: MaterialButton(
                                    height: size.height * 0.07,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    color: Colors.blue,
                                    child: Text(
                                      'EXPLORE MORE',
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300),
                                    ),
                                    onPressed: () async {
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (BuildContext context) {
                                        return HomeScreen(
                                          usertoken:
                                              getuserdata.userInfo!.token,
                                          email: getuserdata.userInfo!.email,
                                        );
                                      }));
                                    }),
                              )
                            ],
                          ))
                      : Center(
                          child: CircularProgressIndicator(),
                        ))),
        ));
  }
}
