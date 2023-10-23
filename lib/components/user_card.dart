import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final String userPhone;
  final String userEmail;
  final Image userGender;
  final Function() pressToDelete;
  final Function() pressToEdite;
  

  const UserCard(
      {super.key,
      required this.userPhone,
      required this.userEmail,
      required this.userGender,
      required this.pressToDelete,
      required this.pressToEdite
      });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: ListTile(
        title: Text(
          userEmail,
          style:const TextStyle(
               //color: Colors.grey[700],
               fontSize: 14,
        ),),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: userGender,
        ),
        subtitle: Text(
          userPhone,
          style:const TextStyle(
              // color: Colors.white,
              // fontSize: 5,
        ),),
        textColor: const Color.fromARGB(255, 93, 73, 129),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                icon: const Icon(
                  Icons.edit,
                  color: Colors.blue,
                ),
                onPressed: pressToEdite),
            IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: pressToDelete
            ),
          ],
        ),
      ),
    );
  }
}
