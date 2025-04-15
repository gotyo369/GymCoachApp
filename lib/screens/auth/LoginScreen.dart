import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _email = "";
  String _password = "";

  @override
  void initState() {
    super.initState();
    _checkCurrentUser();
  }

  void _checkCurrentUser() async {
    // Verifica si el usuario ya está autenticado
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      // Si está autenticado, navega a HomeScreen
      // Este codigo se dispara despues de que el metodo build haya construido los widgets
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
      });
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        // El usuario canceló el inicio de sesión
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      final User? user = userCredential.user;

      // Almacenar información del usuario en Firestore
      if (user != null) {
        final userRef = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid);

        await userRef.set({
          'email': user.email,
          'name': user.displayName,
          'lastname': '',
          'profilePic': user.photoURL,
          'phone': user.phoneNumber,
          'username':
              user.email!.split(
                '@',
              )[0], // Asumiendo que el nombre de usuario es la parte antes de '@'
          'username_lowercase':
              user.email!
                  .split('@')[0]
                  .toLowerCase(), // Asumiendo que el nombre de usuario es la parte antes de '@'
        }, SetOptions(merge: true));
      }

      Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
    } catch (e) {
      print("Error al iniciar sesión con Google: $e");
    }
  }

  void _signInWithEmailAndPassword() async {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      try {
        await _auth.signInWithEmailAndPassword(
          email: _email,
          password: _password,
        );
        Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
        // Navegar a la pantalla principal o alguna otra pantalla de la aplicación.
        print('USUARIO LOGEADO');
      } catch (e) {
        // Manejar errores de inicio de sesión, por ejemplo, mostrar un mensaje de error.
        print("Error al iniciar sesión: $e");
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
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
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
              Container(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Implementar la funcionalidad para olvidar contraseña
                    Navigator.pushNamed(context, 'forgot/password');
                  },
                  child: Text(
                    "¿Olvidaste tu contraseña?",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: _signInWithEmailAndPassword,
                child: Text(
                  "Iniciar sesión",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              ),
              SizedBox(height: 12.0),
              ElevatedButton(
                onPressed: _signInWithGoogle,
                child: Text(
                  "Iniciar sesión con Google",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
              SizedBox(height: 12.0),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    'register', // Ir a la pantalla de registro
                  );
                },
                child: Text(
                  "¿No tienes una cuenta? Regístrate",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
