import 'package:chat_app/components/materialApp/app_drawer.dart';
import 'package:chat_app/components/generals/app_text.dart';
import 'package:chat_app/styles/theme_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectedRegionalProvider extends ChangeNotifier {

  String _selectedRegional = "Select Regional";

  String get selectedRegional => _selectedRegional;

  set selectedRegional(String value) {
    _selectedRegional = value;
    notifyListeners(); // Notifica a los oyentes (widgets) que el valor ha cambiado
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SelectedRegionalProvider(),
      child: const _SettingsPage(),
    );
  }
}

class _SettingsPage extends StatefulWidget {
  const _SettingsPage();

  @override
  __SettingsPageState createState() => __SettingsPageState();
}

class __SettingsPageState extends State<_SettingsPage> {

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }
    List regionalsList = [];
    List<Widget> regionalsWidgetList = [];
    
    Future<String?> getCurrentRegional() async{
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var string = prefs.getString("currentRegional");
      currentRegional = string;
      print(currentRegional);
      return currentRegional;
    }
    setCurrentRegional(String regional) async{
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("currentRegional", regional);
    }

    String? currentRegional = "Select Regional";



    setRegionalsWidgets(){
      for(int i=0; i<regionalsList.length; i++){
        regionalsWidgetList.add(
          Center(child: AppText(text: regionalsList[i]["name"], fontSize: 20, textColor: TextColor.red,))
        );
      }
    }

     getRegionalsList() async {
    var data = await FirebaseFirestore.instance
        .collection("scouts")
        .get();

    setState(() {
      regionalsList = data.docs;
      
      // Ordena los documentos por el campo "match" convertido a entero
      for (int i = 0; i < regionalsList.length; i++) {
        print(regionalsList[i]["name"]);
      }
    });
    setRegionalsWidgets();
  }

    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRegionalsList();
    getCurrentRegional();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<SelectedRegionalProvider>(context, listen: false);

    return Scaffold(
        drawer: const AppDrawer(),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 50,
          foregroundColor: Theme.of(context).colorScheme.primary,
          title: const Text("Settings"),
        ),
        body: Column(children: [
          CupertinoFormSection(
            children: [
              CupertinoFormRow(
                  child: SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Select Regional"),
                    GestureDetector(
                        onTap: () => showCupertinoModalPopup(
                            context: context,
                            builder: (_) => SizedBox(
                                  width: double.infinity,
                                  height: 250,
                                  child: CupertinoPicker(
                                      itemExtent: 35,
                                      onSelectedItemChanged:
                                          (value) {
                                            
                                            setState(()  {
                                              setCurrentRegional(regionalsList[value]["name"]);
                                              getCurrentRegional();
                                              //currentRegional = regionalsList[value]["name"];
                                              //selectedRegionalProvider.selectedRegional =
                                              //regionalsList[value]["name"];
                                            });
                                            //print(getCurrentRegional());
                                            //print("provider" + selectedRegionalProvider.selectedRegional);
                                            
                                          },
                                      children: regionalsWidgetList),
                                )),
                        child: Text(
                          currentRegional!,
                          style: const TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
              )),
              CupertinoFormRow(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Dark Mode"),
                  CupertinoSwitch(
                    activeColor: Colors.red,
                    trackColor: Colors.blue,
                    value: Provider.of<ThemeProvider>(context).isDarkMode,
                    onChanged: (value) {
                      Provider.of<ThemeProvider>(context, listen: false)
                          .toggleTheme();
                    },
                  ),
                ],
              ))
            ],
          ),
          const SizedBox(
            height: 10,
          ),
        ]));
  }
}

  