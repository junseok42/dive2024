from fastapi import APIRouter, HTTPException, Depends, Response,Security
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials

from sqlalchemy.orm import Session
from database import get_userdb,get_stamp_db

from models import User as User_model, Stamp as Stamp_model

from stamp.stamp_schema import create_stamp,stamp
from user.user_func import decode_jwt
security = HTTPBearer()


router = APIRouter(
    prefix="/stamp",
)

@router.post("/create_stamp")
def create_new_stamp(
                stamp: stamp,
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
    model_stamp = create_stamp()