//
//  ProfileView.swift
//  ChildCare
//
//  Created by Martha Heredia Andrade on 26/10/25.
//

import SwiftUI
import PhotosUI

// MARK: - Models
struct Child: Identifiable {
    let id = UUID()
    var name: String
    var birthDate: Date
    var currentWeight: Double
    var currentHeight: Double
    var achievements: [Achievement] = []
    
    var ageText: String {
        let components = Calendar.current.dateComponents([.year, .month], from: birthDate, to: Date())
        let years = components.year ?? 0
        let months = components.month ?? 0
        
        if years == 0 {
            return "\(months) \(months == 1 ? "mes" : "meses")"
        } else {
            return "\(years) \(years == 1 ? "año" : "años") y \(months) \(months == 1 ? "mes" : "meses")"
        }
    }
}

struct Parent: Identifiable {
    let id = UUID()
    var name: String
    var age: String
    var email: String
    var password: String
}

struct Achievement: Identifiable {
    let id = UUID()
    var milestone: MilestoneType
    var date: Date
    var weight: Double
    var height: Double
    var headCircumference: Double
    var notes: String
    var photoData: Data?
}

enum MilestoneType: String, CaseIterable {
    // 0-12 meses (mensuales)
    case month1 = "Primer mes"
    case month2 = "Segundo mes"
    case month3 = "Tercer mes"
    case month4 = "Cuarto mes"
    case month5 = "Quinto mes"
    case month6 = "Sexto mes"
    case month7 = "Séptimo mes"
    case month8 = "Octavo mes"
    case month9 = "Noveno mes"
    case month10 = "Décimo mes"
    case month11 = "Onceavo mes"
    case month12 = "Doceavo mes"
    
    // 1-2 años (trimestrales)
    case quarter1 = "15 meses"
    case quarter2 = "18 meses"
    case quarter3 = "21 meses"
    case quarter4 = "24 meses (2 años)"
    
    // 2-5 años (anuales)
    case year3 = "3 años"
    case year4 = "4 años"
    case year5 = "5 años"
    
    var icon: String {
        switch self {
        case .month1: return "1.circle.fill"
        case .month2: return "2.circle.fill"
        case .month3: return "3.circle.fill"
        case .month4: return "4.circle.fill"
        case .month5: return "5.circle.fill"
        case .month6: return "6.circle.fill"
        case .month7: return "7.circle.fill"
        case .month8: return "8.circle.fill"
        case .month9: return "9.circle.fill"
        case .month10: return "10.circle"
        case .month11: return "11.circle"
        case .month12: return "12.circle"
        case .quarter1, .quarter2, .quarter3, .quarter4: return "calendar.circle.fill"
        case .year3, .year4, .year5: return "trophy.fill"
        }
    }
}

extension MilestoneType: Identifiable {
    var id: String { self.rawValue }
}

// MARK: - Main Profile View
struct ProfileView: View {
    @State private var child = Child(
        name: "Sofia Garcia",
        birthDate: Calendar.current.date(byAdding: .month, value: -27, to: Date())!,
        currentWeight: 12.5,
        currentHeight: 86
    )
    
    @State private var parent = Parent(
        name: "Martha Andrade Aparicio",
        age: "48 años y 8 meses",
        email: "mpatricia_andrade07@hotmail.com",
        password: "••••••••••••"
    )
    
    @State private var showingChildEdit = false
    @State private var showingParentEdit = false
    @State private var showingAchievements = false
    @State private var showingSupport = false
    @State private var showingTerms = false
    
    @State private var vaccineReminders = true
    @State private var dailyTips = true
    @State private var appUpdates = false
    @State private var showPremiumSheet = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Profile Section
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Perfil")
                            .font(.system(size: 32, weight: .bold))
                            .padding(.horizontal)
                        
                        // Child Profile Card
                        ProfileCard(
                            icon: "person.fill",
                            name: child.name,
                            subtitle: child.ageText,
                            iconColor: .pink.opacity(0.3)
                        ) {
                            showingChildEdit = true
                        }
                        
