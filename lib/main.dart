import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';

void main() {
  runApp(
      MaterialApp(
      home:
      MyApp()
      )
  );
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {

  getPermission() async {
    var status = await Permission.contacts.status;
    if (status.isGranted) {
      print('허락됨');
      var contacts = await ContactsService.getContacts();
      setState(() {
        name = contacts;
      });
      /*
      var newPerson = Contact();
      newPerson.givenName = '영광';
      newPerson.familyName = '독고';
      await ContactsService.addContact(newPerson);
      */
    }
    else if (status.isDenied) {
      print('거절됨');
      Permission.contacts.request();

    }
  }

  var total = 3;
  var a = 1;
  var image = ['assets/IMG_3609.PNG'];
  dynamic name = [];

  addName(inputName){
    setState(() {
      name.add(inputName);
    });
  }

  addOne(){
    setState(() {
      total++;
    });
  }

  @override
  build(context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            showDialog(context: context, builder: (context){
              return DialogUI(state : a, addOne : addOne, addName: addName, name: name, getPermission: getPermission);
            });
          },
        ),

        appBar: AppBar( title: Text(total.toString()), actions: [
            IconButton(onPressed: (){ getPermission(); }, icon: Icon(Icons.contacts))
          ], ),

        body: ListView.builder(
            itemCount: name.length,
            itemBuilder: (c, i){
              return ListTile(
                leading: Image.asset(image[0]),
                title: Text(name[i].displayName),
                subtitle: Text(name[i].phones.toString()),
              );
            }
        ),
        bottomNavigationBar: BottomAppbar()
      );
  }
}

class BottomAppbar extends StatelessWidget {
  const BottomAppbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(Icons.phone),
          Icon(Icons.message),
          Icon(Icons.contact_page),
        ],
      ),
    );
  }
}

class DialogUI extends StatelessWidget {
  DialogUI({Key? key, this.state, this.addOne, this.addName, this.name, this.getPermission}) : super(key: key);
  final state;
  final addOne;
  final name;
  var inputData = TextEditingController();
  final addName;
  final getPermission;
  var newPerson = Contact();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
      padding: EdgeInsets.all(20),
        width: 300,
        height: 300,
        child: Column(
          children: [
            TextField( controller: inputData,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    child: Text('완료'),
                    onPressed: (){
                      getPermission();
                      newPerson.givenName = inputData.text;
                      ContactsService.addContact(newPerson);
                      Navigator.pop(context);
                    }
                ),
                TextButton(
                  child: Text('취소'),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
