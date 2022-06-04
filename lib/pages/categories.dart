import 'package:flutter/material.dart';
import 'package:gotour/models/Category.dart';
import 'package:gotour/providers/categoryProvider.dart';
import 'package:gotour/widgets/ProgressWidget.dart';
import 'package:gotour/widgets/categoryDesign.dart';
import 'package:provider/provider.dart';

class CategoryList extends StatefulWidget {
  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  // //CategoryDatabaseManager categoryDatabaseManager = CategoryDatabaseManager();
  // Future<List<Category>> futureCategoryResult;
  // bool loading = false;

  // @override
  // void initState() {
  //   super.initState();

  //   getCategories();
  // }

  // getCategories() async {
  //   setState(() {
  //     loading = true;
  //   });

  //   futureCategoryResult = CategoryProvider().getCategoryList();

  //   setState(() {
  //     loading = false;
  //   });
  // }

  displayCategories() {
    return FutureBuilder(
      future: context.watch<CategoryProvider>().getCategoryList(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        } else {
          List<Category> categories = snapshot.data;

          return Container(
            child: GridView.count(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              crossAxisCount: 2,
              children: List.generate(categories.length, (index) {
                Category category = categories[index];

                return CategoryDesign(
                  category: category,
                );
              }),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    context.read<CategoryProvider>().updateCategories();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text(
          "Categories",
          style: TextStyle(color: Colors.teal),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.grey,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: displayCategories(),
    );
  }
}
