import SwiftUI

@main
struct TicTacToeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    @StateObject private var game = TicTacToeGame()
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Tic-Tac-Toe")
                .font(.system(size: 40, weight: .bold, design: .default))
            
            VStack(spacing: 0) {
                ForEach(0..<3, id: \.self) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<3, id: \.self) { col in
                            let index = row * 3 + col
                            Button(action: {
                                game.makeMove(at: index)
                            }) {
                                Text(game.board[index])
                                    .font(.system(size: 60, weight: .bold))
                                    .frame(width: 100, height: 100)
                                    .foregroundColor(game.board[index] == "X" ? .blue : .red)
                                    .background(Color.gray.opacity(0.1))
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            if col < 2 {
                                Divider()
                                    .frame(height: 100)
                            }
                        }
                    }
                    
                    if row < 2 {
                        Divider()
                            .frame(height: 2)
                    }
                }
            }
            .border(Color.black, width: 2)
            
            if game.isGameOver {
                Text(game.winner)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.green)
            } else {
                Text(game.currentPlayer == "X" ? "Dein Zug (X)" : "Computer zieht...")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(game.currentPlayer == "X" ? .blue : .red)
            }
            
            Button(action: {
                game.resetGame()
            }) {
                Text("Neues Spiel")
                    .font(.system(size: 16, weight: .semibold))
                    .padding(.horizontal, 40)
                    .padding(.vertical, 10)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(40)
        .frame(minWidth: 500, minHeight: 700)
    }
}

#Preview {
    ContentView()
}
