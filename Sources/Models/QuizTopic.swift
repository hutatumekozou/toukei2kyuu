import Foundation

enum QuizTopic: CaseIterable, Identifiable {
    case keigo
    case bunpo
    case goi
    case imi
    case hyoki
    
    var id: String { category }
    
    var title: String { category }
    
    var category: String {
        switch self {
        case .keigo: return "敬語"
        case .bunpo: return "文法"
        case .goi:   return "語彙"
        case .imi:   return "意味"
        case .hyoki: return "表記"
        }
    }
    
    var fileName: String {
        "questions_ja3"
    }
}
