import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:g9_learn_http/models/all_product.dart';
import 'package:g9_learn_http/models/product_model.dart';
import 'package:g9_learn_http/services/network_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;

  late List<Product> productModel;


  // fetch data
  Future<void> getAllData() async {
    // String
    String result = await NetworkService.GET(NetworkService.apiGetAllData);

    // Map => Object
    productModel = productFromJson(result);
    setState(() {});
  }

  // delete data

  Future<void> deleteData(int id)async{
    String result = await NetworkService.DELETE(NetworkService.apiDeleteData, id);
    log(result);
    if(result == "200" || result == "201"){
      log(result);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${id.toString()} Successfully deleted")));
    }
    await getAllData();
    setState(() {});
  }

  @override
  void initState() {
    getAllData().then((value) {
      isLoading = true;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("HTTP"),
          centerTitle: true,
        ),
        body: isLoading
            ? ListView.separated(
                padding: EdgeInsets.zero,
                itemBuilder: (_, index) {
                  var item = productModel[index];
                  return ListTile(
                    title: Text(item.name),
                    subtitle: Text("Price: ${item.cost}"),
                    // leading: Row(
                    //   mainAxisSize: MainAxisSize.min,
                    //   children: [
                    //     Text("${index+1}. ", style: const TextStyle(
                    //       fontWeight: FontWeight.w700,
                    //       fontSize: 20,
                    //     ),),
                    //     Image.network(
                    //       item.thumbnail,
                    //       fit: BoxFit.cover,
                    //     ),
                    //   ],
                    // ),
                    trailing: IconButton(
                      icon: const Icon(CupertinoIcons.delete),
                      onPressed: ()async{
                        await deleteData(int.parse(item.id));
                      },
                    ),
                  );
                },
                separatorBuilder: (_, index) {
                  if (index % 7 == 0) {
                    return Container(
                      width: double.infinity,
                      height: 130,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.blueGrey,
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      child: const Center(
                        child: Text("Reklama"),
                      ),
                    );
                  }
                  return const Divider();
                },
                itemCount: productModel.length,
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
    );
  }
}
