import 'package:flutter/material.dart';
import 'package:hyrule/controllers/api_controller.dart';
import 'package:hyrule/screens/results.dart';
import 'package:hyrule/utils/consts/categories.dart';

import '../../domain/models/entry.dart';

class Category extends StatefulWidget {
  const Category({Key? key, required this.category, this.isHighLight = false})
      : super(key: key);
  final String category;
  final bool isHighLight;

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> with SingleTickerProviderStateMixin{
  final ApiController apiController = ApiController();

  late AnimationController _animationController;

  @override
  void initState(){
    _animationController = AnimationController(
      vsync: this, 
      duration: const Duration(seconds: 1),
      lowerBound: 0.8,
      upperBound: 1
    );

    if (widget.isHighLight){
      _animationController.repeat(reverse: true);
    } else {
      _animationController.animateTo(1);
    }
  }

  Future<List<Entry>> getEntries() async {
    return await apiController.getEntriesByCategory(category: widget.category);
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
                          Results(entries: value, category: widget.category))));
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
              child: ScaleTransition(
                alignment: Alignment.center,
                scale: _animationController,
                child: Center(
                  child: Image.asset(
                    "$imagePath${widget.category}.png",
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Text(categories[widget.category]!,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: const Color(0xFF0079CF))),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
