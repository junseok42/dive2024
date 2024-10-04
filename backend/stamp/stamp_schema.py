from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class stamp(BaseModel):
    user_id : str
    title : str
    description : str
    latitude : float
    longitude : float
    district_id : int


class create_stamp(BaseModel):
    user_id : str
    title : str
    description : str
    latitude : float
    longitude : float
    district_id : int
    created_at : datetime
    
class location_stamp(BaseModel):
    id : int
    title: str
    description: str
    latitude : float
    longitude : float
    district_id : int