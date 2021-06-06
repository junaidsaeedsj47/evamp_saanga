import 'package:cached_network_image/cached_network_image.dart';
import 'package:evamp_saanga/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:evamp_saanga/Models/CustomersList.dart';
import 'package:evamp_saanga/screen/LoginScreen.dart';
import 'package:evamp_saanga/services/Api_service.dart';
import 'package:evamp_saanga/services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({this.usertoken, this.email});
  String? usertoken;
  String? email;
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String usernmae = '';
  Future showusername() async {
    usernmae = await AuthService().getusername();
    setState(() {
      usernmae = usernmae;
    });
    return usernmae;
  }

  late ItemData itemData;
  bool isloading = false;
  @override
  void initState() {
    showusername();
    Future.delayed(
        Duration(seconds: 4),
        () => ApiServices()
                .getItemsList(widget.usertoken, widget.email)
                .then((getitem) {
              setState(() {
                itemData = getitem;
              });

              isloading = true;
            }));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Items List',
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
                    usernmae,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                  leading: Icon(
                    Icons.account_circle_rounded,
                    size: 30,
                  ),
                ),
              ),
              Divider(
                color: Colors.black38,
                height: 1,
              ),
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
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: isloading
                  ? ListView.builder(
                      itemCount: itemData.items!.length,
                      itemBuilder: (BuildContext ctx, int index) {
                        return Card(
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 15, bottom: 15, left: 8, right: 8),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 2,
                                      child: isloading
                                          ? Container(
                                              height: size.height / 4,
                                              width: size.width / 2.7,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                child: CachedNetworkImage(
                                                  fit: BoxFit.cover,
                                                  imageUrl: itemData
                                                      .items![index].itemImage
                                                      .toString(),
                                                  placeholder: (context, url) =>
                                                      Center(
                                                          child:
                                                              CircularProgressIndicator()),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Icon(Icons.error),
                                                ),
                                              ),
                                            )
                                          : Center(
                                              child:
                                                  CircularProgressIndicator())),
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      padding: EdgeInsets.only(left: 20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            itemData.items![index].name
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            itemData.items![index].description
                                                .toString(),
                                            style: TextStyle(
                                                color: Colors.grey.shade500),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            "\$${itemData.items![index].price.toString()}",
                                            style: TextStyle(
                                                color: Colors.blue.shade700,
                                                fontSize: 25,
                                                fontWeight: FontWeight.w600),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      })
                  : Center(
                      child: CircularProgressIndicator(),
                    )),
        ));
  }
}
