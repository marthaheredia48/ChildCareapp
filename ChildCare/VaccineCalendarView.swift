//
//  VaccineCalendarView.swift
//  ChildCare
//
//  Created by Martha Heredia Andrade on 20/10/25.
//


import SwiftUI
import UserNotifications
import VisionKit // Para el escaneo de documentos

// MARK: - Modelo de Vacuna
struct Vaccine: Identifiable, Codable {
    let id: String
    var name: String
    var recommendedDate: Date
    var appliedDate: Date?
    var isApplied: Bool
    var description: String
    var ageInMonths: Int // Edad recomendada en meses
    var babyId: String
    var remindersSent: [Date] // Para tracking de recordatorios enviados
    
    init(id: String = UUID().uuidString, name: String, recommendedDate: Date,
         description: String, ageInMonths: Int, babyId: String) {
        self.id = id
        self.name = name
        self.recommendedDate = recommendedDate
        self.appliedDate = nil
        self.isApplied = false
        self.description = description
        self.ageInMonths = ageInMonths
        self.babyId = babyId
        self.remindersSent = []
    }
}

// MARK: - Esquema Nacional de Vacunación México
struct VaccineScheduleMX {
    static func generateVaccineSchedule(for baby: Baby) -> [Vaccine] {
        let birthDate = baby.birthDate
        var vaccines: [Vaccine] = []
        
        // ===== AL NACER (0 meses) =====
        vaccines.append(Vaccine(
            name: "BCG",
            recommendedDate: birthDate,
            description: "Protege contra formas graves de tuberculosis",
            ageInMonths: 0,
            babyId: baby.id.uuidString
        ))
        vaccines.append(Vaccine(
            name: "Hepatitis B",
            recommendedDate: birthDate,
            description: "Previene la infección del virus de la Hepatitis B",
            ageInMonths: 0,
            babyId: baby.id.uuidString
        ))
        
        // ===== 2 MESES =====
        let twoMonths = Calendar.current.date(byAdding: .month, value: 2, to: birthDate)!
        vaccines.append(Vaccine(
            name: "Hexavalente (1ra dosis)",
            recommendedDate: twoMonths,
            description: "Protege contra difteria, tosferina, tétanos, polio, Hib y Hepatitis B",
            ageInMonths: 2,
            babyId: baby.id.uuidString
        ))
        vaccines.append(Vaccine(
            name: "Rotavirus (1ra dosis)",
            recommendedDate: twoMonths,
            description: "Previene diarreas graves causadas por rotavirus",
            ageInMonths: 2,
            babyId: baby.id.uuidString
        ))
        vaccines.append(Vaccine(
            name: "Neumocócica Conjugada (1ra dosis)",
            recommendedDate: twoMonths,
            description: "Protege contra infecciones por neumococo",
            ageInMonths: 2,
            babyId: baby.id.uuidString
        ))
        
        // ===== 4 MESES =====
        let fourMonths = Calendar.current.date(byAdding: .month, value: 4, to: birthDate)!
        vaccines.append(Vaccine(
            name: "Hexavalente (2da dosis)",
            recommendedDate: fourMonths,
            description: "Protege contra difteria, tosferina, tétanos, polio, Hib y Hepatitis B",
            ageInMonths: 4,
            babyId: baby.id.uuidString
        ))
        vaccines.append(Vaccine(
            name: "Rotavirus (2da dosis)",
            recommendedDate: fourMonths,
            description: "Previene diarreas graves causadas por rotavirus",
            ageInMonths: 4,
            babyId: baby.id.uuidString
        ))
        vaccines.append(Vaccine(
            name: "Neumocócica Conjugada (2da dosis)",
            recommendedDate: fourMonths,
            description: "Protege contra infecciones por neumococo",
            ageInMonths: 4,
            babyId: baby.id.uuidString
        ))
        
        // ===== 6 MESES =====
        let sixMonths = Calendar.current.date(byAdding: .month, value: 6, to: birthDate)!
        vaccines.append(Vaccine(
            name: "Hexavalente (3ra dosis)",
            recommendedDate: sixMonths,
            description: "Protege contra difteria, tosferina, tétanos, polio, Hib y Hepatitis B",
            ageInMonths: 6,
            babyId: baby.id.uuidString
        ))
        vaccines.append(Vaccine(
            name: "Influenza (1ra dosis)",
            recommendedDate: sixMonths,
            description: "Protege contra la influenza estacional (a partir de 6 meses)",
            ageInMonths: 6,
            babyId: baby.id.uuidString
        ))
        
        // ===== 7 MESES (Influenza 2da) =====
        let sevenMonths = Calendar.current.date(byAdding: .month, value: 7, to: birthDate)!
        vaccines.append(Vaccine(
            name: "Influenza (2da dosis)",
            recommendedDate: sevenMonths,
            description: "4 semanas después de la 1ra dosis de influenza",
            ageInMonths: 7,
            babyId: baby.id.uuidString
        ))
        
        // ===== 12 MESES =====
        let twelveMonths = Calendar.current.date(byAdding: .month, value: 12, to: birthDate)!
        vaccines.append(Vaccine(
            name: "SRP (Triple Viral - 1ra dosis)",
            recommendedDate: twelveMonths,
            description: "Protege contra sarampión, rubéola y paperas",
            ageInMonths: 12,
            babyId: baby.id.uuidString
        ))
        vaccines.append(Vaccine(
            name: "Neumocócica Conjugada (Refuerzo)",
            recommendedDate: twelveMonths,
            description: "Refuerzo contra infecciones por neumococo",
            ageInMonths: 12,
            babyId: baby.id.uuidString
        ))
        vaccines.append(Vaccine(
            name: "Influenza Anual",
            recommendedDate: twelveMonths,
            description: "Protección anual contra influenza (temporada invernal)",
            ageInMonths: 12,
            babyId: baby.id.uuidString
        ))
        
        // ===== 18 MESES =====
        let eighteenMonths = Calendar.current.date(byAdding: .month, value: 18, to: birthDate)!
        vaccines.append(Vaccine(
            name: "Hexavalente (Refuerzo)",
            recommendedDate: eighteenMonths,
            description: "Refuerzo contra difteria, tosferina, tétanos, polio, Hib y Hepatitis B",
            ageInMonths: 18,
            babyId: baby.id.uuidString
        ))
        vaccines.append(Vaccine(
            name: "SRP (Triple Viral - 2da dosis)*",
            recommendedDate: eighteenMonths,
            description: "Para nacidos después de julio 2020",
            ageInMonths: 18,
            babyId: baby.id.uuidString
        ))
        vaccines.append(Vaccine(
            name: "Influenza Anual",
            recommendedDate: eighteenMonths,
            description: "Protección anual contra influenza (temporada invernal)",
            ageInMonths: 18,
            babyId: baby.id.uuidString
        ))
        
        // ===== 24 MESES (2 AÑOS) =====
        let twentyFourMonths = Calendar.current.date(byAdding: .month, value: 24, to: birthDate)!
        vaccines.append(Vaccine(
            name: "Influenza Anual",
            recommendedDate: twentyFourMonths,
            description: "Protección anual contra influenza (temporada invernal)",
            ageInMonths: 24,
            babyId: baby.id.uuidString
        ))
        
        // ===== 36 MESES (3 AÑOS) =====
        let thirtySixMonths = Calendar.current.date(byAdding: .month, value: 36, to: birthDate)!
        vaccines.append(Vaccine(
            name: "Influenza Anual",
            recommendedDate: thirtySixMonths,
            description: "Protección anual contra influenza (temporada invernal)",
            ageInMonths: 36,
            babyId: baby.id.uuidString
        ))
        
        // ===== 48 MESES (4 AÑOS) =====
        let fourYears = Calendar.current.date(byAdding: .month, value: 48, to: birthDate)!
        vaccines.append(Vaccine(
            name: "DPT (Refuerzo)",
            recommendedDate: fourYears,
            description: "Refuerzo contra difteria, tosferina y tétanos",
            ageInMonths: 48,
            babyId: baby.id.uuidString
        ))
        vaccines.append(Vaccine(
            name: "Influenza Anual",
            recommendedDate: fourYears,
            description: "Protección anual contra influenza (temporada invernal)",
            ageInMonths: 48,
            babyId: baby.id.uuidString
        ))
        
        // ===== 5 AÑOS - COVID-19 (OPCIONAL) =====
        let fiveYears = Calendar.current.date(byAdding: .year, value: 5, to: birthDate)!
        vaccines.append(Vaccine(
            name: "COVID-19 (1ra dosis)*",
            recommendedDate: fiveYears,
            description: "A partir de 5 años - según disponibilidad",
            ageInMonths: 60,
            babyId: baby.id.uuidString
        ))
        let fiveYearsOneMonth = Calendar.current.date(byAdding: .month, value: 1, to: fiveYears)!
        vaccines.append(Vaccine(
            name: "COVID-19 (2da dosis)*",
            recommendedDate: fiveYearsOneMonth,
            description: "Según intervalo recomendado",
            ageInMonths: 61,
            babyId: baby.id.uuidString
        ))
        let fiveYearsTwoMonths = Calendar.current.date(byAdding: .month, value: 2, to: fiveYears)!
        vaccines.append(Vaccine(
            name: "COVID-19 (3ra dosis)*",
            recommendedDate: fiveYearsTwoMonths,
            description: "Refuerzo según intervalo recomendado",
            ageInMonths: 62,
            babyId: baby.id.uuidString
        ))
        
        // Rotavirus 3ra dosis SOLO SI ES NECESARIA (algunas marcas)
        if Calendar.current.dateComponents([.month], from: birthDate, to: Date()).month ?? 0 <= 6 {
            vaccines.append(Vaccine(
                name: "Rotavirus (3ra dosis)*",
                recommendedDate: sixMonths,
                description: "Solo para ciertas marcas de rotavirus",
                ageInMonths: 6,
                babyId: baby.id.uuidString
            ))
        }
        
        return vaccines
    }
}
// MARK: - Vista Principal del Calendario de Vacunas
struct VaccineCalendarView: View {
    @Binding var selectedBaby: Baby?
    @State private var vaccines: [Vaccine] = []
    @State private var selectedDate = Date()
    @State private var showingMonthView = true // true = mes, false = lista
    @State private var showingScannerSheet = false
    @State private var showingVaccineDetail: Vaccine? = nil
    @State private var currentMonth = Date()
    @State private var scannedCardImages: [UIImage] = [] // 🆕 Almacena todas las fotos escaneadas
    @State private var showingImageViewer: Int? = nil // 🆕 Para ver imagen en grande
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header con selector de bebé
                VStack(spacing: 16) {
                    HStack {
                        Text("Calendario de Vacunas")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        // Selector de bebé (igual que en HomeView)
                        if let baby = selectedBaby {
                            HStack(spacing: 8) {
                                Circle()
                                    .fill(baby.gender == "girl" ? Color.pink.opacity(0.3) : Color.blue.opacity(0.3))
                                    .frame(width: 32, height: 32)
                                    .overlay(
                                        Text(String(baby.name.prefix(1)))
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(baby.gender == "girl" ? .pink : .blue)
                                    )
                                
                                Text(baby.name)
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
                    }
                    .padding(.top, 15)
                    .padding(.horizontal, 20)
                    
                    // Toggle Mes/Lista
                    HStack(spacing: 0) {
                        Button(action: {
                            withAnimation {
                                showingMonthView = true
                            }
                        }) {
                            Text("Mes")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(showingMonthView ? Color(red: 0.93, green: 0.6, blue: 0.73) : .gray)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(
                                    showingMonthView ?
                                    Color(red: 0.93, green: 0.6, blue: 0.73).opacity(0.1) :
                                        Color.clear
                                )
                        }
                        
                        Button(action: {
                            withAnimation {
                                showingMonthView = false
                            }
                        }) {
                            Text("Lista")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(!showingMonthView ? Color(red: 0.93, green: 0.6, blue: 0.73) : .gray)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(
                                    !showingMonthView ?
                                    Color(red: 0.93, green: 0.6, blue: 0.73).opacity(0.1) :
                                        Color.clear
                                )
                        }
                    }
                    .background(Color.gray.opacity(0.08))
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                }
                .padding(.top, 8)
                .padding(.bottom, 16)
                
                // Contenido: Calendario o Lista
                if showingMonthView {
                    calendarMonthView
                } else {
                    vaccineListView
                }
            }
            .background(Color.white)
            .navigationBarHidden(true)
            .onAppear {
                loadVaccines()
                loadScannedImages() // 🆕 Cargar imágenes guardadas
                requestNotificationPermissions()
            }
            .sheet(isPresented: $showingScannerSheet) {
                DocumentScannerView(scannedImages: $scannedCardImages)
            }
            .sheet(item: $showingVaccineDetail) { vaccine in
                VaccineDetailSheet(vaccine: binding(for: vaccine))
            }
            .sheet(isPresented: Binding<Bool>(
                get: { showingImageViewer != nil },
                set: { if !$0 { showingImageViewer = nil } }
            )) {
                if let index = showingImageViewer, index < scannedCardImages.count {
                    ImageViewerSheet(image: scannedCardImages[index])
                }
            }
        }
    }
    
    // MARK: - Vista de Calendario Mensual
    var calendarMonthView: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Navegación del mes
                HStack {
                    Button(action: {
                        withAnimation {
                            currentMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
                        }
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.gray)
                            .frame(width: 44, height: 44)
                    }
                    
                    Spacer()
                    
                    Text(getMonthYearString(from: currentMonth))
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation {
                            currentMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
                        }
                    }) {
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                            .frame(width: 44, height: 44)
                    }
                }
                .padding(.horizontal, 20)
                
                // Días de la semana
                HStack(spacing: 0) {
                    ForEach(["Lu", "Ma", "Mi", "Ju", "Vi", "Sa", "Do"], id: \.self) { day in
                        Text(day)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal, 20)
                
                // Calendario
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 12) {
                    ForEach(getDaysInMonth(for: currentMonth), id: \.self) { date in
                        if let date = date {
                            VaccineCalendarDayCell(
                                date: date,
                                vaccines: getVaccinesForDate(date),
                                isSelected: Calendar.current.isDate(date, inSameDayAs: selectedDate)
                            )
                            .onTapGesture {
                                selectedDate = date
                            }
                        } else {
                            Color.clear
                                .frame(height: 50)
                        }
                    }
                }
                .padding(.horizontal, 20)
                
                // Vacunas del día seleccionado
                if !getVaccinesForDate(selectedDate).isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Vacunas para \(formatDate(selectedDate))")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 20)
                        
                        ForEach(getVaccinesForDate(selectedDate)) { vaccine in
                            VaccineCard(vaccine: vaccine) {
                                showingVaccineDetail = vaccine
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    .padding(.top, 20)
                }
                
                // Botón para escanear cartilla
                Button(action: {
                    showingScannerSheet = true
                }) {
                    HStack {
                        Image(systemName: "doc.text.viewfinder")
                            .font(.system(size: 20))
                        
                        Text("Escanear cartilla de vacunación")
                            .font(.system(size: 16, weight: .medium))
                    }
                    .foregroundColor(Color(red: 0.93, green: 0.6, blue: 0.73))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color(red: 0.93, green: 0.6, blue: 0.73).opacity(0.1))
                    .cornerRadius(12)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                // 🆕 Galería de cartillas escaneadas
                if !scannedCardImages.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Cartillas Escaneadas (\(scannedCardImages.count))")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 20)
                            .padding(.top, 8)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(Array(scannedCardImages.enumerated()), id: \.offset) { index, image in
                                    ScannedCardThumbnail(
                                        image: image,
                                        pageNumber: index + 1,
                                        onTap: {
                                            if let index = scannedCardImages.firstIndex(of: image) {
                                                showingImageViewer = index
                                            }
                                        },
                                        onDelete: {
                                            deleteScannedImage(at: index)
                                        }
                                    )
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                }
                
                Spacer(minLength: 40)
            }
        }
    }
    
    // MARK: - Vista de Lista
    var vaccineListView: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Aplicadas
                if !vaccines.filter({ $0.isApplied }).isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Aplicadas")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 20)
                        
                        ForEach(vaccines.filter({ $0.isApplied }).sorted(by: { $0.appliedDate ?? Date() > $1.appliedDate ?? Date() })) { vaccine in
                            VaccineCard(vaccine: vaccine) {
                                showingVaccineDetail = vaccine
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                }
                
                // Pendientes
                if !vaccines.filter({ !$0.isApplied }).isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Pendientes")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 20)
                            .padding(.top, 8)
                        
                        ForEach(vaccines.filter({ !$0.isApplied }).sorted(by: { $0.recommendedDate < $1.recommendedDate })) { vaccine in
                            VaccineCard(vaccine: vaccine) {
                                showingVaccineDetail = vaccine
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                }
                
                // Retrasadas
                let delayedVaccines = vaccines.filter { !$0.isApplied && $0.recommendedDate < Date() }
                if !delayedVaccines.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Retrasadas")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.red)
                            .padding(.horizontal, 20)
                            .padding(.top, 8)
                        
                        ForEach(delayedVaccines.sorted(by: { $0.recommendedDate < $1.recommendedDate })) { vaccine in
                            VaccineCard(vaccine: vaccine, isDelayed: true) {
                                showingVaccineDetail = vaccine
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                }
                
                // Botón para escanear cartilla
                Button(action: {
                    showingScannerSheet = true
                }) {
                    HStack {
                        Image(systemName: "doc.text.viewfinder")
                            .font(.system(size: 20))
                        
                        Text("Escanear cartilla de vacunación")
                            .font(.system(size: 16, weight: .medium))
                    }
                    .foregroundColor(Color(red: 0.93, green: 0.6, blue: 0.73))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color(red: 0.93, green: 0.6, blue: 0.73).opacity(0.1))
                    .cornerRadius(12)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                // 🆕 Galería de cartillas escaneadas
                if !scannedCardImages.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Cartillas Escaneadas (\(scannedCardImages.count))")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 20)
                            .padding(.top, 8)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(Array(scannedCardImages.enumerated()), id: \.offset) { index, image in
                                    ScannedCardThumbnail(
                                        image: image,
                                        pageNumber: index + 1,
                                        onTap: {
                                            showingImageViewer = index

                                        },
                                        onDelete: {
                                            deleteScannedImage(at: index)
                                        }
                                    )
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                }
                
                Spacer(minLength: 40)
            }
            .padding(.top, 16)
        }
    }
    
    // MARK: - Helper Functions
    
    private func loadVaccines() {
        guard let baby = selectedBaby else { return }
        
        // 🔥 FIREBASE: Cargar vacunas desde Firebase
        // vaccines = FirebaseManager.shared.loadVaccines(for: baby.id.uuidString)
        
        // Por ahora: generar vacunas del esquema mexicano
        vaccines = VaccineScheduleMX.generateVaccineSchedule(for: baby)
        
        // Programar notificaciones para cada vacuna pendiente
        scheduleNotificationsForAllVaccines()
    }
    
    // 🆕 Cargar imágenes escaneadas desde UserDefaults
    private func loadScannedImages() {
        guard let baby = selectedBaby else { return }
        let key = "scannedCards_\(baby.id.uuidString)"
        
        if let imageDataArray = UserDefaults.standard.array(forKey: key) as? [Data] {
            scannedCardImages = imageDataArray.compactMap { UIImage(data: $0) }
            print("✅ Cargadas \(scannedCardImages.count) imágenes escaneadas")
        }
    }
    
    // 🆕 Guardar imágenes en UserDefaults
    private func saveScannedImages() {
        guard let baby = selectedBaby else { return }
        let key = "scannedCards_\(baby.id.uuidString)"
        
        let imageDataArray = scannedCardImages.compactMap { $0.jpegData(compressionQuality: 0.8) }
        UserDefaults.standard.set(imageDataArray, forKey: key)
        print("✅ Guardadas \(imageDataArray.count) imágenes")
    }
    
    // 🆕 Eliminar imagen escaneada
    private func deleteScannedImage(at index: Int) {
        scannedCardImages.remove(at: index)
        saveScannedImages()
    }
    
    private func getVaccinesForDate(_ date: Date) -> [Vaccine] {
        vaccines.filter { Calendar.current.isDate($0.recommendedDate, inSameDayAs: date) }
    }
    
    private func getDaysInMonth(for date: Date) -> [Date?] {
        let calendar = Calendar.current
        let interval = calendar.dateInterval(of: .month, for: date)!
        let firstWeekday = calendar.component(.weekday, from: interval.start)
        let adjustedFirstWeekday = (firstWeekday + 5) % 7 // Ajustar para empezar en lunes
        
        var days: [Date?] = Array(repeating: nil, count: adjustedFirstWeekday)
        
        let range = calendar.range(of: .day, in: .month, for: date)!
        for day in range {
            if let date = calendar.date(bySetting: .day, value: day, of: date) {
                days.append(date)
            }
        }
        
        return days
    }
    
    private func getMonthYearString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_ES")
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date).capitalized
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_ES")
        formatter.dateFormat = "d 'de' MMMM"
        return formatter.string(from: date)
    }
    
    private func binding(for vaccine: Vaccine) -> Binding<Vaccine> {
        guard let index = vaccines.firstIndex(where: { $0.id == vaccine.id }) else {
            fatalError("Vaccine not found")
        }
        return $vaccines[index]
    }
    
    // MARK: - Notificaciones
    
    private func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("✅ Permisos de notificación concedidos")
            } else if let error = error {
                print("❌ Error al solicitar permisos: \(error.localizedDescription)")
            }
        }
    }
    
    private func scheduleNotificationsForAllVaccines() {
        for vaccine in vaccines where !vaccine.isApplied {
            scheduleNotifications(for: vaccine)
        }
    }
    
    private func scheduleNotifications(for vaccine: Vaccine) {
        let center = UNUserNotificationCenter.current()
        
        // Recordatorio 3 días antes
        if let threeDaysBefore = Calendar.current.date(byAdding: .day, value: -3, to: vaccine.recommendedDate) {
            scheduleNotification(
                id: "\(vaccine.id)-3days",
                title: "📅 Vacuna próxima",
                body: "En 3 días: \(vaccine.name) para \(selectedBaby?.name ?? "tu bebé")",
                date: threeDaysBefore,
                vaccine: vaccine
            )
        }
        
        // Recordatorio 1 día antes
        if let oneDayBefore = Calendar.current.date(byAdding: .day, value: -1, to: vaccine.recommendedDate) {
            scheduleNotification(
                id: "\(vaccine.id)-1day",
                title: "⏰ Vacuna mañana",
                body: "Mañana: \(vaccine.name) para \(selectedBaby?.name ?? "tu bebé")",
                date: oneDayBefore,
                vaccine: vaccine
            )
        }
        
        // Recordatorio el mismo día
        scheduleNotification(
            id: "\(vaccine.id)-today",
            title: "💉 ¡Hoy es el día!",
            body: "Hoy: \(vaccine.name) para \(selectedBaby?.name ?? "tu bebé")",
            date: vaccine.recommendedDate,
            vaccine: vaccine
        )
        
        // Recordatorio 3 días después si no se marcó como aplicada
        if let threeDaysAfter = Calendar.current.date(byAdding: .day, value: 3, to: vaccine.recommendedDate) {
            scheduleNotification(
                id: "\(vaccine.id)-3daysafter",
                title: "⚠️ Recordatorio de vacuna",
                body: "¿Ya aplicaste la vacuna \(vaccine.name)? Marca como completada.",
                date: threeDaysAfter,
                vaccine: vaccine
            )
        }
    }
    
    private func scheduleNotification(id: String, title: String, body: String, date: Date, vaccine: Vaccine) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.badge = 1
        
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Error al programar notificación: \(error.localizedDescription)")
            } else {
                print("✅ Notificación programada: \(title) para \(date)")
            }
        }
    }
    
    private func cancelNotifications(for vaccine: Vaccine) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [
            "\(vaccine.id)-3days",
            "\(vaccine.id)-1day",
            "\(vaccine.id)-today",
            "\(vaccine.id)-3daysafter"
        ])
    }
}

