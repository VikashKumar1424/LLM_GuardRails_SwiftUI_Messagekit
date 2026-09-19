import SwiftUI

struct ChatView: View {
    @StateObject private var viewModel = ChatViewModel()

    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 12) {
                        ForEach(viewModel.messages) { message in
                            HStack {
                                if message.isUser { Spacer() }
                                Text(message.text)
                                    .padding(12)
                                    .background(message.isUser ? Color.blue : Color.gray.opacity(0.2))
                                    .foregroundStyle(message.isUser ? .white : .primary)
                                    .clipShape(RoundedRectangle(cornerRadius: 14))
                                if !message.isUser { Spacer() }
                            }
                        }
                    }
                    .padding()
                }
            }

            HStack {
                TextField("Ask something...", text: $viewModel.inputText)
                    .textFieldStyle(.roundedBorder)

                Button("Send") {
                    viewModel.send()
                }
                .disabled(viewModel.inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding()
        }
        .navigationTitle("Guardrails Chat")
    }
}
