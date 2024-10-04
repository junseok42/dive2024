from pydantic import BaseModel
from typing import Optional


class Puzzle(BaseModel):
    puzzle_num : int
    puzzle_cnt : int

class ConfigPuzzle(BaseModel):
    puzzle_num : int
    puzzle_index : int
    district : str
    title : str
    content : str
    address : str

class ClearPuzzle(BaseModel):
    puzzle_index: int