                        // Parent Profile Card
                        ProfileCard(
                            icon: "person.fill",
                            name: parent.name,
                            subtitle: parent.age,
                            iconColor: .pink.opacity(0.3)
                        ) {
                            showingParentEdit = true
                        }
                    }
                    
                    // Notifications Section
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Notificaciones")
                                .font(.system(size: 22, weight: .bold))
                            Spacer()
                            Image(systemName: "bell")
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal)
                        
                        NotificationToggle(title: "Recordatorios de vacunas", isOn: $vaccineReminders)
                        NotificationToggle(title: "Consejos diarios", isOn: $dailyTips)
                        NotificationToggle(title: "Actualizaciones de la app", isOn: $appUpdates)
                    }
                    
                    // Achievements Section
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Logros")
                                .font(.system(size: 22, weight: .bold))
                            Spacer()
                            Image(systemName: "trophy")
                                .foregroundColor(.purple.opacity(0.3))
                        }
                        .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(MilestoneType.allCases.prefix(6), id: \.self) { milestone in
                                    let hasAchievement = child.achievements.contains { $0.milestone == milestone }
                                    AchievementButton(
                                        title: milestone.rawValue,
                                        icon: milestone.icon,
                                        isCompleted: hasAchievement
                                    ) {
                                        showingAchievements = true
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    PremiumBannerCard(action: {
                        showPremiumSheet = true
                    })
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                    
                    // Support Section
                    VStack(spacing: 12) {
                        Button(action: { showingSupport = true }) {
                            HStack {
                                Text("Ayuda y soporte")
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(12)
                        }
                        
                        Button(action: { showingTerms = true }) {
                            HStack {
                                Text("Términos y condiciones")
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(12)
                        }
                        
                        Button(action: {}) {
                            Text("Cerrar sesión")
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity)
                                .padding()
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .sheet(isPresented: $showingChildEdit) {
                ChildEditView(child: $child)
            }
            .sheet(isPresented: $showingParentEdit) {
                ParentEditView(parent: $parent)
            }
            .sheet(isPresented: $showingAchievements) {
                AchievementsView(child: $child)
            }
            .sheet(isPresented: $showingSupport) {
                SupportView()
            }
            .sheet(isPresented: $showingTerms) {
                TermsView()
            }
            .sheet(isPresented: $showPremiumSheet) {
                PremiumSheet()
            }
        }
    }
}

// MARK: - Profile Card Component
struct ProfileCard: View {
    let icon: String
    let name: String
    let subtitle: String
    let iconColor: Color
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(iconColor)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(name)
                        .font(.system(size: 16, weight: .semibold))
                    Text(subtitle)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
            
            Button(action: action) {
                Text("Editar información")
                    .font(.system(size: 16))
                    .foregroundColor(.pink)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.pink.opacity(0.3), lineWidth: 1)
                    )
                    .cornerRadius(12)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(16)
        .padding(.horizontal)
    }
}

// MARK: - Notification Toggle
struct NotificationToggle: View {
    let title: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 16))
            Spacer()
            Toggle("", isOn: $isOn)
                .tint(.pink)
        }
        .padding(.horizontal)
    }
}

// MARK: - Achievement Button
struct AchievementButton: View {
    let title: String
    let icon: String
    let isCompleted: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(isCompleted ? .purple : .purple.opacity(0.3))
                Text(title)
                    .font(.system(size: 11))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(width: 100, height: 100)
            .background(isCompleted ? Color.purple.opacity(0.1) : Color.gray.opacity(0.05))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isCompleted ? Color.purple.opacity(0.3) : Color.clear, lineWidth: 2)
            )
        }
    }
}

// MARK: - Child Edit View (Sheet) - NUEVO DISEÑO MINIMALISTA
struct ChildEditView: View {
    @Binding var child: Child
    @Environment(\.dismiss) var dismiss
    
    @State private var birthDate: Date
    @State private var weight: String
    @State private var height: String
    @State private var showingSaveAlert = false
    
    init(child: Binding<Child>) {
        self._child = child
        self._birthDate = State(initialValue: child.wrappedValue.birthDate)
        self._weight = State(initialValue: String(format: "%.1f", child.wrappedValue.currentWeight))
        self._height = State(initialValue: String(format: "%.0f", child.wrappedValue.currentHeight))
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 32) {
                    // Header con foto del bebé
                    VStack(spacing: 12) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.pink.opacity(0.3))
                        
