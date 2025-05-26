// File: lib/features/widgets/instructions_section.dart
import 'package:flutter/material.dart';

class InstructionsSection extends StatelessWidget {
  const InstructionsSection({super.key, required this.instructions});

  final List<String> instructions;

  @override
  Widget build(BuildContext context) {
    // This was your "Cute Instructions Section"
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: const Color.fromARGB(255, 241, 181, 212),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 241, 181, 212).withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 241, 181, 212),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.receipt_long_outlined,
                  color: const Color.fromARGB(255, 67, 47, 21),
                  size: 20,
                ),
              ),
              SizedBox(width: 12),
              Text(
                'Instructions',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 67, 47, 21),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          ...instructions.asMap().entries.map((entry) {
            return Container(
              margin: EdgeInsets.only(bottom: 12),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 248, 231),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: const Color.fromARGB(
                    255,
                    241,
                    181,
                    212,
                  ).withOpacity(0.5),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 241, 181, 212),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${entry.key + 1}',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 67, 47, 21),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: TextStyle(
                        fontSize: 16,
                        color: const Color.fromARGB(255, 67, 47, 21),
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
