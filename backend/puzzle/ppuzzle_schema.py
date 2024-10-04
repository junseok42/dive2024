from pydantic import BaseModel
from typing import Optional


class Puzzle(BaseModel):
    puzzle_num : int
    puzzle_cnt : int
    district = str