// MARK: - 🆕 Miniatura de Cartilla Escaneada
struct ScannedCardThumbnail: View {
    let image: UIImage
    let pageNumber: Int
    let onTap: () -> Void
    let onDelete: () -> Void
    @State private var showingDeleteAlert = false
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack(alignment: .topTrailing) {
                // Imagen
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 160)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                    .onTapGesture {
                        onTap()
                    }
                
                // Botón eliminar
                Button(action: {
                    showingDeleteAlert = true
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                        .background(
                            Circle()
                                .fill(Color.red)
                                .frame(width: 22, height: 22)
                        )
                }
                .offset(x: 8, y: -8)
            }
            
            // Número de página
            Text("Página \(pageNumber)")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.gray)
        }
        .alert("Eliminar imagen", isPresented: $showingDeleteAlert) {
            Button("Cancelar", role: .cancel) { }
            Button("Eliminar", role: .destructive) {
                onDelete()
            }
        } message: {
            Text("¿Estás segura de que deseas eliminar esta imagen de la cartilla?")
        }
    }
}

// MARK: - 🆕 Visor de Imagen en Grande
struct ImageViewerSheet: View {
    @Environment(\.dismiss) var dismiss
    let image: UIImage
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView([.horizontal, .vertical], showsIndicators: false) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width * scale, height: geometry.size.height * scale)
                        .offset(offset)
                        .gesture(
                            MagnificationGesture()
                                .onChanged { value in
                                    let delta = value / lastScale
                                    lastScale = value
                                    scale = min(max(scale * delta, 1), 4)
                                }
                                .onEnded { _ in
                                    lastScale = 1.0
                                    if scale < 1 {
                                        withAnimation {
                                            scale = 1
                                            offset = .zero
                                        }
                                    }
                                }
                        )
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    offset = CGSize(
                                        width: lastOffset.width + value.translation.width,
                                        height: lastOffset.height + value.translation.height
                                    )
                                }
                                .onEnded { _ in
                                    lastOffset = offset
                                }
                        )
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
            .background(Color.black)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .font(.system(size: 18, weight: .semibold))
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Compartir imagen
                        shareImage(image)
                    }) {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                    }
                }
            }
        }
    }
    
    private func shareImage(_ image: UIImage) {
        let activityVC = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }
}

