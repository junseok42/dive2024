from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class Stamp(BaseModel):
    title : str
    description : str
    latitude : float
    longitude : float
    district_id : int

    
class location_stamp(BaseModel):
    id : int
    title: str
    description: str
    latitude : float
    longitude : float
    district_id : int