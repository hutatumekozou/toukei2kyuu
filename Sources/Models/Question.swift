import Foundation

struct Question: Codable, Identifiable {
    let id: String
    let category: String
    let question: String
    let choices: [String]
    let answerLabel: String
    let answerIndex: Int
    let explanation: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case category
        case question
        case text
        case choices
        case answerLabel = "answer_label"
        case answerIndex = "answer_index"
        case correct
        case explanation
    }
    
    init(
        id: String = UUID().uuidString,
        category: String = "未分類",
        question: String,
        choices: [String],
        answerLabel: String? = nil,
        answerIndex: Int,
        explanation: String
    ) {
        self.id = id
        self.category = category
        self.question = question
        self.choices = choices
        self.answerIndex = answerIndex
        self.answerLabel = answerLabel ?? Question.label(for: answerIndex)
        self.explanation = explanation
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let questionText = try container.decodeIfPresent(String.self, forKey: .question)
            ?? container.decodeIfPresent(String.self, forKey: .text)
        guard let questionTextUnwrapped = questionText else {
            throw DecodingError.dataCorruptedError(forKey: .question, in: container, debugDescription: "Missing question text.")
        }
        
        let answerIndex = try container.decodeIfPresent(Int.self, forKey: .answerIndex)
            ?? container.decodeIfPresent(Int.self, forKey: .correct)
        guard let answerIndexUnwrapped = answerIndex else {
            throw DecodingError.dataCorruptedError(forKey: .answerIndex, in: container, debugDescription: "Missing answer index.")
        }
        guard (0..<4).contains(answerIndexUnwrapped) else {
            throw DecodingError.dataCorruptedError(forKey: .answerIndex, in: container, debugDescription: "answer_index must be between 0 and 3.")
        }
        
        let choices = try container.decode([String].self, forKey: .choices)
        guard choices.count == 4 else {
            throw DecodingError.dataCorruptedError(forKey: .choices, in: container, debugDescription: "choices must contain exactly 4 entries.")
        }
        
        let decodedLabel = try container.decodeIfPresent(String.self, forKey: .answerLabel)
        let derivedLabel = Question.label(for: answerIndexUnwrapped)
        if let decodedLabel, decodedLabel != derivedLabel {
            throw DecodingError.dataCorruptedError(forKey: .answerLabel, in: container, debugDescription: "answer_label \(decodedLabel) does not match answer_index \(answerIndexUnwrapped).")
        }
        
        self.id = try container.decodeIfPresent(String.self, forKey: .id) ?? UUID().uuidString
        self.category = try container.decodeIfPresent(String.self, forKey: .category) ?? "未分類"
        self.question = questionTextUnwrapped
        self.choices = choices
        self.answerIndex = answerIndexUnwrapped
        self.answerLabel = decodedLabel ?? derivedLabel
        self.explanation = try container.decode(String.self, forKey: .explanation)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(category, forKey: .category)
        try container.encode(question, forKey: .question)
        try container.encode(choices, forKey: .choices)
        try container.encode(answerLabel, forKey: .answerLabel)
        try container.encode(answerIndex, forKey: .answerIndex)
        try container.encode(explanation, forKey: .explanation)
    }
    
    private static func label(for index: Int) -> String {
        let labels = ["A", "B", "C", "D"]
        return labels.indices.contains(index) ? labels[index] : ""
    }
}
