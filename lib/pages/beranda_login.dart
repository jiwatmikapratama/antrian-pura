// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables



import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ara/login.dart';
import 'package:ara/pages/daftar_pengelola.dart';
import 'package:ara/pages/pengaturan.dart';
import 'package:ara/pages/riwayat.dart';
import 'package:ara/pages/detail_profil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ara/firestore/datamanagement.dart';

class Beranda_login extends StatefulWidget {
  const Beranda_login({Key? key}) : super(key: key);

  @override
  State<Beranda_login> createState() => _Beranda_loginState();
}

class _Beranda_loginState extends State<Beranda_login> {
  final users = FirebaseAuth.instance;
  List puraList = [];

  
    final db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF189AB4),
        child:Text('Daftar Pengelola'),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => Daftar_pengelola()));
        },
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xFF189AB4),
        title: Text(
          'Search',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          // Container(
          //   child: TextField(
          //     decoration: InputDecoration(
          //       prefixIcon: Icon(Icons.search),
          //       hintText: 'Search',
          //     ),
          //   ),
          // ),
          IconButton(
            icon: Icon(
              Icons.search,
            ),
            onPressed: () {
              showSearch(context: context, delegate: DataSearch());
            },
          )
        ],
      ),
      // body: Container(),
      body: Card(
        child: FutureBuilder(
        future: FireStoreDataBase().getData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text(
              "LoadingS",
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
           puraList = snapshot.data as List;
            return buildItems(puraList);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      ),
      
    
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Container(
                child: GestureDetector(
                  child: Text(
                    users.currentUser!.email.toString(),
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Detail_profil())),
                ),
              ),
              accountEmail: null,
              currentAccountPicture:
                  CircleAvatar(backgroundImage: AssetImage('images/catur.jpg')),
              decoration: BoxDecoration(),
            ),
            ListTile(
              leading: Icon(
                Icons.history,
                color: Colors.black,
              ),
              title: Text(
                "Riwayat",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Riwayat())),
            ),
            ListTile(
              leading: Icon(
                Icons.settings,
                color: Colors.black,
              ),
              title: Text(
                "Pengaturan",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Pengaturan())),
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: Colors.black,
              ),
              title: Text(
                "Logout",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Login())),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget buildItems(puraList) => ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: puraList.length,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          
          title: Text(
            puraList[index]["nama"],
          ),
          subtitle:  Text(puraList[index]["alamat"]),


        );
      });
}

class DataSearch extends SearchDelegate<String> {
  final pura = ["Besakih", "Tanah Lot", "Uluwatu"];

  final recentPura = ["Besakih", "Tanah Lot"];

  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
        onPressed: () {
          query = "";
        },
        icon: Icon(Icons.clear),
      )
    ];

    throw UnimplementedError();
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
      onPressed: () {
        close(context, "");
      },
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults

    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    final suggestionList = query.isEmpty
        ? recentPura
        : pura.where((p) => p.startsWith(query)).toList();

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          showResults(context);
        },
        leading: CircleAvatar(
          backgroundImage: AssetImage('images/catur.jpg'),
        ),
        title: Column(
          children: [
            Text(suggestionList[index]),
            Text("Alamat"),
          ],
        ),
      ),
      itemCount: suggestionList.length,
    );
  }
}
