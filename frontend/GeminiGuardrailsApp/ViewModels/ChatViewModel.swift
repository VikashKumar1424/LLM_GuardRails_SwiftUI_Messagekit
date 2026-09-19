import Foundation
import Combine

@MainActor
final class ChatViewModel: ObservableObject {
    @Published private(set) var messages: [ChatMessage] = []
    @Published var inputText = ""
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?

    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
    }

    func send() {
        let text = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty, !isLoading else { return }

        inputText = ""
        messages.append(ChatMessage(text: text, isUser: true))
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let result = try await apiClient.sendMessage(text)
                messages.append(ChatMessage(text: result.response, isUser: false))
            } catch {
                errorMessage = error.localizedDescription
                messages.append(ChatMessage(text: "Unable to reach the server.", isUser: false))
            }
            isLoading = false
        }
    }
}
