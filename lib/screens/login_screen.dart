
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:varchas_app/Utils/fetch_data.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:varchas_app/screens/schedule_screen.dart';
import 'home_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TeamData? teamData;
  final TextEditingController teamIdController = TextEditingController();
  bool fetchedData = false;
  Widget bottomWidget = const SizedBox(height: 1,);


  @override
  void initState() {
    // TODO: implement initState
    updateLoginData();
    fetchTeamData().then((td) {
      teamData = td;
      setState(() {
        fetchedData = true;
      });
    });
    super.initState();
  }

  updateLoginData() async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false);
  }

  @override
  Widget build(BuildContext context) {
    Size pageSize = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: MediaQuery.of(context).size.height * 0.15,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
        ),
        title:Container(
          padding: const EdgeInsets.only(
            top: 25,
            left: 3,
            right: 3,
          ),
          height: pageSize.height * 0.12,
          width: pageSize.width,
          decoration: const BoxDecoration(
            color: Colors.black87,//fromARGB(255,18,7,17),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: pageSize.width*0.035,),
              Expanded(child: Image.asset("assets/varchas_textLogo_nobg.png",),flex: 2,),
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children:   [
              //     Image.asset("assets/varchas_textLogo_nobg.png", height: size.height * 0.09,),
              //     // showMenuOption? IconButton(
              //     //   onPressed: ()=> const NavigationDrawer(),// ZoomDrawer.of(context)!.toggle(),
              //     //   icon: const Icon(Icons.menu,color: Colors.white,),
              //     // ): IconButton(
              //     //     onPressed: ()=>Navigator.pop(context),
              //     //     icon: const Icon(Icons.arrow_back,color: Colors.white,)
              //     // ),
              //     // const Text('Varchas',style: TextStyle(color: Colors.white,fontSize:30,fontWeight: FontWeight.bold),),
              //     // Row(
              //     //   mainAxisAlignment: MainAxisAlignment.start,
              //     //   children: [
              //     //     const SizedBox(width: 10,),
              //     //     Image.asset("assets/varchas_textLogo_nobg.png", height: size.height * 0.09,),
              //     //   ],
              //     // ),
              //   ],
              // ),
              SizedBox(width: pageSize.width*0.05,),
              Expanded(
                child: Image.asset("assets/varchas_Logo_nobg.png",
                ),
                flex: 1,),
              SizedBox(width: pageSize.width*0.02,),
            ],
          ),
        ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     Column(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       crossAxisAlignment: CrossAxisAlignment.center,
        //       children: [
        //         Image.asset("assets/varchas_textLogo_nobg.png", height: pageSize.height * 0.09,),
        //       ],
        //     ),
        //     SizedBox(width: pageSize.width*0.15,),
        //     Column(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       crossAxisAlignment: CrossAxisAlignment.center,
        //       children: [
        //         Image.asset("assets/varchas_Logo_nobg.png", scale: 2.9,),
        //       ],
        //     ),
        //
        //   ],
        // ),
      ),
      backgroundColor: Color.fromRGBO(35, 14, 33, 25),
      body: Container(
        padding: EdgeInsets.all(pageSize.width * 0.025),
        child: Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: pageSize.height * 0.15,),
              const Text(
                "LOGIN",
                style: TextStyle(fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                child: const Divider(color: Colors.white70, ),
                width: pageSize.width * 0.3,
              ),
              const SizedBox(height: 10,),
              // SizedBox(height: pageSize.height * 0.03),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                width: pageSize.width * 0.8,
                decoration: BoxDecoration(
                  color: Colors.white38,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextField(
                  controller: teamIdController,
                  autocorrect: false,
                  // cursorColor: kPrimaryColor,
                  decoration: const InputDecoration(
                    icon: Icon(
                      Icons.key,
                      color: Colors.white,
                    ),
                    hintText: "Team ID",
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              GestureDetector(
                onTap: () async {
                  String enteredTeamid = teamIdController.text;
                  if(fetchedData == false){
                    Fluttertoast.showToast(
                      msg: "App connecting.. Please try again",
                      backgroundColor: Colors.blueGrey.shade600,
                      toastLength: Toast.LENGTH_SHORT,
                      timeInSecForIosWeb: 1,
                    );
                  }
                  int teamIndex = teamData!.verifyTeamIDandGetDetails(enteredTeamid);
                  if(teamIndex != -1){
                    dynamic team = teamData!.results[teamIndex];
                    final prefs = await SharedPreferences.getInstance();
                    prefs.setBool('isLoggedIn', true);
                    prefs.setStringList('teamData', [team['teamId'], team['college'], team['sport'], team['score'].toString()]);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const ScheduleScreen()),
                    );
                  }
                  else{
                    Fluttertoast.showToast(
                      msg: "Please enter valid Team ID. Eg. VA-ABC-XYZ69",
                      backgroundColor: Colors.redAccent,
                      toastLength: Toast.LENGTH_SHORT,
                      timeInSecForIosWeb: 1,
                    );
                  }
                },
                child: Container(
                  width: pageSize.width * 0.6,
                  height: 50,
                  decoration: BoxDecoration(
                    // color: Colors.brown,
                    color: Colors.red.shade900,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      Icon(Icons.login_sharp, color: Colors.white,),
                      SizedBox(width: 20,),
                      Text("Login", style: TextStyle(color: Colors.white),),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              GestureDetector(
                onTap: () async {
                  final prefs = await SharedPreferences.getInstance();
                  prefs.setBool('isLoggedIn', false);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const ScheduleScreen()),
                  );
                },
                child: Container(
                  width: pageSize.width * 0.6,
                  height: 50,
                  decoration: BoxDecoration(
                    // color: Colors.brown,
                    color: Colors.blueAccent.shade700,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      Icon(Icons.login_sharp, color: Colors.white),
                      SizedBox(width: 20,),
                      Text("Continue without login", style: TextStyle(color: Colors.white),),
                    ],
                  ),
                ),
              ),
              bottomWidget,
            ],
          ),
        ),
      ),
    );
  }
}

//
// class RoundedInputField extends StatelessWidget {
//   final String hintText;
//   final IconData icon;
//   final ValueChanged<String> onChanged;
//   const RoundedInputField({
//     Key? key,
//     required this.hintText,
//     this.icon = Icons.person,
//     required this.onChanged,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 10),
//       padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
//       width: pageSize.width * 0.8,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(29),
//       ),
//       child: TextField(
//         onChanged: onChanged,
//         // cursorColor: kPrimaryColor,
//         decoration: InputDecoration(
//           icon: Icon(
//             icon,
//             // color: kPrimaryColor,
//           ),
//           hintText: hintText,
//           border: InputBorder.none,
//         ),
//       ),
//     );
//   }
// }