                        Text(child.name)
                            .font(.system(size: 24, weight: .bold))
                        
                        Text(child.ageText)
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 20)
                    
                    // Información en cards horizontales
                    VStack(spacing: 20) {
                        // Fecha de nacimiento
                        VStack(spacing: 12) {
                            HStack {
                                Image(systemName: "calendar")
                                    .foregroundColor(.pink)
                                Text("Fecha de nacimiento")
                                    .font(.system(size: 16, weight: .semibold))
                                Spacer()
                            }
                            
                            DatePicker("", selection: $birthDate, displayedComponents: .date)
                                .datePickerStyle(.graphical)
                                .tint(.pink)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.05))
                        .cornerRadius(16)
                        
                        // Peso y Talla en fila
                        HStack(spacing: 16) {
                            // Peso
                            VStack(spacing: 12) {
                                Image(systemName: "scalemass")
                                    .font(.system(size: 32))
                                    .foregroundColor(.pink)
                                
                                Text("Peso")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                                
                                HStack {
                                    TextField("0.0", text: $weight)
                                        .keyboardType(.decimalPad)
                                        .multilineTextAlignment(.center)
                                        .font(.system(size: 24, weight: .bold))
                                    Text("kg")
                                        .font(.system(size: 16))
                                        .foregroundColor(.gray)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.05))
                            .cornerRadius(16)
                            
                            // Talla
                            VStack(spacing: 12) {
                                Image(systemName: "ruler")
                                    .font(.system(size: 32))
                                    .foregroundColor(.purple)
                                
                                Text("Talla")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                                
                                HStack {
                                    TextField("0", text: $height)
                                        .keyboardType(.numberPad)
                                        .multilineTextAlignment(.center)
                                        .font(.system(size: 24, weight: .bold))
                                    Text("cm")
                                        .font(.system(size: 16))
                                        .foregroundColor(.gray)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.05))
                            .cornerRadius(16)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Botón guardar
                    Button(action: saveChanges) {
                        Text("Guardar cambios")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    colors: [Color.pink, Color.purple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(16)
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 30)
            }
            .navigationTitle("Editar información")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cerrar") {
                        dismiss()
                    }
                }
            }
            .alert("Cambios guardados", isPresented: $showingSaveAlert) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text("La información de \(child.name) se ha actualizado correctamente")
            }
        }
    }
    
    private func saveChanges() {
        child.birthDate = birthDate
        if let w = Double(weight) {
            child.currentWeight = w
        }
        if let h = Double(height) {
            child.currentHeight = h
        }
        showingSaveAlert = true
    }
}

// MARK: - Parent Edit View
struct ParentEditView: View {
    @Binding var parent: Parent
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String
    @State private var email: String
    @State private var password: String
    @State private var showingSaveAlert = false
    
    init(parent: Binding<Parent>) {
        self._parent = parent
        self._name = State(initialValue: parent.wrappedValue.name)
        self._email = State(initialValue: parent.wrappedValue.email)
        self._password = State(initialValue: "")
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        Image(systemName: "person")
                            .foregroundColor(.pink)
                        TextField("Nombre", text: $name)
                    }
                }
                
                Section {
                    HStack {
                        Image(systemName: "envelope")
                            .foregroundColor(.pink)
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                    }
                }
                
                Section {
                    HStack {
                        Image(systemName: "lock")
                            .foregroundColor(.pink)
                        SecureField("Nueva contraseña", text: $password)
                    }
                } footer: {
                    Text("Deja en blanco para mantener la contraseña actual")
                        .font(.caption)
                }
                
                Section {
                    Button(action: saveChanges) {
                        Text("Guardar cambios")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.pink)
                    }
                }
            }
            .navigationTitle("Editar información")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cerrar") {
                        dismiss()
                    }
                }
            }
            .alert("Cambios guardados", isPresented: $showingSaveAlert) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text("Tu información se ha actualizado correctamente")
            }
        }
    }
    
    private func saveChanges() {
        parent.name = name
        parent.email = email
        if !password.isEmpty {
            parent.password = password
        }
        showingSaveAlert = true
    }
}

