import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rating_dialog/rating_dialog.dart';

import 'controller.dart';
import 'modals.dart';

class NewOrderScreen extends StatefulWidget {
  @override
  _NewOrderScreenState createState() => _NewOrderScreenState();
}

class _NewOrderScreenState extends State<NewOrderScreen> {
  bool isLoading = false;
  late MyJsonResponse jsonResponse;

  @override
  Widget build(BuildContext context) {
    final provider=Provider.of<OrderProvider>(context, listen: false);
    if (!isLoading) {
      Provider.of<OrderProvider>(context, listen: false).fetchAndSetOrders().then((value) {
        jsonResponse = value;

        print('\n\n\n Again Printing \n\n\n\n\n\n');
        print('Code ${jsonResponse.code} message ${jsonResponse.message} Total ${jsonResponse.data.total} Status ${jsonResponse.data.status}');
        jsonResponse.data.orders.forEach((element) {
          print(element.product_id);
          print(element.item_name);
        });
        setState(() {
          isLoading = true;
        });
      });
    }

    if (!isLoading) {
      return Center(child: CircularProgressIndicator());
    } else {
      List<Orders> list=provider.groupByItemStatus();

      return DefaultTabController(
        length: list.length,
        child: Scaffold(
          backgroundColor: MyConstants.primaryColor,
          appBar: AppBar(
            backgroundColor: MyConstants.primaryColor,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                size: 17,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            title: Center(
                child: Text(
                  'Pesnan Saya',
                  style: TextStyle(color: MyConstants.pageTitleColor),
                )),
            actions: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Icon(Icons.menu),
              ),
            ],
          ),
          body: Column(
            children: [
              Material(
                color: MyConstants.blackBgColor,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TabBar(
                      isScrollable: true,
                      indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(5), // Creates border
                          color: MyConstants.greenColor), // Creates border
                      // unselectedLabelColor: Colors.black,
                      tabs: list
                          .map((e) => Tab(
                        child: Text(
                          e.item_status,
                        ),
                      ))
                          .toList()),
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: list
                      .map((e) => NewLogic(
                    order: e,
                  ))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
        // SingleChildScrollView(
        //   child: Column(
        //       children: [
        //         Column(
        //           children: jsonResponse.data.orders
        //               .map((e) => CustomOrderItem(
        //             order: e,
        //           ))
        //               .toList(),
        //         ),
        //
        //         // Align(
        //         //   alignment: FractionalOffset.bottomCenter,
        //         //   child: Padding(
        //         //       padding: EdgeInsets.only(bottom: 10.0),
        //         //       child: Row(
        //         //         children: [
        //         //           Expanded(child: Padding(
        //         //             padding: const EdgeInsets.fromLTRB(16,8,4,8),
        //         //             child: ElevatedButton(onPressed: (){
        //         //               showDialogSimple(context);
        //         //             },child: Text('Laporkan'),),
        //         //           )),
        //         //           Expanded(child: Padding(
        //         //             padding: const EdgeInsets.fromLTRB(4,8,16,8),
        //         //             child: ElevatedButton(onPressed: (){
        //         //               showRatingAppDialog(context);
        //         //             },child: Text('Product Diagmaram'), style: ElevatedButton.styleFrom(
        //         //                 primary: Colors.purple,
        //         //             ),),
        //         //           )),
        //         //
        //         //         ],
        //         //       )
        //         //   ),
        //         // ),
        //
        //       ]),
        // )),
      );
    }
  }
}

class NewLogic extends StatelessWidget {
  Orders order;
  NewLogic({required this.order});

  @override
  Widget build(BuildContext context) {
   List<Orders> myList= Provider.of<OrderProvider>(context,listen: false).getOrderById(order);
    return SingleChildScrollView(
      child: Column(
        children:myList.map((e) => CustomOrderItem(order: e)).toList()
      ),
    );
  }
}


class CustomOrderItem extends StatelessWidget {
  late Orders order;

  CustomOrderItem({required this.order});

