from fastapi import FastAPI
from pydantic import BaseModel
from typing import List

app = FastAPI()

# Define request structure
class MeetingInput(BaseModel):
    name: str
    objectives: List[str]
    constraints: List[str]

# Simple AI logic (mock recommendation)
@app.post("/analyze_meeting")
async def analyze_meeting(meeting: MeetingInput):
    recommendation = f"Optimize for {', '.join(meeting.objectives)} while considering {', '.join(meeting.constraints)}"
    return {"recommendation": recommendation}

# Run with: uvicorn main:app --reload
