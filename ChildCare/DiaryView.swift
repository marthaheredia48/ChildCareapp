//
//  DiaryView.swift
//  ChildCare
//
//  Created by Martha Heredia Andrade on 20/10/25.
//

import SwiftUI
import Charts
import PDFKit

// MARK: - 📔 DIARIO DE SALUD PRINCIPAL
struct DiaryView: View {
    @Binding var selectedBaby: Baby?
    @State private var selectedDate = Date()
    @State private var selectedTab = 0
    @State private var showExportSheet = false
    @State private var showMedicalAlert = false
    @State private var medicalAlertMessage = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                // Fondo degradado rosa pastel
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 1.0, green: 0.95, blue: 0.97),
                        Color.white
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // 📅 Selector de fecha
                        DateSelectorView(selectedDate: $selectedDate)
                            .padding(.horizontal, 20)
                            .padding(.top, 10)
                        
                        // 🔄 Tabs: Síntomas / Hábitos
                        CustomTabSelector(selectedTab: $selectedTab)
                            .padding(.horizontal, 20)
                        
                        // Vista según tab seleccionado
                        if selectedTab == 0 {
                            // Síntomas del día
                            SymptomsDayTrackerView(date: selectedDate)
                                .padding(.horizontal, 20)
                            
                            // Gráfica de evolución
                            SymptomsChartViewReal()
                                    .padding(.horizontal, 20)
                                    .padding(.top, 20)
                        } else {
                            // Hábitos del día
                            HabitsDayTrackerView(date: selectedDate)
                                .padding(.horizontal, 20)
                            
                            // Gráfica de evolución
                            HabitsChartViewReal()
                                .padding(.horizontal, 20)
                                .padding(.top, 20)

                        }
                        
                        // 📊 Botón exportar PDF (Premium)
                        ExportPDFButton {
                            showExportSheet = true
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 30)
                    }
                }
            }
            .navigationTitle("Diario de Salud")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        checkMedicalAlerts()
                    }) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(Color(red: 0.93, green: 0.6, blue: 0.73))
                    }
                }
            }
        }
        .sheet(isPresented: $showExportSheet) {
            ExportPDFSheetComplete(selectedTab: selectedTab)
        }
        .alert("⚠️ Alerta Médica", isPresented: $showMedicalAlert) {
            Button("Entendido", role: .cancel) { }
            Button("Agendar cita", role: .none) {
                // TODO: Navegar a calendario de citas
            }
        } message: {
            Text(medicalAlertMessage)
        }
        .onAppear {
            checkMedicalAlerts()
        }
    }
    
    // MARK: - Verificar alertas médicas
    private func checkMedicalAlerts() {
        // TODO: Verificar síntomas recurrentes en Firebase
        // Ejemplo de lógica:
        /*
        let db = Firestore.firestore()
        let userId = Auth.auth().currentUser?.uid ?? ""
        let babyId = selectedBaby?.id ?? ""
        
        // Obtener síntomas de los últimos 3 días
        let threeDaysAgo = Calendar.current.date(byAdding: .day, value: -3, to: Date())!
        
        db.collection("users").document(userId)
            .collection("babies").document(babyId)
            .collection("symptoms")
            .whereField("date", isGreaterThan: Timestamp(date: threeDaysAgo))
            .getDocuments { snapshot, error in
                guard let documents = snapshot?.documents else { return }
                
                var symptomCount: [String: Int] = [:]
                for doc in documents {
                    if let symptoms = doc.data()["symptoms"] as? [String] {
                        for symptom in symptoms {
                            symptomCount[symptom, default: 0] += 1
                        }
                    }
                }
                
                // Verificar síntomas críticos
                if let fiebreCount = symptomCount["fiebre"], fiebreCount >= 2 {
                    medicalAlertMessage = "Tu bebé ha tenido fiebre durante \(fiebreCount) días. Considera consultar con el pediatra."
                    showMedicalAlert = true
                }
                
                if let vomitoCount = symptomCount["vomito"], vomitoCount >= 2 {
                    medicalAlertMessage = "Tu bebé ha presentado vómito durante \(vomitoCount) días seguidos. Es recomendable acudir al médico."
                    showMedicalAlert = true
                }
                
                if let diarreaCount = symptomCount["diarrea"], diarreaCount >= 3 {
                    medicalAlertMessage = "Se ha registrado diarrea durante \(diarreaCount) días. Mantén a tu bebé hidratado y consulta al pediatra."
                    showMedicalAlert = true
                }
            }
        */
        
        // Simulación para demo
        let mockSymptoms = ["fiebre": 2, "vomito": 1]
        if let fiebreCount = mockSymptoms["fiebre"], fiebreCount >= 2 {
            medicalAlertMessage = "🌡️ Tu bebé ha tenido fiebre durante \(fiebreCount) días consecutivos.\n\n📋 Recomendación: Consulta con el pediatra si la fiebre persiste o supera los 38°C."
            showMedicalAlert = true
        }
    }
}

