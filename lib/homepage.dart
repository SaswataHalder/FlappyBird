import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import 'package:flappybird/barrier.dart';
import 'package:flappybird/bird.dart';
import 'package:flutter/material.dart';
import 'dart:core';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  static double birdYaxis=0;
  double time=0;
  double height=0;
  double initialHeight=birdYaxis;
  bool gameHasStarted=false;
  static double barrierXone=2;
  double barrierXtwo=barrierXone+2;
  static int score=0;
  int bestScore=score;
  List<double> arr = [200.0,150.0];
  bool _enabled=true;


  void jump(){    
      setState(() {
        time=0;
        initialHeight=birdYaxis;
      });
  }

  addIntToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('intValue', bestScore);
  }
  // getIntValuesSF() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   //Return int
  //   int test= prefs.getInt('intValue') ?? 0;
  //   return test;
  // }

  void startGame(){
    gameHasStarted =true;    
    Timer.periodic(Duration(milliseconds: 60), (timer){
      time +=0.05;
      height= -4.9 *time*time + 2*time;
      
      setState(() {
        birdYaxis=initialHeight-height;
        if(barrierXone<-2){
          barrierXone+=3.5;
        }else{
          barrierXone -=0.05;
        }
        if(barrierXtwo<-2){
          barrierXtwo+=3.5;
        }else{
          barrierXtwo -=0.05;
        }
        print('barrierXone=$barrierXone barrierXtwo=$barrierXtwo birdYaxis=${birdYaxis*335}');
        if((barrierXone<-0.23 && barrierXone>-0.28) || (barrierXtwo<-0.23 && barrierXtwo>-0.28)){
          score++;
        }
      });
      if (birdYaxis>1 || birdYaxis<-1 || (barrierXone.abs()<0.25 && ((birdYaxis*335.0)<-135.0 || (birdYaxis*335.0)>150.0)) ||(barrierXtwo.abs()<0.25 && ((birdYaxis*335.0)<-75.0 || (birdYaxis*335.0)>200.0))){
        timer.cancel();        
        bestScore= score>bestScore?score:bestScore;
        //addIntToSF();
        gameHasStarted=false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(gameHasStarted){
          jump();
        }else{
          if(!_enabled){
            print('enabled $_enabled');
            for(int i=0;i<500;i++){print('$i');}
            _enabled=true;
            // double t=0;
            // Timer.periodic(Duration(seconds: 1), (timer){
            //   t+=0.01;
            //   setState(() {
            //     print('enabled $_enabled');
            //     _enabled=true;
            //   });
            // });
          }else{            
            time=0;
            height=0;
            birdYaxis=0;
            initialHeight=birdYaxis;
            score=0;
            barrierXone=2;
            barrierXtwo=barrierXone+2;
            _enabled=false;
            startGame();
          }          
        }
      },      
      child: Scaffold(
        body: Column(        
          children: [
            Expanded(
              flex: 2,
              child: Stack(
                children: [                
                    AnimatedContainer(
                      alignment: Alignment(0,birdYaxis),              
                      duration: Duration(milliseconds: 0),
                      color: Colors.blue[300],
                      child: MyBird(),
                    ),
                  Container(
                    alignment: Alignment(0,-0.3),
                    child: gameHasStarted
                      ?Text("")
                      :Text("T A P  T O  P L A Y", style: TextStyle(color: Colors.white, fontSize: 20),),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrierXone,1.1),
                    duration: Duration(milliseconds: 0),
                    child: MyBarrier(
                      size: arr[0],
                    ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrierXone,-1.1),
                    duration: Duration(milliseconds: 0),
                    child: MyBarrier(
                      size: 400.0-arr[0],
                    ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrierXtwo,1.1),
                    duration: Duration(milliseconds: 0),
                    child: MyBarrier(
                      size: arr[1],
                    ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrierXtwo,-1.1),
                    duration: Duration(milliseconds: 0),
                    child: MyBarrier(
                      size: 400.0-arr[1],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 15,
              color: Colors.lightGreen,
            ),
            Expanded(
              child: Container(
                color: Colors.brown[900],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Score", style: TextStyle(color: Colors.white, fontSize: 20),),
                        SizedBox(
                          height: 20,
                        ),
                        Text(score.toString(), style: TextStyle(color: Colors.white, fontSize: 35),),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Best", style: TextStyle(color: Colors.white, fontSize: 20),),
                        SizedBox(
                          height: 20,
                        ),
                        Text(bestScore.toString(), style: TextStyle(color: Colors.white, fontSize: 35),),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
    ),
    );
  }
}
