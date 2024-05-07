import 'package:chat_app/components/generals/app_text.dart';
import 'package:flutter/material.dart';

class AppCounter extends StatefulWidget {
  final String counterTitle;
  final double width;
  final TextEditingController? controller;
  const AppCounter({super.key, this.counterTitle = "", this.width = 300, this.controller});

  @override
  State<AppCounter> createState() => _AppCounterState();
}

class _AppCounterState extends State<AppCounter> {
  int counter = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppText(text: widget.counterTitle, textColor: TextColor.red, fontSize: 20,),
          Container(
            //height: 80,
            width: 200,
            //padding: EdgeInsets.symmetric(),
            margin: EdgeInsets.all(0),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: Theme.of(context).colorScheme.inversePrimary),
                        //height: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(onTap: () {
                              setState(() {
                                if(counter > 0){
                                  counter -= 1;
                              widget.controller?.text = counter.toString();
                              print(widget.controller?.text);

                                }
                              });
                              }, child: AppText(text: "-", textColor: TextColor.gray, fontSize: 60,)),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            child: AppText(text: counter.toString(), fontSize: 35,),
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context).colorScheme.inversePrimary),
                          ),
                            GestureDetector(onTap: () {
                              setState(() {
                              counter += 1;
                              widget.controller?.text = counter.toString();
                              print(widget.controller?.text);
                              });
                            }, child: AppText(text: "+", textColor: TextColor.gray, fontSize: 60,)),
                        
                        ],),
                      ),
        ],
      ),
    );
  }
}