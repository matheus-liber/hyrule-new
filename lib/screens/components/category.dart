import 'package:flutter/material.dart';
import 'package:hyrule/controllers/api_controller.dart';
import 'package:hyrule/screens/results.dart';
import 'package:hyrule/utils/consts/categories.dart';

import '../../domain/models/entry.dart';

class Category extends StatelessWidget {
  Category({Key? key, required this.category, this.isHighLight = false})
      : super(key: key);
  final String category;
  final bool isHighLight;

  final ApiController apiController = ApiController();

  Future<List<Entry>> getEntries() async {
    return await apiController.getEntriesByCategory(category: category);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Flexible(
          child: InkWell(
            onTap: () async {
              await getEntries().then((value) => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Results(entries: value, category: category))));
            },
            borderRadius: BorderRadius.circular(16.0),
            child: Ink(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    border:
                        Border.all(width: 2.0, color: const Color(0xFF0079CF)),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 6.0,
                          color: const Color(0xFF0079CF).withOpacity(0.2),
                          blurStyle: BlurStyle.outer),
                    ]),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.8, end: 1),
                  duration: const Duration(seconds: 1),
                  builder: (context, value, child) {
                    return Center(
                      child: Image.asset(
                        "$imagePath$category.png",
                        height: 78 * value,
                        fit: BoxFit.fitHeight,
                      ),
                    );
                  },
                )),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Text(categories[category]!,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: const Color(0xFF0079CF))),
        ),
      ],
    );
  }
}
