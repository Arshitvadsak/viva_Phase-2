import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../helper/firestore_helper.dart';

class votePage extends StatefulWidget {
  const votePage({super.key});

  @override
  State<votePage> createState() => _votePageState();
}

class _votePageState extends State<votePage> {
  final GlobalKey<FormState> updateKey = GlobalKey<FormState>();
  TextEditingController VoteController = TextEditingController();

  String? vote;
  String? electionParty;
  int count = 0;

  void _increment() {
    setState(() {
      count++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Vote App",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFC0DBEA),
      ),
      body: StreamBuilder(
        stream: CloudFirestoreHelper.cloudFirestoreHelper.selectrecord(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapShot) {
          if (snapShot.hasError) {
            return Center(
              child: Text("ERROR : ${snapShot.error}"),
            );
          } else if (snapShot.hasData) {
            QuerySnapshot? data = snapShot.data;
            List<QueryDocumentSnapshot> documents = data!.docs;

            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.all(30),
                  child: Container(
                    height: 500,
                    width: 250,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 10.0,
                          spreadRadius: 3.0,
                          offset: Offset(
                            5.0,
                            5.0,
                          ),
                        )
                      ],
                      border: Border.all(width: 2),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              height: 70,
                              width: 400,
                              child: Card(
                                elevation: 5,
                                child: Center(
                                  child: Text(
                                    "AAP:-${documents[i]['AAP']}",
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 70,
                              width: 400,
                              child: Card(
                                elevation: 5,
                                child: Center(
                                  child: Text(
                                    "BJP:-${documents[i]['BJP']}",
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 70,
                              width: 400,
                              child: Card(
                                elevation: 5,
                                child: Center(
                                  child: Text(
                                    "CON:-${documents[i]['CON']}",
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 70,
                              width: 400,
                              child: Card(
                                elevation: 5,
                                child: Center(
                                  child: Text(
                                    "OTHER:-${documents[i]['OTHER']}",
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            electionParty == null
                                ? GestureDetector(
                                    onTap: () {
                                      customDialog(context, documents, i);
                                    },
                                    child: Container(
                                      height: 60,
                                      width: 200,
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey,
                                            blurRadius: 10.0,
                                            spreadRadius: 1.0,
                                            offset: Offset(
                                              3.0,
                                              3.0,
                                            ),
                                          )
                                        ],
                                        border: Border.all(width: 1),
                                        color: const Color(0xFFC0DBEA),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          "vote Now",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Center(
                                    child:
                                        Text("Your Vote Successfully Done..."),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }

  Future<dynamic> customDialog(BuildContext context,
      List<QueryDocumentSnapshot<Object?>> documents, int i) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Votes Records"),
        content: Form(
          key: updateKey,
          child: Container(
            height: 250,
            child: Column(
              children: [
                RadioListTile(
                  title: Text("AAP"),
                  value: "AAP",
                  groupValue: electionParty,
                  onChanged: (value) {
                    setState(() {
                      if (updateKey.currentState!.validate()) {
                        updateKey.currentState!.save();

                        Map<String, dynamic> data = {
                          'AAP': documents[i]['AAP'] + 1
                        };
                        CloudFirestoreHelper.cloudFirestoreHelper
                            .updateRecords(id: documents[i].id, data: data);
                      }
                      electionParty = value.toString();
                      Navigator.of(context).pop();
                    });
                  },
                ),
                RadioListTile(
                  title: Text("BJP"),
                  value: "BJP",
                  groupValue: electionParty,
                  onChanged: (value) {
                    setState(() {
                      if (updateKey.currentState!.validate()) {
                        updateKey.currentState!.save();

                        Map<String, dynamic> data = {
                          'BJP': documents[i]['BJP'] + 1
                        };
                        CloudFirestoreHelper.cloudFirestoreHelper
                            .updateRecords(id: documents[i].id, data: data);
                      }
                      electionParty = value.toString();
                      Navigator.of(context).pop();
                    });
                  },
                ),
                RadioListTile(
                  title: Text("CON"),
                  value: "CON",
                  groupValue: electionParty,
                  onChanged: (value) {
                    setState(() {
                      if (updateKey.currentState!.validate()) {
                        updateKey.currentState!.save();

                        Map<String, dynamic> data = {
                          'CON': documents[i]['CON'] + 1
                        };
                        CloudFirestoreHelper.cloudFirestoreHelper
                            .updateRecords(id: documents[i].id, data: data);
                      }
                      electionParty = value.toString();
                      Navigator.of(context).pop();
                    });
                  },
                ),
                RadioListTile(
                  title: Text("OTHER"),
                  value: "other",
                  groupValue: electionParty,
                  onChanged: (value) {
                    setState(() {
                      if (updateKey.currentState!.validate()) {
                        updateKey.currentState!.save();

                        Map<String, dynamic> data = {
                          'OTHER': documents[i]['OTHER'] + 1
                        };
                        CloudFirestoreHelper.cloudFirestoreHelper
                            .updateRecords(id: documents[i].id, data: data);
                      }
                      electionParty = value.toString();
                      Navigator.of(context).pop();
                    });
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
