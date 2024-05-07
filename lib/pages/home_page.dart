import 'package:carousel_slider/carousel_slider.dart';
import 'package:chat_app/components/generals/app_text.dart';
import 'package:chat_app/components/materialApp/app_drawer.dart';
import 'package:chat_app/components/visualization/line_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            // leading: Icon(Icons.home, color: Theme.of(context).colorScheme.inversePrimary,),
            title: const AppText(
              text: "H O M E",
              textColor: TextColor.red,
            ),
            expandedHeight: 250,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                  decoration: const BoxDecoration(
                      gradient:
                          LinearGradient(begin: Alignment.topLeft, colors: [
                    Color.fromARGB(255, 83, 14, 14),
                    Color.fromARGB(255, 212, 35, 50),
                  ])),
                  //color: Theme.of(context).colorScheme.inversePrimary,
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.125,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 0.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/images/futureB.png", height: 150,)
                          /*AppText(text: "WIRING THE", fontSize: 65),
                          SizedBox(height: 0,),
                          AppText(text: "FUTURE", fontSize: 80,),*/

                        ],)
                      )
                    ],
                  )),
            ),
          ),
          
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  height: 100,
                  //width: 100, // Utiliza el ancho máximo disponible
                  child: const Center(
                      child: AppText(
                    text: " B E L I E V E !!",
                    textColor: TextColor.red,
                    fontSize: 52,
                  )),
                ),
              ),
            ),
          ),
          
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: CircularProgressIndicator.adaptive(),
                      height: 100,
                      width: 100,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                    Container(
                      child: CircularProgressIndicator.adaptive(),
                      height: 100,
                      width: 100,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                    Container(
                      child: CircularProgressIndicator.adaptive(),
                      height: 100,
                      width: 100,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: CarouselSlider.builder(
                    itemCount: 4,
                    itemBuilder: (context, index, realIx) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          height: 200,
                          width: 200,
                          color: Theme.of(context).colorScheme.inversePrimary,
                          child: MyLineChart(
                            showTitles: false,
                            maxXSum: 2.2,
                            minX: -0.2,
                            maxHeight: 10,
                            // Ajusta los spots del gráfico según tus necesidades
                            spots: const [
                              FlSpot(0, 0),
                              FlSpot(2, 6),
                              FlSpot(5, 5)
                            ],
                          ),
                        ),
                      );
                    },
                    options: CarouselOptions(height: 100, autoPlay: true, autoPlayInterval: Duration(seconds: 3)))),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  height: 200,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  height: 200,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
