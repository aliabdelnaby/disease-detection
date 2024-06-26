import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'data_models/articles.dart';

class ItemList extends StatelessWidget {
  const ItemList({super.key, required this.artical});
  final Articles artical;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          SizedBox(
            height: 120,
            width: 120,
            child: (artical.urlToImage == null || artical.urlToImage == "")
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Hero(
                      tag: artical.title![0],
                      child: Image.asset(
                        'assets/images/errorImage.jpeg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Hero(
                      tag: artical.title![0],
                      child: Image.network(
                        artical.urlToImage!,
                        fit: BoxFit.cover,
                        loadingBuilder:
                            (context, child, ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                      ),
                    ),
                  ),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: SizedBox(
              height: 120,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Text(
                      artical.title!,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    DateFormat('yMMMMEEEEd').add_jm().format(
                          DateTime.parse(
                            "${artical.publishedAt}",
                          ),
                        ),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
