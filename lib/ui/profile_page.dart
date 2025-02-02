import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prelovedrelux/bloc/user_bloc/user_bloc.dart';
import 'package:prelovedrelux/data/model/user/user_model.dart';
import 'package:prelovedrelux/ui/component/text_field.dart';
import 'dart:developer';

import '../data/datasource/shared_preferences_service.dart';
import '../data/datasource/user_repository.dart';
import '../di/service_locator.dart';

class ProfilePage extends StatefulWidget {
  final UserRepository userRepository;

  const ProfilePage({super.key, required this.userRepository});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final addressController = TextEditingController();
  final sharedPrefService = serviceLocator<SharedPreferencesService>();
  UserModel user = UserModel.empty;

  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(GetMyUser(myUserId: sharedPrefService.uid));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
        listener: (context, state) {},
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            user = state.user ?? UserModel.empty;
            addressController.text = user.address ?? "";
            log(user.toString());
            return ProfileScreen(
              providers: const [],
              actions: [
                DisplayNameChangedAction((context, oldName, newName) {
                  setState(() {
                    context
                        .read<UserBloc>()
                        .add(SetUserData(user: user.copyWith(name: newName)));
                  });
                }),
                SignedOutAction((context) {
                  Navigator.pushReplacementNamed(context, '/sign-in');
                }),
                AccountDeletedAction((context, user) {
                  Navigator.pushReplacementNamed(context, '/sign-in');
                })
              ],
              children: [
                Card(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Spacer(
                        flex: 1,
                      ),
                      const Icon(Icons.account_balance_wallet),
                      Text('Rp.${(state.user?.balance ?? 0).toString()}'),
                      const Expanded(flex: 3, child: Spacer()),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Padding(padding: EdgeInsets.all(4.0)),
                          IconButton(
                            icon: const Icon(Icons.add_box),
                            tooltip: 'Top Up',
                            onPressed: () {
                              context.read<UserBloc>().add(SetUserData(
                                  user: user.copyWith(
                                      balance: (user.balance ?? 0) + 10000)));
                            },
                          ),
                          const Text('Top Up'),
                          const Padding(padding: EdgeInsets.all(4.0)),
                        ],
                      ),
                      const Spacer(
                        flex: 1,
                      ),
                    ],
                  ),
                ),
                MyTextField(
                    controller: addressController,
                    hintText: 'Address',
                    obscureText: false,
                    keyboardType: TextInputType.streetAddress,
                    prefixIcon: const Icon(Icons.location_city),
                    textInputAction: TextInputAction.done,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Please fill in this field';
                      }
                      return null;
                    }),
                ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        context.read<UserBloc>().add(SetUserData(
                            user: user.copyWith(
                                address: addressController.text)));
                      });
                    },
                    icon: const Icon(Icons.save),
                    label: const Text("Save"))
              ],
            );
          },
        ));
  }
}
