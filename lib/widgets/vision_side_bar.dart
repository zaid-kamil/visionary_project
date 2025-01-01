import 'package:flutter/material.dart';

/// A drawer widget for the Visionary app
class VisionDrawer extends StatelessWidget {
  /// The background color of the drawer
  final Color color;

  /// Callback function to handle sign out action
  final VoidCallback signOut;

  /// Callback function to handle add item action
  final VoidCallback addItem;

  /// Callback function to handle reload action
  final VoidCallback onReload;

  /// Constructor for VisionDrawer
  const VisionDrawer({
    super.key,
    required this.color,
    required this.signOut,
    required this.addItem,
    required this.onReload,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      elevation: 2,
      width: 400,
      shadowColor: Colors.grey,
      backgroundColor: color,
      child: Column(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Center(
              child: Text("V I S I O N A R Y"),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.add_box),
            title: const Text('A D D   I T E M'),
            onTap: addItem,
          ),
          ListTile(
            leading: const Icon(Icons.refresh),
            title: const Text('R E L O A D'),
            onTap: onReload,
          ),
          const Spacer(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('L O G O U T'),
            onTap: signOut,
          ),
        ],
      ),
    );
  }
}