  void showRatingAppDialog(BuildContext context, int orderId, int itemId) {
    final _ratingDialog = RatingDialog(
      ratingColor: Colors.amber,
      title: 'Rating Dialog Heading',
      message: 'Rating this app and tell others what you think.'
          ' Add more description here if you want.',
      // image: Image.asset("assets/images/devs.jpg",
      //   height: 100,),
      submitButton: 'Submit',
      onCancelled: () => print('cancelled'),
      onSubmitted: (response) {
        print('rating: ${response.rating}, '
            'comment: ${response.comment}');
        Provider.of<OrderProvider>(context, listen: false).reviewProduct(orderId, itemId, response.rating, response.comment).then((value) {
          if (value) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Thankyou for Review!"),
            ));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Something Went Wrong!"),
            ));
          }
        });

        if (response.rating < 3.0) {
          print('response.rating: ${response.rating}');
        } else {
          Container();
        }
      },
    );

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => _ratingDialog,
    );
  }

  Future<void> showDialogSimple(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('This is a demo alert dialog.'),
                Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                primary: Colors.purple,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  final GlobalKey expansionTileKey = GlobalKey();
  ValueNotifier<bool> isExpand=ValueNotifier(false);

  @override
  Widget build(BuildContext context) {

    return ExpansionTile(
      key: expansionTileKey,
      onExpansionChanged: (val){
        isExpand.value=val;
      },
      title: Text(
        '${order.item_name}',
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.subtitle2!.copyWith(color: Colors.white),
      ),
      trailing:  ValueListenableBuilder(builder: (context,isEx,child){
           if(isExpand.value){
          return Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
            child: Icon(Icons.keyboard_arrow_down_sharp,color: Colors.red, size: 20,),
          );
        }else{
          return Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
            child: Icon(Icons.keyboard_arrow_up_sharp,color: Colors.red, size: 20,),
          );
        }
      }, valueListenable: isExpand,),
      children: [
        Card(
          color: MyConstants.primaryColor,
          elevation: 4,
          child: Column (
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 80,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage("${order.item_image}"),
                                ),
                              ),
                            )),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: MyConstants.redButton,
                              ),
                              onPressed: () {},
                              child: Text(
                                '${order.order_date_text}',
                                style: TextStyle(fontSize: 7.5),
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                          child: Text(
                            'Monotoguu Konfirmasi',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 11,color: MyConstants.textColor),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: Text(
                                  '${order.item_name}',
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.subtitle2!.copyWith(color: Colors.white),
                                )),

                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text(
                            'Data 2',
                            style: Theme.of(context).textTheme.caption!.copyWith(color: MyConstants.textColor),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Rp ${order.order_total}',
                                  style: Theme.of(context).textTheme.subtitle2!.copyWith(color: MyConstants.greenColor),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 40, 0),
                                child: Text(
                                  'xl',
                                  style: TextStyle(color: MyConstants.textColor),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 40, 0),
                          child: Divider(
                            color: MyConstants.textColor,
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                              child: Icon(
                                Icons.star,
                                color: Colors.yellow,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '${order.vendor_name}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: Theme.of(context).textTheme.subtitle2!.copyWith(color: MyConstants.textColor,),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 40, 0),
                              child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    primary: MyConstants.greenColor,
                                  ),
                                  child: Text('Chat Toko')),
                            )
                          ],
                        ),
                        // Row(
                        //   children: [
                        //     Expanded(
                        //       child: Padding(
                        //         padding: const EdgeInsets.symmetric(vertical: 2),
                        //         child: Text(
                        //           'Skin',
                        //           style: Theme.of(context).textTheme.caption,
                        //         ),
                        //       ),
                        //     ),
                        //
                        //   ],
                        // ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 40, 0),
                          child: Divider(
                            color: MyConstants.textColor,
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Text(
                                'Dikirim Jam',
                                style: Theme.of(context).textTheme.caption!.copyWith(color: MyConstants.textColor),
                              ),
                            ),
                            Text(
                              'Samyo Watko',
                              style: Theme.of(context).textTheme.caption!.copyWith(color: Colors.white,fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 40, 0),
                child: Divider(
                  color:MyConstants.textColor,
                ),
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                        child: Text('Namar Transaction', style: Theme.of(context).textTheme.caption!.copyWith(color: MyConstants.textColor)),
                      ),
                    ],
                  )
                ],
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                        child: Text('GWHWO00HHH44', style: Theme.of(context).textTheme.subtitle2!.copyWith(color: MyConstants.greenColor)),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                        child: Text('Status', style: Theme.of(context).textTheme.caption!.copyWith(color: MyConstants.textColor)),
                      ),
                    ],
                  )
                ],
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                        child: Text('${order.payment_status}', style: Theme.of(context).textTheme.subtitle2!.copyWith(color: Colors.white)),
                      ),
                    ],
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 40, 0),
                child: Divider(
                  color: MyConstants.textColor,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                        child: Text('Item Notes', style: Theme.of(context).textTheme.caption!.copyWith(color: MyConstants.textColor)),
                      ),
                    ],
                  )
                ],
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                        child: Text('${order.item_note_seller}', style: Theme.of(context).textTheme.subtitle2!.copyWith(color: Colors.white)),
                      ),
                    ],
                  )
                ],
              ),
              if(order.item_status.toLowerCase()!="completed")...[
                Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Row(
                        children: [
                          Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(16, 8, 4, 8),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: MyConstants.button1,
                                  ),
                                  onPressed: () {
                                    showDialogSimple(context);
                                  },
                                  child: Text('Laporkan'),
                                ),
                              )),
                          Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(4, 8, 16, 8),
                                child: ElevatedButton(
                                  onPressed: () {
                                    showRatingAppDialog(context, order.order_id, order.item_id);
                                  },
                                  child: Text('Product Diagmaram'),
                                  style: ElevatedButton.styleFrom(
                                      primary: MyConstants.greenColor
                                  ),
                                ),
                              )),
                        ],
                      )),
                ),
              ]
            ],
          ),
        )
      ],

    );
  }
}
