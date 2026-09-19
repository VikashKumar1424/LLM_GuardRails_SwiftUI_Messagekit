import Foundation

struct ChatRequest: Encodable {
    let message: String
}

struct ChatResponse: Decodable {
    let allowed: Bool
    let response: String
    let guardrailReason: String

    enum CodingKeys: String, CodingKey {
        case allowed, response
        case guardrailReason = "guardrail_reason"
    }
}
