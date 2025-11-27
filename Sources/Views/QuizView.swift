import SwiftUI

// 質問カード（簿記アプリスタイル）
struct QuestionCardView: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.body)
            .fontWeight(.medium)
            .foregroundColor(.black)
            .multilineTextAlignment(.center)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.vertical, 20)
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity)
            .background(Color.white.opacity(0.95))
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

// 選択肢カード（簿記アプリスタイル: ラベルなし、テキストのみ）
struct ChoiceCardView: View {
    let text: String
    let isCorrect: Bool?
    let isSelected: Bool
    let showExplanation: Bool
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text(text)
                .font(.body)
                .foregroundColor(.black)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 16)
        .background(backgroundColorForChoice())
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.08), radius: 3, x: 0, y: 1)
    }
    
    private func backgroundColorForChoice() -> Color {
        if !showExplanation {
            return .white
        }
        if let isCorrect = isCorrect, isCorrect {
            return Color.green.opacity(0.3)
        } else if isSelected {
            return Color.red.opacity(0.3)
        }
        return .white
    }
}

struct QuizView: View {
    let topic: QuizTopic
    @State private var questions: [Question] = []
    @State private var currentQuestionIndex = 0
    @State private var selectedAnswer: Int? = nil
    @State private var showExplanation = false
    @State private var correctAnswers = 0
    @State private var navigateToResult = false
    
    var body: some View {
        ZStack {
            // 背景グラデーション（簿記アプリ風）
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.4, green: 0.8, blue: 0.8),
                    Color(red: 0.3, green: 0.6, blue: 0.9)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    if !questions.isEmpty {
                        // ヘッダー（問題番号）
                        HStack {
                            Text("第\(currentQuestionIndex + 1)問")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Spacer()
                            Text("\(currentQuestionIndex + 1) / \(questions.count)")
                                .font(.headline)
                                .foregroundColor(.white.opacity(0.9))
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 16)
                        
                        // 質問カード
                        QuestionCardView(text: questions[currentQuestionIndex].question)
                            .padding(.horizontal, 24)
                        
                        // 選択肢
                        VStack(spacing: 12) {
                            ForEach(0..<questions[currentQuestionIndex].choices.count, id: \.self) { index in
                                Button {
                                    if selectedAnswer == nil {
                                        selectedAnswer = index
                                        showExplanation = true
                                    }
                                } label: {
                                    ChoiceCardView(
                                        text: questions[currentQuestionIndex].choices[index],
                                        isCorrect: index == questions[currentQuestionIndex].answerIndex ? true : nil,
                                        isSelected: selectedAnswer == index,
                                        showExplanation: showExplanation
                                    )
                                }
                                .disabled(selectedAnswer != nil)
                            }
                        }
                        .padding(.horizontal, 24)
                        
                        // 正解・不正解表示と解説
                        if showExplanation {
                            VStack(spacing: 16) {
                                // 正解・不正解表示
                                Text(selectedAnswer == questions[currentQuestionIndex].answerIndex ? "正解！" : "不正解")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(.top, 8)
                                
                                // 解説カード
                                Text(questions[currentQuestionIndex].explanation)
                                    .font(.body)
                                    .foregroundColor(.black)
                                    .multilineTextAlignment(.leading)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .padding(.vertical, 20)
                                    .padding(.horizontal, 20)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.white.opacity(0.95))
                                    .cornerRadius(16)
                                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                            }
                            .padding(.horizontal, 24)
                            
                            // 次の問題ボタン
                            Button(action: nextQuestion) {
                                Text(currentQuestionIndex == questions.count - 1 ? "結果を見る" : "次の問題")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(Color(red: 0.2, green: 0.4, blue: 0.8))
                                    .cornerRadius(12)
                                    .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                            }
                            .padding(.horizontal, 24)
                            .padding(.bottom, 20)
                        }
                        
                        Spacer(minLength: 30)
                    }
                }
                .padding(.bottom, 40)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(topic.title)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            loadQuestions()
        }
        .background(
            NavigationLink(
                destination: ResultView(topic: topic, correctAnswers: correctAnswers, totalQuestions: questions.count),
                isActive: $navigateToResult,
                label: { EmptyView() }
            )
        )
    }
    
    private func loadQuestions() {
        questions = QuizRepository.shared.loadQuestions(for: topic)
    }
    
    private func nextQuestion() {
        if let selected = selectedAnswer, selected == questions[currentQuestionIndex].answerIndex {
            correctAnswers += 1
        }
        
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
            selectedAnswer = nil
            showExplanation = false
        } else {
            navigateToResult = true
        }
    }
}
