//
//  ExportPDFSheetComplete.swift
//  ChildCare
//
//  Created by Martha Heredia Andrade on 20/10/25.
//

import SwiftUI
import PDFKit

// MARK: - 📊 DATOS MOCK PARA PDF
struct MockDataManager {
    static let babyName = "Sofía Martínez"
    static let babyAge = "8 meses"
    static let parentName = "María Martínez"
    
    // Síntomas últimos 7 días
    static let symptomHistory: [(date: String, symptoms: [String])] = [
        ("20 Oct", ["fiebre", "tos"]),
        ("19 Oct", ["fiebre", "congestion"]),
        ("18 Oct", ["tos"]),
        ("17 Oct", ["tos", "irritable"]),
        ("16 Oct", []),
        ("15 Oct", ["congestion"]),
        ("14 Oct", ["congestion", "tos"])
    ]
    
    // Hábitos últimos 7 días
    static let habitHistory: [(date: String, feeding: Int, sleep: Double, diapers: Int)] = [
        ("20 Oct", 650, 9.5, 6),
        ("19 Oct", 620, 8.0, 7),
        ("18 Oct", 700, 10.0, 6),
        ("17 Oct", 680, 9.0, 5),
        ("16 Oct", 650, 8.5, 6),
        ("15 Oct", 720, 9.5, 7),
        ("14 Oct", 690, 9.0, 6)
    ]
    
    static func symptomName(_ id: String) -> String {
        switch id {
        case "fiebre": return "Fiebre"
        case "tos": return "Tos"
        case "congestion": return "Congestión"
        case "diarrea": return "Diarrea"
        case "vomito": return "Vómito"
        case "irritable": return "Irritable"
        case "sarpullido": return "Sarpullido"
        case "dolor": return "Dolor"
        default: return id
        }
    }
}

// MARK: - 📄 GENERADOR DE PDF PROFESIONAL
class ProfessionalPDFGenerator {
    
    private let pageWidth: CGFloat = 595.0  // A4 width
    private let pageHeight: CGFloat = 842.0  // A4 height
    private let margin: CGFloat = 50.0
    
    private let primaryColor = UIColor(red: 0.93, green: 0.6, blue: 0.73, alpha: 1.0)
    private let accentColor = UIColor(red: 0.85, green: 0.7, blue: 1.0, alpha: 1.0)
    
    func generatePDF(type: Int) -> Data {
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = [
            kCGPDFContextCreator: "ChildCare App",
            kCGPDFContextAuthor: MockDataManager.parentName,
            kCGPDFContextTitle: "Informe Médico Pediátrico"
        ] as [String: Any]
        
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        
        return renderer.pdfData { context in
            context.beginPage()
            
            var yPosition: CGFloat = margin
            
            // 🎨 HEADER CON GRADIENTE
            yPosition = drawHeader(context: context.cgContext, yPosition: yPosition)
            
            // 👶 INFO DEL BEBÉ
            yPosition = drawBabyInfo(context: context.cgContext, yPosition: yPosition)
            
            if type == 0 {
                // 📊 INFORME DE SÍNTOMAS
                yPosition = drawSymptomsSummary(context: context.cgContext, yPosition: yPosition)
                yPosition = drawSymptomsChart(context: context.cgContext, yPosition: yPosition)
                yPosition = drawSymptomsTable(context: context.cgContext, yPosition: yPosition)
                
                // Nueva página si es necesario
                if yPosition > pageHeight - 200 {
                    context.beginPage()
                    yPosition = margin
                }
                
                yPosition = drawMedicalRecommendations(context: context.cgContext, yPosition: yPosition, type: 0)
            } else {
                // 📊 INFORME DE HÁBITOS
                yPosition = drawHabitsSummary(context: context.cgContext, yPosition: yPosition)
                yPosition = drawHabitsChart(context: context.cgContext, yPosition: yPosition)
                yPosition = drawHabitsTable(context: context.cgContext, yPosition: yPosition)
                
                // Nueva página si es necesario
                if yPosition > pageHeight - 200 {
                    context.beginPage()
                    yPosition = margin
                }
                
                yPosition = drawMedicalRecommendations(context: context.cgContext, yPosition: yPosition, type: 1)
            }
            
            // 📝 FOOTER
            drawFooter(context: context.cgContext)
        }
    }
    