// MARK: - 📅 Selector de Fecha
struct DateSelectorView: View {
    @Binding var selectedDate: Date
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Button(action: {
                    selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate) ?? selectedDate
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color(red: 0.93, green: 0.6, blue: 0.73))
                        .frame(width: 40, height: 40)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.05), radius: 4)
                }
                
                Spacer()
                
                VStack(spacing: 4) {
                    Text(formatDate(selectedDate))
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.black)
                    
                    if Calendar.current.isDateInToday(selectedDate) {
                        Text("Hoy")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color(red: 0.93, green: 0.6, blue: 0.73))
                    }
                }
                
                Spacer()
                
                Button(action: {
                    if !Calendar.current.isDateInToday(selectedDate) {
                        selectedDate = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate) ?? selectedDate
                    }
                }) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Calendar.current.isDateInToday(selectedDate) ? .gray : Color(red: 0.93, green: 0.6, blue: 0.73))
                        .frame(width: 40, height: 40)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.05), radius: 4)
                }
                .disabled(Calendar.current.isDateInToday(selectedDate))
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_ES")
        formatter.dateFormat = "d 'de' MMMM, yyyy"
        return formatter.string(from: date).capitalized
    }
}

// MARK: - 🔄 Tab Selector Personalizado
struct CustomTabSelector: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack(spacing: 0) {
            TabButton(title: "Síntomas", isSelected: selectedTab == 0) {
                withAnimation(.spring(response: 0.3)) {
                    selectedTab = 0
                }
            }
            
            TabButton(title: "Hábitos", isSelected: selectedTab == 1) {
                withAnimation(.spring(response: 0.3)) {
                    selectedTab = 1
                }
            }
        }
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

struct TabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: isSelected ? .semibold : .medium))
                .foregroundColor(isSelected ? .white : .gray)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(isSelected ? Color(red: 0.93, green: 0.6, blue: 0.73) : Color.clear)
                .cornerRadius(12)
        }
    }
}

// MARK: - 🩺 Tracker de Síntomas del Día
struct SymptomsDayTrackerView: View {
    let date: Date
    @State private var todaySymptoms: [String] = ["fiebre", "tos"] // TODO: Cargar de Firebase
    @State private var showEditSheet = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Síntomas registrados")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black)
                
                Spacer()
                
                if Calendar.current.isDateInToday(date) {
                    Button(action: {
                        showEditSheet = true
                    }) {
                        Text("Editar")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color(red: 0.93, green: 0.6, blue: 0.73))
                    }
                }
            }
            
            if todaySymptoms.isEmpty {
                EmptyStateView(icon: "heart.circle", message: "No hay síntomas registrados")
            } else {
                VStack(spacing: 12) {
                    ForEach(todaySymptoms, id: \.self) { symptomId in
                        SymptomRowView(symptomId: symptomId)
                    }
                }
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8)
        .sheet(isPresented: $showEditSheet) {
            EditSymptomsSheet(symptoms: $todaySymptoms, date: date)
        }
    }
}

struct SymptomRowView: View {
    let symptomId: String
    
    var symptomData: (icon: String, name: String, color: Color) {
        switch symptomId {
        case "fiebre": return ("thermometer.medium", "Fiebre", Color(red: 1.0, green: 0.6, blue: 0.6))
        case "tos": return ("wind", "Tos", Color(red: 0.7, green: 0.85, blue: 1.0))
        case "congestion": return ("nose", "Congestión", Color(red: 0.85, green: 0.82, blue: 0.95))
        case "diarrea": return ("drop.fill", "Diarrea", Color(red: 0.95, green: 0.85, blue: 0.70))
        case "vomito": return ("exclamationmark.circle.fill", "Vómito", Color(red: 0.95, green: 0.75, blue: 0.85))
        case "irritable": return ("face.dashed", "Irritable", Color(red: 1.0, green: 0.85, blue: 0.92))
        case "sarpullido": return ("allergens", "Sarpullido", Color(red: 1.0, green: 0.80, blue: 0.80))
        case "dolor": return ("bandage.fill", "Dolor", Color(red: 0.92, green: 0.78, blue: 0.96))
        default: return ("circle", "Desconocido", .gray)
        }
    }
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(symptomData.color.opacity(0.2))
                    .frame(width: 44, height: 44)
                
