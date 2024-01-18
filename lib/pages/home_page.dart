import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:g9_learn_http/models/product_model.dart';
import 'package:g9_learn_http/services/network_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;

  late List<ProductModel> productList;

  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController priceController = TextEditingController();


  // fetch data
  Future<void> getAllData() async {

    isLoading = false;

    // String
    String result = await NetworkService.GET(NetworkService.apiGetAllData);

    // Map => Object
    productList = productModelFromJson(result);

    isLoading = true;

    setState(() {});
  }

  // delete data

  Future<void> deleteData(int id)async{
    String result = await NetworkService.DELETE(NetworkService.apiDeleteData, id);
    if(result == "200" || result == "201"){
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
                  var item = productList[index];
                  return ListTile(
                    title: Text(item.title ?? ""),
                    subtitle: Text("Price: ${item.price}"),
                    leading: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("${index+1}. ", style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),),
                        Image.network(
                          item.thumbnail ?? "https://cdn.dummyjson.com/product-images/10/thumbnail.jpeg",
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(CupertinoIcons.pencil),
                          onPressed: (){

                            titleController.text = item.title ?? "No title";
                            descController.text = item.description ?? "No description";
                            priceController.text = item.price.toString();

                            showDialog(
                              context: context,
                              builder: (context){
                                return AlertDialog(
                                  title: const Text("Update item"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [

                                      // title
                                      TextField(
                                        controller: titleController,
                                        decoration: const InputDecoration(
                                          hintText: "Name",
                                        ),
                                      ),

                                      // desc
                                      TextField(
                                        controller: descController,
                                        decoration: const InputDecoration(
                                          hintText: "Description",
                                        ),
                                      ),


                                      // price
                                      TextField(
                                        controller: priceController,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                          hintText: "Price",
                                        ),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    IconButton(
                                      onPressed: (){
                                        Navigator.pop(context);
                                      },
                                      icon: const Text("Close"),
                                    ),
                                    IconButton(
                                      onPressed: ()async{

                                        if(titleController.text.isNotEmpty && descController.text.isNotEmpty && priceController.text.isNotEmpty){
                                          ProductModel product = ProductModel(
                                            title: titleController.text.trim(),
                                            description: descController.text.trim(),
                                            thumbnail: "https://cdn.dummyjson.com/product-images/10/thumbnail.jpeg",
                                            price: int.parse(priceController.text.trim()),
                                          );
                                          await NetworkService.PUT(NetworkService.apiPutData, product.toJson(), item.id ?? "0");
                                          await getAllData().then((value) {
                                            Navigator.pop(context);
                                          });
                                          setState(() {});
                                        }else{
                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please fill all the gaps")));
                                        }
                                      },
                                      icon: const Text("Save"),
                                    ),
                                  ],
                                );
                              },
                            );

                          },
                        ),
                        IconButton(
                          icon: const Icon(CupertinoIcons.delete),
                          onPressed: ()async{
                            await deleteData(int.parse(item.id ?? "0"));
                          },
                        ),
                      ],
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
                itemCount: productList.length,
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showDialog(
              context: context,
              builder: (context){
                return AlertDialog(
                  title: const Text("Adding new item"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      
                      // title
                      TextField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          hintText: "Name",
                        ),
                      ),

                      // desc
                      TextField(
                        controller: descController,
                        decoration: const InputDecoration(
                          hintText: "Description",
                        ),
                      ),

                      
                      // price
                      TextField(
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: "Price",
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    IconButton(
                      onPressed: ()async{
                        
                        if(titleController.text.isNotEmpty && descController.text.isNotEmpty && priceController.text.isNotEmpty){
                          ProductModel product = ProductModel(
                              title: titleController.text.trim(),
                              description: descController.text.trim(),
                              thumbnail: "https://cdn.dummyjson.com/product-images/10/thumbnail.jpeg",
                              price: int.parse(priceController.text.trim()),
                          );
                          await NetworkService.POST(NetworkService.apiPostData, product.toJson());
                          await getAllData().then((value) {
                            Navigator.pop(context);
                          });
                          setState(() {});
                        }else{
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please fill all the gaps")));
                        }
                      },
                      icon: const Text("Save"),
                    ),
                    IconButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      icon: const Text("Close"),
                    ),
                  ],
                );
              },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
