import 'package:flutter/material.dart';

class HeaderAndInfo extends StatelessWidget {
  final String headertext;
  final String infotext;

  const HeaderAndInfo({required this.headertext, required this.infotext});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            headertext,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: <Widget>[
              const Icon(
                Icons.info,
                color: Colors.black54,
              ),
              const SizedBox(
                width: 8.0,
              ),
              Text(
                infotext,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
