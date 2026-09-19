from pydantic import BaseModel, Field

class ChatRequest(BaseModel):
    message: str = Field(min_length=1, max_length=10000)

class GuardrailResult(BaseModel):
    allowed: bool
    reason: str
    response: str | None = None

class ChatResponse(BaseModel):
    allowed: bool
    response: str
    guardrail_reason: str
