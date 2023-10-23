// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:test/components/user_card.dart';
import 'package:test/models/crud_fonction.dart';
import 'package:test/models/user.dart';
import 'package:test/pages/add_user_form.dart';
import 'package:test/services/sqllite_service.dart';
import 'package:test/services/user_api.dart';

class HomePage extends StatefulWidget {
  final User? user;
  const HomePage({super.key, this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<User> users = [];
  List<Map<String, dynamic>> _allUser = [];
  bool loading = false;
  List<User> filterUserList = [];
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
   checkIfDatabaseIsEmpty();
  }


  final TextEditingController? searchTextController = TextEditingController();

//* appel Api
  Future<void> fetchUsers() async {
    setState(() {
      loading = true;
    });
    final response = await UserApi.fetchUsers();
    //*insertion des donnees dans l'api
    for (var user in response) {
      int id = await SqliteService.createData(
        user.gender,
        user.email,
        user.phone,
      );
      if (id > 0) {
        print('insertion reussi');
      } else {
        // L'insertion a échoué
        print("Échec de l'insertion de l'utilisateur");
      }
    }

    await getUsersFromDatabase();
    setState(() {
      loading = false;
      filterUserList = response;
      users = response;
    });
  }

//*Fonction pour afficher les utilisateur de la base de donnee
  Future<void> getUsersFromDatabase() async {
    try {
      final userList = await UserService.getUsers();
      setState(() {
        users = userList.map((userData) => User.fromMap(userData)).toList();
        filterUserList = users;
        print('All users in database');
      });
    } catch (e) {
      print(e);
    }
  }

  //
  Future<void> checkIfDatabaseIsEmpty() async {
    final users = await SqliteService.getAllUser();
    if (users.isEmpty) {
      fetchUsers();
    } else {
      getUsersFromDatabase();
    }
  }

//* Supprimer un utilisateur
  void _deleteUser(int userId) async {
    try {
      await UserService.deleteUser(userId);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text('Utilisateur supprimer avec succes'),
        duration: Duration(milliseconds: 700),
      ));
    } catch (e) {
      print(e);
    }
    getUsersFromDatabase();
  }

//* find users
  void findUser(String value) {
    final filteredUsers = users.where((user) {
      return user.email.toLowerCase().contains(value.toLowerCase());
    }).toList();

    setState(() {
      filterUserList = filteredUsers;
      isSearching = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isSearching == false) {
      getUsersFromDatabase();
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[300],
        title: const Text(
          'Random users',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      drawer: const Drawer(),
      body: loading == true
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: (value) {
                      findUser(value);
                    },
                    decoration: const InputDecoration(
                        hintText: 'Rechercher un utilisateur',
                        labelText: 'seach',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        )),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: filterUserList.length,
                      itemBuilder: (context, index) {
                        final user = filterUserList[index];
                        final UserGender = user.gender == 'male'
                            ? Image.asset(
                                'assets/man1.png',
                              )
                            : Image.asset('assets/woman.png');

                        return UserCard(
                            userPhone: user.phone,
                            userEmail: user.email,
                            userGender: UserGender,
                            pressToDelete: () {
                              print('Suppression d\'utilisateur');
                              _deleteUser(users[index].id!);
                            },
                            pressToEdite: () {
                              print('mise a jour');
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddOrUpdateUserForm(
                                            user: user,
                                          ))).then((result) {
                                getUsersFromDatabase();
                              });
                            });
                      }),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent,
        onPressed: () {
          setState(() {
            isSearching = false;
          });
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddOrUpdateUserForm(),
              ));
        },
        child: const Icon(
          Icons.add,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