// MARK: - Celda del Calendario
struct VaccineCalendarDayCell: View {
    let date: Date
    let vaccines: [Vaccine]
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            Text("\(Calendar.current.component(.day, from: date))")
                .font(.system(size: 14, weight: isSelected ? .semibold : .regular))
                .foregroundColor(isSelected ? .white : .black)
            
            // Indicador de vacunas
            HStack(spacing: 2) {
                ForEach(vaccines.prefix(3)) { vaccine in
                    Circle()
                        .fill(vaccine.isApplied ?
                              Color.green :
                              vaccine.recommendedDate < Date() ?
                              Color.red :
                              Color(red: 0.93, green: 0.6, blue: 0.73))
                        .frame(width: 4, height: 4)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 50)
        .background(
            isSelected ?
            Color(red: 0.93, green: 0.6, blue: 0.73) :
            !vaccines.isEmpty ?
            Color(red: 0.93, green: 0.6, blue: 0.73).opacity(0.1) :
            Color.clear
        )
        .cornerRadius(8)
    }
}

// MARK: - Tarjeta de Vacuna
struct VaccineCard: View {
    let vaccine: Vaccine
    var isDelayed: Bool = false
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                // Icono
                Image(systemName: vaccine.isApplied ? "checkmark.circle.fill" : "calendar")
                    .font(.system(size: 24))
                    .foregroundColor(
                        vaccine.isApplied ? .green :
                        isDelayed ? .red :
                        Color(red: 0.93, green: 0.6, blue: 0.73)
                    )
                    .frame(width: 50, height: 50)
                    .background(
                        (vaccine.isApplied ? Color.green :
                         isDelayed ? Color.red :
                         Color(red: 0.93, green: 0.6, blue: 0.73)).opacity(0.15)
                    )
                    .cornerRadius(12)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(vaccine.name)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.black)
                        .lineLimit(1)
                    
                    Text(formatVaccineDate(vaccine))
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    
                    Text(vaccine.description)
                        .font(.system(size: 12))
                        .foregroundColor(.gray.opacity(0.8))
                        .lineLimit(1)
                }
                
                Spacer()
                
                // Badge de estado
                Text(vaccine.isApplied ? "Aplicada" : isDelayed ? "Retrasada" : "Pendiente")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(
                        vaccine.isApplied ? .green :
                        isDelayed ? .red :
                        Color(red: 0.93, green: 0.6, blue: 0.73)
                    )
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        (vaccine.isApplied ? Color.green :
                         isDelayed ? Color.red :
                         Color(red: 0.93, green: 0.6, blue: 0.73)).opacity(0.15)
                    )
                    .cornerRadius(8)
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        }
    }
    
    private func formatVaccineDate(_ vaccine: Vaccine) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_ES")
        formatter.dateFormat = "d 'de' MMMM, yyyy"
        
        if let appliedDate = vaccine.appliedDate {
            return "Aplicada: \(formatter.string(from: appliedDate))"
        } else {
            let daysUntil = Calendar.current.dateComponents([.day], from: Date(), to: vaccine.recommendedDate).day ?? 0
            if daysUntil < 0 {
                return "Retrasada \(-daysUntil) días"
            } else if daysUntil == 0 {
                return "Hoy"
            } else if daysUntil == 1 {
                return "Mañana"
            } else if daysUntil <= 7 {
                return "En \(daysUntil) días - \(formatter.string(from: vaccine.recommendedDate))"
            } else {
                return formatter.string(from: vaccine.recommendedDate)
            }
        }
    }
}