    // MARK: - 🎨 HEADER
    private func drawHeader(context: CGContext, yPosition: CGFloat) -> CGFloat {
        var y = yPosition
        
        // Rectángulo de fondo con gradiente simulado
        context.setFillColor(primaryColor.cgColor)
        context.fill(CGRect(x: 0, y: y, width: pageWidth, height: 80))
        
        // Logo circular (simulado)
        context.setFillColor(UIColor.white.cgColor)
        context.fillEllipse(in: CGRect(x: margin, y: y + 15, width: 50, height: 50))
        
        // Símbolo de salud
        let symbolAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 30),
            .foregroundColor: primaryColor
        ]
        "👶".draw(at: CGPoint(x: margin + 10, y: y + 20), withAttributes: symbolAttributes)
        
        // Título
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 24),
            .foregroundColor: UIColor.white
        ]
        "Informe Médico Pediátrico".draw(at: CGPoint(x: margin + 70, y: y + 20), withAttributes: titleAttributes)
        
        // Subtítulo
        let subtitleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12),
            .foregroundColor: UIColor.white.withAlphaComponent(0.9)
        ]
        "Generado por ChildCare App".draw(at: CGPoint(x: margin + 70, y: y + 48), withAttributes: subtitleAttributes)
        
        return y + 100
    }
    
    // MARK: - 👶 INFO DEL BEBÉ
    private func drawBabyInfo(context: CGContext, yPosition: CGFloat) -> CGFloat {
        var y = yPosition
        
        // Caja con borde
        let boxRect = CGRect(x: margin, y: y, width: pageWidth - 2 * margin, height: 90)
        context.setStrokeColor(primaryColor.cgColor)
        context.setLineWidth(2)
        context.stroke(boxRect)
        
        // Fondo suave
        context.setFillColor(primaryColor.withAlphaComponent(0.05).cgColor)
        context.fill(boxRect)
        
        let labelAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 11),
            .foregroundColor: UIColor.gray
        ]
        
        let valueAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 14),
            .foregroundColor: UIColor.black
        ]
        
        // Columna 1
        "Paciente:".draw(at: CGPoint(x: margin + 20, y: y + 15), withAttributes: labelAttributes)
        MockDataManager.babyName.draw(at: CGPoint(x: margin + 20, y: y + 30), withAttributes: valueAttributes)
        
        "Edad:".draw(at: CGPoint(x: margin + 20, y: y + 55), withAttributes: labelAttributes)
        MockDataManager.babyAge.draw(at: CGPoint(x: margin + 20, y: y + 70), withAttributes: valueAttributes)
        
        // Columna 2
        let col2X = margin + 200
        "Responsable:".draw(at: CGPoint(x: col2X, y: y + 15), withAttributes: labelAttributes)
        MockDataManager.parentName.draw(at: CGPoint(x: col2X, y: y + 30), withAttributes: valueAttributes)
        
        "Fecha de generación:".draw(at: CGPoint(x: col2X, y: y + 55), withAttributes: labelAttributes)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "es_ES")
        dateFormatter.dateStyle = .medium
        dateFormatter.string(from: Date()).draw(at: CGPoint(x: col2X, y: y + 70), withAttributes: valueAttributes)
        
        return y + 110
    }
    
    // MARK: - 📊 RESUMEN DE SÍNTOMAS
    private func drawSymptomsSummary(context: CGContext, yPosition: CGFloat) -> CGFloat {
        var y = yPosition
        
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 18),
            .foregroundColor: UIColor.black
        ]
        "Resumen de Síntomas (Últimos 7 días)".draw(at: CGPoint(x: margin, y: y), withAttributes: titleAttributes)
        y += 35
        
        // Contar síntomas
        var symptomCounts: [String: Int] = [:]
        for record in MockDataManager.symptomHistory {
            for symptom in record.symptoms {
                symptomCounts[symptom, default: 0] += 1
            }
        }
        
        // Mostrar top 3
        let sorted = symptomCounts.sorted { $0.value > $1.value }.prefix(3)
        
        var xOffset: CGFloat = margin
        for (symptom, count) in sorted {
            let boxWidth: CGFloat = 150
            
            // Caja de estadística
            let boxRect = CGRect(x: xOffset, y: y, width: boxWidth, height: 70)
            context.setFillColor(primaryColor.withAlphaComponent(0.1).cgColor)
            context.fill(boxRect)
            context.setStrokeColor(primaryColor.cgColor)
            context.setLineWidth(1)
            context.stroke(boxRect)
            
            // Contador grande
            let countAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 32),
                .foregroundColor: primaryColor
            ]
            "\(count)".draw(at: CGPoint(x: xOffset + 15, y: y + 10), withAttributes: countAttributes)
            
            // Nombre del síntoma
            let nameAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 12),
                .foregroundColor: UIColor.darkGray
            ]
            MockDataManager.symptomName(symptom).draw(at: CGPoint(x: xOffset + 15, y: y + 48), withAttributes: nameAttributes)
            
            xOffset += boxWidth + 20
        }
        
        return y + 90
    }
    
    // MARK: - 📈 GRÁFICA DE SÍNTOMAS
    private func drawSymptomsChart(context: CGContext, yPosition: CGFloat) -> CGFloat {
        var y = yPosition
        
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 16),
            .foregroundColor: UIColor.black
        ]
        "Evolución Temporal".draw(at: CGPoint(x: margin, y: y), withAttributes: titleAttributes)
        y += 30
        
        let chartHeight: CGFloat = 150
        let chartWidth = pageWidth - 2 * margin - 40
        let chartX = margin + 40
        
        // Fondo del gráfico
        context.setFillColor(UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0).cgColor)
        context.fill(CGRect(x: chartX, y: y, width: chartWidth, height: chartHeight))
        
        // Ejes
        context.setStrokeColor(UIColor.lightGray.cgColor)
        context.setLineWidth(1)
        
        // Eje Y (vertical)
        context.move(to: CGPoint(x: chartX, y: y))
        context.addLine(to: CGPoint(x: chartX, y: y + chartHeight))
        context.strokePath()
        
        // Eje X (horizontal)
        context.move(to: CGPoint(x: chartX, y: y + chartHeight))
        context.addLine(to: CGPoint(x: chartX + chartWidth, y: y + chartHeight))
        context.strokePath()
        
        // Líneas de cuadrícula
        context.setStrokeColor(UIColor.lightGray.withAlphaComponent(0.3).cgColor)
        for i in 1...3 {
            let yPos = y + (chartHeight / 4) * CGFloat(i)
            context.move(to: CGPoint(x: chartX, y: yPos))
            context.addLine(to: CGPoint(x: chartX + chartWidth, y: yPos))
        }
        context.strokePath()
        
        // Etiquetas eje Y
        let labelAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 9),
            .foregroundColor: UIColor.gray
        ]
        for i in 0...4 {
            let label = "\(i)"
            let yPos = y + chartHeight - (chartHeight / 4) * CGFloat(i)
            label.draw(at: CGPoint(x: chartX - 20, y: yPos - 5), withAttributes: labelAttributes)
        }
        
        // Datos del gráfico (barras)
        let barWidth = chartWidth / CGFloat(MockDataManager.symptomHistory.count) * 0.6
        let spacing = chartWidth / CGFloat(MockDataManager.symptomHistory.count)
        
        for (index, record) in MockDataManager.symptomHistory.enumerated().reversed() {
            let count = record.symptoms.count
            let barHeight = (CGFloat(count) / 4.0) * chartHeight
            
            let xPos = chartX + CGFloat(MockDataManager.symptomHistory.count - index - 1) * spacing + (spacing - barWidth) / 2
            let yPos = y + chartHeight - barHeight
            
            // Barra
            context.setFillColor(primaryColor.withAlphaComponent(0.7).cgColor)
            context.fill(CGRect(x: xPos, y: yPos, width: barWidth, height: barHeight))
            
            // Etiqueta fecha
            record.date.draw(at: CGPoint(x: xPos - 5, y: y + chartHeight + 5), withAttributes: labelAttributes)
        }
        
        return y + chartHeight + 40
    }
    
    // MARK: - 📋 TABLA DE SÍNTOMAS
    private func drawSymptomsTable(context: CGContext, yPosition: CGFloat) -> CGFloat {
        var y = yPosition
        
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 16),
            .foregroundColor: UIColor.black
        ]
        "Registro Detallado".draw(at: CGPoint(x: margin, y: y), withAttributes: titleAttributes)
        y += 30
        
        let tableWidth = pageWidth - 2 * margin
        let rowHeight: CGFloat = 30
        let col1Width: CGFloat = 100
        let col2Width = tableWidth - col1Width
        
        // Header
        context.setFillColor(primaryColor.cgColor)
        context.fill(CGRect(x: margin, y: y, width: tableWidth, height: rowHeight))
        
        let headerAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 12),
            .foregroundColor: UIColor.white
        ]
        "Fecha".draw(at: CGPoint(x: margin + 10, y: y + 8), withAttributes: headerAttributes)
        "Síntomas".draw(at: CGPoint(x: margin + col1Width + 10, y: y + 8), withAttributes: headerAttributes)
        
        y += rowHeight
        
        // Filas
        let cellAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 11),
            .foregroundColor: UIColor.black
        ]
        
        for (index, record) in MockDataManager.symptomHistory.enumerated() {
            let bgColor = index % 2 == 0 ? UIColor.white : UIColor(white: 0.97, alpha: 1.0)
            context.setFillColor(bgColor.cgColor)
            context.fill(CGRect(x: margin, y: y, width: tableWidth, height: rowHeight))
            
            // Bordes
            context.setStrokeColor(UIColor.lightGray.cgColor)
            context.setLineWidth(0.5)
            context.stroke(CGRect(x: margin, y: y, width: tableWidth, height: rowHeight))
            
            record.date.draw(at: CGPoint(x: margin + 10, y: y + 8), withAttributes: cellAttributes)
            
            let symptomsText = record.symptoms.isEmpty ? "Sin síntomas" : record.symptoms.map { MockDataManager.symptomName($0) }.joined(separator: ", ")
            symptomsText.draw(at: CGPoint(x: margin + col1Width + 10, y: y + 8), withAttributes: cellAttributes)
            
            y += rowHeight
        }
        
        return y + 30
    }
    
    // MARK: - 📊 RESUMEN DE HÁBITOS
    private func drawHabitsSummary(context: CGContext, yPosition: CGFloat) -> CGFloat {
        var y = yPosition
        
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 18),
            .foregroundColor: UIColor.black
        ]
        "Resumen de Hábitos (Últimos 7 días)".draw(at: CGPoint(x: margin, y: y), withAttributes: titleAttributes)
        y += 35
        
        // Calcular promedios
        let avgFeeding = MockDataManager.habitHistory.map { $0.feeding }.reduce(0, +) / MockDataManager.habitHistory.count
        let avgSleep = MockDataManager.habitHistory.map { $0.sleep }.reduce(0, +) / Double(MockDataManager.habitHistory.count)
        let avgDiapers = MockDataManager.habitHistory.map { $0.diapers }.reduce(0, +) / MockDataManager.habitHistory.count
        
        let stats = [
            ("🍼", "Alimentación", "\(avgFeeding) ml", "Promedio diario"),
            ("😴", "Sueño", String(format: "%.1f hrs", avgSleep), "Promedio diario"),
            ("👶", "Pañales", "\(avgDiapers)", "Cambios diarios")
        ]
        
        var xOffset: CGFloat = margin
        for stat in stats {
            let boxWidth: CGFloat = 150
            
            // Caja
            let boxRect = CGRect(x: xOffset, y: y, width: boxWidth, height: 90)
            context.setFillColor(accentColor.withAlphaComponent(0.1).cgColor)
            context.fill(boxRect)
            context.setStrokeColor(accentColor.cgColor)
            context.setLineWidth(1)
            context.stroke(boxRect)
            
            // Emoji
            let emojiAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 24)
            ]
            stat.0.draw(at: CGPoint(x: xOffset + 15, y: y + 10), withAttributes: emojiAttributes)
            
            // Valor
            let valueAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 20),
                .foregroundColor: accentColor
            ]
            stat.2.draw(at: CGPoint(x: xOffset + 15, y: y + 40), withAttributes: valueAttributes)
            
            // Descripción
            let descAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 10),
                .foregroundColor: UIColor.darkGray
            ]
            stat.1.draw(at: CGPoint(x: xOffset + 15, y: y + 68), withAttributes: descAttributes)
            
            xOffset += boxWidth + 20
        }
        
        return y + 110
    }
    
    // MARK: - 📈 GRÁFICA DE HÁBITOS
    private func drawHabitsChart(context: CGContext, yPosition: CGFloat) -> CGFloat {
        var y = yPosition
        
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 16),
            .foregroundColor: UIColor.black
        ]
        "Evolución del Sueño".draw(at: CGPoint(x: margin, y: y), withAttributes: titleAttributes)
        y += 30
        
        let chartHeight: CGFloat = 150
        let chartWidth = pageWidth - 2 * margin - 40
        let chartX = margin + 40
        
        // Fondo
        context.setFillColor(UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0).cgColor)
        context.fill(CGRect(x: chartX, y: y, width: chartWidth, height: chartHeight))
        
        // Ejes
        context.setStrokeColor(UIColor.lightGray.cgColor)
        context.setLineWidth(1)
        context.move(to: CGPoint(x: chartX, y: y))
        context.addLine(to: CGPoint(x: chartX, y: y + chartHeight))
        context.move(to: CGPoint(x: chartX, y: y + chartHeight))
        context.addLine(to: CGPoint(x: chartX + chartWidth, y: y + chartHeight))
        context.strokePath()
        
        // Línea de tendencia
        context.setStrokeColor(accentColor.cgColor)
        context.setLineWidth(2.5)
        
        let pointSpacing = chartWidth / CGFloat(MockDataManager.habitHistory.count - 1)
        var isFirstPoint = true
        
        for (index, record) in MockDataManager.habitHistory.enumerated().reversed() {
            let xPos = chartX + CGFloat(MockDataManager.habitHistory.count - index - 1) * pointSpacing
            let yPos = y + chartHeight - (CGFloat(record.sleep) / 12.0) * chartHeight
            
            if isFirstPoint {
                context.move(to: CGPoint(x: xPos, y: yPos))
                isFirstPoint = false
            } else {
                context.addLine(to: CGPoint(x: xPos, y: yPos))
            }
            
            // Punto
            context.strokePath()
            context.fillEllipse(in: CGRect(x: xPos - 4, y: yPos - 4, width: 8, height: 8))
            context.move(to: CGPoint(x: xPos, y: yPos))
        }
        context.strokePath()
        
        return y + chartHeight + 40
    }
    
    // MARK: - 📋 TABLA DE HÁBITOS
    private func drawHabitsTable(context: CGContext, yPosition: CGFloat) -> CGFloat {
        var y = yPosition
        
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 16),
            .foregroundColor: UIColor.black
        ]
        "Registro Detallado".draw(at: CGPoint(x: margin, y: y), withAttributes: titleAttributes)
        y += 30
        
        let tableWidth = pageWidth - 2 * margin
        let rowHeight: CGFloat = 30
        let colWidth = tableWidth / 4
        
        // Header
        context.setFillColor(accentColor.cgColor)
        context.fill(CGRect(x: margin, y: y, width: tableWidth, height: rowHeight))
        
        let headerAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 11),
            .foregroundColor: UIColor.white
        ]
        
        ["Fecha", "Alimentación", "Sueño", "Pañales"].enumerated().forEach { index, header in
            header.draw(at: CGPoint(x: margin + CGFloat(index) * colWidth + 10, y: y + 8), withAttributes: headerAttributes)
        }
        
        y += rowHeight
        
        // Filas
        let cellAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 10),
            .foregroundColor: UIColor.black
        ]
        
        for (index, record) in MockDataManager.habitHistory.enumerated() {
            let bgColor = index % 2 == 0 ? UIColor.white : UIColor(white: 0.97, alpha: 1.0)
            context.setFillColor(bgColor.cgColor)
            context.fill(CGRect(x: margin, y: y, width: tableWidth, height: rowHeight))
            
            context.setStrokeColor(UIColor.lightGray.cgColor)
            context.setLineWidth(0.5)
            context.stroke(CGRect(x: margin, y: y, width: tableWidth, height: rowHeight))
            
            let data = [
                record.date,
                "\(record.feeding) ml",
                String(format: "%.1f hrs", record.sleep),
                "\(record.diapers) cambios"
            ]
            
            data.enumerated().forEach { index, text in
                text.draw(at: CGPoint(x: margin + CGFloat(index) * colWidth + 10, y: y + 8), withAttributes: cellAttributes)
            }
            
            y += rowHeight
        }
        
        return y + 30
    }
    
    // MARK: - 💡 RECOMENDACIONES
    private func drawMedicalRecommendations(context: CGContext, yPosition: CGFloat, type: Int) -> CGFloat {
        var y = yPosition
        
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 16),
            .foregroundColor: UIColor.black
        ]
        "Recomendaciones Médicas".draw(at: CGPoint(x: margin, y: y), withAttributes: titleAttributes)
        y += 30
        
        // Caja de recomendación
        let boxHeight: CGFloat = 120
        context.setFillColor(UIColor(red: 1.0, green: 0.98, blue: 0.9, alpha: 1.0).cgColor)
        context.fill(CGRect(x: margin, y: y, width: pageWidth - 2 * margin, height: boxHeight))
        
        context.setStrokeColor(UIColor.orange.cgColor)
        context.setLineWidth(2)
        context.stroke(CGRect(x: margin, y: y, width: pageWidth - 2 * margin, height: boxHeight))
        
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 11),
            .foregroundColor: UIColor.darkGray
        ]
        
        if type == 0 {
            let text = """
            ⚠️ Importante:
            • Si la fiebre persiste más de 3 días o supera los 38.5°C, consulte al pediatra.
            • La tos persistente debe ser evaluada por un profesional.
            • Mantenga al bebé hidratado y observe signos de deshidratación.
            • Este informe es informativo y no sustituye la consulta médica profesional.
            """
            text.draw(in: CGRect(x: margin + 15, y: y + 15, width: pageWidth - 2 * margin - 30, height: boxHeight - 30), withAttributes: textAttributes)
        } else {
            let text = """
            💡 Recomendaciones:
            • Mantener rutinas regulares de alimentación y sueño es fundamental.
            • El promedio de sueño para bebés de esta edad es 12-14 horas al día.
            • Monitoree la cantidad de pañales mojados (6-8 por día es normal).
            • Consulte con su pediatra si nota cambios significativos en los hábitos.
            """
            text.draw(in: CGRect(x: margin + 15, y: y + 15, width: pageWidth - 2 * margin - 30, height: boxHeight - 30), withAttributes: textAttributes)
        }
        
        return y + boxHeight + 20
    }
    
    // MARK: - 📝 FOOTER
    private func drawFooter(context: CGContext) {
        let footerY = pageHeight - 40
        
        // Línea separadora
        context.setStrokeColor(UIColor.lightGray.cgColor)
        context.setLineWidth(0.5)
        context.move(to: CGPoint(x: margin, y: footerY))
        context.addLine(to: CGPoint(x: pageWidth - margin, y: footerY))
        context.strokePath()
        
        let footerAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 9),
            .foregroundColor: UIColor.gray
        ]
        
        "Generado por ChildCare App - Este documento es confidencial".draw(at: CGPoint(x: margin, y: footerY + 10), withAttributes: footerAttributes)
        
        let pageNumber = "Página 1 de 1"
        let pageSize = pageNumber.size(withAttributes: footerAttributes)
        pageNumber.draw(at: CGPoint(x: pageWidth - margin - pageSize.width, y: footerY + 10), withAttributes: footerAttributes)
    }
}

