import 'package:findmyfun/services/services.dart';
import 'package:findmyfun/themes/themes.dart';
import 'package:findmyfun/widgets/widgets.dart';
import 'package:findmyfun/models/models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsersListViewScreen extends StatefulWidget {
  const UsersListViewScreen({super.key});

  @override
  State<UsersListViewScreen> createState() => _UsersListViewScreenState();
}

class _UsersListViewScreenState extends State<UsersListViewScreen> {
  @override
  void initState() {
    final usersService = Provider.of<UsersService>(context, listen: false);
    Future.delayed(Duration.zero, () async => await usersService.getUsers());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final usersService = Provider.of<UsersService>(context);
    // final users = usersService.users;
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            leading: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.chevron_left,
                  size: 45,
                  color: ProjectColors.secondary,
                )),
            backgroundColor: ProjectColors.primary,
            elevation: 0,
            centerTitle: true,
            title: Text('USUARIOS',
                textAlign: TextAlign.center, style: Styles.appBar),
          ),
          backgroundColor: ProjectColors.primary,
          body: Column(children: [
            const SizedBox(
              height: 20,
            ),
            UsersContainer(
              child: _UsersColumn(
                users: usersService.users,
              ),
            )
          ])),
    );
  }
}

class _UsersColumn extends StatelessWidget {
  final List<User> users;
  const _UsersColumn({required this.users});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        SizedBox(
            height: 500,
            width: 325,
            child: ListView.separated(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                    title: Text('${user.name} ${user.surname}'),
                    subtitle: Text('${user.username} \n${user.email}'),
                    onTap: () => Navigator.pushNamed(context, 'profileAdmin',
                        arguments: user));
              },
              separatorBuilder: (context, index) => const Divider(),
            )),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