// MARK: - Detalle de Vacuna (Sheet)
struct VaccineDetailSheet: View {
    @Environment(\.dismiss) var dismiss
    @Binding var vaccine: Vaccine
    @State private var showingDatePicker = false
    @State private var tempDate = Date()
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Icono y nombre
                    VStack(spacing: 16) {
                        Image(systemName: vaccine.isApplied ? "checkmark.seal.fill" : "syringe.fill")
                            .font(.system(size: 60))
                            .foregroundColor(vaccine.isApplied ? .green : Color(red: 0.93, green: 0.6, blue: 0.73))
                        
                        Text(vaccine.name)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                        
                        Text(vaccine.description)
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                    }
                    .padding(.top, 20)
                    
                    // Información
                    VStack(spacing: 16) {
                        InfoRow(
                            icon: "calendar",
                            title: "Fecha recomendada",
                            value: formatDate(vaccine.recommendedDate)
                        )
                        
                        if vaccine.isApplied, let appliedDate = vaccine.appliedDate {
                            InfoRow(
                                icon: "checkmark.circle.fill",
                                title: "Fecha de aplicación",
                                value: formatDate(appliedDate),
                                color: .green
                            )
                        }
                        
                        InfoRow(
                            icon: "person.fill",
                            title: "Edad recomendada",
                            value: "\(vaccine.ageInMonths) \(vaccine.ageInMonths == 1 ? "mes" : "meses")"
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    Divider()
                        .padding(.horizontal, 20)
                    
                    // Botones de acción
                    VStack(spacing: 12) {
                        if !vaccine.isApplied {
                            Button(action: {
                                tempDate = Date()
                                showingDatePicker = true
                            }) {
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 20))
                                    
                                    Text("Marcar como aplicada")
                                        .font(.system(size: 17, weight: .semibold))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color(red: 0.93, green: 0.6, blue: 0.73))
                                .cornerRadius(12)
                            }
                            
                            Button(action: {
                                // Reprogramar notificaciones
                                alertMessage = "Las notificaciones se reprogramarán cada 3 días hasta que marques la vacuna como aplicada."
                                showingAlert = true
                            }) {
                                HStack {
                                    Image(systemName: "bell.fill")
                                        .font(.system(size: 20))
                                    
                                    Text("Recordar más tarde")
                                        .font(.system(size: 17, weight: .medium))
                                }
                                .foregroundColor(Color(red: 0.93, green: 0.6, blue: 0.73))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color(red: 0.93, green: 0.6, blue: 0.73).opacity(0.1))
                                .cornerRadius(12)
                            }
                        } else {
                            Button(action: {
                                // Desmarcar como aplicada
                                vaccine.isApplied = false
                                vaccine.appliedDate = nil
                                
                                // 🔥 FIREBASE: Actualizar en Firebase
                                // FirebaseManager.shared.updateVaccine(vaccine)
                                
                                dismiss()
                            }) {
                                HStack {
                                    Image(systemName: "arrow.uturn.backward")
                                        .font(.system(size: 20))
                                    
                                    Text("Desmarcar como aplicada")
                                        .font(.system(size: 17, weight: .medium))
                                }
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.red.opacity(0.1))
                                .cornerRadius(12)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle("Detalles de vacuna")
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
        .sheet(isPresented: $showingDatePicker) {
            DatePickerSheet(selectedDate: $tempDate) {
                markAsApplied(on: tempDate)
                showingDatePicker = false
            }
        }
        .alert("Recordatorio", isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func markAsApplied(on date: Date) {
        vaccine.isApplied = true
        vaccine.appliedDate = date
        
        // Cancelar notificaciones pendientes
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [
            "\(vaccine.id)-3days",
            "\(vaccine.id)-1day",
            "\(vaccine.id)-today",
            "\(vaccine.id)-3daysafter"
        ])
        
        // 🔥 FIREBASE: Guardar en Firebase
        // FirebaseManager.shared.updateVaccine(vaccine)
        
        // Mostrar confirmación
        alertMessage = "✅ Vacuna marcada como aplicada el \(formatDate(date))"
        showingAlert = true
        
        // Cerrar después de un momento
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            dismiss()
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_ES")
        formatter.dateFormat = "d 'de' MMMM, yyyy"
        return formatter.string(from: date)
    }
}

