import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'custom_search_delegate.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quran App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List _data = [];
  final PageController _pageController = PageController();

  Future<void> readDataFromJson() async {
    final String response =
        await rootBundle.loadString('assets/hafs_smart_v8.json');
    final i = await json.decode(response);
    setState(() {
      _data = i["sura"];
    });
  }

  @override
  void initState() {
    readDataFromJson();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          centerTitle: true,
          backgroundColor: const Color(0xffffffff),
          title: const Text(
            'القرآن الكريم',
            style: TextStyle(color: Color(0xff000000)),
          ),
          iconTheme: const IconThemeData(color: Color(0xff000000)),
          actions: [
            IconButton(
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: CustomSearchDelegate(items: _data),
                );
              },
              icon: Icon(Icons.search),
            ),
          ],
        ),
        backgroundColor: const Color(0xffffffff),
        body: PageView.builder(
          controller: _pageController,
          reverse: true,
          itemBuilder: (BuildContext context, int index) {
            if (_data.isNotEmpty) {
              String byPage = '';
              String surahName = '';
              int jozzNum = 0;
              bool isBasmalahShown = false;

              for (Map ayahData in _data) {
                if (ayahData['page'] == index + 1) {
                  byPage = byPage + ' ${ayahData['aya_text']}';
                }
              }

              for (Map ayahData in _data) {
                if (ayahData['page'] == index + 1) {
                  surahName = ayahData['sura_name_ar'];
                }
              }

              for (Map ayahData in _data) {
                if (ayahData['page'] == index + 1) {
                  jozzNum = ayahData['jozz'];
                }
              }

              for (Map ayahData in _data) {
                if (ayahData['page'] == index + 1) {
                  if (ayahData['aya_no'] == 1 &&
                      ayahData['sura_name_ar'] != 'الفَاتِحة' &&
                      ayahData['sura_name_ar'] != 'التوبَة') {
                    isBasmalahShown = true;
                    break;
                  }
                }
              }

              return SafeArea(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'الجزء $jozzNum',
                                    style: const TextStyle(
                                        fontFamily: 'Kitab', fontSize: 20),
                                    textAlign: TextAlign.center,
                                    textDirection: TextDirection.rtl,
                                  ),
                                  Text(
                                    surahName,
                                    style: const TextStyle(
                                        fontFamily: 'Kitab', fontSize: 20),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                isBasmalahShown
                                    ? const Text(
                                        "‏ ‏‏ ‏‏‏‏ ‏‏‏‏‏‏ ‏",
                                        textDirection: TextDirection.rtl,
                                        style: TextStyle(
                                            fontFamily: 'Hafs', fontSize: 22),
                                        textAlign: TextAlign.center,
                                      )
                                    : Container(),
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  byPage,
                                  textDirection: TextDirection.rtl,
                                  style: const TextStyle(
                                      fontFamily: 'Hafs', fontSize: 22),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          Align(
                              alignment: Alignment.bottomCenter,
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                    fontFamily: 'Kitab', fontSize: 18),
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return const Center(
                  child: CircularProgressIndicator(
                backgroundColor: Color(0xffffffff),
              ));
            }
          },
        ),
      ),
    );
  }
}
