//
//  BabyProfileSetupView.swift
//  ChildCare
//
//  Created by Martha Heredia Andrade on 19/10/25.
//

import SwiftUI

struct Baby: Identifiable {
    let id = UUID()
    var name: String = ""
    var birthDate: Date = Date()
    var gender: String = ""
}

struct BabyProfileSetupView: View {
    @Environment(\.dismiss) var dismiss
    @State private var currentStep = 1
    @State private var numberOfBabies = 1
    @State private var babies: [Baby] = [Baby()]
    @State private var currentBabyIndex = 0
    @State private var showingDatePicker = false
    @State private var tempDate = Date()
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var isCompleted = false
    
    private let maxSteps = 3
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header con progreso
                VStack(spacing: 16) {
                    HStack {
                        Button(action: {
                            if currentStep > 1 {
                                withAnimation {
                                    if currentStep == 3 && currentBabyIndex > 0 {
                                        currentBabyIndex -= 1
                                    } else {
                                        currentStep -= 1
                                        if currentStep == 2 {
                                            currentBabyIndex = 0
                                        }
                                    }
                                }
                            } else {
                                dismiss()
                            }
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.black)
                                .frame(width: 44, height: 44)
                        }
                        
                        Spacer()
                        
                        Text("Paso \(currentStep) de \(maxSteps)")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal, 16)
                    
                    // Barra de progreso
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(Color.gray.opacity(0.15))
                                .frame(height: 4)
                            
                            Rectangle()
                                .fill(Color(red: 0.93, green: 0.6, blue: 0.73))
                                .frame(width: geometry.size.width * CGFloat(currentStep) / CGFloat(maxSteps), height: 4)
                                .animation(.easeInOut, value: currentStep)
                        }
                    }
                    .frame(height: 4)
                    .padding(.horizontal, 16)
                }
                .padding(.top, 8)
                .padding(.bottom, 24)
                
                // Contenido principal
                ScrollView {
                    VStack(spacing: 32) {
                        if currentStep == 1 {
                            step1NumberOfBabies
                        } else if currentStep == 2 {
                            step2BabyNames
                        } else if currentStep == 3 {
                            step3BabyDetails
                        }
                    }
                    .padding(.horizontal, 32)
                    .padding(.top, 20)
                }
                
                Spacer()
                
                // Botón continuar
                VStack(spacing: 16) {
                    Button(action: {
                        handleContinue()
                    }) {
                        Text(getButtonText())
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(
                                canProceed() ? Color(red: 0.93, green: 0.6, blue: 0.73) : Color.gray.opacity(0.3)
                            )
                            .cornerRadius(12)
                    }
                    .disabled(!canProceed())
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 40)
            }
        }
        .navigationBarBackButtonHidden(true)
        .alert("ChildCare", isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
        .fullScreenCover(isPresented: $isCompleted) {
            // Aquí irá tu siguiente vista (HomeView o Dashboard)
            CompletionView()
        }
    }
    
    // MARK: - Step 1: Número de bebés
    var step1NumberOfBabies: some View {
        VStack(spacing: 24) {
            VStack(spacing: 12) {
                Image(systemName: "heart.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(Color(red: 1.0, green: 0.7, blue: 0.7))
                
                Text("Conociendo a tu bebé")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                
                Text("Cuéntanos un poco sobre tu familia para personalizar tu experiencia")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
            .padding(.top, 20)
            
            VStack(alignment: .leading, spacing: 16) {
                Text("¿Cuántos hijos tienes?")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                
                // Selector de número
                HStack(spacing: 16) {
                    ForEach(1...4, id: \.self) { number in
                        Button(action: {
                            withAnimation {
                                numberOfBabies = number
                                babies = Array(repeating: Baby(), count: number)
                            }
                        }) {
                            VStack(spacing: 8) {
                                Text("\(number)")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(numberOfBabies == number ? .white : .black)
                                
                                Text(number == 1 ? "hijo" : "hijos")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(numberOfBabies == number ? .white : .gray)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 80)
                            .background(
                                numberOfBabies == number ?
                                Color(red: 0.93, green: 0.6, blue: 0.73) :
                                Color.gray.opacity(0.08)
                            )
                            .cornerRadius(12)
                        }
                    }
                }
            }
            .padding(.top, 20)
        }
    }
    
    // MARK: - Step 2: Nombres de los bebés
    var step2BabyNames: some View {
        VStack(spacing: 24) {
            VStack(spacing: 12) {
                Image(systemName: "person.fill.badge.plus")
                    .font(.system(size: 50))
                    .foregroundColor(Color(red: 0.93, green: 0.6, blue: 0.73))
                
                Text(numberOfBabies == 1 ? "¿Cómo se llama?" : "¿Cómo se llaman?")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                
                Text(numberOfBabies == 1 ?
                     "Escribe el nombre de tu bebé" :
                     "Escribe el nombre de cada uno de tus bebés")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 20)
            
            VStack(spacing: 20) {
                ForEach(Array(babies.enumerated()), id: \.offset) { index, baby in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(numberOfBabies == 1 ? "Nombre" : "Hijo \(index + 1)")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.gray)
                            
                            Spacer()
                            
                            if !baby.name.isEmpty {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(Color(red: 0.93, green: 0.6, blue: 0.73))
                            }
                        }
                        
                        TextField("Ej: Sofía, Daniel...", text: Binding(
                            get: { babies[index].name },
                            set: { babies[index].name = $0 }
                        ))
                        .font(.system(size: 16))
                        .padding()
                        .background(Color.gray.opacity(0.08))
                        .cornerRadius(12)
                        .autocapitalization(.words)
                    }
                }
            }
            .padding(.top, 10)
        }
    }
    
    // MARK: - Step 3: Detalles de cada bebé
    var step3BabyDetails: some View {
        VStack(spacing: 24) {
            VStack(spacing: 12) {
                Image(systemName: "calendar.badge.plus")
                    .font(.system(size: 50))
                    .foregroundColor(Color(red: 0.85, green: 0.7, blue: 1.0))
                
                Text("Sobre \(babies[currentBabyIndex].name)")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                
                Text("Esto nos ayudará a darte información más precisa y personalizada")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 10)
            }
            .padding(.top, 20)
            
            VStack(spacing: 24) {
                // Fecha de nacimiento
                VStack(alignment: .leading, spacing: 8) {
                    Text("Fecha de nacimiento")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                    
                    Button(action: {
                        tempDate = babies[currentBabyIndex].birthDate
                        showingDatePicker = true
                    }) {
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(Color(red: 0.93, green: 0.6, blue: 0.73))
                            
                            Text(formatDate(babies[currentBabyIndex].birthDate))
                                .font(.system(size: 16))
                                .foregroundColor(.black)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.08))
                        .cornerRadius(12)
                    }
                }
                
                // Género
                VStack(alignment: .leading, spacing: 12) {
                    Text("Género")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                    
                    HStack(spacing: 12) {
                        GenderButton(
                            icon: "girl",
                            label: "Niña",
                            isSelected: babies[currentBabyIndex].gender == "girl",
                            action: { babies[currentBabyIndex].gender = "girl" }
                        )
                        
                        GenderButton(
                            icon: "boy",
                            label: "Niño",
                            isSelected: babies[currentBabyIndex].gender == "boy",
                            action: { babies[currentBabyIndex].gender = "boy" }
                        )
                        
                        GenderButton(
                            icon: "intersex",
                           
                            label: "Intersex",
                            isSelected: babies[currentBabyIndex].gender == "intersex",
                            action: { babies[currentBabyIndex].gender = "intersex" }
                        )
                    }
                }
                
                // Indicador de progreso si hay múltiples bebés
                if numberOfBabies > 1 {
                    HStack(spacing: 8) {
                        ForEach(0..<numberOfBabies, id: \.self) { index in
                            Circle()
                                .fill(index <= currentBabyIndex ?
                                      Color(red: 0.93, green: 0.6, blue: 0.73) :
                                      Color.gray.opacity(0.3))
                                .frame(width: 8, height: 8)
                        }
                    }
                    .padding(.top, 8)
                }
            }
            .padding(.top, 10)
        }
        .sheet(isPresented: $showingDatePicker) {
            DatePickerSheet1(selectedDate: $tempDate, onDone: {
                babies[currentBabyIndex].birthDate = tempDate
                showingDatePicker = false
            })
        }
    }
    
    // MARK: - Helper Functions
    
    private func handleContinue() {
        if currentStep == 1 {
            withAnimation {
                currentStep = 2
            }
        } else if currentStep == 2 {
            if babies.allSatisfy({ !$0.name.isEmpty }) {
                withAnimation {
                    currentStep = 3
                }
            } else {
                alertMessage = "Por favor ingresa el nombre de todos tus bebés"
                showingAlert = true
            }
        } else if currentStep == 3 {
            if babies[currentBabyIndex].gender.isEmpty {
                alertMessage = "Por favor selecciona el género de \(babies[currentBabyIndex].name)"
                showingAlert = true
                return
            }
            
            if currentBabyIndex < numberOfBabies - 1 {
                withAnimation {
                    currentBabyIndex += 1
                }
            } else {
                // Completado
                completeSetup()
            }
        }
    }
    
    private func completeSetup() {
        // Guardar datos del bebé
        print("👶 Perfil completado!")
        for (index, baby) in babies.enumerated() {
            print("Bebé \(index + 1): \(baby.name)")
        }
        
        // ✅ SOLO ESTO: Guardar ANTES de mostrar animación
        @AppStorage("hasCompletedBabySetup") var hasCompletedBabySetup = false
        hasCompletedBabySetup = true
        
        // ✅ Mostrar animación BONITA
        isCompleted = true
    }
    
    private func canProceed() -> Bool {
        switch currentStep {
        case 1:
            return numberOfBabies > 0
        case 2:
            return babies.allSatisfy({ !$0.name.isEmpty })
        case 3:
            return !babies[currentBabyIndex].gender.isEmpty
        default:
            return false
        }
    }
    
    private func getButtonText() -> String {
        if currentStep == 3 && currentBabyIndex < numberOfBabies - 1 {
            return "Siguiente bebé"
        } else if currentStep == 3 && currentBabyIndex == numberOfBabies - 1 {
            return "Finalizar"
        } else {
            return "Continuar"
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.locale = Locale(identifier: "es_ES")
        return formatter.string(from: date)
    }
}

