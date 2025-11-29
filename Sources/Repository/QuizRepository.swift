import Foundation

class QuizRepository: ObservableObject {
    static let shared = QuizRepository()
    
    private init() {}
    
    func loadQuestions(for topic: QuizTopic) -> [Question] {
        guard let url = Bundle.main.url(forResource: topic.fileName, withExtension: "json", subdirectory: "questions"),
              let data = try? Data(contentsOf: url) else {
            print("Failed to load questions for \(topic.fileName)")
            return []
        }
        
        do {

            let allQuestions = try JSONDecoder().decode([Question].self, from: data)
            
            // 間違えた問題のみの特別ロジック
            if topic == .mistakes {
                let incorrectIDs = HistoryManager.shared.getIncorrectQuestionIDs()
                if incorrectIDs.isEmpty {
                    // 履歴がない場合はランダムに10問
                    let shuffled = allQuestions.shuffled()
                    return Array(shuffled.prefix(min(10, shuffled.count)))
                } else {
                    // 間違えた問題IDに一致するものを全て取得
                    let mistakes = allQuestions.filter { incorrectIDs.contains($0.id) }
                    // IDがあっても問題データが見つからない場合（データ変更など）の対策
                    if mistakes.isEmpty {
                        let shuffled = allQuestions.shuffled()
                        return Array(shuffled.prefix(min(10, shuffled.count)))
                    }
                    return mistakes
                }
            }
            
            let filtered = allQuestions.filter { $0.category == topic.category }
            let source = filtered.isEmpty ? allQuestions : filtered
            if filtered.isEmpty {
                print("Warning: No category match for \(topic.category). Falling back to full question set.")
            }
            
            let shuffled = source.shuffled()
            return Array(shuffled.prefix(min(10, shuffled.count)))
        } catch {
            print("Decoding error for \(topic.fileName): \(error)")
            return []
        }
    }
}
