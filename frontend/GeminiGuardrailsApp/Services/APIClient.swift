import Foundation

protocol APIClientProtocol {
    func sendMessage(_ message: String) async throws -> ChatResponse
}

final class APIClient: APIClientProtocol {
    private let baseURL = URL(string: "http://127.0.0.1:8000")!

    func sendMessage(_ message: String) async throws -> ChatResponse {
        let url = baseURL.appendingPathComponent("api/v1/chat")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(ChatRequest(message: message))

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse,
              200..<300 ~= http.statusCode else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(ChatResponse.self, from: data)
    }
}
