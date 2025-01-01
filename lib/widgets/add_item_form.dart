import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:visionary_project/constants.dart';

/// A form widget for adding or editing a vision item
class AddItemForm extends StatelessWidget {
  /// The initial text for the item
  final String initialItemText;

  /// The initial URL for the image
  final String initialImageUrl;

  /// Callback function to handle form submission
  final Function(String, String) onSubmit;

  /// Constructor for AddItemForm
  const AddItemForm({
    super.key,
    this.initialItemText = '',
    this.initialImageUrl = '',
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormBuilderState>();

    saveForm() {
      if (formKey.currentState?.saveAndValidate() ?? false) {
        final itemText = formKey.currentState?.fields['itemText']?.value;
        final imageUrl = formKey.currentState?.fields['imageUrl']?.value;
        onSubmit(itemText ?? '', imageUrl ?? '');
      }
    }

    Widget formField(String name, String labelText, IconData icon) {
      return FormBuilderTextField(
        name: name,
        initialValue: name == 'itemText' ? initialItemText : initialImageUrl,
        decoration: InputDecoration(
          labelText: labelText,
          icon: Icon(icon),
        ),
        validator: FormBuilderValidators.required(),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FormBuilder(
        key: formKey,
        child: Column(
          spacing: 20,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Heading
            const Text(
              Constants.addVisionItem,
              style: TextStyle(fontSize: 24),
            ),
            // Text field for item text
            formField('itemText', Constants.itemText, Icons.text_fields),
            // Text field for image URL
            formField('imageUrl', Constants.imageUrl, Icons.image),
            // Save button
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton(
                onPressed: saveForm,
                child: const Text(Constants.saveVisionItem),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
