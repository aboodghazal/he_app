import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryDropdown extends StatefulWidget {
  final String? selectedCategory;
  final Function(String?) onChanged;

  const CategoryDropdown({
    super.key,
    required this.selectedCategory,
    required this.onChanged,
  });

  @override
  State<CategoryDropdown> createState() => _CategoryDropdownState();
}

class _CategoryDropdownState extends State<CategoryDropdown> {
  late Future<List<String>> _categoriesFuture;

  Future<List<String>> _getCategories() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('categories').get();

    return snapshot.docs.map((doc) => doc['name'] as String).toList();
  }

  @override
  void initState() {
    super.initState();
    _categoriesFuture = _getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _categoriesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Text("حدث خطأ أثناء تحميل التصنيفات");
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text("لا توجد تصنيفات متاحة");
        }

        final categories = snapshot.data!;

        // Ensure the selected value exists in the list
        String? validValue = widget.selectedCategory != null &&
                categories.contains(widget.selectedCategory)
            ? widget.selectedCategory
            : null;

        return DropdownButtonFormField<String>(
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFEDF3F2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          hint: const Text("اختر التصنيف"),
          value: validValue,
          items: categories
              .map((name) => DropdownMenuItem(
                    value: name,
                    child: Text(name, textAlign: TextAlign.right),
                  ))
              .toList(),
          onChanged: widget.onChanged,
        );
      },
    );
  }
}
