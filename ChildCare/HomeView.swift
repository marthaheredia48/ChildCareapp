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
            
        
            // Tab 2: Calendario de Vacunas
            VaccineCalendarView(selectedBaby: $selectedBaby)
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
            ZStack {
                // 🌸 FONDO DEGRADADO ROSA PASTEL CON CÍRCULOS
                VStack {
                    ZStack {
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 1.0, green: 0.9, blue: 0.95), // Rosa muy claro
                                Color(red: 1.0, green: 0.85, blue: 0.92), // Rosa pastel
                                Color.white
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        
                        // Círculos difuminados pastel
                        Circle()
                            .fill(Color(red: 0.98, green: 0.75, blue: 0.85).opacity(0.3)) // Rosa
                            .frame(width: 300, height: 300)
                            .blur(radius: 60)
                            .offset(x: -100, y: -60)
                        
                        Circle()
                            .fill(Color(red: 0.92, green: 0.78, blue: 0.96).opacity(0.25)) // Lila
                            .frame(width: 250, height: 250)
                            .blur(radius: 50)
                            .offset(x: 150, y: 100)
                        
                        Circle()
                            .fill(Color(red: 1.0, green: 0.8, blue: 0.88).opacity(0.3))
                            .frame(width: 220, height: 220)
                            .blur(radius: 45)
                            .offset(x: -50, y: 220)
                    }
                    .frame(height: 500)
                    
                    Spacer()
                }
                .ignoresSafeArea()
                
          
                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        HStack  {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("¡Buenos días!")
                                    .font(.system(size: 27, weight: .bold))
                                    .foregroundColor(.black)
                                
                                Text(getCurrentDate())
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                            }
                            .padding(.top, 15)
                            
                            Spacer()
                            
                            // Selector de bebé
                            Button(action: {
                                showBabySelector = true
                            }) {
                                HStack(spacing: 8) {
                                    Circle()
                                        .fill(selectedBaby?.gender == "girl" ?
                                              Color.pink.opacity(0.3) :
                                              Color(red: 0.75, green: 0.85, blue: 1.0).opacity(0.3))
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
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(20)
                            }
                            
                            // Notificaciones
                            Button(action: {}) {
                                ZStack(alignment: .topTrailing) {
                                    Image(systemName: "bell.fill")
                                        .font(.system(size: 20))
                                        .foregroundColor(.gray)
                                    
                                    Circle()
                                        .fill(Color.pink)
                                        .frame(width: 8, height: 8)
                                        .offset(x: 2, y: -2)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                        
                        // 🌼 Tarjeta de vacuna
                        VStack(spacing: 16) {
                            Text("Próxima vacuna")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity, alignment: .center)
                            
                            VaccineCardCentered(
                                name: "Influenza",
                                daysUntil: 3,
                                fullDate: "23 de Octubre"
                            )
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        
                        
                        // Mis consejos diarios (estilo historias de Instagram)
                                               VStack(alignment: .leading, spacing: 16) {
                                                   Text("Mis consejos diarios")
                                                       .font(.system(size: 20, weight: .bold))
                                                       .foregroundColor(.black)
                                                       .padding(.horizontal, 20)
                                                   
                                                   DailyTipsStoriesView()
                                               }
                                               .padding(.top, 30)
                        // 🌸 Tips de salud
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("Registrar sintoma")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.black)
                                
                                Spacer()
                                
                                Button(action: {}) {
                                    Text("Ver más")
                                        .font(.system(size: 14))
                                        .foregroundColor(.pink)
                                }
                            }
                            
                            //HealthTipCard(
                            //    title: "Cuidados después de la vacunación",
                            //    description: "Qué hacer si tu bebé presenta fiebre leve después de una vacuna...",
                           //     isPremium: false
                         //   )
                            
                         //   HealthTipCard(
                        //       title: "Desarrollo del habla en bebés",
                         //       description: "Señales importantes que debes observar en los primeros meses...",
                         //       isPremium: true
                         //   )
                            
                            SymptomsSelectionView()
                                .padding(.bottom, 15)
                            
                            Text("Registrar hábito")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.black)
                            
                            HabitsTrackingView()
                                .padding(.bottom, 15)
                            
                            
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 30)
                        
                                               
                        
                        // 🌷 Banner premium
                        PremiumBannerCard(action: {
                            showPremiumSheet = true
                        })
                        .padding(.horizontal, 20)
                        .padding(.bottom, 30)
                    }
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