// MARK: - Achievements View
struct AchievementsView: View {
    @Binding var child: Child
    @Environment(\.dismiss) var dismiss
    @State private var selectedMilestone: MilestoneType?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    if child.achievements.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "trophy.circle")
                                .resizable()
                                .frame(width: 80, height: 80)
                                .foregroundColor(.purple.opacity(0.3))
                            
                            Text("No hay logros registrados")
                                .font(.system(size: 18, weight: .semibold))
                            
                            Text("Agrega el primer registro del desarrollo de \(child.name.components(separatedBy: " ").first ?? "")")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        .padding(.top, 100)
                    } else {
                        // Grupo logros por categoría
                        achievementsGrid
                    }
                }
                .padding()
            }
            .navigationTitle("Logros de \(child.name.components(separatedBy: " ").first ?? "")")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cerrar") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        ForEach(MilestoneType.allCases, id: \.self) { milestone in
                            Button(milestone.rawValue) {
                                selectedMilestone = milestone
                            }
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.pink)
                    }
                }
            }
            .sheet(item: $selectedMilestone) { milestone in
                AddAchievementView(child: $child, milestone: milestone)
            }
        }
    }
    
    var achievementsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            ForEach(MilestoneType.allCases, id: \.self) { milestone in
                if let achievement = child.achievements.first(where: { $0.milestone == milestone }) {
                    MilestoneCard(achievement: achievement, child: $child)
                } else {
                    EmptyMilestoneCard(milestone: milestone) {
                        selectedMilestone = milestone
                    }
                }
            }
        }
    }
}

// MARK: - Milestone Card (Logro completado)
struct MilestoneCard: View {
    let achievement: Achievement
    @Binding var child: Child
    @State private var showingDetail = false
    
    var body: some View {
        Button(action: { showingDetail = true }) {
            VStack(spacing: 12) {
                Image(systemName: achievement.milestone.icon)
                    .font(.system(size: 32))
                    .foregroundColor(.purple)
                
                Text(achievement.milestone.rawValue)
                    .font(.system(size: 13, weight: .semibold))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .foregroundColor(.primary)
                
                HStack(spacing: 8) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(String(format: "%.1f", achievement.weight)) kg")
                            .font(.system(size: 11, weight: .medium))
                        Text("\(String(format: "%.0f", achievement.height)) cm")
                            .font(.system(size: 11, weight: .medium))
                    }
                    .foregroundColor(.primary)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(minHeight: 140)
            .padding()
            .background(Color.purple.opacity(0.1))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.purple.opacity(0.3), lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingDetail) {
            AchievementDetailView(achievement: achievement, child: $child)
        }
    }
}

// MARK: - Empty Milestone Card
struct EmptyMilestoneCard: View {
    let milestone: MilestoneType
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: milestone.icon)
                    .font(.system(size: 32))
                    .foregroundColor(.gray.opacity(0.3))
                
                Text(milestone.rawValue)
                    .font(.system(size: 13, weight: .semibold))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .foregroundColor(.gray)
                
                Image(systemName: "plus.circle")
                    .font(.system(size: 20))
                    .foregroundColor(.pink.opacity(0.5))
            }
            .frame(maxWidth: .infinity)
            .frame(minHeight: 140)
            .padding()
            .background(Color.gray.opacity(0.05))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [5]))
                    .foregroundColor(.gray.opacity(0.3))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Achievement Detail View (Info específica de UN logro)
