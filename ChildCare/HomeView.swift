//
//  HomeView.swift
//  ChildCare
//
//  Created by Martha Heredia Andrade on 19/10/25.
//

import SwiftUI

struct HomeView: View {
    @State private var selectedBaby: Baby? = nil
    @State private var babies: [Baby] = [] // Se cargarán de tu base de datos
    @State private var selectedTab = 0
    @State private var showBabySelector = false
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Tab 1: Inicio
            HomeContentView(selectedBaby: $selectedBaby, babies: $babies)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Inicio")
                }
                .tag(0)
            
            // Tab 2: Calendario
            CalendarView(selectedBaby: $selectedBaby)
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Calendario")
                }
                .tag(1)
            
            // Tab 3: Diario
            DiaryView(selectedBaby: $selectedBaby)
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("Diario")
                }
                .tag(2)
            
            // Tab 4: Aprende (no depende del bebé)
            LearnView()
                .tabItem {
                    Image(systemName: "book.closed.fill")
                    Text("Aprende")
                }
                .tag(3)
            
            // Tab 5: Perfil 
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Perfil")
                }
                .tag(4)
        }
        .accentColor(Color(red: 0.93, green: 0.6, blue: 0.73))
        .onAppear {
            loadBabies()
        }
    }
    
    private func loadBabies() {
        // Aquí cargarías los bebés desde Firebase/Base de datos
        // Por ahora datos de ejemplo
        babies = [
            Baby(name: "Sofía", birthDate: Calendar.current.date(byAdding: .month, value: -3, to: Date()) ?? Date(), gender: "girl"),
            Baby(name: "Daniel", birthDate: Calendar.current.date(byAdding: .year, value: -1, to: Date()) ?? Date(), gender: "boy")
        ]
        selectedBaby = babies.first
    }
}

// MARK: - Home Content View
struct HomeContentView: View {
    @Binding var selectedBaby: Baby?
    @Binding var babies: [Baby]
    @State private var showBabySelector = false
    @State private var showPremiumSheet = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header con selector de bebé
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("¡Buenos días!")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.black)
                            
                            Text(getCurrentDate())
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        // Selector de bebé
                        Button(action: {
                            showBabySelector = true
                        }) {
                            HStack(spacing: 8) {
                                // Foto del bebé (placeholder)
                                Circle()
                                    .fill(selectedBaby?.gender == "girl" ?
                                          Color.pink.opacity(0.3) :
                                          Color.blue.opacity(0.3))
                                    .frame(width: 32, height: 32)
                                    .overlay(
                                        Text(String(selectedBaby?.name.prefix(1) ?? "B"))
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(selectedBaby?.gender == "girl" ? .pink : .blue)
                                    )
                                
                                Text(selectedBaby?.name ?? "Bebé")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(.black)
                                
                                Image(systemName: "chevron.down")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(20)
                        }
                        
                        // Notificaciones
                        Button(action: {}) {
                            ZStack(alignment: .topTrailing) {
                                Image(systemName: "bell.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(.gray)
                                
                                Circle()
                                    .fill(Color(red: 0.93, green: 0.6, blue: 0.73))
                                    .frame(width: 8, height: 8)
                                    .offset(x: 2, y: -2)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    
                    // Próxima vacuna
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Próxima vacuna")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.black)
                            
                            Spacer()
                            
                            Button(action: {}) {
                                Text("Ver todas")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(red: 0.93, green: 0.6, blue: 0.73))
                            }
                        }
                        
                        VaccineCard(
                            name: "Pentavalente",
                            date: "En 3 días - 8 de Octubre"
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    // Tu racha
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            HStack(spacing: 8) {
                                Text("Tu racha")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.black)
                                
                                Image(systemName: "flame.fill")
                                    .foregroundColor(.orange)
                            }
                            
                            Spacer()
                            
                            Text("7 días")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color(red: 0.93, green: 0.6, blue: 0.73))
                        }
                        
                        StreakCard(
                            message: "¡Sigue así! Estás cuidando muy bien la salud de \(selectedBaby?.name ?? "tu bebé")."
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    // Premium Banner
                    PremiumBannerCard(action: {
                        showPremiumSheet = true
                    })
                    .padding(.horizontal, 20)
                    
                    // Tips de salud
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Tips de salud")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.black)
                            
                            Spacer()
                            
                            Button(action: {}) {
                                Text("Ver más")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(red: 0.93, green: 0.6, blue: 0.73))
                            }
                        }
                        
                        HealthTipCard(
                            title: "Cuidados después de la vacunación",
                            description: "Qué hacer si tu bebé presenta fiebre leve después de una vacuna...",
                            isPremium: false
                        )
                        
                        HealthTipCard(
                            title: "Desarrollo del habla en bebés",
                            description: "Señales importantes que debes observar en los primeros meses...",
                            isPremium: true
                        )
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
            .background(Color.white)
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showBabySelector) {
            BabySelectorSheet(babies: babies, selectedBaby: $selectedBaby)
        }
        .sheet(isPresented: $showPremiumSheet) {
            PremiumSheet()
        }
    }
    
    private func getCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_ES")
        formatter.dateFormat = "EEEE, d 'de' MMMM"
        return formatter.string(from: Date()).capitalized
    }
}