// MARK: - Tarjeta de vacuna versión rosa pastel
struct VaccineCardCentered: View {
    let name: String
    let daysUntil: Int
    let fullDate: String
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.3))
                    .frame(width: 150, height: 150)
                    .offset(x: -80, y: -30)
                
                Circle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 100, height: 100)
                    .offset(x: 100, y: 40)
                
                VStack(spacing: 16) {
                    Text("Vacunación en")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.95))
                    
                    Text("\(daysUntil) días")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text(name)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white.opacity(0.95))
                        .padding(.top, 4)
                }
                .frame(maxWidth: .infinity)
            }
            .frame(height: 180)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 1.0, green: 0.75, blue: 0.85),
                        Color(red: 0.98, green: 0.6, blue: 0.75)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            
            HStack(spacing: 12) {
                Image(systemName: "calendar")
                    .font(.system(size: 16))
                    .foregroundColor(.pink)
                
                Text(fullDate)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.black.opacity(0.7))
                
                Spacer()
                
                Button(action: {}) {
                    Text("Ver todas")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.pink)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color.white)
        }
        .cornerRadius(24)
        .shadow(color: Color.pink.opacity(0.25), radius: 20, x: 0, y: 10)
    }
}
// MARK: - Vaccine Card
struct VaccineCard1: View {
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





// MARK: - 🩺 SELECCIÓN DE SÍNTOMAS
struct SymptomsSelectionView: View {
    @State private var selectedSymptoms: Set<String> = []
    @State private var showSuccessAlert = false
    
    let symptoms = [
        Symptom(id: "fiebre", icon: "thermometer.medium", name: "Fiebre", color: Color(red: 1.0, green: 0.6, blue: 0.6)),
        Symptom(id: "tos", icon: "wind", name: "Tos", color: Color(red: 0.7, green: 0.85, blue: 1.0)),
        Symptom(id: "congestion", icon: "nose", name: "Congestión", color: Color(red: 0.85, green: 0.82, blue: 0.95)),
        Symptom(id: "diarrea", icon: "drop.fill", name: "Diarrea", color: Color(red: 0.95, green: 0.85, blue: 0.70)),
        Symptom(id: "vomito", icon: "exclamationmark.circle.fill", name: "Vómito", color: Color(red: 0.95, green: 0.75, blue: 0.85)),
        Symptom(id: "irritable", icon: "face.dashed", name: "Irritable", color: Color(red: 1.0, green: 0.85, blue: 0.92)),
        Symptom(id: "sarpullido", icon: "allergens", name: "Sarpullido", color: Color(red: 1.0, green: 0.80, blue: 0.80)),
        Symptom(id: "dolor", icon: "bandage.fill", name: "Dolor", color: Color(red: 0.92, green: 0.78, blue: 0.96))
    ]
    