struct AchievementDetailView: View {
    let achievement: Achievement
    @Binding var child: Child
    @Environment(\.dismiss) var dismiss
    @State private var showingDeleteAlert = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 12) {
                        Image(systemName: achievement.milestone.icon)
                            .font(.system(size: 60))
                            .foregroundColor(.purple)
                        
                        Text(achievement.milestone.rawValue)
                            .font(.system(size: 28, weight: .bold))
                        
                        Text(achievement.date, style: .date)
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                    }
                    .padding(.top)
                    
                    // Foto del bebé
                    if let photoData = achievement.photoData,
                       let uiImage = UIImage(data: photoData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 250)
                            .cornerRadius(20)
                            .clipped()
                            .padding(.horizontal)
                    }
                    
                    // Medidas
                    HStack(spacing: 16) {
                        MeasurementCard(icon: "scalemass", title: "Peso", value: "\(String(format: "%.1f", achievement.weight)) kg", color: .pink)
                        MeasurementCard(icon: "ruler", title: "Talla", value: "\(String(format: "%.0f", achievement.height)) cm", color: .purple)
                    }
                    .padding(.horizontal)
                    
                    // Perímetro cefálico
                    HStack(spacing: 16) {
                        MeasurementCard(icon: "brain.head.profile", title: "P. Cefálico", value: "\(String(format: "%.1f", achievement.headCircumference)) cm", color: .orange)
                        Spacer()
                            .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal)
                    
                    // Notas
                    if !achievement.notes.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Notas")
                                .font(.system(size: 18, weight: .semibold))
                            
                            Text(achievement.notes)
                                .font(.system(size: 15))
                                .foregroundColor(.secondary)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.gray.opacity(0.05))
                                .cornerRadius(12)
                        }
                        .padding(.horizontal)
                    }
                    
                    // Botón eliminar
                    Button(action: { showingDeleteAlert = true }) {
                        Text("Eliminar logro")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 30)
                }
            }
            .navigationTitle("Detalle")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cerrar") {
                        dismiss()
                    }
                }
            }
            .alert("¿Eliminar logro?", isPresented: $showingDeleteAlert) {
                Button("Cancelar", role: .cancel) { }
                Button("Eliminar", role: .destructive) {
                    if let index = child.achievements.firstIndex(where: { $0.id == achievement.id }) {
                        child.achievements.remove(at: index)
                        dismiss()
                    }
                }
            } message: {
                Text("Esta acción no se puede deshacer")
            }
        }
    }
}

// MARK: - Measurement Card
struct MeasurementCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundColor(color)
            
            Text(title)
                .font(.system(size: 13))
                .foregroundColor(.gray)
            
            Text(value)
                .font(.system(size: 18, weight: .bold))
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(16)
    }
}

// MARK: - Add Achievement View
struct AddAchievementView: View {
    @Binding var child: Child
    let milestone: MilestoneType
    @Environment(\.dismiss) var dismiss
    