// MARK: - 📄 ACTUALIZAR ExportPDFSheet CON GENERADOR COMPLETO

struct ExportPDFSheetComplete: View {
    @Environment(\.dismiss) var dismiss
    let selectedTab: Int
    @State private var showShareSheet = false
    @State private var pdfURL: URL?
    @State private var isGenerating = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 1.0, green: 0.98, blue: 0.99).ignoresSafeArea()
                
                VStack(spacing: 24) {
                    Image(systemName: "doc.richtext.fill")
                        .font(.system(size: 60))
                        .foregroundColor(Color(red: 0.93, green: 0.6, blue: 0.73))
                        .padding(.top, 40)
                    
                    Text("Exportar Informe Médico")
                        .font(.system(size: 24, weight: .bold))
                    
                    Text("Genera un PDF profesional con gráficas y datos de \(selectedTab == 0 ? "síntomas" : "hábitos") para compartir con el pediatra.")
                        .font(.system(size: 15))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        FeatureRowPDF(icon: "chart.bar.fill", text: "Gráficas de evolución profesionales")
                        FeatureRowPDF(icon: "calendar", text: "Historial completo de 7 días")
                        FeatureRowPDF(icon: "tablecells.fill", text: "Tablas detalladas con datos")
                        FeatureRowPDF(icon: "stethoscope", text: "Recomendaciones médicas")
                        FeatureRowPDF(icon: "star.fill", text: "Formato A4 listo para imprimir")
                    }
                    .padding(20)
                    .background(Color.gray.opacity(0.05))
                    .cornerRadius(16)
                    .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    if isGenerating {
                        VStack(spacing: 12) {
                            ProgressView()
                                .scaleEffect(1.2)
                            Text("Generando PDF profesional...")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 30)
                    } else {
                        Button(action: {
                            generatePDF()
                        }) {
                            HStack {
                                Image(systemName: "arrow.down.doc.fill")
                                    .font(.system(size: 18))
                                Text("Generar PDF Profesional")
                                    .font(.system(size: 17, weight: .semibold))
                            }
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
                        .padding(.horizontal, 32)
                        .padding(.bottom, 40)
                    }
                }
            }
            .navigationTitle("Exportar PDF")
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
        .sheet(isPresented: $showShareSheet) {
            if let url = pdfURL {
                ShareSheet(items: [url])
            }
        }
    }
    
    private func generatePDF() {
        isGenerating = true
        
        // Simular proceso de generación (para feedback visual)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let generator = ProfessionalPDFGenerator()
            let pdfData = generator.generatePDFWithAllCharts(type: selectedTab)
            
            // Guardar PDF
            let fileName = "informe_medico_\(selectedTab == 0 ? "sintomas" : "habitos")_\(Date().timeIntervalSince1970).pdf"
            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
            
            do {
                try pdfData.write(to: tempURL)
                self.pdfURL = tempURL
                self.isGenerating = false
                
                // Mostrar sheet de compartir después de un pequeño delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.showShareSheet = true
                }
                
                print("✅ PDF generado exitosamente en: \(tempURL.path)")
            } catch {
                print("❌ Error guardando PDF: \(error)")
                self.isGenerating = false
            }
        }
    }
}

