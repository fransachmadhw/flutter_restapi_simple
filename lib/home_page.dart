import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_restapi_simple/users_pets.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late UsersPets usersPets; // to hold response
  bool isDataLoaded = false; // whether data from api is loaded or not
  String errorMessage = ''; // incase if api is failed to load

  // API call
  Future<UsersPets> getDataFromAPI() async {
    Uri url = Uri.parse(
        'https://jatinderji.github.io/users_pets_api/users_pets.json');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      UsersPets usersPets = usersPetsFromJson(response.body);
      setState(() {
        isDataLoaded = true;
      });
      return usersPets;
    } else {
      errorMessage = '${response.statusCode}: ${response.body}';
      return UsersPets(data: []);
    }
  }

  assignData() async {
    usersPets = await getDataFromAPI();
  }

  @override
  void initState() {
    // call function
    assignData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("REST API"),
        centerTitle: true,
      ),
      body: isDataLoaded
          ? errorMessage.isNotEmpty
              ? Text(errorMessage)
              : usersPets.data.isEmpty
                  ? const Text('No Data Loaded')
                  : ListView.builder(
                      itemCount: usersPets.data.length,
                      itemBuilder: (context, index) => getMyRow(index),
                    )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Widget getMyRow(int index) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          radius: 21,
          backgroundColor:
              usersPets.data[index].isFriendly ? Colors.green : Colors.red,
          child: CircleAvatar(
            radius: 20,
            backgroundColor:
                usersPets.data[index].isFriendly ? Colors.green : Colors.red,
            backgroundImage: NetworkImage(usersPets.data[index].petImage),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              usersPets.data[index].userName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('Dog: ${usersPets.data[index].petName}')
          ],
        ),
        trailing: Icon(
          usersPets.data[index].isFriendly ? Icons.pets : Icons.do_not_touch,
          color: usersPets.data[index].isFriendly ? Colors.green : Colors.red,
        ),
      ),
    );
  }
}