    @State private var date = Date()
    @State private var weight = ""
    @State private var height = ""
    @State private var headCircumference = ""
    @State private var notes = ""
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    @State private var showingCamera = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 12) {
                        Image(systemName: milestone.icon)
                            .font(.system(size: 50))
                            .foregroundColor(.purple)
                        
                        Text(milestone.rawValue)
                            .font(.system(size: 24, weight: .bold))
                    }
                    .padding(.top)
                    
                    // Foto
                    VStack(spacing: 12) {
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 200)
                                .cornerRadius(16)
                                .clipped()
                        } else {
                            ZStack {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.gray.opacity(0.1))
                                    .frame(height: 200)
                                
                                VStack(spacing: 12) {
                                    Image(systemName: "photo.on.rectangle.angled")
                                        .font(.system(size: 50))
                                        .foregroundColor(.gray.opacity(0.5))
                                    
                                    Text("Agregar foto")
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        
                        HStack(spacing: 12) {
                            Button(action: { showingImagePicker = true }) {
                                Label("Galería", systemImage: "photo")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.pink.opacity(0.1))
                                    .foregroundColor(.pink)
                                    .cornerRadius(12)
                            }
                            
                            Button(action: { showingCamera = true }) {
                                Label("Cámara", systemImage: "camera")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.purple.opacity(0.1))
                                    .foregroundColor(.purple)
                                    .cornerRadius(12)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Fecha
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Fecha del registro")
                            .font(.system(size: 16, weight: .semibold))
                        
                        DatePicker("", selection: $date, displayedComponents: .date)
                            .datePickerStyle(.compact)
                            .tint(.pink)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.05))
                    .cornerRadius(16)
                    .padding(.horizontal)
                    
                    // Medidas
                    VStack(spacing: 16) {
                        HStack(spacing: 16) {
                            // Peso
                            VStack(alignment: .leading, spacing: 8) {
                                Label("Peso (kg)", systemImage: "scalemass")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.pink)
                                
                                TextField("12.5", text: $weight)
                                    .keyboardType(.decimalPad)
                                    .font(.system(size: 20, weight: .bold))
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(12)
                            }
                            
                            // Talla
                            VStack(alignment: .leading, spacing: 8) {
                                Label("Talla (cm)", systemImage: "ruler")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.purple)
                                
                                TextField("86", text: $height)
                                    .keyboardType(.decimalPad)
                                    .font(.system(size: 20, weight: .bold))
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(12)
                            }
                        }
                        
                        // Perímetro cefálico
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Perímetro cefálico (cm)", systemImage: "brain.head.profile")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.orange)
                            
                            TextField("45.0", text: $headCircumference)
                                .keyboardType(.decimalPad)
                                .font(.system(size: 20, weight: .bold))
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.05))
                    .cornerRadius(16)
                    .padding(.horizontal)
                    
                    // Notas
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Notas adicionales")
                            .font(.system(size: 16, weight: .semibold))
                        
                        TextEditor(text: $notes)
                            .frame(height: 100)
                            .padding(8)
                            .background(Color.white)
                            .cornerRadius(12)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.05))
                    .cornerRadius(16)
                    .padding(.horizontal)
                    
                    // Botón guardar
                    Button(action: saveAchievement) {
                        Text("Guardar logro")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    colors: [Color.pink, Color.purple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(16)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 30)
                }
            }
            .navigationTitle("Nuevo Logro")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $selectedImage, sourceType: .photoLibrary)
            }
            .sheet(isPresented: $showingCamera) {
                ImagePicker(image: $selectedImage, sourceType: .camera)
            }
        }
    }
    
    private func saveAchievement() {
        guard let w = Double(weight),
              let h = Double(height),
              let hc = Double(headCircumference) else {
            return
        }
        
        let photoData = selectedImage?.jpegData(compressionQuality: 0.8)
        
        let achievement = Achievement(
            milestone: milestone,
            date: date,
            weight: w,
            height: h,
            headCircumference: hc,
            notes: notes,
            photoData: photoData
        )
        
        // Remover logro anterior del mismo milestone si existe
        if let index = child.achievements.firstIndex(where: { $0.milestone == milestone }) {
            child.achievements.remove(at: index)
        }
        
        child.achievements.append(achievement)
        child.currentWeight = w
        child.currentHeight = h
        dismiss()
    }
}

// MARK: - Image Picker
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    let sourceType: UIImagePickerController.SourceType
    @Environment(\.dismiss) var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
            }
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

// MARK: - Support View
struct SupportView: View {
    @Environment(\.dismiss) var dismiss
    @State private var subject = ""
    @State private var message = ""
    @State private var reportType = "Reporte de bug"
    @State private var showingSuccessAlert = false
    
    let reportTypes = ["Reporte de bug", "Sugerencia", "Problema técnico", "Pregunta", "Otro"]
    
    var body: some View {
        NavigationView {
            Form {
                Section("Tipo de consulta") {
                    Picker("Tipo", selection: $reportType) {
                        ForEach(reportTypes, id: \.self) { type in
                            Text(type)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                Section("Asunto") {
                    TextField("Describe brevemente el problema", text: $subject)
                }
                
                Section("Mensaje") {
                    TextEditor(text: $message)
                        .frame(height: 150)
                }
                
                Section {
                    Button(action: sendEmail) {
                        HStack {
                            Spacer()
                            Text("Enviar reporte")
                                .foregroundColor(.white)
                            Spacer()
                        }
                    }
                    .listRowBackground(Color.pink)
                }
            }
            .navigationTitle("Ayuda y soporte")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cerrar") {
                        dismiss()
                    }
                }
            }
            .alert("Reporte enviado", isPresented: $showingSuccessAlert) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text("Gracias por tu mensaje. Te responderemos pronto.")
            }
        }
    }
    
    private func sendEmail() {
        let emailSubject = "[\(reportType)] \(subject)"
        let emailBody = message
        let emailTo = "support@childcare.com"
        
        if let url = URL(string: "mailto:\(emailTo)?subject=\(emailSubject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&body=\(emailBody.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")") {
            UIApplication.shared.open(url)
        }
        
        showingSuccessAlert = true
    }
}

