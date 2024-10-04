from fastapi import APIRouter, HTTPException, Depends, Response,Security
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials

from sqlalchemy.orm import Session
from database import get_region_db

from models import house_info as House_model
import csv
security = HTTPBearer()


router = APIRouter(
    prefix="/house",
)


@router.post("/house")
def set_subway(region_db: Session = Depends(get_region_db)):
    f = open('C:/dive2024/backend/region/임대주택현황.csv','r')
    rdr = csv.reader(f)
    for line in rdr:
        data = House_model(type = line[0],
                            name = line[1],
                            cnt = int(line[2]),
                            address = line[3],
                            region = (line[4].split())[1]
                            
        )
        region_db.add(data)
        region_db.commit()
    region_db.refresh(data)
    return {"message" : "성공"}