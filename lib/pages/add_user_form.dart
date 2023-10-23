import 'package:flutter/material.dart';
import '../models/crud_fonction.dart';
import '../models/user.dart';
import '../services/sqllite_service.dart';

class AddOrUpdateUserForm extends StatefulWidget {
  final User? user;
  final Function(User)? updateUserList;

  const AddOrUpdateUserForm({super.key, this.user, this.updateUserList});

  _AddOrUpdateUserFormState createState() => _AddOrUpdateUserFormState();
}

class _AddOrUpdateUserFormState extends State<AddOrUpdateUserForm> {
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _genderController = TextEditingController(); // Contrôleur pour le genre
  String _selectedGender = 'male';

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      _emailController.text = widget.user!.email;
      _phoneController.text = widget.user!.phone;
      _genderController.text = widget.user!.gender;
      _selectedGender = widget.user!.gender;
    }
  }

  //*Ajouter un Utilisateur
  Future<void> _addUser() async {
    await SqliteService.createData(
        _genderController.text, _emailController.text, _phoneController.text);
    await UserService.getUsers();
  }

//* Mettre a jour un Utilisateur
  Future<void> _upDateUser(int id) async {
    await UserService.updateUser(id, _genderController.text,
        _emailController.text, _phoneController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user == null
            ? 'Ajouter un utilisateur'
            : 'Modifier un utilisateur'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 50,
              ),

              //formulaire pour le genre
              DropdownButtonFormField<String>(
                onChanged: (selectedGender) {
                  setState(() {
                    _selectedGender = selectedGender!;
                    _genderController.text = selectedGender;
                  });
                },
                items: const [
                  DropdownMenuItem<String>(
                    value: 'male',
                    child: Text('Male'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'female',
                    child: Text('Female'),
                  ),
                ],
                decoration: const InputDecoration(
                  labelText: 'Genre',
                  prefixIcon: Icon(Icons.wc),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              //email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email), // Icône pour l'email
                ),
              ),
              const SizedBox(
                height: 10,
              ),

              //numero de telephone
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Téléphone',
                  prefixIcon: Icon(Icons.phone), // Icône pour le téléphone
                ),
              ),
              const SizedBox(
                height: 10,
              ),

              //Bouton d'ajout
              ElevatedButton(
                onPressed: () async {
                  print('ajouter ou modifier un user');

                  final email = _emailController.text;
                  final gender = _genderController.text;
                  final phone = _phoneController.text;
                  if (email.isEmpty || gender.isEmpty || phone.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.deepOrange,
                        content: Text(
                            'Veuillez remplir tous les champs obligatoires.'),
                            duration:Duration(milliseconds: 2000),
                      ),
                      
                    );
                  } else {
                    if (widget.user == null) {
                      await _addUser();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        backgroundColor: Colors.green,
                        content: Text('Utilisateur ajouter avec succes'),
                        duration:Duration(milliseconds: 500),
                      ));
                    } else {
                      await _upDateUser(widget.user!.id!);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        backgroundColor: Color.fromARGB(255, 108, 77, 114),
                        content: Text('Utilisateur mise a jour avec succes'),
                        duration:Duration(milliseconds: 1100),
                      ));
                    }
                    _emailController.text = '';
                    _genderController.text = '';
                    _phoneController.text = '';
                    Navigator.of(context).pop();
                    await UserService.getUsers();
                  }
                },
                child: Text(
                  widget.user == null ? "Ajouter" : "Modifier",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
