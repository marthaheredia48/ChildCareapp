//
//  PremiumSheet.swift
//  ChildCare
//
//  Created by Martha Heredia Andrade on 19/10/25.
//

import SwiftUI
import StoreKit

struct PremiumSheet: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedPlan: PremiumPlan = .yearly
    
    enum PremiumPlan {
        case monthly
        case yearly
        
        var title: String {
            switch self {
            case .monthly: return "Mensual"
            case .yearly: return "Anual"
            }
        }
        
        var price: String {
            switch self {
            case .monthly: return "$9.99"
            case .yearly: return "$79.99"
            }
        }
        
        var savings: String? {
            switch self {
            case .monthly: return nil
            case .yearly: return "Ahorra 33%"
            }
        }
    }
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.93, green: 0.6, blue: 0.73),
                    Color(red: 0.85, green: 0.7, blue: 1.0)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Spacer()
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 32, height: 32)
                            .background(Color.white.opacity(0.2))
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                
                ScrollView {
                    VStack(spacing: 32) {
                        // Icon y título
                        VStack(spacing: 16) {
                            Image(systemName: "crown.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.yellow)
                            
                            Text("ChildCare Premium")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("Desbloquea todo el potencial de ChildCare")
                                .font(.system(size: 16))
                                .foregroundColor(.white.opacity(0.9))
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 20)
                        
                        // Features
                        VStack(spacing: 20) {
                            PremiumFeature(
                                icon: "calendar.badge.plus",
                                title: "Calendario ilimitado",
                                description: "Registra todas las citas y vacunas sin límite"
                            )
                            
                            PremiumFeature(
                                icon: "heart.text.square.fill",
                                title: "Diario de salud completo",
                                description: "Historial médico completo y exportable"
                            )
                            
                            PremiumFeature(
                                icon: "sparkles",
                                title: "Contenido exclusivo",
                                description: "Acceso a todos los artículos y consejos premium"
                            )
                            
                            PremiumFeature(
                                icon: "person.2.fill",
                                title: "Comunidad privada",
                                description: "Únete a nuestra comunidad de padres premium"
                            )
                            
                            PremiumFeature(
                                icon: "bell.badge.fill",
                                title: "Recordatorios personalizados",
                                description: "Notificaciones inteligentes adaptadas a tu bebé"
                            )
                            
                            PremiumFeature(
                                icon: "icloud.fill",
                                title: "Backup en la nube",
                                description: "Sincronización automática en todos tus dispositivos"
                            )
                        }
                        .padding(.horizontal, 20)
                        
                        // Plan selector
                        VStack(spacing: 12) {
                            PlanCard(
                                plan: .yearly,
                                isSelected: selectedPlan == .yearly,
                                action: { selectedPlan = .yearly }
                            )
                            
                            PlanCard(
                                plan: .monthly,
                                isSelected: selectedPlan == .monthly,
                                action: { selectedPlan = .monthly }
                            )
                        }
                        .padding(.horizontal, 20)
                        
                        // Subscribe button
                        Button(action: {
                            handlePurchase()
                        }) {
                            Text("Comenzar prueba gratuita de 7 días")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(Color(red: 0.93, green: 0.6, blue: 0.73))
                                .frame(maxWidth: .infinity)
                                .frame(height: 54)
                                .background(Color.white)
                                .cornerRadius(16)
                        }
                        .padding(.horizontal, 20)
                        
                        // Footer text
                        VStack(spacing: 8) {
                            Text("Luego \(selectedPlan.price)/\(selectedPlan.title.lowercased())")
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text("Cancela cuando quieras")
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.6))
                        }
                        .padding(.bottom, 20)
                    }
                }
            }
        }
    }
    
    private func handlePurchase() {
        // Aquí implementarías la lógica de compra con StoreKit
        print("Iniciando compra: \(selectedPlan)")
        
        /*
         Implementación real con StoreKit 2:
         
         Task {
             do {
                 let product = try await Product.products(for: ["premium_monthly", "premium_yearly"]).first
                 if let product = product {
                     let result = try await product.purchase()
                     
                     switch result {
                     case .success(let verification):
                         // Verificar la transacción
                         // Desbloquear premium en tu app
                         dismiss()
                     case .userCancelled:
                         print("Usuario canceló")
                     case .pending:
                         print("Compra pendiente")
                     @unknown default:
                         break
                     }
                 }
             } catch {
                 print("Error: \(error)")
             }
         }
         */
    }
}

struct PremiumFeature: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.white)
                .frame(width: 48, height: 48)
                .background(Color.white.opacity(0.2))
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.8))
            }
            
            Spacer()
        }
    }
}

struct PlanCard: View {
    let plan: PremiumSheet.PremiumPlan
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(plan.title)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(isSelected ? Color(red: 0.93, green: 0.6, blue: 0.73) : .white)
                    
                    if let savings = plan.savings {
                        Text(savings)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(isSelected ? Color(red: 0.93, green: 0.6, blue: 0.73) : .white.opacity(0.8))
                    }
                }
                
                Spacer()
                
                Text(plan.price)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(isSelected ? Color(red: 0.93, green: 0.6, blue: 0.73) : .white)
            }
            .padding(20)
            .background(
                isSelected ? Color.white : Color.white.opacity(0.2)
            )
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color.white : Color.clear, lineWidth: 2)
            )
        }
    }
}
