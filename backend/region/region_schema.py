from pydantic import BaseModel
from typing import Optional


class District(BaseModel):
    name : str
    content : str

class attraction(BaseModel):
    name : str
    district : str
    content : str
    address : str
    puzzle_num : int
    puzzle_index : int