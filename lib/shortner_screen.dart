import 'package:flutter/material.dart';
import 'package:flutter_clipboard_manager/flutter_clipboard_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  String shortLink = "No Value Yet";
  String fullShortLink = "No Value Yet";
  String shortLink2 = "No Value Yet";
  String fullShortLink2 = "No Value Yet";
  String shareLink = "No Value Yet";
  String original = "";
  TextEditingController urlcontroller = TextEditingController();
  getdata() async{
    //var url ="https://api.shrtco.de/v2/shorten?url=google.com";
    var url ='https://api.shrtco.de/v2/shorten?url=${urlcontroller.text}';
    var response = await http.get(url);
    var result = jsonDecode(response.body);
    print(result);
    setState(() {
      shortLink = result['result']['short_link'];
      fullShortLink = result['result']['full_short_link'];
      shortLink2 = result['result']['short_link2'];
      fullShortLink2 = result['result']['full_short_link2'];
      shareLink = result['result']['share_link'];
      original = result['result']['original_link'];
    }); 
  }  
  copy(String dataToCopy){
    FlutterClipboardManager.copyToClipBoard(dataToCopy).then((value){
      SnackBar snackBar = SnackBar(
        content:Text("$dataToCopy was copied to clipboard"),duration: Duration(seconds: 3),
      );
      _globalKey.currentState.showSnackBar(snackBar);
    });
  }

  buildrow(String title,String data, bool original){
    return SingleChildScrollView(
      child: original == true ? 
      Container(
        alignment: Alignment.center,
        child: Text(data,
        style: GoogleFonts.montserrat(
              fontSize: 20,
              fontWeight: FontWeight.w700),
        )
        )
        : Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:<Widget> [
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 20,
              fontWeight: FontWeight.w700),
            ),
          Text(
            data,
            style: GoogleFonts.montserrat(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color:Colors.white),
            ),
          InkWell(
            onTap: () => copy(data),
            child: Icon(Icons.content_copy)
            )
        ],
        )
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      body:ListView(
        children:<Widget> [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height/3,
            decoration: BoxDecoration(
              image: DecorationImage(image: NetworkImage("https://mybigplunge.com/wp-content/uploads/2018/04/url-shortener-theplungedaily.jpg"),
              fit:BoxFit.cover,
              ),
              color:Colors.purple[200],
              borderRadius: BorderRadius.circular(20.0)
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:<Widget> [
                  /*Text("Hello there", style: GoogleFonts.montserrat(
                    fontSize: 20.0,
                    color:Colors.white,
                  ),),*/
                  SizedBox(height:20.0),
                  Container(
                    width:MediaQuery.of(context).size.width,
                    height:50,
                    margin: EdgeInsets.only(left:40.0,right:40.0),
                    child:TextField(
                      controller: urlcontroller,
                      decoration: InputDecoration(
                        filled:true,
                        fillColor: Colors.grey[200],
                        prefixIcon: Icon(Icons.search),
                        labelText: "Enter the URL",
                        labelStyle: GoogleFonts.montserrat(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                        border:OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        )
                      ),
                    )
                  )
                ],
                )
              ),
          ),
          SizedBox(height:10),
           Container(
             width: MediaQuery.of(context).size.width/2,
             child: RaisedButton(
              color: Colors.lightBlue,
              child:Center(
                child:Text("Shorten now"  ,
                style:GoogleFonts.montserrat(
                  fontWeight: FontWeight.w800,
                  fontSize: 17.0)
                )
                ),
                onPressed: ()=>getdata(),
              ),
           ),
          SizedBox(height:40),
          Container(
            width:MediaQuery.of(context).size.width,
            height:MediaQuery.of(context).size.height/2,
            decoration: BoxDecoration(color:Colors.amberAccent),
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                buildrow("Short Link", shortLink,false),
                SizedBox(height:20),
                buildrow("Full Short Link", fullShortLink,false),
                SizedBox(height:20),
                buildrow("Short Link-2", shortLink2,false),
                SizedBox(height:20),
                buildrow("Full Short Link-2", fullShortLink2,false),
                SizedBox(height:20),
                buildrow("Share Link", shareLink,false),
                SizedBox(height:20),
                buildrow("Original", original,true),
              ]
            )
          )
        ],
      )
    );
  }
}