                Image(systemName: symptomData.icon)
                    .font(.system(size: 20))
                    .foregroundColor(symptomData.color)
            }
            
            Text(symptomData.name)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.black)
            
            Spacer()
            
            Text("Registrado")
                .font(.system(size: 13))
                .foregroundColor(.gray)
        }
        .padding(12)
        .background(Color.gray.opacity(0.05))
        .cornerRadius(12)
    }
}

// MARK: - 📊 Tracker de Hábitos del Día
struct HabitsDayTrackerView: View {
    let date: Date
    @State private var todayHabits: [HabitRecord] = [
        HabitRecord(habitId: "alimentacion", value: "120", time: Date(), notes: "Tomó todo el biberón"),
        HabitRecord(habitId: "sueno", value: "2.5", time: Date(), notes: "Siesta tranquila")
    ] // TODO: Cargar de Firebase
    @State private var showEditSheet = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Hábitos registrados")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black)
                
                Spacer()
                
                if Calendar.current.isDateInToday(date) {
                    Button(action: {
                        showEditSheet = true
                    }) {
                        Text("Editar")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color(red: 0.93, green: 0.6, blue: 0.73))
                    }
                }
            }
            
            if todayHabits.isEmpty {
                EmptyStateView(icon: "chart.bar", message: "No hay hábitos registrados")
            } else {
                VStack(spacing: 12) {
                    ForEach(todayHabits) { record in
                        HabitRecordRowView(record: record)
                    }
                }
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8)
    }
}

struct HabitRecord: Identifiable {
    let id = UUID()
    let habitId: String
    let value: String
    let time: Date
    let notes: String
}

struct HabitRecordRowView: View {
    let record: HabitRecord
    
    var habitData: (icon: String, name: String, color: Color, unit: String) {
        switch record.habitId {
        case "alimentacion": return ("fork.knife", "Alimentación", Color(red: 1.0, green: 0.75, blue: 0.85), "ml")
        case "sueno": return ("moon.zzz.fill", "Sueño", Color(red: 0.85, green: 0.82, blue: 0.95), "horas")
        case "panal": return ("water.waves", "Pañal", Color(red: 0.75, green: 0.85, blue: 1.0), "veces")
        case "bano": return ("drop.circle.fill", "Baño", Color(red: 0.88, green: 0.95, blue: 0.82), "min")
        default: return ("circle", "Desconocido", .gray, "")
        }
    }
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(habitData.color.opacity(0.2))
                    .frame(width: 44, height: 44)
                
                Image(systemName: habitData.icon)
                    .font(.system(size: 20))
                    .foregroundColor(habitData.color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(habitData.name)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.black)
                
                if !record.notes.isEmpty {
                    Text(record.notes)
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(record.value) \(habitData.unit)")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.black)
                
                Text(formatTime(record.time))
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
        }
        .padding(12)
        .background(Color.gray.opacity(0.05))
        .cornerRadius(12)
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}

// MARK: - 📈 Gráfica de Síntomas (Mock)
struct SymptomsChartView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Evolución de síntomas")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black)
                
                Spacer()
                
                Text("Último mes")
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
            }
            
            // Mock de gráfica (usa Swift Charts en producción)
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.05))
                    .frame(height: 200)
                
                VStack {
                    Image(systemName: "chart.bar.xaxis")
                        .font(.system(size: 40))
                        .foregroundColor(.gray.opacity(0.3))
                    
                    Text("Gráfica de evolución")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
            }
            
            Text("💡 Tip: Los síntomas más frecuentes este mes han sido tos y congestión")
                .font(.system(size: 13))
                .foregroundColor(.gray)
                .padding(12)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8)
    }
}

