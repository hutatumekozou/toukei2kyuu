import Foundation

class HistoryManager {
    static let shared = HistoryManager()
    
    private let defaults = UserDefaults.standard
    private let incorrectQuestionsKey = "incorrect_questions_ids"
    
    private init() {}
    
    // 不正解の問題IDセットを取得
    func getIncorrectQuestionIDs() -> Set<String> {
        let array = defaults.stringArray(forKey: incorrectQuestionsKey) ?? []
        return Set(array)
    }
    
    // 結果を保存（正解なら削除、不正解なら追加）
    func saveResult(questionId: String, isCorrect: Bool) {
        var currentIDs = getIncorrectQuestionIDs()
        
        if isCorrect {
            currentIDs.remove(questionId)
        } else {
            currentIDs.insert(questionId)
        }
        
        defaults.set(Array(currentIDs), forKey: incorrectQuestionsKey)
    }
    
    // 履歴をクリア（デバッグ用など）
    func clearHistory() {
        defaults.removeObject(forKey: incorrectQuestionsKey)
    }
}