    var body: some View {
        VStack(spacing: 12) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(symptoms) { symptom in
                        SymptomCard(
                            symptom: symptom,
                            isSelected: selectedSymptoms.contains(symptom.id)
                        )
                        .padding(.top,10)
                        .padding(.bottom,10)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                if selectedSymptoms.contains(symptom.id) {
                                    selectedSymptoms.remove(symptom.id)
                                } else {
                                    selectedSymptoms.insert(symptom.id)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
            
            // Botón para guardar síntomas
            if !selectedSymptoms.isEmpty {
                Button(action: {
                    saveSymptoms()
                }) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 16))
                        Text("Guardar síntomas (\(selectedSymptoms.count))")
                            .font(.system(size: 15, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
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
                    .cornerRadius(25)
                    .shadow(color: Color(red: 0.93, green: 0.6, blue: 0.73).opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .transition(.scale.combined(with: .opacity))
            }
        }
        .alert("Síntomas guardados", isPresented: $showSuccessAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Los síntomas se han registrado correctamente")
        }
    }
    
    private func saveSymptoms() {
        // TODO: Guardar en Firebase
        // Estructura sugerida en Firestore:
        // users/{userId}/babies/{babyId}/symptoms/{symptomId}
        // {
        //   date: Timestamp,
        //   symptoms: [String], // Array con los IDs de síntomas seleccionados
        //   babyId: String,
        //   createdAt: Timestamp
        // }
        
        /* CÓDIGO FIREBASE EJEMPLO:
        let db = Firestore.firestore()
        let userId = Auth.auth().currentUser?.uid ?? ""
        let babyId = selectedBaby?.id ?? ""
        
        let symptomData: [String: Any] = [
            "symptoms": Array(selectedSymptoms),
            "date": Timestamp(date: Date()),
            "babyId": babyId,
            "createdAt": Timestamp(date: Date())
        ]
        
        db.collection("users").document(userId)
            .collection("babies").document(babyId)
            .collection("symptoms").addDocument(data: symptomData) { error in
                if let error = error {
                    print("Error guardando síntomas: \(error.localizedDescription)")
                } else {
                    withAnimation {
                        showSuccessAlert = true
                        selectedSymptoms.removeAll()
                    }
                }
            }
        */
        
        // Por ahora simulamos el guardado
        withAnimation {
            showSuccessAlert = true
            selectedSymptoms.removeAll()
        }
    }
}

struct Symptom: Identifiable {
    let id: String
    let icon: String
    let name: String
    let color: Color
}

struct SymptomCard: View {
    let symptom: Symptom
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(isSelected ? symptom.color : symptom.color.opacity(0.3))
                    .frame(width: 60, height: 60)
                
                Image(systemName: symptom.icon)
                    .font(.system(size: 26))
                    .foregroundColor(isSelected ? .white : symptom.color.opacity(0.8))
            }
            
            Text(symptom.name)
                .font(.system(size: 13, weight: isSelected ? .semibold : .medium))
                .foregroundColor(isSelected ? .black : .gray)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 8)
       
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(isSelected ? Color.white : Color.clear)
                .shadow(color: isSelected ? symptom.color.opacity(0.2) : Color.clear, radius: 8, x: 0, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isSelected ? symptom.color : Color.gray.opacity(0.2), lineWidth: isSelected ? 2 : 1)
        )
        .scaleEffect(isSelected ? 1.05 : 1.0)
    }
}

// MARK: - SEGUIMIENTO DE HÁBITOS
struct HabitsTrackingView: View {
    @State private var showHabitSheet = false
    @State private var selectedHabit: Habit?
    
    let habits = [
        Habit(id: "alimentacion", icon: "fork.knife", name: "Alimentación", color: Color(red: 1.0, green: 0.75, blue: 0.85), description: "Comida", unit: "ml/oz"),
        Habit(id: "sueño", icon: "moon.zzz.fill", name: "Sueño", color: Color(red: 0.85, green: 0.82, blue: 0.95), description: "Siesta", unit: "horas"),
        Habit(id: "panal", icon: "water.waves", name: "Pañal", color: Color(red: 0.75, green: 0.85, blue: 1.0), description: "Cambio", unit: "tipo"),
        Habit(id: "bano", icon: "drop.circle.fill", name: "Baño", color: Color(red: 0.88, green: 0.95, blue: 0.82), description: "Duración", unit: "min")
    ]
    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(habits) { habit in
                        HabitCardHorizontal(habit: habit)
                            .onTapGesture {
                                selectedHabit = habit
                                showHabitSheet = true
                            }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .sheet(item: $selectedHabit) { habit in
            HabitRegistrationSheet(habit: habit, isPresented: $showHabitSheet)
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
    }
}

struct Habit: Identifiable {
    let id: String
    let icon: String
    let name: String
    let color: Color
    let description: String
    let unit: String
}

struct HabitCardHorizontal: View {
    let habit: Habit
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(habit.color.opacity(0.3))
                    .frame(width: 60, height: 60)
                