// MARK: - 📈 Gráfica de Hábitos (Mock)
struct HabitsChartView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Evolución de hábitos")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black)
                
                Spacer()
                
                Text("Última semana")
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
            }
            
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.05))
                    .frame(height: 200)
                
                VStack {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.system(size: 40))
                        .foregroundColor(.gray.opacity(0.3))
                    
                    Text("Gráfica de evolución")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
            }
            
            Text("📊 Promedio de sueño esta semana: 8.5 horas")
                .font(.system(size: 13))
                .foregroundColor(.gray)
                .padding(12)
                .background(Color.purple.opacity(0.1))
                .cornerRadius(8)
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8)
    }
}

// MARK: - 📄 Botón Exportar PDF
struct ExportPDFButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "arrow.down.doc.fill")
                    .font(.system(size: 18))
                
                Text("Exportar informe médico")
                    .font(.system(size: 16, weight: .semibold))
                
                Spacer()
                
                Image(systemName: "crown.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.orange)
            }
            .foregroundColor(.white)
            .padding(16)
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
    }
}


// MARK: - 📤 Share Sheet para compartir PDF
struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// MARK: - 🚫 Estado vacío
struct EmptyStateView: View {
    let icon: String
    let message: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 40))
                .foregroundColor(.gray.opacity(0.3))
            
            Text(message)
                .font(.system(size: 15))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
}

// MARK: - ✏️ Sheet para editar síntomas
struct EditSymptomsSheet: View {
    @Environment(\.dismiss) var dismiss
    @Binding var symptoms: [String]
    let date: Date
    @State private var selectedSymptoms: Set<String>
    
    let allSymptoms = [
        Symptom(id: "fiebre", icon: "thermometer.medium", name: "Fiebre", color: Color(red: 1.0, green: 0.6, blue: 0.6)),
        Symptom(id: "tos", icon: "wind", name: "Tos", color: Color(red: 0.7, green: 0.85, blue: 1.0)),
        Symptom(id: "congestion", icon: "nose", name: "Congestión", color: Color(red: 0.85, green: 0.82, blue: 0.95)),
        Symptom(id: "diarrea", icon: "drop.fill", name: "Diarrea", color: Color(red: 0.95, green: 0.85, blue: 0.70)),
        Symptom(id: "vomito", icon: "exclamationmark.circle.fill", name: "Vómito", color: Color(red: 0.95, green: 0.75, blue: 0.85)),
        Symptom(id: "irritable", icon: "face.dashed", name: "Irritable", color: Color(red: 1.0, green: 0.85, blue: 0.92)),
        Symptom(id: "sarpullido", icon: "allergens", name: "Sarpullido", color: Color(red: 1.0, green: 0.80, blue: 0.80)),
        Symptom(id: "dolor", icon: "bandage.fill", name: "Dolor", color: Color(red: 0.92, green: 0.78, blue: 0.96))
    ]
    
    init(symptoms: Binding<[String]>, date: Date) {
        self._symptoms = symptoms
        self.date = date
        self._selectedSymptoms = State(initialValue: Set(symptoms.wrappedValue))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 1.0, green: 0.98, blue: 0.99).ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Información de fecha
                        VStack(spacing: 8) {
                            Text("Editar síntomas del")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                            
                            Text(formatDate(date))
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.black)
                        }
                        .padding(.top, 20)
                        
                        // Grid de síntomas
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 16) {
                            ForEach(allSymptoms) { symptom in
                                SymptomEditCard(
                                    symptom: symptom,
                                    isSelected: selectedSymptoms.contains(symptom.id)
                                )
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
                        
                        // Botón guardar
                        Button(action: {
                            saveChanges()
                        }) {
                            Text("Guardar cambios")
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
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 40)
                    }
                }
            }
            .navigationTitle("Editar síntomas")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                    .foregroundColor(Color(red: 0.93, green: 0.6, blue: 0.73))
                }
            }
        }
    }
    
    private func saveChanges() {
        symptoms = Array(selectedSymptoms)
        
        // TODO: Guardar en Firebase
        /*
        let db = Firestore.firestore()
        let userId = Auth.auth().currentUser?.uid ?? ""
        let babyId = selectedBaby?.id ?? ""
        
        let symptomData: [String: Any] = [
            "symptoms": Array(selectedSymptoms),
            "date": Timestamp(date: date),
            "babyId": babyId,
            "updatedAt": Timestamp(date: Date())
        ]
        
        db.collection("users").document(userId)
            .collection("babies").document(babyId)
            .collection("symptoms")
            .document(formatDateForFirebase(date))
            .setData(symptomData) { error in
                if let error = error {
                    print("Error actualizando síntomas: \(error)")
                } else {
                    dismiss()
                }
            }
        */
        
        dismiss()
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_ES")
        formatter.dateFormat = "d 'de' MMMM, yyyy"
        return formatter.string(from: date).capitalized
    }
    
    private func formatDateForFirebase(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}

