import SwiftUI

struct HomeView: View {
    // ハード要件: グリッドは2列固定
    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    @State private var mistakeCount: Int = 0

    var body: some View {
        // ハード要件: NavigationStack (iOS 16未満互換のためNavigationViewを使用)
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    // 最近間違えた問題ボタン (Gridの上に配置)
                    NavigationLink(destination: QuizView(topic: .mistakes)) {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.title2)
                                .foregroundColor(.white)
                            VStack(alignment: .leading, spacing: 4) {
                                Text("最近間違えた問題")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                Text(mistakeCount > 0 ? "\(mistakeCount)問" : "ランダム10問")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.9))
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding()
                        .background(Color.orange)
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 16)

                    // ハード要件: LazyVGrid
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(QuizTopic.allCases.filter { $0 != .mistakes }) { topic in
                            NavigationLink {
                                QuizView(topic: topic)
                            } label: {
                                CardTile(title: topic.title.replacingOccurrences(of: "ジャンル", with: ""))
                            }
                            .buttonStyle(.plain)
                            .frame(height: 88) // ハード要件: 高さ88pt固定
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 32)
                }
            }
            // ハード要件: 背景設定
            .background(
                Group {
                    if UIImage(named: "home_background") != nil {
                        Image("home_background")
                            .resizable()
                            .scaledToFill()
                            .ignoresSafeArea()
                    } else {
                        Color(.systemGroupedBackground)
                            .ignoresSafeArea()
                    }
                }
            )
            // ハード要件: タイトルはtoolbar(.principal)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack(spacing: 2) {
                        Text("統計検定")
                            .font(.system(size: 34, weight: .bold))
                        Text("2級テスト対策")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(.blue)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                updateMistakeCount()
                AdsManager.shared.preload()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func updateMistakeCount() {
        mistakeCount = HistoryManager.shared.getIncorrectQuestionIDs().count
    }
}

// ハード要件: CardTile実装
struct CardTile: View {
    let title: String
    var body: some View {
        Text(title)
            .font(.headline)
            .foregroundColor(.primary)          // 親のtint/foreground影響を遮断
            .lineLimit(2)
            .minimumScaleFactor(0.78)
            .truncationMode(.tail)
            .layoutPriority(1)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.08), radius: 8, y: 4)
            )
            .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