extension ProfessionalPDFGenerator {
    
    func generatePDFWithAllCharts(type: Int) -> Data {
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = [
            kCGPDFContextCreator: "ChildCare App",
            kCGPDFContextAuthor: MockDataManager.parentName,
            kCGPDFContextTitle: "Informe Médico Pediátrico Completo"
        ] as [String: Any]
        
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        
        return renderer.pdfData { context in
            var pageNumber = 1
            
            // PÁGINA 1: RESUMEN GENERAL
            context.beginPage()
            var yPosition: CGFloat = margin
            
            yPosition = drawHeader(context: context.cgContext, yPosition: yPosition)
            yPosition = drawBabyInfo(context: context.cgContext, yPosition: yPosition)
            
            if type == 0 {
                yPosition = drawSymptomsSummary(context: context.cgContext, yPosition: yPosition)
                yPosition = drawSymptomsChart(context: context.cgContext, yPosition: yPosition)
            } else {
                yPosition = drawHabitsSummary(context: context.cgContext, yPosition: yPosition)
            }
            
            drawFooterWithPage(context: context.cgContext, pageNumber: pageNumber)
            
            if type == 0 {
                // PÁGINA 2: GRÁFICAS INDIVIDUALES DE SÍNTOMAS
                context.beginPage()
                pageNumber += 1
                yPosition = margin + 20
                
                let titleAttrs: [NSAttributedString.Key: Any] = [
                    .font: UIFont.boldSystemFont(ofSize: 20),
                    .foregroundColor: UIColor.black
                ]
                "Análisis Detallado por Síntoma".draw(at: CGPoint(x: margin, y: yPosition), withAttributes: titleAttrs)
                yPosition += 40
                
                // Fiebre
                yPosition = drawIndividualSymptomChart(
                    context: context.cgContext,
                    yPosition: yPosition,
                    symptomName: "Fiebre",
                    data: MockDataManager.symptomHistory.map { ($0.date, $0.symptoms.contains("fiebre") ? 1 : 0) },
                    color: UIColor(red: 1.0, green: 0.6, blue: 0.6, alpha: 1.0)
                )
                
                // Tos
                yPosition = drawIndividualSymptomChart(
                    context: context.cgContext,
                    yPosition: yPosition,
                    symptomName: "Tos",
                    data: MockDataManager.symptomHistory.map { ($0.date, $0.symptoms.contains("tos") ? 1 : 0) },
                    color: UIColor(red: 0.7, green: 0.85, blue: 1.0, alpha: 1.0)
                )
                
                drawFooterWithPage(context: context.cgContext, pageNumber: pageNumber)
                
                // PÁGINA 3: MÁS SÍNTOMAS + TABLA
                context.beginPage()
                pageNumber += 1
                yPosition = margin + 20
                
                // Congestión
                yPosition = drawIndividualSymptomChart(
                    context: context.cgContext,
                    yPosition: yPosition,
                    symptomName: "Congestión",
                    data: MockDataManager.symptomHistory.map { ($0.date, $0.symptoms.contains("congestion") ? 1 : 0) },
                    color: UIColor(red: 0.85, green: 0.82, blue: 0.95, alpha: 1.0)
                )
                
                yPosition = drawSymptomsTable(context: context.cgContext, yPosition: yPosition)
                
                if yPosition < pageHeight - 200 {
                    yPosition = drawMedicalRecommendations(context: context.cgContext, yPosition: yPosition, type: 0)
                }
                
                drawFooterWithPage(context: context.cgContext, pageNumber: pageNumber)
                
            } else {
                // PÁGINA 2: GRÁFICAS INDIVIDUALES DE HÁBITOS
                context.beginPage()
                pageNumber += 1
                yPosition = margin + 20
                
                let titleAttrs: [NSAttributedString.Key: Any] = [
                    .font: UIFont.boldSystemFont(ofSize: 20),
                    .foregroundColor: UIColor.black
                ]
                "Análisis Detallado de Hábitos".draw(at: CGPoint(x: margin, y: yPosition), withAttributes: titleAttrs)
                yPosition += 40
                
                // Alimentación
                yPosition = drawIndividualHabitChart(
                    context: context.cgContext,
                    yPosition: yPosition,
                    habitName: "Alimentación (ml)",
                    data: MockDataManager.habitHistory.map { ($0.date, Double($0.feeding)) },
                    color: UIColor(red: 1.0, green: 0.75, blue: 0.85, alpha: 1.0),
                    maxValue: 800
                )
                
                // Sueño
                yPosition = drawIndividualHabitChart(
                    context: context.cgContext,
                    yPosition: yPosition,
                    habitName: "Sueño (horas)",
                    data: MockDataManager.habitHistory.map { ($0.date, $0.sleep) },
                    color: UIColor(red: 0.85, green: 0.82, blue: 0.95, alpha: 1.0),
                    maxValue: 12
                )
                
                drawFooterWithPage(context: context.cgContext, pageNumber: pageNumber)
                
                // PÁGINA 3: PAÑALES + TABLA
                context.beginPage()
                pageNumber += 1
                yPosition = margin + 20
                
                // Pañales
                yPosition = drawIndividualHabitChart(
                    context: context.cgContext,
                    yPosition: yPosition,
                    habitName: "Cambios de Pañal",
                    data: MockDataManager.habitHistory.map { ($0.date, Double($0.diapers)) },
                    color: UIColor(red: 0.75, green: 0.85, blue: 1.0, alpha: 1.0),
                    maxValue: 10
                )
                
                yPosition = drawHabitsTable(context: context.cgContext, yPosition: yPosition)
                
                if yPosition < pageHeight - 200 {
                    yPosition = drawMedicalRecommendations(context: context.cgContext, yPosition: yPosition, type: 1)
                }
                
                drawFooterWithPage(context: context.cgContext, pageNumber: pageNumber)
            }
        }
    }
    
