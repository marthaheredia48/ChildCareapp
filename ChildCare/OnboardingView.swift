//
//  OnboardingView.swift
//  ChildCare
//
//  Created by Martha Heredia Andrade on 19/10/25.
//

import SwiftUI

struct OnboardingView: View {
    @State private var showAuthView = false
    @State private var authViewMode: AuthViewMode = .login
    
    enum AuthViewMode {
        case login
        case signUp
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.white
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    Spacer()
                    
                    // Logo y título
                    VStack(spacing: 12) {
                        Text("ChildCare")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.black)
                        
                        Text("Para padres y madres primerizos")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.gray)
                    }
                    .padding(.bottom, 60)
                    
                    // Features list
                    VStack(spacing: 32) {
                        FeatureRow(
                            icon: "calendar",
                            iconColor: .gray.opacity(0.3),
                            title: "Calendario de Vacunas",
                            subtitle: "Recordatorios y seguimiento de vacunas"
                        )
                        
                        FeatureRow(
                            icon: "heart.fill",
                            iconColor: Color(red: 1.0, green: 0.7, blue: 0.7),
                            title: "Diario de Salud",
                            subtitle: "Registro de síntomas y evolución"
                        )
                        
                        FeatureRow(
                            icon: "person.2.circle.fill",
                            iconColor: Color(red: 0.85, green: 0.7, blue: 1.0),
                            title: "Consejos Educativos",
                            subtitle: "Aprende sobre el desarrollo infantil"
                        )
                    }
                    .padding(.horizontal, 40)
                    
                    Spacer()
                    
                    // Botones de acción
                    VStack(spacing: 16) {
                        // Botón de REGISTRARSE - lleva a crear cuenta
                        Button(action: {
                            authViewMode = .signUp
                            showAuthView = true
                        }) {
                            Text("Registrarse")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                                .background(
                                    Color(red: 0.93, green: 0.6, blue: 0.73)
                                )
                                .cornerRadius(12)
                        }
                        
                        // Botón de INICIAR SESIÓN
                        Button(action: {
                            authViewMode = .login
                            showAuthView = true
                        }) {
                            Text("Iniciar sesión")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(Color(red: 0.93, green: 0.6, blue: 0.73))
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                                .background(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color(red: 0.93, green: 0.6, blue: 0.73), lineWidth: 1.5)
                                )
                                .cornerRadius(12)
                        }
                        
                        Text("Al registrarte, aceptas nuestros Términos y\nPolítica de Privacidad")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.top, 8)
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 40)
                }
            }
            .navigationDestination(isPresented: $showAuthView) {
                // Aquí especificamos si mostrar login o registro
                AuthView(startWithLogin: authViewMode == .login)
            }
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack(spacing: 20) {
            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundColor(iconColor)
                .frame(width: 50, height: 50)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.black)
                
                Text(subtitle)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView()
}
