import 'package:flutter/material.dart';

class LayananCard extends StatelessWidget {
  final String title;
  final Widget route;
  final IconData icon;

  const LayananCard(
      {super.key,
      required this.title,
      required this.icon,
      required this.route});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      color: Colors.white,
      elevation: 15,
      shadowColor: Colors.grey.withOpacity(0.5),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => route));
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, size: 80, color: Colors.lightGreen),
              Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
