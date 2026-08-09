import Foundation

class TicTacToeGame: ObservableObject {
    @Published var board: [String] = Array(repeating: "", count: 9)
    @Published var isGameOver = false
    @Published var winner: String = ""
    @Published var currentPlayer = "X"
    
    let winningCombinations = [
        [0, 1, 2],
        [3, 4, 5],
        [6, 7, 8],
        [0, 3, 6],
        [1, 4, 7],
        [2, 5, 8],
        [0, 4, 8],
        [2, 4, 6]
    ]
    
    func makeMove(at index: Int) {
        guard !isGameOver && board[index].isEmpty else { return }
        
        board[index] = currentPlayer
        
        if checkWinner() {
            isGameOver = true
            winner = "Spieler \(currentPlayer) hat gewonnen!"
            return
        }
        
        if isBoardFull() {
            isGameOver = true
            winner = "Unentschieden!"
            return
        }
        
        currentPlayer = currentPlayer == "X" ? "O" : "X"
        
        if currentPlayer == "O" {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.computerMove()
            }
        }
    }
    
    private func computerMove() {
        guard !isGameOver else { return }
        
        // Versuche zu gewinnen
        if let winningMove = findWinningMove(for: "O") {
            board[winningMove] = "O"
            if checkWinner() {
                isGameOver = true
                winner = "Computer hat gewonnen!"
                return
            }
            currentPlayer = "X"
            return
        }
        
        // Blockiere Spieler
        if let blockingMove = findWinningMove(for: "X") {
            board[blockingMove] = "O"
            currentPlayer = "X"
            return
        }
        
        // Nimm die Mitte
        if board[4].isEmpty {
            board[4] = "O"
            currentPlayer = "X"
            return
        }
        
        // Nimm eine Ecke
        let corners = [0, 2, 6, 8]
        let availableCorners = corners.filter { board[$0].isEmpty }
        if let corner = availableCorners.randomElement() {
            board[corner] = "O"
            currentPlayer = "X"
            return
        }
        
        // Nimm einen verfügbaren Platz
        if let emptyIndex = board.firstIndex(where: { $0.isEmpty }) {
            board[emptyIndex] = "O"
            currentPlayer = "X"
        }
        
        if isBoardFull() {
            isGameOver = true
            winner = "Unentschieden!"
        }
    }
    
    private func findWinningMove(for player: String) -> Int? {
        for combination in winningCombinations {
            let values = combination.map { board[$0] }
            let playerCount = values.filter { $0 == player }.count
            let emptyCount = values.filter { $0.isEmpty }.count
            
            if playerCount == 2 && emptyCount == 1 {
                return combination.first { board[$0].isEmpty }
            }
        }
        return nil
    }
    
    private func checkWinner() -> Bool {
        for combination in winningCombinations {
            let values = combination.map { board[$0] }
            if values[0] != "" && values[0] == values[1] && values[1] == values[2] {
                return true
            }
        }
        return false
    }
    
    private func isBoardFull() -> Bool {
        board.allSatisfy { !$0.isEmpty }
    }
    
    func resetGame() {
        board = Array(repeating: "", count: 9)
        isGameOver = false
        winner = ""
        currentPlayer = "X"
    }
}
