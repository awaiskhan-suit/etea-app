import 'package:etea/adminloginscreen.dart';
import 'package:etea/registration.dart';
import 'package:etea/result.dart';
import 'package:etea/rollno.dart';
import 'package:etea/show.dart';
import 'package:etea/student_marks.dart';
import 'package:flutter/material.dart';
import 'splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(), // show splash first
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Colors.blue.shade900,
            Colors.white,
          ]),
        ),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // horizontal menu
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>RollNoScreen(),));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[900],
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Roll_No"),
                  ),
                  const SizedBox(width: 13),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>StudentMarks()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[900],
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Result"),
                  ),
                  const SizedBox(width: 13),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminLoginScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[900],
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Admin"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // centered ETEA text
            Container(
              width: double.infinity,
              child: Text(
                "ETEA",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[900],
                ),
              ),
            ),
            const SizedBox(height: 5),
            // image
            CircleAvatar(

              radius: 150, // 150/2
              backgroundImage: AssetImage('assets/images/etea.png'),
            )
            ,

             const SizedBox(height: 10),
            // announcement texts
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                "The Board of Governors ETEA under the Chairmanship of Honorable Chief Minister KPK, has decided to CONFISCATE all such mobile phones in favour of the Government.",
                style:  TextStyle(fontWeight: FontWeight.bold,color: Colors.deepOrange),
              ),
            ),


            const SizedBox(height: 5),
            // contact info
          ElevatedButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>RegistrationScreen()));
          },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[900],
                foregroundColor: Colors.white,
              ),
              child: Text("Apply Now")),
          ],
        ),
      ),
    );
  }
}
