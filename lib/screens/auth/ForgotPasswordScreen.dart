import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _email = "";

  void _resetPassword() async {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      try {
        await _auth.sendPasswordResetEmail(email: _email);
        // Mostrar mensaje de éxito o navegar a una pantalla de éxito.
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Correo enviado"),
              content: Text(
                  "Se ha enviado un enlace para restablecer la contraseña a su correo electrónico."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Cerrar el diálogo
                    Navigator.pop(context); // Regresar a la pantalla de inicio de sesión
                  },
                  child: Text("Aceptar"),
                ),
              ],
            );
          },
        );
      } catch (e) {
        // Manejar errores, por ejemplo, mostrar un mensaje de error.
        print("Error al enviar el correo electrónico de restablecimiento de contraseña: $e");
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
              Text(
                "¿Olvidaste tu contraseña?",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12.0),
              Text(
                "Ingresa tu correo electrónico y te enviaremos un enlace para restablecer tu contraseña.",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.0),
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
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: _resetPassword,
                child: Text(
                  "Enviar",
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
    );
  }
}