                Image(systemName: habit.icon)
                    .font(.system(size: 26))
                    .foregroundColor(habit.color.opacity(0.8))
            }
            
            VStack(spacing: 4) {
                Text(habit.name)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.black)
                
                Text("Registrar")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            
            // Botón circular +
            ZStack {
                Circle()
                    .fill(Color(red: 0.93, green: 0.6, blue: 0.73).opacity(0.15))
                    .frame(width: 32, height: 32)
                
                Image(systemName: "plus")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color(red: 0.93, green: 0.6, blue: 0.73))
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 12)
        .frame(width: 120)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(habit.color.opacity(0.2), lineWidth: 1)
        )
    }
}

// MARK: - Sheet para registrar hábito
struct HabitRegistrationSheet: View {
    let habit: Habit
    @Binding var isPresented: Bool
    @State private var value: String = ""
    @State private var notes: String = ""
    @State private var selectedTime = Date()
    @State private var showSuccessAlert = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Ícono del hábito
                    ZStack {
                        Circle()
                            .fill(habit.color.opacity(0.2))
                            .frame(width: 80, height: 80)
                        
                        Image(systemName: habit.icon)
                            .font(.system(size: 40))
                            .foregroundColor(habit.color)
                    }
                    .padding(.top, 20)
                    
                    // Título
                    Text("Registrar \(habit.name)")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.black)
                    
                    // Formulario
                    VStack(spacing: 5) {
                        // Hora
                        VStack(alignment: .center, spacing: 8) {
                          
                            
                            HStack(spacing: 10) {
                               
                                Text("Cambiar hora: ")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.gray)
                                DatePicker(
                                    "",
                                    selection: $selectedTime,
                                    displayedComponents: [.hourAndMinute]
                                )
                                .labelsHidden()
                                .datePickerStyle(.compact)
                                .tint(Color.pink)
                                .padding(.vertical, 8)
                            }
                            .padding(.horizontal, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 0)
                                    .fill(
                                        LinearGradient(
                                            colors: [Color.white.opacity(0.8), Color.white.opacity(0.5)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .shadow(color: Color.pink.opacity(0.2), radius: 6, x: 0, y: 3)
                            )
                        }


                        
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("\(habit.description) (\(habit.unit))")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.gray)
                            
                            TextField("Ejemplo: 120", text: $value)
                                .keyboardType(.numberPad)
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(12)
                        }
                        
                        // Notas opcionales
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Notas ")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.gray)
                            
                            TextEditor(text: $notes)
                                .frame(height: 100)
                                .padding(8)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Botón guardar
                    Button(action: {
                        saveHabit()
                    }) {
                        Text("Guardar registro")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
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
                            .shadow(color: Color(red: 0.93, green: 0.6, blue: 0.73).opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .padding(.horizontal, 20)
                    .disabled(value.isEmpty)
                    .opacity(value.isEmpty ? 0.5 : 1.0)
                    
                    Spacer()
                }
            }
            .navigationTitle("Nuevo registro")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancelar") {
                        isPresented = false
                    }
                    .foregroundColor(Color(red: 0.93, green: 0.6, blue: 0.73))
                }
            }
        }
        .alert("Registro guardado", isPresented: $showSuccessAlert) {
            Button("OK", role: .cancel) {
                isPresented = false
            }
        } message: {
            Text("El registro de \(habit.name) se ha guardado correctamente")
        }
    }
    
    private func saveHabit() {
        // TODO: Guardar en Firebase
        // Estructura sugerida en Firestore:
        // users/{userId}/babies/{babyId}/habits/{habitType}/{recordId}
        // {
        //   habitId: String, // "alimentacion", "sueno", "panal", "bano"
        //   value: String, // cantidad/duración
        //   unit: String, // "ml", "horas", etc
        //   time: Timestamp,
        //   notes: String,
        //   babyId: String,
        //   createdAt: Timestamp
        // }
        
        /* CÓDIGO FIREBASE EJEMPLO:
        let db = Firestore.firestore()
        let userId = Auth.auth().currentUser?.uid ?? ""
        let babyId = selectedBaby?.id ?? ""
        
        let habitData: [String: Any] = [
            "habitId": habit.id,
            "value": value,
            "unit": habit.unit,
            "time": Timestamp(date: selectedTime),
            "notes": notes,
            "babyId": babyId,
            "createdAt": Timestamp(date: Date())
        ]
        
        db.collection("users").document(userId)
            .collection("babies").document(babyId)
            .collection("habits").document(habit.id)
            .collection("records").addDocument(data: habitData) { error in
                if let error = error {
                    print("Error guardando hábito: \(error.localizedDescription)")
                } else {
                    withAnimation {
                        showSuccessAlert = true
                    }
                }
            }
        */
        
        // Por ahora simulamos el guardado
        showSuccessAlert = true
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



// MARK: - Modelo de datos para tips
struct DailyTip: Identifiable {
    let id: Int
    let title: String
    //let shortDescription: String
    let image: String
    let backgroundColor: Color
    let borderColor: Color
    let fullContent: String
}

// MARK: - Tarjeta individual (estilo historia de Instagram)
struct StoryCard: View {
    let tip: DailyTip
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Contenido de la tarjeta
            ZStack {
                // Fondo con color
                RoundedRectangle(cornerRadius: 20)
                    .fill(tip.backgroundColor)
                
                VStack(spacing: 12) {
                    // Ícono
                    Image(systemName: tip.image)
                        .font(.system(size: 40))
                        .foregroundColor(.white.opacity(0.9))
                    
                    // Título
                    Text(tip.title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 8)
                    
                    // Descripción corta o número
                  
                }
                .padding(16)
            }
            .frame(width: 140, height: 180)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(tip.borderColor, lineWidth: 0)
            )
        }
    }
}