struct SymptomEditCard: View {
    let symptom: Symptom
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(isSelected ? symptom.color : symptom.color.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: symptom.icon)
                    .font(.system(size: 22))
                    .foregroundColor(isSelected ? .white : symptom.color.opacity(0.7))
            }
            
            Text(symptom.name)
                .font(.system(size: 12, weight: isSelected ? .semibold : .medium))
                .foregroundColor(isSelected ? .black : .gray)
                .lineLimit(1)
        }
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
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

struct ChartDataManager {
    static let symptomsByDay: [(date: Date, fiebre: Int, tos: Int, congestion: Int, diarrea: Int, vomito: Int)] = {
        let calendar = Calendar.current
        let today = Date()
        return (0..<14).reversed().map { daysAgo in
            let date = calendar.date(byAdding: .day, value: -daysAgo, to: today)!
            return (
                date: date,
                fiebre: [0, 1, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0][daysAgo],
                tos: [1, 1, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 1, 0][daysAgo],
                congestion: [0, 1, 1, 1, 0, 0, 1, 0, 0, 0, 1, 1, 0, 0][daysAgo],
                diarrea: [0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0][daysAgo],
                vomito: [0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0][daysAgo]
            )
        }
    }()
    
    static let habitsByDay: [(date: Date, feeding: Int, sleep: Double, diapers: Int)] = {
        let calendar = Calendar.current
        let today = Date()
        return (0..<14).reversed().map { daysAgo in
            let date = calendar.date(byAdding: .day, value: -daysAgo, to: today)!
            let feeding = [650, 620, 700, 680, 650, 720, 690, 670, 640, 710, 680, 650, 690, 700][daysAgo]
            let sleep = [9.5, 8.0, 10.0, 9.0, 8.5, 9.5, 9.0, 8.5, 10.5, 9.0, 8.0, 9.5, 9.0, 10.0][daysAgo]
            let diapers = [6, 7, 6, 5, 6, 7, 6, 5, 6, 7, 6, 6, 7, 6][daysAgo]
            return (date: date, feeding: feeding, sleep: sleep, diapers: diapers)
        }
    }()
}

// MARK: - 📈 GRÁFICA REAL DE SÍNTOMAS CON FILTROS
struct SymptomsChartViewReal: View {
    @State private var selectedSymptom: String = "todos"
    @State private var timeRange: Int = 7
    
    let symptoms = [
        ("todos", "Todos", Color(red: 0.93, green: 0.6, blue: 0.73)),
        ("fiebre", "Fiebre", Color(red: 1.0, green: 0.6, blue: 0.6)),
        ("tos", "Tos", Color(red: 0.7, green: 0.85, blue: 1.0)),
        ("congestion", "Congestión", Color(red: 0.85, green: 0.82, blue: 0.95)),
        ("diarrea", "Diarrea", Color(red: 0.95, green: 0.85, blue: 0.70)),
        ("vomito", "Vómito", Color(red: 0.95, green: 0.75, blue: 0.85))
    ]
    
    var filteredData: [(date: Date, count: Int, symptom: String)] {
        let data = ChartDataManager.symptomsByDay.suffix(timeRange)
        
        if selectedSymptom == "todos" {
            return data.map { day in
                let total = day.fiebre + day.tos + day.congestion + day.diarrea + day.vomito
                return (date: day.date, count: total, symptom: "Total")
            }
        } else {
            return data.map { day in
                let count: Int
                switch selectedSymptom {
                case "fiebre": count = day.fiebre
                case "tos": count = day.tos
                case "congestion": count = day.congestion
                case "diarrea": count = day.diarrea
                case "vomito": count = day.vomito
                default: count = 0
                }
                return (date: day.date, count: count, symptom: selectedSymptom)
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Evolución de síntomas")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black)
                
                Spacer()
                
                Menu {
                    Button("7 días") { timeRange = 7 }
                    Button("14 días") { timeRange = 14 }
                } label: {
                    HStack(spacing: 4) {
                        Text("\(timeRange) días")
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                        Image(systemName: "chevron.down")
                            .font(.system(size: 10))
                            .foregroundColor(.gray)
                    }
                }
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(symptoms, id: \.0) { symptom in
                        Button(action: {
                            withAnimation(.spring(response: 0.3)) {
                                selectedSymptom = symptom.0
                            }
                        }) {
                            Text(symptom.1)
                                .font(.system(size: 13, weight: selectedSymptom == symptom.0 ? .semibold : .medium))
                                .foregroundColor(selectedSymptom == symptom.0 ? .white : symptom.2)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(selectedSymptom == symptom.0 ? symptom.2 : symptom.2.opacity(0.15))
                                )
                        }
                    }
                }
            }
            