// MARK: - Vaccine Card
struct VaccineCard: View {
    let name: String
    let date: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "calendar")
                .font(.system(size: 24))
                .foregroundColor(Color(red: 0.93, green: 0.6, blue: 0.73))
                .frame(width: 50, height: 50)
                .background(Color(red: 0.93, green: 0.6, blue: 0.73).opacity(0.15))
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.black)
                
                Text(date)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

// MARK: - Streak Card
struct StreakCard: View {
    let message: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "medal.fill")
                .font(.system(size: 24))
                .foregroundColor(Color(red: 0.93, green: 0.6, blue: 0.73))
            
            Text(message)
                .font(.system(size: 14))
                .foregroundColor(.black)
                .lineLimit(2)
            
            Spacer()
        }
        .padding(16)
        .background(Color(red: 0.93, green: 0.6, blue: 0.73).opacity(0.1))
        .cornerRadius(12)
    }
}

// MARK: - Premium Banner Card
struct PremiumBannerCard: View {
    let action: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Mejora a Premium")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            
            Text("Desbloquea todas las funciones y obtén acceso a nuestra comunidad exclusiva")
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.9))
                .lineLimit(2)
            
            Button(action: action) {
                Text("Ver planes")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(Color(red: 0.93, green: 0.6, blue: 0.73))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.white)
                    .cornerRadius(8)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.93, green: 0.6, blue: 0.73),
                    Color(red: 0.85, green: 0.7, blue: 1.0)
                ]),
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .cornerRadius(16)
    }
}

// MARK: - Health Tip Card
struct HealthTipCard: View {
    let title: String
    let description: String
    let isPremium: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                
                Spacer()
                
                if isPremium {
                    Image(systemName: "crown.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.orange)
                }
            }
            
            Text(description)
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .lineLimit(2)
            
            Button(action: {}) {
                Text("Leer más")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(red: 0.93, green: 0.6, blue: 0.73))
            }
            .padding(.top, 4)
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

// MARK: - Baby Selector Sheet
struct BabySelectorSheet: View {
    @Environment(\.dismiss) var dismiss
    let babies: [Baby]
    @Binding var selectedBaby: Baby?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(babies) { baby in
                    Button(action: {
                        selectedBaby = baby
                        dismiss()
                    }) {
                        HStack(spacing: 12) {
                            Circle()
                                .fill(baby.gender == "girl" ?
                                      Color.pink.opacity(0.3) :
                                      Color.blue.opacity(0.3))
                                .frame(width: 44, height: 44)
                                .overlay(
                                    Text(String(baby.name.prefix(1)))
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(baby.gender == "girl" ? .pink : .blue)
                                )
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(baby.name)
                                    .font(.system(size: 17, weight: .medium))
                                    .foregroundColor(.black)
                                
                                Text(getAge(from: baby.birthDate))
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            if selectedBaby?.id == baby.id {
                                Image(systemName: "checkmark")
                                    .foregroundColor(Color(red: 0.93, green: 0.6, blue: 0.73))
                            }
                        }
                    }
                }
            }
            .navigationTitle("Seleccionar bebé")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cerrar") {
                        dismiss()
                    }
                    .foregroundColor(Color(red: 0.93, green: 0.6, blue: 0.73))
                }
            }
        }
    }
    
    private func getAge(from birthDate: Date) -> String {
        let components = Calendar.current.dateComponents([.year, .month], from: birthDate, to: Date())
        if let years = components.year, years > 0 {
            return "\(years) \(years == 1 ? "año" : "años")"
        } else if let months = components.month {
            return "\(months) \(months == 1 ? "mes" : "meses")"
        }
        return "Recién nacido"
    }
}

// MARK: - Placeholder Views (crear después)
struct CalendarView: View {
    @Binding var selectedBaby: Baby?
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Calendario de \(selectedBaby?.name ?? "Bebé")")
                    .font(.title)
            }
            .navigationTitle("Calendario")
        }
    }
}

struct DiaryView: View {
    @Binding var selectedBaby: Baby?
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Diario de \(selectedBaby?.name ?? "Bebé")")
                    .font(.title)
            }
            .navigationTitle("Diario")
        }
    }
}

struct LearnView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Aprende")
                    .font(.title)
            }
            .navigationTitle("Aprende")
        }
    }
}

struct ProfileView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Perfil del usuario")
                    .font(.title)
            }
            .navigationTitle("Perfil")
        }
    }
}

#Preview {
    HomeView()
}