// MARK: - Date Picker Sheet
struct DatePickerSheet: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedDate: Date
    let onConfirm: () -> Void
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Selecciona la fecha de aplicación")
                    .font(.system(size: 18, weight: .semibold))
                    .padding(.top, 20)
                
                DatePicker("Fecha", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .padding()
                
                Button(action: {
                    onConfirm()
                    dismiss()
                }) {
                    Text("Confirmar")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color(red: 0.93, green: 0.6, blue: 0.73))
                        .cornerRadius(12)
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Info Row Component
struct InfoRow: View {
    let icon: String
    let title: String
    let value: String
    var color: Color = Color(red: 0.93, green: 0.6, blue: 0.73)
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
                .frame(width: 40, height: 40)
                .background(color.opacity(0.15))
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.gray)
                
                Text(value)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.black)
            }
            
            Spacer()
        }
        .padding(12)
        .background(Color.gray.opacity(0.05))
        .cornerRadius(10)
    }
}

// MARK: - Document Scanner View
struct DocumentScannerView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var scannedImages: [UIImage]
    @State private var isShowingScanner = false
    @State private var temporaryImages: [UIImage] = []
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                if temporaryImages.isEmpty && scannedImages.isEmpty {
                    // Vista inicial
                    VStack(spacing: 20) {
                        Image(systemName: "doc.text.viewfinder")
                            .font(.system(size: 80))
                            .foregroundColor(Color(red: 0.93, green: 0.6, blue: 0.73))
                        
                        Text("Escanea la cartilla de vacunación")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                        
                        Text("Guarda una copia digital de la cartilla física de tu bebé para tener un respaldo seguro")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                        
                        Button(action: {
                            isShowingScanner = true
                        }) {
                            HStack {
                                Image(systemName: "camera.fill")
                                    .font(.system(size: 20))
                                
                                Text("Iniciar escaneo")
                                    .font(.system(size: 17, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color(red: 0.93, green: 0.6, blue: 0.73))
                            .cornerRadius(12)
                        }
                        .padding(.horizontal, 40)
                        .padding(.top, 20)
                    }
                } else {
                    // Vista de previsualización
                    ScrollView {
                        VStack(spacing: 16) {
                            Text("Páginas escaneadas: \(temporaryImages.count)")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.black)
                            
                            ForEach(Array(temporaryImages.enumerated()), id: \.offset) { index, image in
                                VStack(spacing: 8) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFit()
                                        .cornerRadius(12)
                                        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                                    
                                    Text("Página \(scannedImages.count + index + 1)")
                                        .font(.system(size: 14))
                                        .foregroundColor(.gray)
                                }
                                .padding(.horizontal, 20)
                            }
                            
                            // Botón para agregar más páginas
                            Button(action: {
                                isShowingScanner = true
                            }) {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.system(size: 20))
                                    
                                    Text("Agregar más páginas")
                                        .font(.system(size: 17, weight: .medium))
                                }
                                .foregroundColor(Color(red: 0.93, green: 0.6, blue: 0.73))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color(red: 0.93, green: 0.6, blue: 0.73).opacity(0.1))
                                .cornerRadius(12)
                            }
                            .padding(.horizontal, 20)
                            
                            // Botón para guardar
                            Button(action: {
                                saveScannedDocument()
                            }) {
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 20))
                                    
                                    Text("Guardar cartilla")
                                        .font(.system(size: 17, weight: .semibold))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color(red: 0.93, green: 0.6, blue: 0.73))
                                .cornerRadius(12)
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 40)
                        }
                        .padding(.top, 20)
                    }
                }
            }
            .navigationTitle("Escanear cartilla")
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
        .sheet(isPresented: $isShowingScanner) {
            DocumentScannerViewControllerWrapper(scannedImages: $temporaryImages)
        }
    }
    
    private func saveScannedDocument() {
        // Agregar las imágenes temporales al array principal
        scannedImages.append(contentsOf: temporaryImages)
        temporaryImages.removeAll()
        
        print("✅ Cartilla escaneada guardada: \(scannedImages.count) páginas totales")
        dismiss()
    }
}

// MARK: - Document Scanner Wrapper (VisionKit)
struct DocumentScannerViewControllerWrapper: UIViewControllerRepresentable {
    @Environment(\.dismiss) var dismiss
    @Binding var scannedImages: [UIImage]
    
    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let scannerViewController = VNDocumentCameraViewController()
        scannerViewController.delegate = context.coordinator
        return scannerViewController
    }
    
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        let parent: DocumentScannerViewControllerWrapper
        
        init(_ parent: DocumentScannerViewControllerWrapper) {
            self.parent = parent
        }
        
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            for pageIndex in 0..<scan.pageCount {
                let image = scan.imageOfPage(at: pageIndex)
                parent.scannedImages.append(image)
            }
            parent.dismiss()
        }
        
        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            parent.dismiss()
        }
        
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            print("❌ Error al escanear: \(error.localizedDescription)")
            parent.dismiss()
        }
    }
}

// MARK: - Preview
#Preview {
    VaccineCalendarView(selectedBaby: .constant(Baby(
        name: "Sofía",
        birthDate: Calendar.current.date(byAdding: .month, value: -3, to: Date()) ?? Date(),
        gender: "girl"
    )))
}
