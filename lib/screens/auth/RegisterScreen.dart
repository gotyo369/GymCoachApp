import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _email = "";
  String _password = "";
  String _nombre = "";
  String _apellido = "";
  String _telefono = "";
  String _username = "";

  void _registerWithEmailAndPassword() async {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      try {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );
        print('USUARIO REGISTRO');
        // Guardar datos en Firestore
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'email': _email,
          'name': _nombre,
          'lastname': _apellido,
          'phone': _telefono,
          'username': _username,
          'profilePic': null,
          'bio': '',
          'username_lowercase': _username.toLowerCase(),
        });
        print('NUEVO USUARIO EN LA BASE DATOS');
         Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
        // Navegar a la pantalla principal o alguna otra pantalla de la aplicación después del registro exitoso.
      } catch (e) {
        // Manejar errores de registro, por ejemplo, mostrar un mensaje de error.
        print("Error al registrarse: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Regresar a la pantalla de inicio de sesión
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Image.asset(
                  "assets/img/instaclone.png", // Reemplaza con la ruta de tu imagen de logo de Instagram
                  height: 50,
                ),
                SizedBox(height: 48.0),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "Correo electrónico",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Por favor, introduce tu correo electrónico";
                    }
                    return null;
                  },
                  onSaved: (value) => _email = value!,
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: "Nombre de usuario",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Por favor, introduce tu nombre de usuario";
                    }
                    return null;
                  },
                  onSaved: (value) => _username = value!,
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Nombre",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Por favor, introduce tu nombre";
                    }
                    return null;
                  },
                  onSaved: (value) => _nombre = value!,
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Apellido",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Por favor, introduce tu apellido";
                    }
                    return null;
                  },
                  onSaved: (value) => _apellido = value!,
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: "Teléfono",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Por favor, introduce tu teléfono";
                    }
                    return null;
                  },
                  onSaved: (value) => _telefono = value!,
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Contraseña",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Por favor, introduce tu contraseña";
                    }
                    return null;
                  },
                  onSaved: (value) => _password = value!,
                ),
                SizedBox(height: 24.0),
                ElevatedButton(
                  onPressed: _registerWithEmailAndPassword,
                  child: Text(
                    "Registrarse",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
