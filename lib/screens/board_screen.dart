import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visionary_project/constants.dart';
import 'package:visionary_project/core/vision_item.dart';
import 'package:visionary_project/core/vision_provider.dart';
import 'package:visionary_project/widgets/add_item_form.dart';
import 'package:visionary_project/widgets/vision_item_card.dart';
import 'package:visionary_project/widgets/vision_side_bar.dart';

/// A screen that displays the vision board
class BoardScreen extends ConsumerStatefulWidget {
  const BoardScreen({super.key});

  @override
  BoardScreenState createState() => BoardScreenState();
}

/// State class for BoardScreen
class BoardScreenState extends ConsumerState<BoardScreen> {
  /// Builds the form to add a new vision item
  Future<dynamic> buildAddForm(
    BuildContext context,
    VisionItemsNotifier visionItemsNotifier,
  ) {
    return showModalBottomSheet(
      context: context,
      builder: (context) => AddItemForm(
        onSubmit: (itemText, imageUrl) async {
          Navigator.pop(context);
          await visionItemsNotifier.addOrUpdateItem(
            itemText,
            imageUrl,
            null,
          );
        },
      ),
    );
  }

  /// Builds the form to edit an existing vision item
  Future<dynamic> buildEditForm(
    BuildContext context,
    VisionItem visionItem,
    VisionItemsNotifier visionItemsNotifier,
  ) {
    return showModalBottomSheet(
      context: context,
      builder: (context) => AddItemForm(
        initialImageUrl: visionItem.imageUrl,
        initialItemText: visionItem.itemText,
        onSubmit: (itemText, imageUrl) async {
          Navigator.pop(context);
          await visionItemsNotifier.addOrUpdateItem(
            itemText,
            imageUrl,
            visionItem,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Watches the visionItemsProvider for changes
    final visionItemsAsyncValue = ref.watch(visionItemsProvider);

    // Reads the visionItemsNotifierProvider to get the notifier
    final visionItemsNotifier = ref.read(visionItemsNotifierProvider.notifier);

    /// Builds the grid of vision items
    Widget visionGrid() {
      return Expanded(
        child: visionItemsAsyncValue.when(
          data: (visionItems) {
            return GridView.builder(
              padding: const EdgeInsets.all(30),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 600,
                crossAxisSpacing: 30,
                mainAxisSpacing: 30,
              ),
              itemCount: visionItems.length,
              itemBuilder: (context, index) {
                final visionItem = visionItems[index];
                editForm() => buildEditForm(
                      context,
                      visionItem,
                      visionItemsNotifier,
                    );
                return VisionItemCard(
                  visionItem: visionItem,
                  onEdit: editForm,
                  onDelete: () async => await visionItemsNotifier.deleteItem(
                    visionItem.id,
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(child: Text('Error: $error')),
        ),
      );
    }

    return Scaffold(
      body: Stack(children: [
        // the background image
        Positioned.fill(
          child: Image.asset(
            'assets/images/bg.jpg',
            fit: BoxFit.contain,
            repeat: ImageRepeat.repeat,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        // row that contains the side bar and the grid of vision items
        Row(
          children: [
            // a class that builds the side bar
            VisionDrawer(
                color: Theme.of(context)
                    .colorScheme
                    .secondaryContainer
                    .withValues(alpha: .8),
                signOut: () {
                  ref.read(authProvider.notifier).signOut();
                  Navigator.pushReplacementNamed(context, Constants.authScreen);
                },
                addItem: () => buildAddForm(context, visionItemsNotifier),
                onReload: () => ref.invalidate(visionItemsProvider)),
            // a function that returns a grid of vision items
            visionGrid(),
          ],
        ),
      ]),
    );
  }
}
