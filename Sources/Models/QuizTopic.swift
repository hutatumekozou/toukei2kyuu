import Foundation

enum QuizTopic: CaseIterable, Identifiable {
    case stat1
    case stat2
    case stat3
    case stat4
    case stat5
    case stat6
    case stat7
    case stat8
    case stat9
    case stat10
    
    var id: String { category }
    
    var title: String {
        switch self {
        case .stat1: return "ジャンル1: 1変数データ"
        case .stat2: return "ジャンル2: 2変数データ"
        case .stat3: return "ジャンル3: データ収集法"
        case .stat4: return "ジャンル4: 確率"
        case .stat5: return "ジャンル5: 確率分布"
        case .stat6: return "ジャンル6: 標本分布"
        case .stat7: return "ジャンル7: 推定"
        case .stat8: return "ジャンル8: 仮説検定"
        case .stat9: return "ジャンル9: カイ二乗検定"
        case .stat10: return "ジャンル10: 線形モデル"
        }
    }
    
    var category: String {
        switch self {
        case .stat1: return "1変数データ"
        case .stat2: return "2変数データ"
        case .stat3: return "データ収集法"
        case .stat4: return "確率"
        case .stat5: return "確率分布"
        case .stat6: return "標本分布"
        case .stat7: return "推定"
        case .stat8: return "仮説検定"
        case .stat9: return "カイ二乗検定"
        case .stat10: return "線形モデル"
        }
    }
    
    var fileName: String {
        return "statistics_grade2"
    }
}