            Chart {
                ForEach(Array(filteredData.enumerated()), id: \.offset) { _, item in
                    BarMark(
                        x: .value("Fecha", item.date, unit: .day),
                        y: .value("Cantidad", item.count)
                    )
                    .foregroundStyle(symptoms.first(where: { $0.0 == selectedSymptom })?.2 ?? .gray)
                    .cornerRadius(4)
                }
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .day, count: timeRange == 7 ? 1 : 2)) { value in
                    AxisValueLabel(format: .dateTime.day().month(.narrow))
                        .font(.system(size: 10))
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading) { value in
                    AxisValueLabel()
                        .font(.system(size: 10))
                }
            }
            .frame(height: 200)
            .padding(.vertical, 8)
            
            HStack(spacing: 20) {
                StatBox(
                    title: "Total",
                    value: "\(filteredData.map { $0.count }.reduce(0, +))",
                    color: symptoms.first(where: { $0.0 == selectedSymptom })?.2 ?? .gray
                )
                
                StatBox(
                    title: "Promedio",
                    value: String(format: "%.1f", Double(filteredData.map { $0.count }.reduce(0, +)) / Double(filteredData.count)),
                    color: .blue
                )
                
                StatBox(
                    title: "Máximo",
                    value: "\(filteredData.map { $0.count }.max() ?? 0)",
                    color: .orange
                )
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8)
    }
}

// MARK: - 📈 GRÁFICA REAL DE HÁBITOS CON FILTROS
struct HabitsChartViewReal: View {
    @State private var selectedHabit: String = "sleep"
    @State private var timeRange: Int = 7
    
    let habits = [
        ("feeding", "Alimentación", "ml", Color(red: 1.0, green: 0.75, blue: 0.85)),
        ("sleep", "Sueño", "hrs", Color(red: 0.85, green: 0.82, blue: 0.95)),
        ("diapers", "Pañales", "cambios", Color(red: 0.75, green: 0.85, blue: 1.0))
    ]
    
    var filteredData: [(date: Date, value: Double)] {
        let data = ChartDataManager.habitsByDay.suffix(timeRange)
        
        switch selectedHabit {
        case "feeding":
            return data.map { (date: $0.date, value: Double($0.feeding)) }
        case "sleep":
            return data.map { (date: $0.date, value: $0.sleep) }
        case "diapers":
            return data.map { (date: $0.date, value: Double($0.diapers)) }
        default:
            return []
        }
    }
    
