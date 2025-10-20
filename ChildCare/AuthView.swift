//
//  AuthView.swift
//  ChildCare
//
//  Created by Martha Heredia Andrade on 19/10/25.
//

import SwiftUI
import AuthenticationServices

struct AuthView: View {
    @Environment(\.dismiss) var dismiss
    @State private var isLogin: Bool
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var name = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var showBabyProfileSetup = false // 👈 NUEVO
    
    // Inicializador que permite especificar si mostrar login o registro
    init(startWithLogin: Bool = true) {
        _isLogin = State(initialValue: startWithLogin)
    }
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header con botón de regreso
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.black)
                            .frame(width: 44, height: 44)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                
                ScrollView {
                    VStack(spacing: 32) {
                        // Logo y título
                        VStack(spacing: 12) {
                            Text("ChildCare")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.black)
                            
                            Text(isLogin ? "Inicia sesión en tu cuenta" : "Crea tu cuenta")
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 20)
                        
                        // Formulario
                        VStack(spacing: 20) {
                            // Campo de nombre (solo para registro)
                            if !isLogin {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Nombre completo")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.gray)
                                    
                                    TextField("Tu nombre", text: $name)
                                        .font(.system(size: 16))
                                        .padding()
                                        .background(Color.gray.opacity(0.08))
                                        .cornerRadius(12)
                                        .autocapitalization(.words)
                                }
                            }
                            
                            // Campo de email
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Correo electrónico")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.gray)
                                
                                TextField("ejemplo@correo.com", text: $email)
                                    .font(.system(size: 16))
                                    .padding()
                                    .background(Color.gray.opacity(0.08))
                                    .cornerRadius(12)
                                    .keyboardType(.emailAddress)
                                    .autocapitalization(.none)
                            }
                            
                            // Campo de contraseña
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Contraseña")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.gray)
                                
                                SecureField("••••••••", text: $password)
                                    .font(.system(size: 16))
                                    .padding()
                                    .background(Color.gray.opacity(0.08))
                                    .cornerRadius(12)
                            }
                            
                            // Confirmar contraseña (solo para registro)
                            if !isLogin {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Confirmar contraseña")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.gray)
                                    
                                    SecureField("••••••••", text: $confirmPassword)
                                        .font(.system(size: 16))
                                        .padding()
                                        .background(Color.gray.opacity(0.08))
                                        .cornerRadius(12)
                                }
                            }
                            
                            // Olvidé mi contraseña (solo para login)
                            if isLogin {
                                HStack {
                                    Spacer()
                                    Button(action: {
                                        alertMessage = "Funcionalidad de recuperación de contraseña próximamente"
                                        showingAlert = true
                                    }) {
                                        Text("¿Olvidaste tu contraseña?")
                                            .font(.system(size: 14))
                                            .foregroundColor(Color(red: 0.93, green: 0.6, blue: 0.73))
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 32)
                        
                        // Botón principal
                        Button(action: {
                            handleMainAction()
                        }) {
                            Text(isLogin ? "Iniciar sesión" : "Crear cuenta")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                                .background(
                                    Color(red: 0.93, green: 0.6, blue: 0.73)
                                )
                                .cornerRadius(12)
                        }
                        .padding(.horizontal, 32)
                        .padding(.top, 8)
                        
                        // Divisor
                        HStack(spacing: 16) {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 1)
                            
                            Text("o")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                            
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 1)
                        }
                        .padding(.horizontal, 32)
                        
                        // Botones de redes sociales
                        VStack(spacing: 12) {
                            SocialButton(
                                icon: "apple.logo",
                                text: "Continuar con Apple",
                                action: handleAppleSignIn
                            )
                            
                            SocialButton(
                                icon: "g.circle.fill",
                                text: "Continuar con Google",
                                action: handleGoogleSignIn
                            )
                        }
                        .padding(.horizontal, 32)
                        
                        // Toggle entre login y registro
                        Button(action: {
                            withAnimation {
                                isLogin.toggle()
                                // Limpiar campos al cambiar
                                clearFields()
                            }
                        }) {
                            HStack(spacing: 4) {
                                Text(isLogin ? "¿No tienes cuenta?" : "¿Ya tienes cuenta?")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                                
                                Text(isLogin ? "Regístrate" : "Inicia sesión")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(Color(red: 0.93, green: 0.6, blue: 0.73))
                            }
                        }
                        .padding(.top, 8)
                        
                        if !isLogin {
                            Text("Al registrarte, aceptas nuestros Términos y\nPolítica de Privacidad")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.bottom, 20)
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .alert("ChildCare", isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
        // 👇 AQUÍ SE CONECTA CON BabyProfileSetupView
        .fullScreenCover(isPresented: $showBabyProfileSetup) {
            BabyProfileSetupView()
        }
    }
    
    // MARK: - Funciones de validación y acciones
    
    private func handleMainAction() {
        if isLogin {
            handleLogin()
        } else {
            handleSignUp()
        }
    }
    
    private func handleLogin() {
        // Validaciones básicas
        guard !email.isEmpty else {
            alertMessage = "Por favor ingresa tu correo electrónico"
            showingAlert = true
            return
        }
        
        guard !password.isEmpty else {
            alertMessage = "Por favor ingresa tu contraseña"
            showingAlert = true
            return
        }
        
        // Aquí va tu lógica de Firebase o backend
        print("Iniciar sesión con:")
        print("Email: \(email)")
        print("Password: \(password)")
        
        // 👇 PARA LOGIN: Si el usuario ya existe, ir directo al Home
        // Si es nuevo usuario, ir a BabyProfileSetup
        // Por ahora, simulamos que ya tiene perfil configurado
        alertMessage = "Inicio de sesión exitoso"
        showingAlert = true
        
        // TODO: Aquí irías directo al HomeView/Dashboard
        // porque el usuario ya tiene perfil configurado
    }
    
    private func handleSignUp() {
        // Validaciones
        guard !name.isEmpty else {
            alertMessage = "Por favor ingresa tu nombre completo"
            showingAlert = true
            return
        }
        
        guard !email.isEmpty else {
            alertMessage = "Por favor ingresa tu correo electrónico"
            showingAlert = true
            return
        }
        
        guard email.contains("@") && email.contains(".") else {
            alertMessage = "Por favor ingresa un correo electrónico válido"
            showingAlert = true
            return
        }
        
        guard !password.isEmpty else {
            alertMessage = "Por favor ingresa una contraseña"
            showingAlert = true
            return
        }
        
        guard password.count >= 6 else {
            alertMessage = "La contraseña debe tener al menos 6 caracteres"
            showingAlert = true
            return
        }
        
        guard password == confirmPassword else {
            alertMessage = "Las contraseñas no coinciden"
            showingAlert = true
            return
        }
        
        // 👇 AQUÍ VA TU LÓGICA DE FIREBASE O BACKEND
        print("Registrar usuario:")
        print("Nombre: \(name)")
        print("Email: \(email)")
        print("Password: \(password)")
        
        // 🎯 DESPUÉS DE CREAR LA CUENTA EXITOSAMENTE:
        // Simular un pequeño delay como si estuviera registrando
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // Navegar a BabyProfileSetupView
            showBabyProfileSetup = true
        }
        
        /*
         En tu implementación real con Firebase sería algo así:
         
         Auth.auth().createUser(withEmail: email, password: password) { result, error in
             if let error = error {
                 alertMessage = error.localizedDescription
                 showingAlert = true
                 return
             }
             
             // Usuario creado exitosamente
             // Guardar el nombre en Firestore
             if let user = result?.user {
                 let db = Firestore.firestore()
                 db.collection("users").document(user.uid).setData([
                     "name": name,
                     "email": email,
                     "createdAt": Timestamp()
                 ]) { error in
                     if error == nil {
                         // Todo exitoso, ir a configurar perfil del bebé
                         showBabyProfileSetup = true
                     }
                 }
             }
         }
         */
    }
    
    private func handleAppleSignIn() {
        // Aquí implementas el inicio de sesión con Apple
        print("Iniciar sesión con Apple")
        alertMessage = "Función de Apple Sign In - Implementar con AuthenticationServices"
        showingAlert = true
        
        // Después de autenticar con Apple exitosamente:
        // showBabyProfileSetup = true
    }
    
    private func handleGoogleSignIn() {
        // Aquí implementas el inicio de sesión con Google
        print("Iniciar sesión con Google")
        alertMessage = "Función de Google Sign In - Implementar con GoogleSignIn SDK"
        showingAlert = true
        
        // Después de autenticar con Google exitosamente:
        // showBabyProfileSetup = true
    }
    
    private func clearFields() {
        email = ""
        password = ""
        confirmPassword = ""
        name = ""
    }
}

struct SocialButton: View {
    let icon: String
    let text: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(.black)
                
                Text(text)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.black)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
            .cornerRadius(12)
        }
    }
}

#Preview {
    AuthView()
}
