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
        backgroundColor: Color.fromARGB(255, 221, 164, 89),
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
                      height: 300,
                      width: 250,
                      decoration: BoxDecoration(
                        border: Border.all(width: 2),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ListTile(
                                title: Column(
                              children: [
                                Text(
                                  "AAP:-${documents[i]['AAP']}",
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "BJP:-${documents[i]['BJP']}",
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "CON:-${documents[i]['CON']}",
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "OTHER:-${documents[i]['OTHER']}",
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            )),
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text("Update Records"),
                                    content: Form(
                                      key: updateKey,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextFormField(
                                            validator: (val) {
                                              (val!.isEmpty)
                                                  ? "Enter author First..."
                                                  : null;
                                            },
                                            onSaved: (val) {
                                              vote = val;
                                            },
                                            controller: VoteController,
                                            decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                hintText:
                                                    "Enter author Here....",
                                                labelText: "author"),
                                          ),
                                          const SizedBox(height: 10),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      ElevatedButton(
                                        child: const Text("Update"),
                                        onPressed: () {
                                          if (updateKey.currentState!
                                              .validate()) {
                                            updateKey.currentState!.save();

                                            Map<String, dynamic> data = {
                                              'author': vote,
                                            };
                                            CloudFirestoreHelper
                                                .cloudFirestoreHelper
                                                .updateRecords(
                                                    id: documents[i].id,
                                                    data: data);
                                          }
                                          VoteController.clear();

                                          vote = "";
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      OutlinedButton(
                                        child: const Text("Cancel"),
                                        onPressed: () {
                                          VoteController.clear();

                                          vote = null;

                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: Container(
                                height: 60,
                                width: 200,
                                decoration: BoxDecoration(
                                  border: Border.all(width: 1),
                                  color: Color.fromARGB(255, 221, 164, 89),
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
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
            return Container();
          }),
    );
  }
}
