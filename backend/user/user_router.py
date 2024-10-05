# fastapi 
from fastapi import APIRouter, HTTPException, Depends, Response,Security
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials

# db
from sqlalchemy.orm import Session
from database import get_userdb
from models import User as User_model

# user
from user.user_schema import User,Login_user, modify_password, TokenRefreshRequest, UserResponse
from user.user_func import decode_jwt, get_user, get_hash_password, verify_password, create_access_token, create_refresh_token, get_current_user

# env
import os
from dotenv import load_dotenv
load_dotenv()

from datetime import timedelta

ACCESS_TOKEN_EXPIRE_MINUTES = int(os.environ.get("ACCESS_TOKEN_EXPIRE_MINUTES"))
REFRESH_TOKEN_EXPIRE_MINUTES = int(os.environ.get("REFRESH_TOKEN_EXPIRE_MINUTES"))


security = HTTPBearer()


router = APIRouter(
    prefix="/user",
)



@router.get("/check_token")
def check_token(credentials: HTTPAuthorizationCredentials = Security(security)):
    token = credentials.credentials
    try:
        payload = decode_jwt(token)
        return {"status": "valid", "user_id": payload.get("sub")}
    except HTTPException as e:
        return {"status": "invalid", "detail": e.detail}


# signin user
@router.post("/signin_user", response_model=User)
def signin_user(user: User, 
                user_db: Session = Depends(get_userdb)):
    check_user_id = get_user(user.user_id, user_db) # user가 table에 있는지 확인
    if check_user_id:
        raise HTTPException(status_code=409, detail="해당 아이디는 이미 존재합니다")
    
    check_user_user_name = user_db.query(User_model).filter(User_model.user_name == user.user_name).first()
    if check_user_user_name:
        raise HTTPException(status_code=409, detail="해당 닉네임은 이미 존재합니다")
    

    # db에 user를 추가
    create_user = User_model(user_id=user.user_id, 
                password=get_hash_password(user.password),
                user_name=user.user_name, 
            )

    user_db.add(create_user)
    user_db.commit()
    user_db.refresh(create_user)
    
    return create_user


# login : 로그인
@router.post("/login")
def login_user(user: Login_user, db: Session = Depends(get_userdb)):
    check_user = get_user(user.user_id, db)

    if not check_user:
        raise HTTPException(status_code=410, detail="존재하지 않는 ID입니다.")
    elif not verify_password(user.password, check_user.password):  # 비밀번호 검증(입력 pw, db pw)
        raise HTTPException(status_code=410, detail="비밀번호가 틀렸습니다.")
    else:
        # access 토근 생성
        access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
        access_token = create_access_token(
            data={"sub": user.user_id}, expires_delta=access_token_expires
        )
        # refresh 토큰 생성
        refresh_token_expires = timedelta(minutes=REFRESH_TOKEN_EXPIRE_MINUTES)
        refresh_token = create_refresh_token(
            data={"sub": user.user_id}, expires_delta=refresh_token_expires
        )
        check = db.query(User_model).filter(User_model.user_id == check_user.user_id).first()
        # 로그인에서 유저 타입 주는거 수정하기
        return {"access_token": access_token, "refresh_token": refresh_token, "token_type": "bearer", "puzzle" : check.current_puzzle}


@router.post("/token/refresh")
def refresh_token(request: TokenRefreshRequest):
    # 리프레시 토큰 검증
    try:
        payload = decode_jwt(request.refresh_token)
    except HTTPException:
        raise HTTPException(status_code=401, detail="인식되지 않는 토큰입니다.")
    
    user_id = payload.get("sub")
    if not user_id:
        raise HTTPException(status_code=403, detail="유효하지 않은 토큰 페이로드입니다.")
    
    # 새 액세스 토큰 발급
    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    new_access_token = create_access_token(
        data={"sub": user_id}, expires_delta=access_token_expires
    )
    
    # 새 리프레시 토큰 발급 (선택 사항, 기존 리프레시 토큰을 유지하고 싶다면 이 부분은 생략 가능)
    refresh_token_expires = timedelta(minutes=REFRESH_TOKEN_EXPIRE_MINUTES)
    new_refresh_token = create_refresh_token(
        data={"sub": user_id}, expires_delta=refresh_token_expires
    )
    
    return {
        "access_token": new_access_token,
        "refresh_token": new_refresh_token,
        "token_type": "bearer"
    }


# 유저 정보 삭제 : 아이디와 비밀번호 입력
@router.delete("/delete_user")
def delete_user(user: Login_user, db: Session = Depends(get_userdb)):
    check_user = db.query(User_model).filter(User_model.user_id == user.user_id)

    if not check_user.first():
        raise HTTPException(status_code=409, detail="id를 다시 입력새주세요")
    elif verify_password(user.password, check_user.first().password):
        delete_user = check_user.delete()
        db.commit()
        # db.refresh(delete_user)
        raise HTTPException(status_code=200, detail="회원정보가 삭제되었습니다.")
    else:
        raise HTTPException(status_code=409, detail="비밀번호가 틀렸습니다.")


# 유저 비밀번호 변경 : 기존 비밀번호, 새로운 비밀번호
@router.put("/modify_pw")
def modify_pw_(user: modify_password, 
              credentials: HTTPAuthorizationCredentials = Security(security), 
              db: Session = Depends(get_userdb)):
    token = credentials.credentials
    
    try:
        payload = decode_jwt(token)
    except Exception as e:
        raise HTTPException(status_code=403, detail="유효하지 않은 토큰입니다.")
    
    user_id = payload.get("sub")
    if not user_id:
        raise HTTPException(status_code=403, detail="유효하지 않은 토큰 페이로드입니다.")
    
    user_info = db.query(User_model).filter(User_model.user_id == user_id).one_or_none()
    if not user_info:
        raise HTTPException(status_code=404, detail="사용자를 찾을 수 없습니다.")

    if not verify_password(user.password, user_info.password):
        raise HTTPException(status_code=400, detail="현재 비밀번호가 올바르지 않습니다.")
    
    user_info.password = get_hash_password(user.new_password)
    db.commit()
    db.refresh(user_info)
    
    return {"status": "success", "detail": "정상적으로 비밀번호가 변경되었습니다."}





@router.get("/get_user", response_model=UserResponse)
def get_login_user(    
    credentials: HTTPAuthorizationCredentials = Security(security), 
    user_db: Session = Depends(get_userdb)):

    user = get_current_user(credentials, user_db)

    user_info = UserResponse(
        user_id=user.user_id,
        user_name=user.user_name
    )
    return user_info
    
