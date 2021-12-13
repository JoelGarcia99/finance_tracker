import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_tracker/areas/api.areas.dart';
import 'package:finance_tracker/areas/model.area.dart';
import 'package:finance_tracker/assembler/assembler.dart';
import 'package:finance_tracker/auth/api/api.auth.dart';
import 'package:finance_tracker/auth/models/model.user.dart';
import 'package:finance_tracker/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({ Key? key }) : super(key: key);

  final nameController = TextEditingController();
  final lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          _sectionDivider(context, Icons.person_outline, "Personal data"),
          _getUserDataFields(context),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _sectionDivider(context, Icons.monetization_on_outlined, "Finance areas"),
              _getCreationBtn(context)
            ],
          ),
          _getUserFinanceAreas(context)
        ],
      )
    );
  }

  Widget _getCreationBtn(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.add_circle_outline),
      onPressed: ()async{

        final areaName = TextEditingController();
        final areaDescription = TextEditingController();

        showDialog(
          context: context, 
          builder: (context) {
            return AlertDialog(
              title: const Text("Add a new Area"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _getInputField(
                      context, 
                      controller: areaName, 
                      placeholder: 'The area name',
                      leadingIcon: Icons.money, 
                      name: "Area name"
                    ),
                    _getInputField(
                      context, 
                      controller: areaDescription,
                      placeholder: 'A short description',
                      leadingIcon: Icons.text_fields, 
                      name: "Area description"
                    ),
                    TextButton.icon(
                      icon: Icon(Icons.save_outlined, color: Theme.of(context).textTheme.headline4?.color),
                      label: Text(
                        "Save",
                        style: TextStyle(color: Theme.of(context).textTheme.headline4?.color),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.secondary
                        )
                      ),
                      onPressed: () async {
                        SmartDialog.showLoading(msg: "Creating");

                        final name = areaName.text;
                        final desc = areaDescription.text;

                        if(name.trim().isEmpty) {
                          SmartDialog.showToast("Name cannot be empty");
                          SmartDialog.dismiss();
                          return;
                        }

                        if(desc.trim().isEmpty) {
                          SmartDialog.showToast("Description cannot be empty");
                          return;
                        }

                        await AreasAPI().createArea(AreaModel(
                          description: areaDescription.text,
                          name: areaName.text,
                          balance: [],
                          capital: 0.0,
                        ));

                        SmartDialog.dismiss();
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar( const SnackBar(
                          content: Text("The area has been added")
                        ));
                      },
                    )
                  ],
                ),
              )
            );
          }
        );

      },
    );
  }

  Widget _getUserFinanceAreas(BuildContext context) {

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: AreasAPI().queryAreasStream,
      builder: (context, snapshot) {
        if(!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator(),);
        }

        final data = snapshot.data!.docs;

        if(data.isEmpty) {
          return const Center(
            child: Text("No finance areas"),
          );
        }

        List<TableRow> rows = [];

        for(int i = 0; i<data.length; i+=2) {
          final area = AreaModel.fromJSON(data.toList()[i].data());
          final area2 = (i+1 == data.length)? null:AreaModel.fromJSON(data.toList()[i + 1].data());

          TableRow row = TableRow(
            children: [
              _areaWidget(
                context, area,
                onPress: ()=>Navigator.of(context).pushNamed(RouteNames.area.toString(), arguments: data.toList()[i])
              ),
              area2 != null? _areaWidget(
                context, area2,
                onPress: ()=>Navigator.of(context).pushNamed(RouteNames.area.toString(), arguments: data.toList()[i+1])
              ):Container(),
            ]
          );

          rows.add(row);
        }

        return Table(
          children: rows,
        );
      },
    );
  }

  Widget _areaWidget(BuildContext context, AreaModel area, {required onPress}) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(10.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10.0)
        ),
        child: Column(
          children: [
            Text(
              area.name,
              style: Theme.of(context).textTheme.headline4
            ),
            Text(area.description)
          ],
        ),
      ),
    );
  }

  Padding _sectionDivider(BuildContext context, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
      child: Row(
        children: [
          Icon(icon),
          Text(
            "\t$text",
            style: Theme.of(context).textTheme.headline4,
          ),
        ],
      ),
    );
  }

  Widget _getUserDataFields(BuildContext context) {

    return StreamBuilder<UserModel?>(
      stream: Wrapper().currentUserStream,
      initialData: Wrapper().currentUser,
      builder: (context, snapshot) {
        if(!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        nameController.text = snapshot.data!.name ?? 'Not defined';
        lastNameController.text = snapshot.data!.lastName ?? 'Not defined';

        return Column(
          children: [
            _getInputField(
              context,
              controller: nameController,
              leadingIcon: Icons.text_fields_outlined,
              name: "Name",
              placeholder: "Your name",
            ),
            _getInputField(
              context,
              controller: lastNameController,
              leadingIcon: Icons.text_fields_outlined,
              name: "Last Name",
              placeholder: "Your last name",
            ),
            TextButton.icon(
              icon: const Icon(Icons.save_outlined, color: Colors.white,),
              label: const Text(
                "Update info",
                style: TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.secondary)
              ),
              onPressed: () async {
                SmartDialog.showLoading(msg: 'Updating');
                try {
                  await AuthAPI().updateUser({
                    'name': nameController.text,
                    'last_name': lastNameController.text
                  });
                }catch(e) {
                  SmartDialog.show(widget: const Text("Error trying to update the user"));
                }finally {
                  SmartDialog.dismiss();
                }

              },
            )
          ],
        );
      }
    );
  }

  
  Widget _getInputField(BuildContext context, {
    required TextEditingController controller,
    required String placeholder,
    required IconData leadingIcon,
    required String name,
    TextInputType keyboard = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        enabled: true,
        keyboardType: keyboard,
        cursorColor: Colors.white,
        initialValue: controller.text,
        decoration: InputDecoration(
          hintText: placeholder,
          icon: Icon(leadingIcon, color: Theme.of(context).iconTheme.color),
          labelText: name,
          labelStyle: TextStyle(
            color: Theme.of(context).textTheme.headline5?.color
          )
        ),
        onChanged: (value) => controller.text = value,
        onSaved: (value) => controller.text = value ?? '',
      ),
    );
  }
}