// MARK: - CONSEJOS DIARIOS
struct DailyTipsStoriesView: View {
    @State private var selectedTip: DailyTip? = nil
    
    let tips: [DailyTip] = [
        DailyTip(
            id: 1,
            title: "Primeros días con tu bebé",
        //    shortDescription: "Consejos esenciales",
            image: "heart.circle.fill",
            backgroundColor: Color(red: 0.95, green: 0.75, blue: 0.80), // rosa más vivo
            borderColor: Color(red: 0.93, green: 0.6, blue: 0.73),
            fullContent: "Los primeros días con tu bebé pueden ser tan emocionantes como agotadores. Es normal sentirte abrumada al principio.\n\nAlgunos consejos:\n\n• Descansa cada vez que tu bebé duerma.\n• Acepta ayuda de familiares o amigos.\n• No te preocupes por tener todo perfecto; lo más importante es tu bienestar y el del bebé.\n• Escucha tu instinto: tú conoces mejor que nadie a tu hijo.\n\nCada día será una oportunidad para aprender juntos. 🌸"
        ),
        DailyTip(
            id: 2,
            title: "El baño del bebé",
        //    shortDescription: "Seguro y tranquilo",
            image: "drop.circle.fill",
            backgroundColor: Color(red: 0.60, green: 0.72, blue: 0.90), // azul malva que combina con rosa pastel
            borderColor: Color(red: 0.50, green: 0.65, blue: 0.85),
            
            fullContent: "Bañar a tu bebé puede ser un momento relajante si tomas algunas precauciones:\n\n• Usa agua tibia (alrededor de 37 °C).\n• Sujeta bien la cabeza y el cuello.\n• Usa jabón suave para bebés.\n• Sécalo con toalla suave y evita corrientes de aire.\n\nNo es necesario bañarlo todos los días; 2 o 3 veces por semana es suficiente al principio."
        ),
        DailyTip(
            id: 3,
            title: "Depresión posparto",
       //     shortDescription: "Busca apoyo",
            image: "heart.text.square.fill",
            backgroundColor: Color(red: 0.80, green: 0.60, blue: 0.85), // lila más intenso
            borderColor: Color(red: 0.75, green: 0.45, blue: 0.70), // borde lila más oscuro
            fullContent: "La depresión posparto es más común de lo que parece. No estás sola.\n\nSíntomas frecuentes:\n\n• Tristeza o irritabilidad constante\n• Fatiga extrema o falta de energía\n• Dificultad para vincularte con tu bebé\n• Cambios en el apetito o el sueño\n\nHabla con un profesional de la salud mental o con tu médico si sientes estos síntomas. Pedir ayuda es importante. 💜"
        ),
        DailyTip(
            id: 4,
            title: "Papás primerizos",
        //    shortDescription: "Apoyo y conexión",
            image: "figure.and.child.holdinghands",
            backgroundColor: Color(red: 0.30, green: 0.25, blue: 0.45), // morado oscuro (sin cambios)
            borderColor: Color(red: 0.50, green: 0.45, blue: 0.70),
            fullContent: "Ser papá primerizo es una aventura llena de emociones nuevas. Aunque no pases por los cambios físicos del embarazo, tu rol es igual de importante.\n\nConsejos para ti:\n\n• Involúcrate desde el principio: cambia pañales, arrulla, participa en la rutina.\n• Habla abiertamente con tu pareja sobre cómo se sienten.\n• No tengas miedo de pedir consejos o ayuda.\n• Tómate momentos para descansar y cuidar de ti también.\n\nTu presencia, calma y cariño son lo más valioso para tu bebé. 💙"
        )
    ]

    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(tips) { tip in
                    StoryCard(tip: tip)
                        .onTapGesture {
                            selectedTip = tip  // ← SOLO ESTO
                        }
                }
            }
            .padding(.horizontal, 20)
        }
 
        .fullScreenCover(item: $selectedTip) { tip in
            StoryDetailView(tip: tip) {
                selectedTip = nil  // ← AUTO-CIERRA
            }
        }
    }
}