    // GRÁFICA INDIVIDUAL DE SÍNTOMA
    private func drawIndividualSymptomChart(
        context: CGContext,
        yPosition: CGFloat,
        symptomName: String,
        data: [(String, Int)],
        color: UIColor
    ) -> CGFloat {
        var y = yPosition
        
        let titleAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 15),
            .foregroundColor: color
        ]
        symptomName.draw(at: CGPoint(x: margin, y: y), withAttributes: titleAttrs)
        y += 25
        
        let chartHeight: CGFloat = 120
        let chartWidth = pageWidth - 2 * margin - 40
        let chartX = margin + 40
        
        // Fondo
        context.setFillColor(UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0).cgColor)
        context.fill(CGRect(x: chartX, y: y, width: chartWidth, height: chartHeight))
        
        // Ejes
        context.setStrokeColor(UIColor.lightGray.cgColor)
        context.setLineWidth(1)
        context.move(to: CGPoint(x: chartX, y: y))
        context.addLine(to: CGPoint(x: chartX, y: y + chartHeight))
        context.move(to: CGPoint(x: chartX, y: y + chartHeight))
        context.addLine(to: CGPoint(x: chartX + chartWidth, y: y + chartHeight))
        context.strokePath()
        
        // Etiquetas Y
        let labelAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 9),
            .foregroundColor: UIColor.gray
        ]
        "0".draw(at: CGPoint(x: chartX - 15, y: y + chartHeight - 5), withAttributes: labelAttrs)
        "1".draw(at: CGPoint(x: chartX - 15, y: y - 5), withAttributes: labelAttrs)
        
        // Barras
        let barWidth = (chartWidth / CGFloat(data.count)) * 0.7
        let spacing = chartWidth / CGFloat(data.count)
        
        for (index, record) in data.enumerated().reversed() {
            let count = record.1
            let barHeight = CGFloat(count) * chartHeight
            
            let xPos = chartX + CGFloat(data.count - index - 1) * spacing + (spacing - barWidth) / 2
            let yPos = y + chartHeight - barHeight
            
            context.setFillColor(color.withAlphaComponent(count > 0 ? 0.8 : 0.2).cgColor)
            context.fill(CGRect(x: xPos, y: yPos, width: barWidth, height: barHeight))
            
            if index % 2 == 0 {
                record.0.draw(at: CGPoint(x: xPos - 8, y: y + chartHeight + 5), withAttributes: labelAttrs)
            }
        }
        
        let total = data.filter { $0.1 > 0 }.count
        let statsAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 11),
            .foregroundColor: UIColor.darkGray
        ]
        "Días con síntoma: \(total) de \(data.count)".draw(at: CGPoint(x: chartX, y: y + chartHeight + 25), withAttributes: statsAttrs)
        
        return y + chartHeight + 50
    }
    
    // GRÁFICA INDIVIDUAL DE HÁBITO
    private func drawIndividualHabitChart(
        context: CGContext,
        yPosition: CGFloat,
        habitName: String,
        data: [(String, Double)],
        color: UIColor,
        maxValue: Double
    ) -> CGFloat {
        var y = yPosition
        
        let titleAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 15),
            .foregroundColor: color
        ]
        habitName.draw(at: CGPoint(x: margin, y: y), withAttributes: titleAttrs)
        y += 25
        
        let chartHeight: CGFloat = 120
        let chartWidth = pageWidth - 2 * margin - 40
        let chartX = margin + 40
        
        // Fondo
        context.setFillColor(UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0).cgColor)
        context.fill(CGRect(x: chartX, y: y, width: chartWidth, height: chartHeight))
        
        // Ejes
        context.setStrokeColor(UIColor.lightGray.cgColor)
        context.setLineWidth(1)
        context.move(to: CGPoint(x: chartX, y: y))
        context.addLine(to: CGPoint(x: chartX, y: y + chartHeight))
        context.move(to: CGPoint(x: chartX, y: y + chartHeight))
        context.addLine(to: CGPoint(x: chartX + chartWidth, y: y + chartHeight))
        context.strokePath()
        
        // Cuadrícula
        context.setStrokeColor(UIColor.lightGray.withAlphaComponent(0.2).cgColor)
        for i in 1...3 {
            let gridY = y + (chartHeight / 4) * CGFloat(i)
            context.move(to: CGPoint(x: chartX, y: gridY))
            context.addLine(to: CGPoint(x: chartX + chartWidth, y: gridY))
        }
        context.strokePath()
        
        // Etiquetas Y
        let labelAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 9),
            .foregroundColor: UIColor.gray
        ]
        for i in 0...4 {
            let value = Int((maxValue / 4) * Double(i))
            let labelY = y + chartHeight - (chartHeight / 4) * CGFloat(i)
            "\(value)".draw(at: CGPoint(x: chartX - 25, y: labelY - 5), withAttributes: labelAttrs)
        }
        
        // Área
        let pointSpacing = chartWidth / CGFloat(data.count - 1)
        context.setFillColor(color.withAlphaComponent(0.2).cgColor)
        context.beginPath()
        context.move(to: CGPoint(x: chartX, y: y + chartHeight))
        
        for (index, record) in data.enumerated().reversed() {
            let xPos = chartX + CGFloat(data.count - index - 1) * pointSpacing
            let normalizedValue = CGFloat(record.1 / maxValue)
            let yPos = y + chartHeight - (normalizedValue * chartHeight)
            context.addLine(to: CGPoint(x: xPos, y: yPos))
        }
        
        context.addLine(to: CGPoint(x: chartX + chartWidth, y: y + chartHeight))
        context.closePath()
        context.fillPath()
        
        // Línea
        context.setStrokeColor(color.cgColor)
        context.setLineWidth(2.5)
        context.beginPath()
        var isFirst = true
        
        for (index, record) in data.enumerated().reversed() {
            let xPos = chartX + CGFloat(data.count - index - 1) * pointSpacing
            let normalizedValue = CGFloat(record.1 / maxValue)
            let yPos = y + chartHeight - (normalizedValue * chartHeight)
            
            if isFirst {
                context.move(to: CGPoint(x: xPos, y: yPos))
                isFirst = false
            } else {
                context.addLine(to: CGPoint(x: xPos, y: yPos))
            }
            
            context.strokePath()
            context.setFillColor(color.cgColor)
            context.fillEllipse(in: CGRect(x: xPos - 3, y: yPos - 3, width: 6, height: 6))
            context.setStrokeColor(color.cgColor)
            context.beginPath()
            context.move(to: CGPoint(x: xPos, y: yPos))
            
            if index % 2 == 0 {
                record.0.draw(at: CGPoint(x: xPos - 8, y: y + chartHeight + 5), withAttributes: labelAttrs)
            }
        }
        context.strokePath()
        
        let values = data.map { $0.1 }
        let avg = values.reduce(0, +) / Double(values.count)
        let min = values.min() ?? 0
        let max = values.max() ?? 0
        
        let statsAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 11),
            .foregroundColor: UIColor.darkGray
        ]
        String(format: "Promedio: %.1f  •  Mínimo: %.1f  •  Máximo: %.1f", avg, min, max)
            .draw(at: CGPoint(x: chartX, y: y + chartHeight + 25), withAttributes: statsAttrs)
        
        return y + chartHeight + 50
    }
    
    private func drawFooterWithPage(context: CGContext, pageNumber: Int) {
        let footerY = pageHeight - 40
        
        context.setStrokeColor(UIColor.lightGray.cgColor)
        context.setLineWidth(0.5)
        context.move(to: CGPoint(x: margin, y: footerY))
        context.addLine(to: CGPoint(x: pageWidth - margin, y: footerY))
        context.strokePath()
        
        let footerAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 9),
            .foregroundColor: UIColor.gray
        ]
        
        "Generado por ChildCare App - Confidencial".draw(at: CGPoint(x: margin, y: footerY + 10), withAttributes: footerAttrs)
        
        let pageText = "Página \(pageNumber)"
        let pageSize = pageText.size(withAttributes: footerAttrs)
        pageText.draw(at: CGPoint(x: pageWidth - margin - pageSize.width, y: footerY + 10), withAttributes: footerAttrs)
    }
}


struct FeatureRowPDF: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(Color(red: 0.93, green: 0.6, blue: 0.73))
                .frame(width: 24)
            
            Text(text)
                .font(.system(size: 15))
                .foregroundColor(.black)
        }
    }
}