// MARK: - Gender Button Component
struct GenderButton: View {
    let icon: String
    let label: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(icon)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(isSelected ? .white : .gray)
                                   
                    
                
                Text(label)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(isSelected ? .white : .gray)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 80)
            .background(
                isSelected ?
                Color(red: 0.93, green: 0.6, blue: 0.73) :
                Color.gray.opacity(0.08)
            )
            .cornerRadius(12)
        }
    }
}

// MARK: - Date Picker Sheet
struct DatePickerSheet1: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedDate: Date
    let onDone: () -> Void
    
    var body: some View {
        NavigationView {
            VStack {
                DatePicker(
                    "Fecha de nacimiento",
                    selection: $selectedDate,
                    in: ...Date(),
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .padding()
                
                Spacer()
            }
            .navigationTitle("Fecha de nacimiento")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Listo") {
                        onDone()
                    }
                    .foregroundColor(Color(red: 0.93, green: 0.6, blue: 0.73))
                }
            }
        }
    }
}

// MARK: - Completion View
struct CompletionView: View {
    @AppStorage("hasCompletedBabySetup") private var hasCompletedBabySetup = false
    @State private var showAnimation = false
    @State private var navigateToHome = false
    
    var body: some View {
        ZStack {
            Color(red: 0.93, green: 0.6, blue: 0.73)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.white)
                    .scaleEffect(showAnimation ? 1.0 : 0.5)
                    .opacity(showAnimation ? 1.0 : 0.0)
                
                Text("¡Todo listo!")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .offset(y: showAnimation ? 0 : 20)
                    .opacity(showAnimation ? 1.0 : 0.0)
                
                Text("Tu perfil ha sido creado exitosamente")
                    .font(.system(size: 16))
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .offset(y: showAnimation ? 0 : 20)
                    .opacity(showAnimation ? 1.0 : 0.0)
                
                Button(action: {
                    // Asegurar que el estado está guardado
                    hasCompletedBabySetup = true
                    // Navegar a HomeView
                    navigateToHome = true
                }) {
                    Text("Comenzar")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(Color(red: 0.93, green: 0.6, blue: 0.73))
                        .frame(width: 200)
                        .frame(height: 52)
                        .background(Color.white)
                        .cornerRadius(12)
                }
                .offset(y: showAnimation ? 0 : 20)
                .opacity(showAnimation ? 1.0 : 0.0)
                .padding(.top, 20)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.2)) {
                showAnimation = true
            }
        }
        .fullScreenCover(isPresented: $navigateToHome) {
            HomeView()
        }
    }
}
#Preview {
    BabyProfileSetupView()
}
