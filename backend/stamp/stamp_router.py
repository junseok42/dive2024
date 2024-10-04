from fastapi import APIRouter, HTTPException, Depends, Response,Security
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials

from sqlalchemy.orm import Session
from database import get_userdb,get_stamp_db

from models import User as User_model, Stamp as Stamp_model, UserStamp as User_Stamp_model

from stamp.stamp_schema import Stamp
from user.user_func import decode_jwt
from datetime import datetime
security = HTTPBearer()


router = APIRouter(
    prefix="/stamp",
)

@router.post("/create_stamp")
def create_new_stamp(
            stamp_data: Stamp,
              credentials: HTTPAuthorizationCredentials = Security(security), 
              user_db: Session = Depends(get_userdb),
              stamp_db: Session = Depends(get_stamp_db)):
    token = credentials.credentials
    
    try:
        payload = decode_jwt(token)
    except Exception as e:
        raise HTTPException(status_code=403, detail="유효하지 않은 토큰입니다.")
    
    user_id = payload.get("sub")
    if not user_id:
        raise HTTPException(status_code=403, detail="유효하지 않은 토큰 페이로드입니다.")
    
    user_info = user_db.query(User_model).filter(User_model.user_id == user_id).one_or_none()
    model_stamp = Stamp_model(
        user_id = user_info.user_id,
        title = stamp_data.title,
        description = stamp_data.description,
        latitude = stamp_data.latitude,
        longitude = stamp_data.longitude,
        district_id = stamp_data.district_id,
        created_at = datetime.now()
    )
    stamp_db.add(model_stamp)
    stamp_db.commit()
    stamp_db.refresh(model_stamp)
    return HTTPException(status_code=200, detail="성공적으로 스탬프장소를 추가하였습니다")

@router.get("/mystamp")
def show_my_stamp(credentials: HTTPAuthorizationCredentials = Security(security), 
                  stamp_db: Session = Depends(get_stamp_db)):
    token = credentials.credentials
    
    try:
        payload = decode_jwt(token)
    except Exception as e:
        raise HTTPException(status_code=403, detail="유효하지 않은 토큰입니다.")
    
    user_id = payload.get("sub")
    if not user_id:
        raise HTTPException(status_code=403, detail="유효하지 않은 토큰 페이로드입니다.")

    my_stamp = stamp_db.query(User_Stamp_model).filter(User_Stamp_model.user_id == user_id).all()
    return [{"id": mydata.stamp_id, "received" : mydata.received_at} for mydata in my_stamp]