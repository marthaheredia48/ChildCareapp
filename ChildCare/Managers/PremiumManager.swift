//
//  PremiumManager.swift
//  ChildCare
//
//  Created by Martha Heredia Andrade on 19/10/25.
//

import StoreKit
import SwiftUI
import Combine

@MainActor
class PremiumManager: ObservableObject {
    @Published var isPremium = false
    @Published var products: [Product] = []
    @Published var purchasedSubscriptions: [Product] = []
    @Published var isLoading = false
    
    private let productIDs = [
        "childcare_premium_monthly",
        "childcare_premium_yearly"
    ]
    
    private var updateListenerTask: Task<Void, Error>?
    
    init() {
        // Escuchar actualizaciones de transacciones
        updateListenerTask = listenForTransactions()
        
        Task {
            await loadProducts()
            await updatePurchasedProducts()
        }
    }
    
    deinit {
        updateListenerTask?.cancel()
    }
    
    // MARK: - Cargar productos
    func loadProducts() async {
        isLoading = true
        
        do {
            let loadedProducts = try await Product.products(for: productIDs)
            products = loadedProducts.sorted { $0.price < $1.price }
            print("✅ Productos cargados: \(products.count)")
        } catch {
            print("❌ Error loading products: \(error)")
        }
        
        isLoading = false
    }
    
    // MARK: - Comprar producto
    func purchase(_ product: Product) async throws -> Bool {
        print("🛒 Iniciando compra de: \(product.displayName)")
        
        let result = try await product.purchase()
        
        switch result {
        case .success(let verification):
            // Verificar la transacción
            let transaction = try checkVerified(verification)
            
            // Actualizar estado
            await updatePurchasedProducts()
            
            // Finalizar transacción
            await transaction.finish()
            
            print("✅ Compra exitosa")
            return true
            
        case .userCancelled:
            print("⚠️ Usuario canceló la compra")
            return false
            
        case .pending:
            print("⏳ Compra pendiente de aprobación")
            return false
            
        @unknown default:
            print("❓ Estado desconocido")
            return false
        }
    }
    
    // MARK: - Verificar transacción
    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified(let unverifiedResult, let error):
            print("❌ Transacción no verificada: \(error)")
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        }
    }
    
    // MARK: - Actualizar suscripciones compradas
    func updatePurchasedProducts() async {
        var newPurchasedSubscriptions: [Product] = []
        
        // Iterar sobre todas las transacciones actuales
        for await result in Transaction.currentEntitlements {
            do {
                let transaction = try checkVerified(result)
                
                // Verificar que no esté revocada
                if transaction.revocationDate == nil {
                    if let product = products.first(where: { $0.id == transaction.productID }) {
                        newPurchasedSubscriptions.append(product)
                    }
                }
            } catch {
                print("❌ Error verificando transacción: \(error)")
            }
        }
        
        purchasedSubscriptions = newPurchasedSubscriptions
        isPremium = !purchasedSubscriptions.isEmpty
        
        print(isPremium ? "✅ Usuario es Premium" : "ℹ️ Usuario no es Premium")
    }
    
    // MARK: - Escuchar actualizaciones de transacciones
    private func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            for await result in Transaction.updates {
                // Verificar la transacción sin llamar a checkVerified desde Task.detached
                guard case .verified(let transaction) = result else {
                    continue
                }
                
                await self.updatePurchasedProducts()
                
                await transaction.finish()
            }
        }
    }
    
    // MARK: - Restaurar compras
    func restorePurchases() async throws {
        print("🔄 Restaurando compras...")
        
        do {
            try await AppStore.sync()
            await updatePurchasedProducts()
            print("✅ Compras restauradas")
        } catch {
            print("❌ Error restaurando compras: \(error)")
            throw error
        }
    }
    
    // MARK: - Verificar estado de suscripción
    func checkSubscriptionStatus() async {
        guard let subscription = purchasedSubscriptions.first else {
            isPremium = false
            return
        }
        
        guard let statuses = try? await subscription.subscription?.status else {
            return
        }
        
        var isActive = false
        
        for status in statuses {
            switch status.state {
            case .subscribed, .inGracePeriod:
                isActive = true
            case .revoked, .expired:
                isActive = false
            default:
                break
            }
        }
        
        isPremium = isActive
    }
    
    // MARK: - Obtener fecha de expiración
    func getExpirationDate() async -> Date? {
        for await result in Transaction.currentEntitlements {
            do {
                let transaction = try checkVerified(result)
                if transaction.revocationDate == nil {
                    // Retornamos la fecha de expiración de la transacción
                    return transaction.expirationDate
                }
            } catch {
                print("❌ Error verificando transacción: \(error)")
            }
        }
        return nil
    }


    // MARK: - Verificar si está en periodo de prueba
    func isInTrialPeriod() async -> Bool {
        guard let subscription = purchasedSubscriptions.first else {
            return false
        }
        
        guard let statuses = try? await subscription.subscription?.status else {
            return false
        }
        
        for status in statuses {
            if case .verified(let renewalInfo) = status.renewalInfo {
                return renewalInfo.offerType == .introductory
            }
        }
        
        return false
    }
}

// MARK: - Store Errors
enum StoreError: Error, LocalizedError {
    case failedVerification
    case purchaseFailed
    case productNotFound
    
    var errorDescription: String? {
        switch self {
        case .failedVerification:
            return "La verificación de la compra falló. Por favor intenta de nuevo."
        case .purchaseFailed:
            return "No se pudo completar la compra. Verifica tu método de pago."
        case .productNotFound:
            return "El producto solicitado no está disponible."
        }
    }
}

// MARK: - UserDefaults Extension para Premium
extension UserDefaults {
    private enum Keys {
        static let isPremium = "isPremium"
        static let premiumExpirationDate = "premiumExpirationDate"
    }
    
    var isPremiumUser: Bool {
        get { bool(forKey: Keys.isPremium) }
        set { set(newValue, forKey: Keys.isPremium) }
    }
    
    var premiumExpirationDate: Date? {
        get { object(forKey: Keys.premiumExpirationDate) as? Date }
        set { set(newValue, forKey: Keys.premiumExpirationDate) }
    }
}
