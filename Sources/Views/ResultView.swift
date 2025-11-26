import SwiftUI

struct ResultView: View {
    let topic: QuizTopic
    let correctAnswers: Int
    let totalQuestions: Int
    @Environment(\.dismiss) private var dismiss
    @Environment(\.presentationMode) var presentationMode
    
    private var scorePercentage: Double {
        Double(correctAnswers) / Double(totalQuestions) * 100
    }
    
    // スコアに基づく「期」の判定
    private var phaseLabel: String {
        switch scorePercentage {
        case 90...100: return "完成期"
        case 70..<90:  return "応用力養成期"
        case 40..<70:  return "基礎固め期"
        default:       return "導入期"
        }
    }
    
    // スコアに基づくテーマカラー
    private var themeColor: Color {
        switch scorePercentage {
        case 90...100: return Color(red: 0.2, green: 0.8, blue: 0.4) // Green
        case 70..<90:  return Color(red: 0.2, green: 0.6, blue: 1.0) // Blue
        case 40..<70:  return Color(red: 1.0, green: 0.6, blue: 0.2) // Orange
        default:       return Color(red: 1.0, green: 0.4, blue: 0.4) // Red
        }
    }
    
    // 10段階のメインメッセージ
    private var mainMessage: String {
        let percentage = Int(scorePercentage)
        switch percentage {
        case 100:      return "完璧です！統計マスターの称号にふさわしい実力です。"
        case 90..<100: return "すごい！ほぼ完璧です。些細なミスに気をつければ満点確実です！"
        case 80..<90:  return "素晴らしい！かなり理解が進んでいます。満点まであと少し！"
        case 70..<80:  return "ナイススコア！統計2級合格も夢ではありません。"
        case 60..<70:  return "良い調子です！合格ラインが見えてきました。"
        case 50..<60:  return "折り返し地点です！基礎力はついてきています。"
        case 40..<50:  return "惜しい！半分まであと少し。データの見方を再確認しましょう。"
        case 30..<40:  return "あと一歩で半分です！苦手な分野を重点的に復習しましょう。"
        case 20..<30:  return "少しずつ慣れてきましたね。解説をじっくり読んで理解を深めましょう。"
        case 10..<20:  return "まずは用語の意味から確認してみましょう。焦らず一歩ずつ！"
        default:       return "統計の旅は始まったばかりです！基礎からじっくり学びましょう。"
        }
    }
    
    // 「次の一歩」のアドバイス（3点）
    private var nextSteps: [String] {
        switch scorePercentage {
        case 90...100:
            return [
                "間違えた問題があれば、なぜ間違えたか深掘りする",
                "他のジャンルでも満点を目指す",
                "時間を計って解くスピードを上げる"
            ]
        case 70..<90:
            return [
                "ケアレスミスをなくすための見直し習慣をつける",
                "苦手なパターンの問題を繰り返し解く",
                "公式の導出過程をもう一度確認する"
            ]
        case 40..<70:
            return [
                "解説を読んで、解き方の流れをノートに書き出す",
                "基本的な公式（平均、分散など）を暗記する",
                "図やグラフを書いてイメージを掴む"
            ]
        default:
            return [
                "用語の定義（平均、中央値など）をしっかり覚える",
                "簡単な例題から始めて自信をつける",
                "毎日5分でも統計に触れる時間を作る"
            ]
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 背景画像
                if let path = Bundle.main.path(forResource: "background_statistics", ofType: "png", inDirectory: "questions"),
                   let uiImage = UIImage(contentsOfFile: path) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .ignoresSafeArea()
                } else {
                    Color(red: 0.95, green: 0.95, blue: 0.97).ignoresSafeArea()
                }
                
                ScrollView {
                    VStack(spacing: 24) {
                        // ヘッダー部分
                        VStack(spacing: 8) {
                            Text("統計検定２級・結果")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                            
                            Text(topic.title)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 20)
                        
                        // スコアカード
                        VStack(spacing: 20) {
                            // 期ラベル
                            Text(phaseLabel)
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(themeColor)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 6)
                                .background(themeColor.opacity(0.1))
                                .cornerRadius(20)
                            
                            // スコア表示
                            HStack(alignment: .lastTextBaseline, spacing: 4) {
                                Text("\(Int(scorePercentage))")
                                    .font(.system(size: 60, weight: .bold))
                                    .foregroundColor(.black)
                                Text("% 正解")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.gray)
                            }
                            
                            Text("\(correctAnswers) / \(totalQuestions) 問")
                                .font(.headline)
                                .foregroundColor(.gray)
                            
                            // プログレスバー
                            GeometryReader { barGeometry in
                                ZStack(alignment: .leading) {
                                    Capsule()
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(height: 8)
                                    
                                    Capsule()
                                        .fill(themeColor)
                                        .frame(width: barGeometry.size.width * (scorePercentage / 100), height: 8)
                                }
                            }
                            .frame(height: 8)
                            .padding(.horizontal, 20)
                        }
                        .padding(.vertical, 30)
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(24)
                        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 4)
                        .padding(.horizontal, 20)
                        
                        // フィードバックカード
                        VStack(spacing: 24) {
                            // メッセージヘッダー
                            HStack(alignment: .top, spacing: 12) {
                                Image(systemName: "figure.run")
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                                    .padding(8)
                                    .background(themeColor)
                                    .clipShape(Circle())
                                
                                Text(mainMessage)
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                    .multilineTextAlignment(.leading)
                                    .fixedSize(horizontal: false, vertical: true) // 縦方向の拡張を許可
                                    .frame(maxWidth: .infinity, alignment: .leading) // 横幅いっぱいに広げる
                                
                                Spacer(minLength: 0)
                            }
                            .padding(.horizontal, 20)
                            
                            // イラスト
                            if let path = Bundle.main.path(forResource: "result_statistics_trophy", ofType: "png", inDirectory: "questions"),
                               let uiImage = UIImage(contentsOfFile: path) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 160)
                            } else {
                                Image(systemName: "chart.bar.fill")
                                    .font(.system(size: 80))
                                    .foregroundColor(themeColor.opacity(0.5))
                                    .frame(height: 160)
                            }
                            
                            // 次の一歩セクション
                            VStack(alignment: .leading, spacing: 12) {
                                Text("次の一歩")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                
                                ForEach(nextSteps, id: \.self) { step in
                                    HStack(alignment: .top, spacing: 8) {
                                        Circle()
                                            .fill(themeColor)
                                            .frame(width: 6, height: 6)
                                            .padding(.top, 6)
                                        
                                        Text(step)
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                            .multilineTextAlignment(.leading)
                                            .fixedSize(horizontal: false, vertical: true) // 縦方向の拡張を許可
                                            .frame(maxWidth: .infinity, alignment: .leading) // 横幅いっぱいに広げる
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.vertical, 24)
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(24)
                        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 4)
                        .padding(.horizontal, 20)
                        
                        Spacer(minLength: 20)
                        
                        // ボタン
                        Button(action: {
                            AdsManager.shared.showInterstitialAndReturnToRoot()
                        }) {
                            Text("最初に戻る")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(Color(red: 0.2, green: 0.4, blue: 0.8))
                                .cornerRadius(16)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)
                    }
                    .frame(width: geometry.size.width) // ScrollViewの中身の幅を画面幅に固定
                }
            }
        }
        .navigationBarHidden(true)
    }
}