    var currentHabit: (String, String, String, Color) {
        habits.first(where: { $0.0 == selectedHabit }) ?? habits[0]
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Evolución de hábitos")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black)
                
                Spacer()
                
                Menu {
                    Button("7 días") { timeRange = 7 }
                    Button("14 días") { timeRange = 14 }
                } label: {
                    HStack(spacing: 4) {
                        Text("\(timeRange) días")
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                        Image(systemName: "chevron.down")
                            .font(.system(size: 10))
                            .foregroundColor(.gray)
                    }
                }
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(habits, id: \.0) { habit in
                        Button(action: {
                            withAnimation(.spring(response: 0.3)) {
                                selectedHabit = habit.0
                            }
                        }) {
                            Text(habit.1)
                                .font(.system(size: 13, weight: selectedHabit == habit.0 ? .semibold : .medium))
                                .foregroundColor(selectedHabit == habit.0 ? .white : habit.3)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(selectedHabit == habit.0 ? habit.3 : habit.3.opacity(0.15))
                                )
                        }
                    }
                }
            }
            
            Chart {
                ForEach(Array(filteredData.enumerated()), id: \.offset) { _, item in
                    LineMark(
                        x: .value("Fecha", item.date, unit: .day),
                        y: .value(currentHabit.1, item.value)
                    )
                    .foregroundStyle(currentHabit.3)
                    .lineStyle(StrokeStyle(lineWidth: 3))
                    
                    PointMark(
                        x: .value("Fecha", item.date, unit: .day),
                        y: .value(currentHabit.1, item.value)
                    )
                    .foregroundStyle(currentHabit.3)
                    .symbolSize(80)
                    
                    AreaMark(
                        x: .value("Fecha", item.date, unit: .day),
                        y: .value(currentHabit.1, item.value)
                    )
                    .foregroundStyle(
                        LinearGradient(
                            colors: [currentHabit.3.opacity(0.3), currentHabit.3.opacity(0.0)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                }
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .day, count: timeRange == 7 ? 1 : 2)) { value in
                    AxisValueLabel(format: .dateTime.day().month(.narrow))
                        .font(.system(size: 10))
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading) { value in
                    AxisValueLabel()
                        .font(.system(size: 10))
                }
            }
            .frame(height: 200)
            .padding(.vertical, 8)
            
            HStack(spacing: 20) {
                StatBox(
                    title: "Promedio",
                    value: String(format: "%.1f \(currentHabit.2)", filteredData.map { $0.value }.reduce(0, +) / Double(filteredData.count)),
                    color: currentHabit.3
                )
                
                StatBox(
                    title: "Mínimo",
                    value: String(format: "%.1f \(currentHabit.2)", filteredData.map { $0.value }.min() ?? 0),
                    color: .orange
                )
                
                StatBox(
                    title: "Máximo",
                    value: String(format: "%.1f \(currentHabit.2)", filteredData.map { $0.value }.max() ?? 0),
                    color: .green
                )
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8)
    }
}

struct StatBox: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.system(size: 11))
                .foregroundColor(.gray)
            
            Text(value)
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(color.opacity(0.1))
        .cornerRadius(10)
    }
}




// MARK: - 🔔 SISTEMA DE ALERTAS MÉDICAS

extension DiaryView {
    // Estructura para definir reglas de alertas
    struct MedicalAlertRule {
        let symptomId: String
        let daysThreshold: Int
        let severity: AlertSeverity
        let message: String
        
        enum AlertSeverity {
            case warning, urgent, critical
            
            var color: Color {
                switch self {
                case .warning: return .orange
                case .urgent: return Color(red: 1.0, green: 0.6, blue: 0.6)
                case .critical: return .red
                }
            }
        }
    }
    
    // Reglas de alertas médicas
    static let alertRules: [MedicalAlertRule] = [
        MedicalAlertRule(
            symptomId: "fiebre",
            daysThreshold: 2,
            severity: .urgent,
            message: "🌡️ Fiebre persistente detectada\n\n📋 Tu bebé ha tenido fiebre durante 2 días consecutivos. Si la temperatura supera los 38°C o el bebé muestra signos de malestar, consulta al pediatra inmediatamente."
        ),
        MedicalAlertRule(
            symptomId: "vomito",
            daysThreshold: 2,
            severity: .urgent,
            message: "🤢 Vómito recurrente\n\n⚠️ Se ha registrado vómito durante 2 días seguidos. Mantén al bebé hidratado con pequeñas cantidades de líquido frecuentemente. Si continúa, acude al médico."
        ),
        MedicalAlertRule(
            symptomId: "diarrea",
            daysThreshold: 3,
            severity: .warning,
            message: "💧 Diarrea prolongada\n\n💡 La diarrea ha persistido por 3 días. Asegúrate de que el bebé se mantenga bien hidratado. Si notas signos de deshidratación (boca seca, menos pañales mojados), consulta urgentemente."
        ),
        MedicalAlertRule(
            symptomId: "irritable",
            daysThreshold: 4,
            severity: .warning,
            message: "😢 Irritabilidad constante\n\n📋 El bebé ha estado irritable por varios días. Esto podría indicar malestar o dolor. Considera una revisión médica para descartar otras causas."
        ),
        MedicalAlertRule(
            symptomId: "sarpullido",
            daysThreshold: 3,
            severity: .warning,
            message: "🔴 Sarpullido persistente\n\n⚠️ El sarpullido ha durado más de 3 días. Si se extiende, tiene pus, o el bebé tiene fiebre, consulta al pediatra."
        )
    ]
}