// MARK: - Terms View
struct TermsView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Términos y Condiciones")
                        .font(.system(size: 28, weight: .bold))
                        .padding(.bottom)
                    
                    Group {
                        Text("1. Aceptación de los Términos")
                            .font(.system(size: 18, weight: .semibold))
                        Text("Al utilizar ChildCare, aceptas estos términos y condiciones en su totalidad. Si no estás de acuerdo con alguna parte de estos términos, no debes usar la aplicación.")
                            .font(.system(size: 15))
                            .foregroundColor(.secondary)
                    }
                    
                    Group {
                        Text("2. Uso de la Aplicación")
                            .font(.system(size: 18, weight: .semibold))
                        Text("ChildCare es una herramienta diseñada para ayudar a los padres a llevar un seguimiento del desarrollo de sus hijos. La información proporcionada no sustituye el consejo médico profesional.")
                            .font(.system(size: 15))
                            .foregroundColor(.secondary)
                    }
                    
                    Group {
                        Text("3. Privacidad y Datos Personales")
                            .font(.system(size: 18, weight: .semibold))
                        Text("Nos comprometemos a proteger tu privacidad. Los datos de tu hijo y tu información personal se almacenan de forma segura y nunca se compartirán con terceros sin tu consentimiento explícito.")
                            .font(.system(size: 15))
                            .foregroundColor(.secondary)
                    }
                    
                    Group {
                        Text("4. Responsabilidad Médica")
                            .font(.system(size: 18, weight: .semibold))
                        Text("Los recordatorios de vacunas y consejos proporcionados son orientativos. Siempre consulta con un profesional de la salud para decisiones médicas importantes relacionadas con tu hijo.")
                            .font(.system(size: 15))
                            .foregroundColor(.secondary)
                    }
                    
                    Group {
                        Text("5. Contenido del Usuario")
                            .font(.system(size: 18, weight: .semibold))
                        Text("Eres responsable de toda la información, fotos y datos que compartes en la aplicación. No debes subir contenido inapropiado, ilegal o que viole los derechos de terceros.")
                            .font(.system(size: 15))
                            .foregroundColor(.secondary)
                    }
                    
                    Group {
                        Text("6. Modificaciones del Servicio")
                            .font(.system(size: 18, weight: .semibold))
                        Text("Nos reservamos el derecho de modificar, suspender o discontinuar cualquier aspecto de ChildCare en cualquier momento, con o sin previo aviso.")
                            .font(.system(size: 15))
                            .foregroundColor(.secondary)
                    }
                    
                    Group {
                        Text("7. Limitación de Responsabilidad")
                            .font(.system(size: 18, weight: .semibold))
                        Text("ChildCare se proporciona \"tal cual\". No garantizamos que el servicio será ininterrumpido, seguro o libre de errores. No nos hacemos responsables de pérdidas o daños derivados del uso de la aplicación.")
                            .font(.system(size: 15))
                            .foregroundColor(.secondary)
                    }
                    
                    Group {
                        Text("8. Suscripción Premium")
                            .font(.system(size: 18, weight: .semibold))
                        Text("Las funciones premium requieren una suscripción de pago. Los pagos son procesados de forma segura. Puedes cancelar tu suscripción en cualquier momento desde la configuración de tu cuenta.")
                            .font(.system(size: 15))
                            .foregroundColor(.secondary)
                    }
                    
                    Group {
                        Text("9. Terminación de Cuenta")
                            .font(.system(size: 18, weight: .semibold))
                        Text("Puedes eliminar tu cuenta en cualquier momento. Nos reservamos el derecho de suspender o terminar cuentas que violen estos términos.")
                            .font(.system(size: 15))
                            .foregroundColor(.secondary)
                    }
                    
                    Group {
                        Text("10. Contacto")
                            .font(.system(size: 18, weight: .semibold))
                        Text("Para preguntas sobre estos términos, contáctanos en support@childcare.com")
                            .font(.system(size: 15))
                            .foregroundColor(.secondary)
                    }
                    
                    Divider()
                        .padding(.vertical)
                    
                    Text("Última actualización: Octubre 2025")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .italic()
                    
                    Text("Al continuar usando ChildCare, confirmas que has leído, entendido y aceptado estos términos y condiciones.")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                        .padding(.top)
                }
                .padding()
            }
            .navigationTitle("Términos y Condiciones")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cerrar") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Preview
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
