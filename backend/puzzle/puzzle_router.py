from fastapi import APIRouter, HTTPException, Depends, Response,Security
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials

from sqlalchemy.orm import Session
from database import get_region_db
from models import District as District_Model, subway_info as Subway_Model, subway_Locker_info as Locker_Model

from region.region_schema import District


security = HTTPBearer()


router = APIRouter(
    prefix="/puzzle",
)

