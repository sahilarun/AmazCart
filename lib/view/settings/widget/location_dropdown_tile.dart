import 'package:flutter/material.dart';

import '../../../AppConfig/app_config.dart';

class LocationDropDownTile extends StatelessWidget {
  final String title;
  final String? image;
  final Function() onTap;

  const LocationDropDownTile({
    required this.title,
    this.image,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black12.withOpacity(0.05),
        ),
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                if(image!=null)
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Image.network(
                      '${AppConfig.assetPath}/$image',
                      width: 20,
                      errorBuilder:
                          (context, object, stackTrace) {
                        return const Icon(Icons.flag);
                      },
                    ),
                  ),
                Text(title),
              ],
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}
