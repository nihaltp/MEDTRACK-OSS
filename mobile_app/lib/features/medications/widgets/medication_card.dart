import 'package:flutter/material.dart';
import '../../../models/medication.dart';

class MedicationCard extends StatelessWidget {
  final Medication medication;
  final VoidCallback onEdit;
  final VoidCallback? onTakeDose;

  const MedicationCard({
    super.key,
    required this.medication,
    required this.onEdit,
    this.onTakeDose,
  });

  @override
  Widget build(BuildContext context) {
    // Accessibility: Ensure high contrast for critical states
    bool isLowInventory = medication.pillsRemaining < 10;
    bool needsDoctorAuth = isLowInventory && (medication.refillsRemaining == null || medication.refillsRemaining == 0);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2, // Slight elevation for better contrast against background
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isLowInventory 
                ? const Color(0xFFD32F2F) // High contrast Red (700)
                : medication.isActive
                    ? medication.color.withValues(alpha: 0.4)
                    : Colors.grey[400]!, // Clearer 'Inactive' state
            width: isLowInventory ? 2 : 1.5,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Icon with high contrast backing
                Badge(
                  isLabelVisible: isLowInventory,
                  backgroundColor: const Color(0xFFD32F2F),
                  alignment: Alignment.topRight,
                  offset: const Offset(4, -4),
                  label: const Icon(Icons.warning, size: 12, color: Colors.white),
                  child: Container(
                    decoration: BoxDecoration(
                      color: medication.color.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      medication.icon,
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Medication Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              medication.name,
                              style: const TextStyle(
                                fontSize: 18, // Slightly larger for readability
                                fontWeight: FontWeight.w800,
                                color: Colors.black, // Force high contrast black
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: medication.isActive
                                  ? const Color(0xFF1B5E20)
                                      .withValues(alpha: 0.12) // Darker green
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(6),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            child: Text(
                              medication.isActive ? 'ACTIVE' : 'INACTIVE',
                              style: TextStyle(
                                fontSize: 10,
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.w900,
                                color: medication.isActive
                                    ? const Color(0xFF1B5E20) // Deep Green (900)
                                    : Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        medication.dosage,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF212121), // High contrast charcoal
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        medication.frequency,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF424242),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    size: 18, // Slightly larger icon
                    color: Colors.black87,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      medication.purpose,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Refill Warning Section (High Contrast Emphasis)
            if (isLowInventory) ...[
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF1F0),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFD32F2F), width: 1),
                ),
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      size: 24,
                      color: Color(0xFFD32F2F),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            needsDoctorAuth 
                              ? 'ACTION REQUIRED: Contact Doctor' 
                              : 'LOW SUPPLY ALERT',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFB71C1C),
                            ),
                          ),
                          Text(
                            needsDoctorAuth 
                              ? '0 refilling attempts remaining for this prescription.' 
                              : 'Only ${medication.pillsRemaining} pills available in current stock.',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFB71C1C),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        Icons.schedule_rounded,
                        size: 18,
                        color: medication.isActive ? medication.color : Colors.grey[600],
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'NEXT DOSE: ${medication.nextDue}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: medication.isActive
                                ? medication.color
                                : Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (onTakeDose != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ElevatedButton.icon(
                      onPressed: onTakeDose,
                      icon: const Icon(Icons.check_circle_outline, size: 16),
                      label: const Text('LOG DOSE'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E7D32), // High contrast Green (800)
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        elevation: 0,
                        textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                OutlinedButton(
                  onPressed: onEdit,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    side: const BorderSide(color: Colors.black26),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text(
                    'EDIT',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Colors.black54),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