// MARK: - StoryDetailView (SIMPLIFICADA - FULLSCREEN)
struct StoryDetailView: View {
    let tip: DailyTip
    let onDismiss: () -> Void  // ← SIN BINDING
    @State private var progress: CGFloat = 0
    
    var body: some View {
        ZStack {
           
            LinearGradient(
                gradient: Gradient(colors: [
                    tip.backgroundColor,
                    tip.backgroundColor.opacity(0.8)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 📏 BARRA PROGRESO
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color.white.opacity(0.3))
                            .frame(height: 3)
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: geometry.size.width * progress, height: 3)
                    }
                }
                .frame(height: 3)
                .padding(.horizontal, 16)
                
                // 👆 HEADER
                HStack {
                    Circle()
                        .fill(Color.white.opacity(0.3))
                        .frame(width: 35, height: 35)
                        .overlay(
                            Image(systemName: "heart.fill")
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                        )
                    
                    Text("Consejo del día")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: onDismiss) {  // ← CAMBIO
                        Image(systemName: "xmark")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(8)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                Spacer()
                

                VStack(spacing: 14) {
                    Image(systemName: tip.image)
                        .font(.system(size: 60))
                        .foregroundColor(.white)
                    
                    Text(tip.title)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text(tip.fullContent)
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        
                        .padding(.horizontal, 32)
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
 
                Button(action: onDismiss) {
                    HStack {
                        Text("Entendido")
                            .font(.system(size: 16, weight: .semibold))
                        Image(systemName: "checkmark")
                    }
                    .foregroundColor(tip.backgroundColor)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.white)
                    .cornerRadius(16)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 25)) {
                progress = 1.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 25) {
                onDismiss()  // ← CAMBIO
            }
        }
        .gesture(
            DragGesture(minimumDistance: 50)
                .onEnded { value in
                    if value.translation.height > 100 {
                        onDismiss()  // ← CAMBIO
                    }
                }
        )
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
