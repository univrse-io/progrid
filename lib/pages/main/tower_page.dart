import 'package:flutter/material.dart';
import 'package:progrid/components/my_button.dart';
import 'package:progrid/models/tower_provider.dart';
import 'package:progrid/services/themes.dart';

class TowerPage extends StatelessWidget {
  // should we pass index callback instead? to be able to access provider?
  final Tower tower;

  const TowerPage({super.key, required this.tower});

  // UI function to build a detail row format
  Widget _buildDetailRow(String label, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // label
          SizedBox(
            width: 90,
            child: Text(
              label,
              textAlign: TextAlign.right,
              style: TextStyle(
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
          ),
          const SizedBox(width: 5),
          
          // content (potentially multiline)
          Expanded(
            child: Text(
              content,
              style: TextStyle(
                fontSize: 17,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // use appbar for back buttons
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 34),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // tower id
            Text(
              tower.id,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontStyle: FontStyle.italic,
              ),
            ),

            // tower name
            Text(
              tower.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),

            // tower geopoint
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'LatLong:',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  '${tower.position.latitude.toStringAsFixed(6)}, ${tower.position.longitude.toStringAsFixed(6)}',
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // tower status
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Status:',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(width: 5),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: tower.status == 'Surveyed' ? AppColors.green : AppColors.red,
                  ),
                  child: Text(
                    tower.status,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.surface,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 1,
              child: Container(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                const Text(
                  'Site Details',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 5),
                IconButton(
                  icon: Icon(Icons.edit_note, size: 34),
                  onPressed: () {
                    // TODO: implement engineer-side site editing
                  },
                )
              ],
            ),
            const SizedBox(height: 0),

            // site address
            _buildDetailRow('Address:', tower.address),
            // site region
            _buildDetailRow('Region:', tower.region),
            // site type
            _buildDetailRow('Type:', tower.type),
            // site owner
            _buildDetailRow('Owner:', tower.owner),
            const SizedBox(height: 20),

            const Text(
              'All Site Reports',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Create New Report',
              style: TextStyle(
                decoration: TextDecoration.underline,
                fontStyle: FontStyle.italic,
                fontSize: 15,
                color: Theme.of(context).colorScheme.secondary
              ),
            ),
            const SizedBox(height: 5),
            Expanded(
              child: Column(), // TODO: implement site reports
            ),
            MyButton(
              text: "View Issues",
              onTap: () {} // TODO: implement site issues,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
