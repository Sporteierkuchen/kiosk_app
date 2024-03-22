import 'dart:convert';
import 'dart:math';
import 'dart:io' show Platform;
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../dto/Article.dart';
import '../dto/ArticleDTO.dart';
import '../dto/ArticleExtraDTO.dart';
import '../dto/CategoryDTO.dart';
import '../dto/ReceiptDTO.dart';
import '../util/LiveApiRequest.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../util/SerializerHelper.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<MainPage> with TickerProviderStateMixin {

  List<CategoryDTO> _categorylist = [];
  List<ArticleDTO> articleDTOList = [];
  late int _currentSelectedIndex;
  late List<ArticleDTO> articleList;
  late ArticleDTO? selectedArticle;

  late List<ArticleDTO> warenkorb;

  bool showArticleExtras = false;

  bool showWarenkorb = false;

  bool showBezahlen = false;
  bool bezahlungFertig = false;

  late AnimationController animationcontroller;
  double progress = 1.0;

  bool loadedData = false;

  @override
  void initState() {
    super.initState();
    print("App Start! init state");

    loadData().whenComplete(() => setState(()  {


      for (CategoryDTO categoryDTO in _categorylist) {

        if(categoryDTO.name != null){

          if(categoryDTO.name!.trim().isNotEmpty){
            categoryDTO.icon = 'lib/images/categories/${categoryDTO.name}.jpg';
          }
          else{
            categoryDTO.icon = 'lib/images/empty.jpg';
          }

        }
        else{

          categoryDTO.icon = 'lib/images/empty.jpg';

        }

      }

      print(articleDTOList.length);

      articleList = [];

      selectedArticle = null;

      warenkorb = [];


      animationcontroller = AnimationController(
        value: 5,
        vsync: this,
        duration: const Duration(seconds: 6),
      );

      animationcontroller.addListener(() {
        notify();

        if (animationcontroller.isAnimating) {
          setState(() {

            progress = animationcontroller.value;
          });
        }
      });

      _currentSelectedIndex = 0;


      loadedData = true;

    }));

  }

  @override
  void dispose() {
    animationcontroller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    if (loadedData) {

      getItems();

      return Scaffold(
        body: SafeArea(
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  color: Colors.transparent,
                  child: Image.asset(
                    "lib/images/startimage.jpg",
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    color: Colors.white,
                    child:

                    showBezahlen ?
                    Container(color: Colors.transparent,
                      alignment: AlignmentDirectional.center,
                      child:

                      bezahlungFertig ?

                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.green,
                                radius: 20,
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: Icon(Icons.done),
                                  color: Colors.white,
                                  onPressed: () {},
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text("Bestellung erfolgreich bezahlt!",
                                  softWrap: true,
                                  style: TextStyle(
                                    height: 0,
                                    fontWeight:
                                    FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: Platform.isAndroid ? 20 : 30,
                                  ),

                                ),
                              )


                            ],),

                          SizedBox(height: Platform.isAndroid ? 10 : 20,),

                          ElevatedButton(
                            onPressed: () {

                              setState(() {

                                bezahlungFertig = false;
                                showBezahlen = false;
                                showWarenkorb = false;
                                showArticleExtras = false;

                                warenkorb.clear();
                                _currentSelectedIndex = 0;
                                selectedArticle = null;

                              });


                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.green[300],
                              side: const BorderSide(
                                  color: Colors.black, width: 1),
                              padding:
                              EdgeInsets.symmetric(
                                  horizontal: Platform
                                      .isAndroid
                                      ? 20
                                      : 40,
                                  vertical: Platform
                                      .isAndroid
                                      ? 10
                                      : 25),

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              // Text Color (Foreground color)
                            ),
                            child: Text(
                              'OK',
                              style: TextStyle(
                                  fontSize:
                                  Platform.isAndroid ? 14 : 25,
                                  height: 0),
                            ),
                          )

                        ],)


                          :

                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Stack(
                            alignment: Alignment.center,
                            children: [

                              SizedBox(
                                width: Platform.isAndroid ? 150 : 200,
                                height: Platform.isAndroid ? 150 : 200,
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.grey.shade300,
                                  color: Colors.greenAccent,
                                  value: progress,
                                  strokeWidth: Platform.isAndroid ? 10 : 20,
                                ),
                              ),

                              AnimatedBuilder(
                                animation: animationcontroller,
                                builder: (context, child) => Text(
                                  countText,
                                  style:  TextStyle(
                                    color: Colors.black,
                                    fontSize: Platform.isAndroid ? 60 : 100 ,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          Padding(
                            padding: EdgeInsets.all(Platform.isAndroid ? 20 : 40),
                            child:

                            Text("Bestellung wird bezahlt...",
                              softWrap: true,
                              style: TextStyle(
                                height: 0,
                                fontWeight:
                                FontWeight.bold,
                                color: Colors.black,
                                fontSize: Platform.isAndroid ? 20 : 30,
                              ),

                            ),
                          )

                        ],
                      ),

                    )
                        :
                    showWarenkorb
                        ? Container(
                      color: Colors.transparent,
                      //padding: const EdgeInsets.only(right: 8),
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: warenkorb.length,
                          itemBuilder: (context, index) {
                            return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    width: Platform.isAndroid ? 1 : 3,
                                    color: Colors.black26,
                                  ),
                                  color: Colors.transparent,
                                ),
                                margin: EdgeInsets.symmetric(
                                    vertical: Platform.isAndroid ? 5 : 15),
                                padding: EdgeInsets.symmetric(
                                    vertical: Platform.isAndroid ? 10 : 20,
                                    horizontal: Platform.isAndroid ? 10 : 20),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        color: Colors.transparent,
                                        child: Image.memory(
                                            base64Decode(warenkorb[index].icon!),
                                          fit: BoxFit.cover,
                                          // width: Platform.isAndroid
                                          //     ? MediaQuery.of(context)
                                          //             .size
                                          //             .height *
                                          //         0.08
                                          //     : MediaQuery.of(context)
                                          //             .size
                                          //             .height *
                                          //         0.1,
                                          // height: Platform.isAndroid
                                          //     ? MediaQuery.of(context)
                                          //             .size
                                          //             .height *
                                          //         0.12
                                          //     : MediaQuery.of(context)
                                          //             .size
                                          //             .height *
                                          //         0.3,
                                        ),

                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        color: Colors.transparent,
                                        padding: EdgeInsets.only(
                                            left: Platform.isAndroid ? 10 : 20),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              color: Colors.transparent,
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          warenkorb[index].title!,
                                                          softWrap: true,
                                                        //  maxLines: 1,
                                                          style: TextStyle(
                                                            height: 0,
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            color: Colors.black,
                                                            fontSize: Platform
                                                                .isAndroid
                                                                ? 26
                                                                : 40,
                                                          ),
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          showDialog(
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return AlertDialog(
                                                                    backgroundColor:
                                                                    Colors.grey[
                                                                    300],
                                                                    title: Text(
                                                                      "Bitte bestätigen!",
                                                                      textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                      style:
                                                                      TextStyle(
                                                                        height:
                                                                        0,
                                                                        fontWeight:
                                                                        FontWeight.bold,
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize: Platform.isAndroid
                                                                            ? 25
                                                                            : 30,
                                                                      ),
                                                                    ),
                                                                    content:
                                                                    Text(
                                                                      "Soll der Artikel wirklich entfernt werden?",
                                                                      textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                      style:
                                                                      TextStyle(
                                                                        height:
                                                                        0,
                                                                        fontWeight:
                                                                        FontWeight.normal,
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize: Platform.isAndroid
                                                                            ? 20
                                                                            : 25,
                                                                      ),
                                                                    ),
                                                                    contentPadding: EdgeInsets.symmetric(
                                                                        horizontal: Platform.isAndroid
                                                                            ? MediaQuery.of(context).size.width *
                                                                            0
                                                                            : MediaQuery.of(context).size.width *
                                                                            0.15,
                                                                        vertical: Platform.isAndroid
                                                                            ? MediaQuery.of(context).size.height *
                                                                            0.05
                                                                            : MediaQuery.of(context).size.height *
                                                                            0.1),
                                                                    alignment:
                                                                    AlignmentDirectional
                                                                        .center,
                                                                    actions: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                        MainAxisAlignment.spaceEvenly,
                                                                        children: [
                                                                          MaterialButton(
                                                                            color:
                                                                            Colors.grey[400],
                                                                            shape:
                                                                            RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(5.0),
                                                                              side: const BorderSide(color: Colors.black, width: 1),
                                                                            ),
                                                                            padding:
                                                                            EdgeInsets.symmetric(horizontal: Platform.isAndroid ? 10 : 20, vertical: Platform.isAndroid ? 10 : 20),
                                                                            minWidth: Platform.isAndroid
                                                                                ? MediaQuery.of(context).size.width * 0.2
                                                                                : MediaQuery.of(context).size.width * 0.15,
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.pop(context);

                                                                              setState(() {
                                                                                if (warenkorb.length == 1) {
                                                                                  showWarenkorb = false;
                                                                                }
                                                                                warenkorb.removeAt(index);
                                                                              });
                                                                            },
                                                                            child:
                                                                            Text(
                                                                              'Ja',
                                                                              textAlign: TextAlign.center,
                                                                              style: TextStyle(
                                                                                height: 0,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.black,
                                                                                fontSize: Platform.isAndroid ? 18 : 25,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          MaterialButton(
                                                                            color:
                                                                            Colors.grey[400],
                                                                            shape:
                                                                            RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(5.0),
                                                                              side: const BorderSide(color: Colors.black, width: 1),
                                                                            ),
                                                                            padding:
                                                                            EdgeInsets.symmetric(horizontal: Platform.isAndroid ? 10 : 20, vertical: Platform.isAndroid ? 10 : 20),
                                                                            minWidth: Platform.isAndroid
                                                                                ? MediaQuery.of(context).size.width * 0.2
                                                                                : MediaQuery.of(context).size.width * 0.15,
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.pop(context);
                                                                            },
                                                                            child:
                                                                            Text(
                                                                              'Nein',
                                                                              textAlign: TextAlign.center,
                                                                              style: TextStyle(
                                                                                height: 0,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.black,
                                                                                fontSize: Platform.isAndroid ? 18 : 25,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ), // MaterialButton

                                                                      // MaterialButton
                                                                    ]);
                                                              });
                                                        },
                                                        child: Icon(
                                                          Icons.delete,
                                                          color: Colors.grey,
                                                          size:
                                                          Platform.isAndroid
                                                              ? 30
                                                              : 40,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        top: Platform.isAndroid
                                                            ? 0
                                                            : 10),
                                                    child: Text(
                                                      "${formatCurrency(roundDouble(warenkorb[index].priceGross!, 2))}€",
                                                      softWrap: true,
                                                      //maxLines: 1,
                                                      style: TextStyle(
                                                        height: 0,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        color: Colors.black,
                                                        fontSize:
                                                        Platform.isAndroid
                                                            ? 20
                                                            : 25,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            SizedBox(
                                              height:
                                              Platform.isAndroid ? 15 : 30,
                                            ),

                                            ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                const NeverScrollableScrollPhysics(),
                                                itemCount: warenkorb[index]
                                                    .extraslist!
                                                    .length,
                                                itemBuilder: (context, index2) {
                                                  ArticleExtraDTO extra =
                                                  warenkorb[index]
                                                      .extraslist![index2];

                                                  return Container(
                                                      color: Colors.transparent,
                                                      margin:
                                                      EdgeInsets.symmetric(
                                                          vertical: Platform
                                                              .isAndroid
                                                              ? 10
                                                              : 25),
                                                      child: Container(
                                                        //margin: EdgeInsets.symmetric(horizontal: 300),
                                                        //   color: Colors.cyan,
                                                        child: Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                            children: [
                                                              GestureDetector(
                                                                onTap: () {
                                                                  setState(() {
                                                                    extra
                                                                        .increase();
                                                                  });
                                                                },
                                                                child:
                                                                Container(
                                                                  //color: Colors.blue,
                                                                  margin: const EdgeInsets
                                                                      .only(
                                                                      left: 0,
                                                                      right: 10,
                                                                      top: 0,
                                                                      bottom:
                                                                      0),
                                                                  child:
                                                                  Container(
                                                                    padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        5),
                                                                    decoration:
                                                                    BoxDecoration(
                                                                      borderRadius:
                                                                      BorderRadius.circular(
                                                                          5),
                                                                      color: Colors
                                                                          .green,
                                                                    ),
                                                                    child: Icon(
                                                                      Icons.add,
                                                                      size: Platform
                                                                          .isAndroid
                                                                          ? 25
                                                                          : 40,
                                                                      weight:
                                                                      0.1,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                //color: Colors.blue,
                                                                margin:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 0,
                                                                    right:
                                                                    10,
                                                                    top: 0,
                                                                    bottom:
                                                                    0),
                                                                child:
                                                                Container(
                                                                  padding: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                      Platform.isAndroid
                                                                          ? 15
                                                                          : 25,
                                                                      vertical:
                                                                      5),
                                                                  decoration:
                                                                  BoxDecoration(
                                                                    borderRadius:
                                                                    BorderRadius
                                                                        .circular(5),
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .grey),
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                  child: Text(
                                                                    "${extra.amount}",
                                                                    softWrap:
                                                                    true,
                                                                    maxLines: 1,
                                                                    style:
                                                                    TextStyle(
                                                                      height: 0,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize: Platform
                                                                          .isAndroid
                                                                          ? 25
                                                                          : 30,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  if (extra
                                                                      .amount >
                                                                      1) {
                                                                    setState(
                                                                            () {
                                                                          extra
                                                                              .decrease();
                                                                        });
                                                                  } else {
                                                                    showDialog(
                                                                        context:
                                                                        context,
                                                                        builder:
                                                                            (context) {
                                                                          return AlertDialog(
                                                                              backgroundColor: Colors.grey[300],
                                                                              title: Text(
                                                                                "Bitte bestätigen!",
                                                                                textAlign: TextAlign.center,
                                                                                style: TextStyle(
                                                                                  height: 0,
                                                                                  fontWeight: FontWeight.bold,
                                                                                  color: Colors.black,
                                                                                  fontSize: Platform.isAndroid ? 25 : 30,
                                                                                ),
                                                                              ),
                                                                              content: Text(
                                                                                "Soll der Artikel wirklich entfernt werden?",
                                                                                textAlign: TextAlign.center,
                                                                                style: TextStyle(
                                                                                  height: 0,
                                                                                  fontWeight: FontWeight.normal,
                                                                                  color: Colors.black,
                                                                                  fontSize: Platform.isAndroid ? 20 : 25,
                                                                                ),
                                                                              ),
                                                                              contentPadding: EdgeInsets.symmetric(horizontal: Platform.isAndroid ? MediaQuery.of(context).size.width * 0 : MediaQuery.of(context).size.width * 0.15, vertical: Platform.isAndroid ? MediaQuery.of(context).size.height * 0.05 : MediaQuery.of(context).size.height * 0.1),
                                                                              alignment: AlignmentDirectional.center,
                                                                              actions: [
                                                                                Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                  children: [
                                                                                    MaterialButton(
                                                                                      color: Colors.grey[400],
                                                                                      shape: RoundedRectangleBorder(
                                                                                        borderRadius: BorderRadius.circular(5.0),
                                                                                        side: const BorderSide(color: Colors.black, width: 1),
                                                                                      ),
                                                                                      padding: EdgeInsets.symmetric(horizontal: Platform.isAndroid ? 10 : 20, vertical: Platform.isAndroid ? 10 : 20),
                                                                                      minWidth: Platform.isAndroid ? MediaQuery.of(context).size.width * 0.2 : MediaQuery.of(context).size.width * 0.15,
                                                                                      onPressed: () {
                                                                                        Navigator.pop(context);

                                                                                        setState(() {
                                                                                          warenkorb[index].extraslist!.removeAt(index2);
                                                                                        });
                                                                                      },
                                                                                      child: Text(
                                                                                        'Ja',
                                                                                        textAlign: TextAlign.center,
                                                                                        style: TextStyle(
                                                                                          height: 0,
                                                                                          fontWeight: FontWeight.bold,
                                                                                          color: Colors.black,
                                                                                          fontSize: Platform.isAndroid ? 18 : 25,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    MaterialButton(
                                                                                      color: Colors.grey[400],
                                                                                      shape: RoundedRectangleBorder(
                                                                                        borderRadius: BorderRadius.circular(5.0),
                                                                                        side: const BorderSide(color: Colors.black, width: 1),
                                                                                      ),
                                                                                      padding: EdgeInsets.symmetric(horizontal: Platform.isAndroid ? 10 : 20, vertical: Platform.isAndroid ? 10 : 20),
                                                                                      minWidth: Platform.isAndroid ? MediaQuery.of(context).size.width * 0.2 : MediaQuery.of(context).size.width * 0.15,
                                                                                      onPressed: () {
                                                                                        Navigator.pop(context);
                                                                                      },
                                                                                      child: Text(
                                                                                        'Nein',
                                                                                        textAlign: TextAlign.center,
                                                                                        style: TextStyle(
                                                                                          height: 0,
                                                                                          fontWeight: FontWeight.bold,
                                                                                          color: Colors.black,
                                                                                          fontSize: Platform.isAndroid ? 18 : 25,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ), // MaterialButton

                                                                                // MaterialButton
                                                                              ]);
                                                                        });
                                                                  }
                                                                },
                                                                child:
                                                                Container(
                                                                  //color: Colors.blue,
                                                                  margin: const EdgeInsets
                                                                      .only(
                                                                      left: 0,
                                                                      right: 0,
                                                                      top: 0,
                                                                      bottom:
                                                                      0),
                                                                  child:
                                                                  Container(
                                                                    padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        5),
                                                                    decoration:
                                                                    BoxDecoration(
                                                                      borderRadius:
                                                                      BorderRadius.circular(
                                                                          5),
                                                                      color: extra.amount ==
                                                                          0
                                                                          ? Colors.red[
                                                                      100]
                                                                          : Colors
                                                                          .red[300],
                                                                    ),
                                                                    child: Icon(
                                                                      Icons
                                                                          .remove,
                                                                      size: Platform
                                                                          .isAndroid
                                                                          ? 25
                                                                          : 40,
                                                                      weight:
                                                                      0.1,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child:
                                                                Container(
                                                                  color: Colors
                                                                      .transparent,
                                                                  padding: EdgeInsets.only(
                                                                      left: Platform
                                                                          .isAndroid
                                                                          ? 15
                                                                          : 20),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                    children: [
                                                                      Text(
                                                                        extra.name!,
                                                                        style:
                                                                        TextStyle(
                                                                          height:
                                                                          0,
                                                                          fontWeight:
                                                                          FontWeight.bold,
                                                                          color:
                                                                          Colors.black,
                                                                          fontSize: Platform.isAndroid
                                                                              ? 18
                                                                              : 25,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        "${formatCurrency(roundDouble(extra.price!, 2))}€",
                                                                        style:
                                                                        const TextStyle(
                                                                          height:
                                                                          0,
                                                                          fontWeight:
                                                                          FontWeight.normal,
                                                                          color:
                                                                          Colors.black,
                                                                          fontSize:
                                                                          15,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              )
                                                            ]),
                                                      ));
                                                }),

                                            const SizedBox(
                                              height: 10,
                                            ),

                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.end,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 10),
                                                  child: Text(
                                                    "Gesamtpreis Artikel: ${formatCurrency(roundDouble(getPreisArticle(warenkorb[index]), 2))}€",
                                                    softWrap: true,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      height: 0,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: Colors.black,
                                                      fontSize:
                                                      Platform.isAndroid
                                                          ? 15
                                                          : 25,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),

                                            //njujkhljhi
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ));
                          }),
                    )
                        : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            color: Colors.transparent,
                            padding: const EdgeInsets.only(right: 8),
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: _categorylist.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      print(
                                          "Ausgewählte Kategorie: ${_categorylist[index].name}");

                                      setState(() {
                                        _currentSelectedIndex = index;
                                        selectedArticle = null;
                                        showArticleExtras = false;
                                      });
                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(10),
                                          color: index == _currentSelectedIndex
                                              ? Colors.grey[350]
                                              : Colors.white,
                                        ),
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 1),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical:
                                              Platform.isAndroid ? 10 : 35,
                                              horizontal: 2),
                                          child: Column(
                                            children: [
                                              Image.asset(
                                                _categorylist[index].icon.toString(),
                                                fit: BoxFit.cover,
                                                // width:  MediaQuery.of(context).size.width *0.1,
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                    0.1,
                                              ),
                                              Padding(
                                                padding:
                                                const EdgeInsets.all(2.0),
                                                child: Text(
                                                    _categorylist[index].name.toString(),
                                                    softWrap: true,
                                                    style: TextStyle(
                                                        height: 0,
                                                        fontWeight: index ==
                                                            _currentSelectedIndex
                                                            ? FontWeight.bold
                                                            : FontWeight.normal,
                                                        fontSize: 14),
                                                    textAlign:
                                                    TextAlign.center),
                                              )
                                            ],
                                          ),
                                        )),
                                  );
                                }),
                          ),
                        ),
                        const VerticalDivider(
                          color: Colors.grey,
                          thickness: 3,
                          width: 0,
                        ),
                        Expanded(
                            flex: Platform.isAndroid ? 3 : 4,
                            child: Container(
                                color: Colors.transparent,
                                padding: EdgeInsets.only(
                                    left: 8, top: Platform.isAndroid ? 8 : 30),
                                child: showArticleExtras
                                    ? Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 0,
                                          bottom: Platform.isAndroid
                                              ? 10
                                              : 50),
                                      child: Row(
                                   
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: [


                                          Expanded(
                                            flex:4,
                                            child:
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal:
                                                      Platform.isAndroid
                                                          ? 10
                                                          : 30),
                                                  child:

                                                  Image.memory(
                                                    base64Decode(selectedArticle!.icon!),
                                                    // selectedArticle!.icon!,
                                                    fit: BoxFit.cover,
                                                    width: Platform.isAndroid
                                                        ? MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                        0.1
                                                        : MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                        0.1,
                                                    height: Platform.isAndroid
                                                        ? MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                        0.1
                                                        : MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                        0.1,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          
                                          Expanded(
                                            flex: 6,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [

                                                Text(
                                                  selectedArticle!.title!,
                                                  softWrap: true,
                                                  //maxLines: 1,
                                                  style: TextStyle(
                                                    height: 0,
                                                    fontWeight:
                                                    FontWeight.bold,
                                                    color: Colors.black,
                                                    fontSize:
                                                    Platform.isAndroid
                                                        ? 26
                                                        : 40,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top:
                                                      Platform.isAndroid
                                                          ? 0
                                                          : 10),
                                                  child: Text(
                                                    "Preis: ${formatCurrency(roundDouble(selectedArticle!.priceGross!, 2))}€",
                                                    softWrap: true,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      height: 0,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: Colors.black,
                                                      fontSize:
                                                      Platform.isAndroid
                                                          ? 20
                                                          : 25,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: selectedArticle
                                              ?.extraslist!.length,
                                          itemBuilder: (context, index) {
                                            ArticleExtraDTO? extra =
                                            selectedArticle
                                                ?.extraslist![index];

                                            return Container(
                                              // color: Colors.redAccent,
                                                alignment:
                                                AlignmentDirectional
                                                    .center,
                                                margin:
                                                EdgeInsets.symmetric(
                                                    horizontal: Platform
                                                        .isAndroid
                                                        ? 10
                                                        : 20,
                                                    vertical: Platform
                                                        .isAndroid
                                                        ? 10
                                                        : 25),
                                                child: Container(
                                                  //margin: EdgeInsets.symmetric(horizontal: 300),
                                                  //   color: Colors.cyan,
                                                  child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .center,
                                                      mainAxisSize:
                                                      MainAxisSize
                                                          .max,
                                                      children: [
                                                        Expanded(
                                                          flex: Platform
                                                              .isAndroid
                                                              ? 2
                                                              : 1,
                                                          child:
                                                          Container(
                                                            //color: Colors.teal,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                              children: [
                                                                GestureDetector(
                                                                  onTap:
                                                                      () {
                                                                    setState(
                                                                            () {
                                                                          extra!.increase();
                                                                        });
                                                                  },
                                                                  child:
                                                                  Container(
                                                                    //color: Colors.blue,
                                                                    margin: const EdgeInsets
                                                                        .only(
                                                                        left: 0,
                                                                        right: 10,
                                                                        top: 0,
                                                                        bottom: 0),
                                                                    child:
                                                                    Container(
                                                                      padding:
                                                                      const EdgeInsets.all(5),
                                                                      decoration:
                                                                      BoxDecoration(
                                                                        borderRadius: BorderRadius.circular(5),
                                                                        color: Colors.green,
                                                                      ),
                                                                      child:
                                                                      Icon(
                                                                        Icons.add,
                                                                        size: Platform.isAndroid ? 25 : 50,
                                                                        weight: 0.1,
                                                                        color: Colors.white,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  //color: Colors.blue,
                                                                  margin: const EdgeInsets
                                                                      .only(
                                                                      left:
                                                                      0,
                                                                      right:
                                                                      10,
                                                                      top:
                                                                      0,
                                                                      bottom:
                                                                      0),
                                                                  child:
                                                                  Container(
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal: Platform.isAndroid ? 15 : 25,
                                                                        vertical: 5),
                                                                    decoration:
                                                                    BoxDecoration(
                                                                      borderRadius:
                                                                      BorderRadius.circular(5),
                                                                      border:
                                                                      Border.all(color: Colors.grey),
                                                                      color:
                                                                      Colors.white,
                                                                    ),
                                                                    child:
                                                                    Text(
                                                                      "${extra?.amount}",
                                                                      softWrap:
                                                                      true,
                                                                      maxLines:
                                                                      1,
                                                                      style:
                                                                      TextStyle(
                                                                        height: 0,
                                                                        fontWeight: FontWeight.bold,
                                                                        color: Colors.black,
                                                                        fontSize: Platform.isAndroid ? 25 : 35,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                GestureDetector(
                                                                  onTap:
                                                                      () {
                                                                    if (extra!.amount >
                                                                        0) {
                                                                      setState(() {
                                                                        extra!.decrease();
                                                                      });
                                                                    }
                                                                  },
                                                                  child:
                                                                  Container(
                                                                    //color: Colors.blue,
                                                                    margin: const EdgeInsets
                                                                        .only(
                                                                        left: 0,
                                                                        right: 0,
                                                                        top: 0,
                                                                        bottom: 0),
                                                                    child:
                                                                    Container(
                                                                      padding:
                                                                      const EdgeInsets.all(5),
                                                                      decoration:
                                                                      BoxDecoration(
                                                                        borderRadius: BorderRadius.circular(5),
                                                                        color: extra?.amount == 0 ? Colors.red[100] : Colors.red[300],
                                                                      ),
                                                                      child:
                                                                      Icon(
                                                                        Icons.remove,
                                                                        size: Platform.isAndroid ? 25 : 50,
                                                                        weight: 0.1,
                                                                        color: Colors.white,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child:
                                                          Container(
                                                            //color: Colors.purple,
                                                            child:
                                                            Container(
                                                              //color: Colors.red,
                                                              padding: EdgeInsets.only(
                                                                  left: Platform.isAndroid
                                                                      ? 15
                                                                      : 20),
                                                              child:
                                                              Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                                children: [
                                                                  Text(
                                                                    extra!
                                                                        .name!,
                                                                    style:
                                                                    TextStyle(
                                                                      height:
                                                                      0,
                                                                      fontWeight:
                                                                      FontWeight.bold,
                                                                      color:
                                                                      Colors.black,
                                                                      fontSize: Platform.isAndroid
                                                                          ? 18
                                                                          : 25,
                                                                    ),
                                                                  ),
                                                                  extra!.description!.trim().isEmpty
                                                                      ? Container()
                                                                      : Padding(
                                                                    padding: const EdgeInsets.only(bottom: 5),
                                                                    child: Text(
                                                                      extra!.description!,
                                                                      style: const TextStyle(
                                                                        height: 0,
                                                                        fontWeight: FontWeight.normal,
                                                                        color: Colors.black,
                                                                        fontSize: 15,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    "${formatCurrency(roundDouble(extra!.price!, 2))}€",
                                                                    style:
                                                                    const TextStyle(
                                                                      height:
                                                                      0,
                                                                      fontWeight:
                                                                      FontWeight.normal,
                                                                      color:
                                                                      Colors.black,
                                                                      fontSize:
                                                                      15,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      ]),
                                                ));
                                          }),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                          Platform.isAndroid ? 5 : 20,
                                          vertical: Platform.isAndroid
                                              ? 15
                                              : 40),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              print("Zurück!");
                                              setState(() {
                                                selectedArticle = null;
                                                showArticleExtras = false;
                                              });
                                            },
                                            style:
                                            ElevatedButton.styleFrom(
                                              foregroundColor:
                                              Colors.white,
                                              backgroundColor:
                                              Colors.red[300],
                                              side: const BorderSide(
                                                  color: Colors.black,
                                                  width: 1),
                                              padding:
                                              EdgeInsets.symmetric(
                                                  horizontal: Platform
                                                      .isAndroid
                                                      ? 0
                                                      : 15,
                                                  vertical: Platform
                                                      .isAndroid
                                                      ? 0
                                                      : 25),

                                              shape:
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(
                                                    10),
                                              ),
                                              // Text Color (Foreground color)
                                            ),
                                            child: Icon(
                                              Icons.arrow_back_outlined,
                                              size: Platform.isAndroid
                                                  ? 25
                                                  : 50,
                                              color: Colors.black,
                                            ),
                                          ),

                                          Column(
                                            children: [
                                              Text(
                                                "Preis:",
                                                style: TextStyle(
                                                  height: 0,
                                                  fontWeight:
                                                  FontWeight.normal,
                                                  color: Colors.black,
                                                  fontSize:
                                                  Platform.isAndroid
                                                      ? 20
                                                      : 25,
                                                ),
                                              ),
                                              Text(
                                                "${formatCurrency(roundDouble(getPreis(), 2))}€",
                                                style: TextStyle(
                                                  height: 0,
                                                  fontWeight:
                                                  FontWeight.bold,
                                                  color: Colors.black,
                                                  fontSize:
                                                  Platform.isAndroid
                                                      ? 20
                                                      : 30,
                                                ),
                                              ),
                                            ],
                                          ),

                                          // SizedBox(width: MediaQuery.of(context).size.width* 0.05),

                                          ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                List<ArticleExtraDTO>
                                                extrasList = [];

                                                for (ArticleExtraDTO extra in selectedArticle!.extraslist!) {

                                                  if (extra.amount > 0) {
                                                    extrasList.add(ArticleExtraDTO(
                                                        name: extra.name,
                                                        amount:
                                                        extra.amount,
                                                        price:
                                                        extra.price,
                                                        description: extra
                                                            .description));
                                                  }

                                                }


                                                CategoryDTO group = CategoryDTO(uid: selectedArticle!.group!.uid, name: selectedArticle!.group!.name, number: selectedArticle!.group!.number, icon: selectedArticle!.group!.icon);

                                                ArticleDTO articleDTO = ArticleDTO(

                                                  title: selectedArticle!.title,
                                                  description: selectedArticle!.description,
                                                  ingredients: selectedArticle!.ingredients,
                                                  allergens: selectedArticle!.allergens,
                                                  guid: selectedArticle!.guid,
                                                  articleNumber: selectedArticle!.articleNumber,
                                                  group: group,
                                                  priceNet: selectedArticle!.priceNet,
                                                  priceGross: selectedArticle!.priceGross,
                                                  vat: selectedArticle!.vat,
                                                  deleted: selectedArticle!.deleted,
                                                  ean: selectedArticle!.ean,
                                                  quantityUnit: selectedArticle!.quantityUnit,
                                                  icon: selectedArticle!.icon,
                                                  extraslist: extrasList

                                                );

                                                warenkorb.add(articleDTO);

                                                setState(() {
                                                  selectedArticle = null;
                                                  showArticleExtras = false;
                                                });


                                              });
                                            },
                                            style:
                                            ElevatedButton.styleFrom(
                                              foregroundColor:
                                              Colors.white,
                                              backgroundColor:
                                              Colors.green[300],
                                              side: const BorderSide(
                                                  color: Colors.black,
                                                  width: 1),
                                              padding:
                                              EdgeInsets.symmetric(
                                                  horizontal: Platform
                                                      .isAndroid
                                                      ? 5
                                                      : 15,
                                                  vertical: Platform
                                                      .isAndroid
                                                      ? 5
                                                      : 25),

                                              shape:
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(
                                                    10),
                                              ),
                                              // Text Color (Foreground color)
                                            ),
                                            child: Text(
                                              'Hinzufügen',
                                              style: TextStyle(
                                                  fontSize:
                                                  Platform.isAndroid
                                                      ? 15
                                                      : 30),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                                    : GridView.builder(
                                  gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: Platform.isAndroid ? 2 : 3),
                                  itemCount: articleList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: () {
                                        ArticleDTO articleSelected =
                                        articleList[index];
                                        print(
                                            "Ausgewählter Artikel: ${articleSelected.title}");

                                        setState(() {

                                          List<ArticleExtraDTO> extrasList = [];

                                          for (ArticleExtraDTO extra in articleSelected.extraslist!) {

                                            extrasList.add(ArticleExtraDTO(
                                                name: extra.name,
                                                amount: extra.amount,
                                                price: extra.price,
                                                description:
                                                extra.description));
                                          }

                                          CategoryDTO group = CategoryDTO(uid: articleSelected.group!.uid, name: articleSelected.group!.name, number: articleSelected.group!.number, icon: articleSelected.group!.icon);

                                          selectedArticle = ArticleDTO(

                                              title: articleSelected.title,
                                              description: articleSelected.description,
                                              ingredients: articleSelected.ingredients,
                                              allergens: articleSelected.allergens,
                                              guid: articleSelected.guid,
                                              articleNumber: articleSelected.articleNumber,
                                              group: group,
                                              priceNet: articleSelected.priceNet,
                                              priceGross: articleSelected.priceGross,
                                              vat: articleSelected.vat,
                                              deleted: articleSelected.deleted,
                                              ean: articleSelected.ean,
                                              quantityUnit: articleSelected.quantityUnit,
                                              icon: articleSelected.icon,

                                              extraslist: extrasList

                                          );

                                          showArticleExtras = true;
                                        });
                                      },
                                      child: Container(
                                          // decoration: BoxDecoration(
                                          //   borderRadius:
                                          //   BorderRadius.circular(10),
                                          //   color: Colors.white,
                                          // ),
                                          color: Colors.white,
                                          margin:
                                          const EdgeInsets.symmetric(
                                              vertical: 1,horizontal: 1),
                                          child: Padding(
                                            padding: const EdgeInsets
                                                .symmetric(
                                                vertical: 5,
                                                horizontal: 2),
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                  const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8),
                                                  child:
                                                  Image.memory(
                                                    base64Decode(articleList[index].icon!),
                                                      fit: BoxFit.cover,
                                                      // width: MediaQuery.of(context)
                                                      //     .size
                                                      //     .width *
                                                      //     0.2,

                                                      height: Platform
                                                          .isAndroid
                                                          ? MediaQuery.of(
                                                          context)
                                                          .size
                                                          .height *
                                                          0.075
                                                          : MediaQuery.of(
                                                          context)
                                                          .size
                                                          .height *
                                                          0.1

                                                  ),
                                                ),
                                                
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                    const EdgeInsets.only(top: 2),
                                                    child: Text(
                                                        articleList[index]
                                                            .title!,
                                                      // maxLines: 1,
                                                        softWrap: true,
                                                        style: const TextStyle(
                                                            height: 0,
                                                            fontWeight:
                                                            FontWeight
                                                                .normal,
                                                            fontSize: 14),
                                                        textAlign: TextAlign
                                                            .center),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )),
                                    );
                                  },
                                ))),
                      ],
                    ),
                  ),
                ),

                Container(
                    height: Platform.isAndroid ||
                        MediaQuery.of(context).size.height <= 1800
                        ? (MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top) *
                        0.25
                        : (MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top) *
                        0.2,
                    color: Colors.white,
                    child:
                    showBezahlen? Container()
                        :
                    Column(
                      children: [
                        Container(
                          color: Colors.green,
                          width: MediaQuery.of(context).size.width,
                          child: const Padding(
                            padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: Text(
                              "Meine Bestellung",
                              style: TextStyle(
                                  height: 0,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        Expanded(
                          child: showWarenkorb
                              ? Container(
                            color: Colors.transparent,
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.centerRight,
                            child:


                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [

                                Expanded(
                                  child:

                                  Container(
                                    color: Colors.transparent,
                                    padding: const EdgeInsets.only(left: 10),
                                    child:

                                    Platform.isAndroid ?

                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [

                                      Row(
                                        children: [

                                        Expanded(
                                          child:

                                          Padding(
                                            padding: const EdgeInsets.only(right: 3),
                                            child: Image.asset(
                                               "lib/images/payment logos/girocard.png",
                                                fit: BoxFit.fill,

                                              height:  MediaQuery.of(
                                                  context)
                                                  .size
                                                  .height *
                                                  0.05,
                                    ),
                                          ),
                                        ),

                                          Expanded(
                                            child:
                                            Padding(
                                              padding: const EdgeInsets.only(right: 3),
                                              child: Image.asset(
                                                  "lib/images/payment logos/mastercard.png",
                                                  fit: BoxFit.fill,

                                                height:  MediaQuery.of(
                                                    context)
                                                    .size
                                                    .height *
                                                    0.05,
                                              ),
                                            ),
                                          ),

                                          Expanded(
                                            child:

                                            Padding(
                                              padding: const EdgeInsets.only(right: 3),
                                              child: Image.asset(
                                                  "lib/images/payment logos/mastercard-maestro.png",
                                                  fit: BoxFit.fill,

                                                height:  MediaQuery.of(
                                                    context)
                                                    .size
                                                    .height *
                                                    0.05,
                                              ),
                                            ),
                                          ),

                                      ],),

                                      const SizedBox(height: 3,),

                                      Row(
                                        children: [

                                          Expanded(
                                            child:
                                            Padding(
                                              padding: const EdgeInsets.only(right: 3),
                                              child: Image.asset(
                                                  "lib/images/payment logos/visa.png",
                                                  fit: BoxFit.fill,

                                                height:  MediaQuery.of(
                                                    context)
                                                    .size
                                                    .height *
                                                    0.05,
                                              ),
                                            ),
                                          ),

                                          Expanded(
                                            child:
                                            Padding(
                                              padding: const EdgeInsets.only(right: 3),
                                              child: Image.asset(
                                                  "lib/images/payment logos/vpay.png",
                                                  fit: BoxFit.fill,

                                                height:  MediaQuery.of(
                                                    context)
                                                    .size
                                                    .height *
                                                    0.05,
                                              ),
                                            ),
                                          ),

                                          Expanded(
                                            child:
                                            Padding(
                                              padding: const EdgeInsets.only(right: 3),
                                              child: Image.asset(
                                                  "lib/images/payment logos/contactless.png",
                                                  fit: BoxFit.fill,

                                                  height:  MediaQuery.of(
                                                      context)
                                                      .size
                                                      .height *
                                                      0.05,
                                              ),
                                            ),
                                          ),

                                        ],),

                                    ],)

                                     :

                                    Row(
                                      children: [

                                        Expanded(
                                          child:

                                          Padding(
                                            padding: const EdgeInsets.only(right: 10),
                                            child: Image.asset(
                                              "lib/images/payment logos/girocard.png",
                                              fit: BoxFit.fill,

                                              height:  MediaQuery.of(
                                                  context)
                                                  .size
                                                  .height *
                                                  0.07,
                                            ),
                                          ),
                                        ),

                                        Expanded(
                                          child:
                                          Padding(
                                            padding: const EdgeInsets.only(right: 10),
                                            child: Image.asset(
                                              "lib/images/payment logos/mastercard.png",
                                              fit: BoxFit.fill,

                                              height:  MediaQuery.of(
                                                  context)
                                                  .size
                                                  .height *
                                                  0.07,
                                            ),
                                          ),
                                        ),

                                        Expanded(
                                          child:

                                          Padding(
                                            padding: const EdgeInsets.only(right: 10),
                                            child: Image.asset(
                                              "lib/images/payment logos/mastercard-maestro.png",
                                              fit: BoxFit.fill,

                                              height:  MediaQuery.of(
                                                  context)
                                                  .size
                                                  .height *
                                                  0.07,
                                            ),
                                          ),
                                        ),

                                        Expanded(
                                          child:
                                          Padding(
                                            padding: const EdgeInsets.only(right: 10),
                                            child: Image.asset(
                                              "lib/images/payment logos/visa.png",
                                              fit: BoxFit.fill,

                                              height:  MediaQuery.of(
                                                  context)
                                                  .size
                                                  .height *
                                                  0.07,
                                            ),
                                          ),
                                        ),

                                        Expanded(
                                          child:
                                          Padding(
                                            padding: const EdgeInsets.only(right: 10),
                                            child: Image.asset(
                                              "lib/images/payment logos/vpay.png",
                                              fit: BoxFit.fill,

                                              height:  MediaQuery.of(
                                                  context)
                                                  .size
                                                  .height *
                                                  0.07,
                                            ),
                                          ),
                                        ),

                                        Expanded(
                                          child:
                                          Padding(
                                            padding: const EdgeInsets.only(right: 10),
                                            child: Image.asset(
                                              "lib/images/payment logos/contactless.png",
                                              fit: BoxFit.fill,

                                              height:  MediaQuery.of(
                                                  context)
                                                  .size
                                                  .height *
                                                  0.07,
                                            ),
                                          ),
                                        ),

                                      ],),

                                  ),
                                ),



                                Container(
                                  color: Colors.transparent,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: Platform.isAndroid ? 7 : 30,
                                        vertical: 15),
                                    child: Text(
                                      "Gesamtpreis: ${formatCurrency(roundDouble(getTotalPreis(), 2))}€",
                                      style: TextStyle(
                                          height: 0,
                                          fontWeight: FontWeight.bold,
                                          fontSize: Platform.isAndroid ? 22 : 35,
                                          color: Colors.black),
                                    ),
                                  ),
                                ),


                              ],
                            ),
                          )
                              : Container(
                            color: Colors.transparent,
                            // width: MediaQuery.of(context).size.width,
                            alignment: Alignment.center,
                            child:
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: warenkorb.isNotEmpty
                                  ? Column(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Anzahl Artikel: ${getItemCount()}",
                                    style: TextStyle(
                                        height: 0,
                                        backgroundColor: Colors.transparent,
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                        Platform.isAndroid ? 15 : 25,
                                        color: Colors.black),
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(top: 5),
                                    child: Text(
                                      "Gesamtpreis: ${formatCurrency(roundDouble(getTotalPreis(), 2))}€",
                                      style: TextStyle(
                                          height: 0,
                                          backgroundColor: Colors.transparent,
                                          fontWeight: FontWeight.bold,
                                          fontSize: Platform.isAndroid
                                              ? 20
                                              : 30,
                                          color: Colors.black),
                                    ),
                                  ),
                                ],
                              )
                                  : Text(
                                "Ihre Bestellung ist leer!",
                                style: TextStyle(
                                    height: 0,
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                    Platform.isAndroid ? 18 : 23,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.grey[350],
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(
                              vertical: Platform.isAndroid ? 5 : 25),
                          child: showWarenkorb
                              ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                  width:
                                  MediaQuery.of(context).size.width * 0.4,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        print("Zurück zur Bestellansicht!");

                                        showWarenkorb = false;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.red[300],

                                      side: const BorderSide(
                                          color: Colors.black, width: 1),
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                          Platform.isAndroid ? 5 : 15,
                                          vertical:
                                          Platform.isAndroid ? 5 : 15),

                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      // Text Color (Foreground color)
                                    ),
                                    child: Text(
                                      'Zurück',
                                      style: TextStyle(
                                          fontSize:
                                          Platform.isAndroid ? 15 : 20,
                                          height: 0),
                                    ),
                                  )),
                              SizedBox(
                                  width:
                                  MediaQuery.of(context).size.width * 0.1),
                              SizedBox(
                                  width:
                                  MediaQuery.of(context).size.width * 0.4,
                                  child: ElevatedButton(
                                    onPressed: () async{

                                     // await sendWarenkorb(warenkorb);

                                      setState(() {

                                        showBezahlen = true;

                                        animationcontroller.reverse(
                                            from: animationcontroller.value == 0 ? 1.0 : animationcontroller.value);

                                      });


                                    },
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.green[300],
                                      side: const BorderSide(
                                          color: Colors.black, width: 1),
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                          Platform.isAndroid ? 5 : 15,
                                          vertical:
                                          Platform.isAndroid ? 5 : 15),

                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      // Text Color (Foreground color)
                                    ),
                                    child: Text(
                                      'Bezahlen',
                                      style: TextStyle(
                                          fontSize:
                                          Platform.isAndroid ? 14 : 20,
                                          height: 0),
                                    ),
                                  )),
                            ],
                          )
                              : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                  width:
                                  MediaQuery.of(context).size.width * 0.4,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (warenkorb.isNotEmpty) {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                  backgroundColor:
                                                  Colors.grey[300],
                                                  title: Text(
                                                    "Bitte bestätigen!",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      height: 0,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: Colors.black,
                                                      fontSize:
                                                      Platform.isAndroid
                                                          ? 25
                                                          : 30,
                                                    ),
                                                  ),
                                                  content: Text(
                                                    "Soll der Warenkorb wirklich geleert werden?",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      height: 0,
                                                      fontWeight:
                                                      FontWeight.normal,
                                                      color: Colors.black,
                                                      fontSize:
                                                      Platform.isAndroid
                                                          ? 20
                                                          : 25,
                                                    ),
                                                  ),
                                                  contentPadding: EdgeInsets.symmetric(
                                                      horizontal: Platform
                                                          .isAndroid
                                                          ? MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                          0
                                                          : MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                          0.15,
                                                      vertical: Platform
                                                          .isAndroid
                                                          ? MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                          0.05
                                                          : MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                          0.1),
                                                  alignment:
                                                  AlignmentDirectional
                                                      .center,
                                                  actions: [
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                      children: [
                                                        MaterialButton(
                                                          color:
                                                          Colors.grey[400],
                                                          shape:
                                                          RoundedRectangleBorder(
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                5.0),
                                                            side:
                                                            const BorderSide(
                                                                color: Colors
                                                                    .black,
                                                                width: 1),
                                                          ),
                                                          padding: EdgeInsets.symmetric(
                                                              horizontal: Platform
                                                                  .isAndroid
                                                                  ? 10
                                                                  : 20,
                                                              vertical: Platform
                                                                  .isAndroid
                                                                  ? 10
                                                                  : 20),
                                                          minWidth: Platform
                                                              .isAndroid
                                                              ? MediaQuery.of(
                                                              context)
                                                              .size
                                                              .width *
                                                              0.2
                                                              : MediaQuery.of(
                                                              context)
                                                              .size
                                                              .width *
                                                              0.15,
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);

                                                            setState(() {
                                                              print(
                                                                  "Warenkorb geleert!");
                                                              warenkorb.clear();
                                                            });
                                                          },
                                                          child: Text(
                                                            'Ja',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              height: 0,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                              color:
                                                              Colors.black,
                                                              fontSize: Platform
                                                                  .isAndroid
                                                                  ? 18
                                                                  : 25,
                                                            ),
                                                          ),
                                                        ),
                                                        MaterialButton(
                                                          color:
                                                          Colors.grey[400],
                                                          shape:
                                                          RoundedRectangleBorder(
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                5.0),
                                                            side:
                                                            const BorderSide(
                                                                color: Colors
                                                                    .black,
                                                                width: 1),
                                                          ),
                                                          padding: EdgeInsets.symmetric(
                                                              horizontal: Platform
                                                                  .isAndroid
                                                                  ? 10
                                                                  : 20,
                                                              vertical: Platform
                                                                  .isAndroid
                                                                  ? 10
                                                                  : 20),
                                                          minWidth: Platform
                                                              .isAndroid
                                                              ? MediaQuery.of(
                                                              context)
                                                              .size
                                                              .width *
                                                              0.2
                                                              : MediaQuery.of(
                                                              context)
                                                              .size
                                                              .width *
                                                              0.15,
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text(
                                                            'Nein',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              height: 0,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                              color:
                                                              Colors.black,
                                                              fontSize: Platform
                                                                  .isAndroid
                                                                  ? 18
                                                                  : 25,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ), // MaterialButton

                                                    // MaterialButton
                                                  ]);
                                            });
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: warenkorb.isNotEmpty
                                          ? Colors.red[300]
                                          : Colors.red[100],
                                      side: const BorderSide(
                                          color: Colors.black, width: 1),
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                          Platform.isAndroid ? 5 : 15,
                                          vertical:
                                          Platform.isAndroid ? 5 : 15),

                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      // Text Color (Foreground color)
                                    ),
                                    child: Text(
                                      'Abbrechen',
                                      style: TextStyle(
                                          fontSize:
                                          Platform.isAndroid ? 15 : 20,
                                          height: 0),
                                    ),
                                  )),
                              SizedBox(
                                  width:
                                  MediaQuery.of(context).size.width * 0.1),
                              SizedBox(
                                  width:
                                  MediaQuery.of(context).size.width * 0.4,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (warenkorb.isNotEmpty) {
                                        setState(() {
                                          showWarenkorb = true;
                                        });
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: warenkorb.isNotEmpty
                                          ? Colors.green[300]
                                          : Colors.green[100],
                                      side: const BorderSide(
                                          color: Colors.black, width: 1),
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                          Platform.isAndroid ? 5 : 15,
                                          vertical:
                                          Platform.isAndroid ? 5 : 15),

                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      // Text Color (Foreground color)
                                    ),
                                    child: Text(
                                      'Bestellung ansehen',
                                      style: TextStyle(
                                          fontSize:
                                          Platform.isAndroid ? 14 : 20,
                                          height: 0),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ],
                    )),
              ],
            )),
      );

    } else {
      return SafeArea(
        child: Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: LoadingAnimationWidget.prograssiveDots(
                  color: const Color(0xFF7B1A33),
                  size: 100,
                ),
              ),
            ],
          ),
        ),
      );
    }

  }

  int getItemCount() {
    int counter = 0;

    for (ArticleDTO articleDTO in warenkorb) {
      counter += 1;
    }

    return counter;
  }

  double getTotalPreis() {
    double price = 0;

    for (ArticleDTO articleDTO in warenkorb) {
      price += articleDTO.priceGross!;
      for (ArticleExtraDTO extra in articleDTO.extraslist!) {
        price += (extra.price! * extra.amount);
      }
    }

    return price;
  }

  void getItems() {

    articleList.clear();

    try {

      String? categorieID = _categorylist[_currentSelectedIndex].name;

      for (ArticleDTO articleDTO in articleDTOList) {
        if (articleDTO.group!.name!.compareTo(categorieID!) == 0) {
          articleList.add(articleDTO);
        }
      }

    } catch(e) {
      // code that handles the exception
    }

  }

  double getPreisArticle(ArticleDTO article) {
    double price = 0;

    for (ArticleExtraDTO a in article.extraslist!) {
      price += (a.price! * a.amount);
    }

    price += article.priceGross!;

    return price;
  }

  double getPreis() {
    double price = 0;

    for (ArticleExtraDTO a in selectedArticle!.extraslist!) {
      price += (a.price! * a.amount);
    }

    price += selectedArticle!.priceGross!;

    return price;
  }

  String formatCurrency(double value) {
    NumberFormat numberFormat = NumberFormat("#,##0.00", "de_DE");
    return numberFormat.format(value);
  }

  double roundDouble(double value, int places) {
    num mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  String get countText {

    Duration count = animationcontroller.duration! * animationcontroller.value;

    // print(controller.value);
    //print((count.inSeconds % 60).toString());
    return (count.inSeconds).toString();
  }


  void notify() {
    if (countText == '0') {

        bezahlungFertig = true;

    }
  }


  Future<void> loadData() async {

    _categorylist.add(CategoryDTO(name: "Frühstück"));
    _categorylist.add(CategoryDTO(name: "Kaffee"));
    _categorylist.add(CategoryDTO(name: "Kuchen"));

    ByteData bytes;
    ByteBuffer buffer;
    String image;

    bytes = await rootBundle.load('lib/images/articles/Arme Ritter.png');
    buffer = bytes.buffer;
    image = base64.encode(Uint8List.view(buffer));
    articleDTOList.add(ArticleDTO(title: "Arme Ritter", group: _categorylist[0], priceGross: (1+ Random().nextDouble() * 10) + (Random().nextDouble() * 100)/100,extraslist: getExtras(), icon: image));

    bytes = await rootBundle.load('lib/images/articles/Avocado Brot.png');
    buffer = bytes.buffer;
    image = base64.encode(Uint8List.view(buffer));
    articleDTOList.add(ArticleDTO(title: "Avocado Brot", group: _categorylist[0], priceGross: (1+ Random().nextDouble() * 10) + (Random().nextDouble() * 100)/100,extraslist: getExtras(), icon: image));

    bytes = await rootBundle.load('lib/images/articles/English Breakfast.png');
    buffer = bytes.buffer;
    image = base64.encode(Uint8List.view(buffer));
    articleDTOList.add(ArticleDTO(title: "English Breakfast", group: _categorylist[0], priceGross: (1+ Random().nextDouble() * 10) + (Random().nextDouble() * 100)/100,extraslist: getExtras(), icon: image));

    bytes = await rootBundle.load('lib/images/articles/Granola Bowl.png');
    buffer = bytes.buffer;
    image = base64.encode(Uint8List.view(buffer));
    articleDTOList.add(ArticleDTO(title: "Granola Bowl", group: _categorylist[0], priceGross: (1+ Random().nextDouble() * 10) + (Random().nextDouble() * 100)/100,extraslist: getExtras(), icon: image));

    bytes = await rootBundle.load('lib/images/articles/Obstplatte.png');
    buffer = bytes.buffer;
    image = base64.encode(Uint8List.view(buffer));
    articleDTOList.add(ArticleDTO(title: "Obstplatte", group: _categorylist[0], priceGross: (1+ Random().nextDouble() * 10) + (Random().nextDouble() * 100)/100,extraslist: getExtras(), icon: image));

    bytes = await rootBundle.load('lib/images/articles/Omelette.png');
    buffer = bytes.buffer;
    image = base64.encode(Uint8List.view(buffer));
    articleDTOList.add(ArticleDTO(title: "Omelette", group: _categorylist[0], priceGross: (1+ Random().nextDouble() * 10) + (Random().nextDouble() * 100)/100,extraslist: getExtras(), icon: image));

    bytes = await rootBundle.load('lib/images/articles/Pancakes.png');
    buffer = bytes.buffer;
    image = base64.encode(Uint8List.view(buffer));
    articleDTOList.add(ArticleDTO(title: "Pancakes", group: _categorylist[0], priceGross: (1+ Random().nextDouble() * 10) + (Random().nextDouble() * 100)/100,extraslist: getExtras(), icon: image));

    bytes = await rootBundle.load('lib/images/articles/Pochierte Eier.png');
    buffer = bytes.buffer;
    image = base64.encode(Uint8List.view(buffer));
    articleDTOList.add(ArticleDTO(title: "Pochierte Eier", group: _categorylist[0], priceGross: (1+ Random().nextDouble() * 10) + (Random().nextDouble() * 100)/100,extraslist: getExtras(), icon: image));


    bytes = await rootBundle.load('lib/images/articles/Espresso.png');
    buffer = bytes.buffer;
    image = base64.encode(Uint8List.view(buffer));
    articleDTOList.add(ArticleDTO(title: "Espresso", group: _categorylist[1], priceGross: (1+ Random().nextDouble() * 10) + (Random().nextDouble() * 100)/100,extraslist: getExtras(), icon: image));

    bytes = await rootBundle.load('lib/images/articles/Heiße Schokolade.png');
    buffer = bytes.buffer;
    image = base64.encode(Uint8List.view(buffer));
    articleDTOList.add(ArticleDTO(title: "Heiße Schokolade", group: _categorylist[1], priceGross: (1+ Random().nextDouble() * 10) + (Random().nextDouble() * 100)/100,extraslist: getExtras(), icon: image));

    bytes = await rootBundle.load('lib/images/articles/Ice Chai Tee Latte.png');
    buffer = bytes.buffer;
    image = base64.encode(Uint8List.view(buffer));
    articleDTOList.add(ArticleDTO(title: "Ice Chai Tee Latte", group: _categorylist[1], priceGross: (1+ Random().nextDouble() * 10) + (Random().nextDouble() * 100)/100,extraslist: getExtras(), icon: image));

    bytes = await rootBundle.load('lib/images/articles/Ice Latte Macchiato.png');
    buffer = bytes.buffer;
    image = base64.encode(Uint8List.view(buffer));
    articleDTOList.add(ArticleDTO(title: "Ice Latte Macchiato", group: _categorylist[1], priceGross: (1+ Random().nextDouble() * 10) + (Random().nextDouble() * 100)/100,extraslist: getExtras(), icon: image));

    bytes = await rootBundle.load('lib/images/articles/Ice Matcha Latte.png');
    buffer = bytes.buffer;
    image = base64.encode(Uint8List.view(buffer));
    articleDTOList.add(ArticleDTO(title: "Ice Matcha Latte", group: _categorylist[1], priceGross: (1+ Random().nextDouble() * 10) + (Random().nextDouble() * 100)/100,extraslist: getExtras(), icon: image));

    bytes = await rootBundle.load('lib/images/articles/Kaffee.png');
    buffer = bytes.buffer;
    image = base64.encode(Uint8List.view(buffer));
    articleDTOList.add(ArticleDTO(title: "Kaffee", group: _categorylist[1], priceGross: (1+ Random().nextDouble() * 10) + (Random().nextDouble() * 100)/100,extraslist: getExtras(), icon: image));

    bytes = await rootBundle.load('lib/images/articles/Latte Macchiato.png');
    buffer = bytes.buffer;
    image = base64.encode(Uint8List.view(buffer));
    articleDTOList.add(ArticleDTO(title: "Latte Macchiato", group: _categorylist[1], priceGross: (1+ Random().nextDouble() * 10) + (Random().nextDouble() * 100)/100,extraslist: getExtras(), icon: image));


    bytes = await rootBundle.load('lib/images/articles/Erdbeertorte.png');
    buffer = bytes.buffer;
    image = base64.encode(Uint8List.view(buffer));
    articleDTOList.add(ArticleDTO(title: "Erdbeertorte", group: _categorylist[2], priceGross: (1+ Random().nextDouble() * 10) + (Random().nextDouble() * 100)/100,extraslist: getExtras(), icon: image));

    bytes = await rootBundle.load('lib/images/articles/Himbeertorte.png');
    buffer = bytes.buffer;
    image = base64.encode(Uint8List.view(buffer));
    articleDTOList.add(ArticleDTO(title: "Himbeertorte", group: _categorylist[2], priceGross: (1+ Random().nextDouble() * 10) + (Random().nextDouble() * 100)/100,extraslist: getExtras(), icon: image));

    bytes = await rootBundle.load('lib/images/articles/Mohnkuchen.png');
    buffer = bytes.buffer;
    image = base64.encode(Uint8List.view(buffer));
    articleDTOList.add(ArticleDTO(title: "Mohnkuchen", group: _categorylist[2], priceGross: (1+ Random().nextDouble() * 10) + (Random().nextDouble() * 100)/100,extraslist: getExtras(), icon: image));

    bytes = await rootBundle.load('lib/images/articles/Schokoladentorte.png');
    buffer = bytes.buffer;
    image = base64.encode(Uint8List.view(buffer));
    articleDTOList.add(ArticleDTO(title: "Schokoladentorte", group: _categorylist[2], priceGross: (1+ Random().nextDouble() * 10) + (Random().nextDouble() * 100)/100,extraslist: getExtras(), icon: image));

    bytes = await rootBundle.load('lib/images/articles/Zitronenkuchen.png');
    buffer = bytes.buffer;
    image = base64.encode(Uint8List.view(buffer));
    articleDTOList.add(ArticleDTO(title: "Zitronenkuchen", group: _categorylist[2], priceGross: (1+ Random().nextDouble() * 10) + (Random().nextDouble() * 100)/100,extraslist: getExtras(), icon: image));


    bytes = await rootBundle.load('lib/images/articles/egon.jpg');
    buffer = bytes.buffer;
    image = base64.encode(Uint8List.view(buffer));
    articleDTOList.add(ArticleDTO(title: "Egon Kowalski", group: _categorylist[2], priceGross: (1+ Random().nextDouble() * 10) + (Random().nextDouble() * 100)/100,extraslist: getExtras(), icon: image));

    bytes = await rootBundle.load('lib/images/articles/egon2.png');
    buffer = bytes.buffer;
    image = base64.encode(Uint8List.view(buffer));
    articleDTOList.add(ArticleDTO(title: "Gleich ham wa den Salat!", group: _categorylist[2], priceGross: (1+ Random().nextDouble() * 10) + (Random().nextDouble() * 100)/100,extraslist: getExtras(), icon: image));

     // await loadArticleGroups();

  }

  Future<void> loadArticleGroups() async {

    LiveApiRequest<CategoryDTO> liveApiRequest =
    LiveApiRequest<CategoryDTO>(path: "external/kiosk/getArticleGroups");
    ApiResponse apiResponse = await liveApiRequest.executeGet();
    if (apiResponse.status == Status.SUCCESS) {

      print("success articlegroups");

      List<CategoryDTO>.from(jsonDecode(apiResponse.body!)
          .map((model) => CategoryDTO.fromJson(model))).forEach((element) {
        _categorylist.add(element);
      });

      for (CategoryDTO c in _categorylist) {

        await loadArticles(c.number!);

      }


    } else if (apiResponse.status == Status.EXCEPTION) {
    } else if (apiResponse.status == Status.ERROR) {
    }

  }

  Future<void> loadArticles(String groupnumber) async {

    LiveApiRequest<ArticleDTO> liveApiRequest2 =
    LiveApiRequest<ArticleDTO>(path: "external/kiosk/getArticles/$groupnumber");
    ApiResponse apiResponse2 = await liveApiRequest2.executeGet();
    if (apiResponse2.status == Status.SUCCESS) {

      print("success articles");
      //CustomerDto customerDto =

      List<ArticleDTO>.from(jsonDecode(apiResponse2.body!)
          .map((model) => ArticleDTO.fromJson(model))).forEach((element) {
        articleDTOList.add(element);
      });


    } else if (apiResponse2.status == Status.EXCEPTION) {
    } else if (apiResponse2.status == Status.ERROR) {
    }

  }

  Future<void> sendWarenkorb(List<ArticleDTO> warenkorb) async {

    List<Article> articles = [];

    for (ArticleDTO a in warenkorb) {

      articles.add(Article(articleNumber: a.articleNumber, quantity: 1, type: "ARTICLE"));

    }

    ReceiptDTO receipt=ReceiptDTO(currency: "EUR",time: SerializerHelper.formatISOTime2(DateTime.now()), status: "OPEN", type: "SELL", referenceCode: "7a8e8ccc-f8e4-4d8a-8ca4-773349ba9b66", paymentMethod: "EC", articles: articles);

    LiveApiRequest<ArticleDTO> liveApiRequest2 =
    LiveApiRequest<ArticleDTO>(path: "external/kiosk/createReceipt");
    ApiResponse apiResponse2 = await liveApiRequest2.executePost(receipt);
    if (apiResponse2.status == Status.SUCCESS) {

      print("success send warenkorb");

    } else if (apiResponse2.status == Status.EXCEPTION) {
    } else if (apiResponse2.status == Status.ERROR) {
    }

  }

 List<ArticleExtraDTO> getExtras(){

   List<ArticleExtraDTO> extras=[];
   int anzahl = Random().nextInt(11);

   for (int i = 1; i < anzahl+1; i++) {
    
     extras.add(ArticleExtraDTO(amount: 0, name: "Zutat $i", description: i % 3 == 0 ? "Das ist ein Test!" : "", price: anzahl/ i * 1.78+3.45));

   }

   return extras;
  }




}




