from fastapi import APIRouter, HTTPException, Depends, Security
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials

from sqlalchemy.orm import Session
from database import get_userdb,get_stamp_db
from models import subway_info as Subway_Model, subway_Locker_info as Locker_Model,\
      Puzzle as Puzzle_model, PuzzleInfo as Puzzle_info_model, UserPuzzle as UserPuzzle_model,\
      User as User_model

from region.region_schema import District  
from puzzle.ppuzzle_schema import Puzzle, ConfigPuzzle, ClearPuzzle
from user.user_func import decode_jwt
from datetime import datetime

security = HTTPBearer()


router = APIRouter(
    prefix="/puzzle",
)

@router.post("/create_puzzle")
def create_puzzle(data : Puzzle,stamp_db: Session = Depends(get_stamp_db)):
    
    for i in range(int(data.puzzle_cnt)):
        new_puzzle_info = Puzzle_info_model(
            puzzle_num = data.puzzle_num,
            puzzle_index=i,
            district=f"지역이름",
            title=f"장소이름",
            content=f"장소설명",
            address=f"장소주소"
        )
        
        # 새로운 퍼즐 정보를 데이터베이스에 추가
        stamp_db.add(new_puzzle_info)
        stamp_db.commit()
    stamp_db.refresh(new_puzzle_info)
    new_puzzle = Puzzle_model(
        puzzle_num = data.puzzle_num,
        puzzle_cnt = data.puzzle_cnt
    )
    stamp_db.add(new_puzzle)
    stamp_db.commit()
    stamp_db.refresh(new_puzzle)
    return ""

@router.get("/show_list")
def show_list(stamp_db: Session = Depends(get_stamp_db)):
    datas = stamp_db.query(Puzzle_model).all()
    return [{"puzzle_num" : data.puzzle_num}for data in datas]


@router.get("/show_puzzle")
def show_puzzle(credentials: HTTPAuthorizationCredentials = Security(security),stamp_db: Session = Depends(get_stamp_db), user_db: Session = Depends(get_userdb)):
    token = credentials.credentials
    
    try:
        payload = decode_jwt(token)
    except Exception as e:
        raise HTTPException(status_code=403, detail="유효하지 않은 토큰입니다.")
    
    user_id = payload.get("sub")
    if not user_id:
        raise HTTPException(status_code=403, detail="유효하지 않은 토큰 페이로드입니다.")
    
    puzzle_info = user_db.query(User_model).filter(User_model.user_id == user_id).one_or_none()
    if puzzle_info.current_puzzle == None:
        return HTTPException(status_code=404, detail="퍼즐선택이 되지않았습니다.")
    else:
        datas = stamp_db.query(Puzzle_info_model).filter(Puzzle_info_model.puzzle_num == puzzle_info.current_puzzle).all()
        return [{"puzzle_indexd": data.puzzle_index, "district": data.district, "title" : data.title, "content" : data.content, "address" : data.address} for data in datas]
    
@router.patch("/select_puzzle")
def select_puzzle(select: int, credentials: HTTPAuthorizationCredentials = Security(security), 
                   user_db: Session = Depends(get_userdb)):
    token = credentials.credentials
    
    # JWT 토큰 디코딩 및 검증
    try:
        payload = decode_jwt(token)
    except Exception as e:
        raise HTTPException(status_code=403, detail="유효하지 않은 토큰입니다.")
    
    user_id = payload.get("sub")
    if not user_id:
        raise HTTPException(status_code=403, detail="유효하지 않은 토큰 페이로드입니다.")
    
    # 사용자 정보를 user_db에서 조회
    user = user_db.query(User_model).filter(User_model.user_id == user_id).first()
    
    if not user:
        raise HTTPException(status_code=404, detail="사용자를 찾을 수 없습니다.")
    
    # 현재 퍼즐을 업데이트
    user.current_puzzle = select
    
    # 변경 사항 저장
    user_db.commit()

    return {"message": "퍼즐이 선택되었습니다.", "selected_puzzle": select}

@router.patch("/config_puzzle")
def config_puzzle(data : ConfigPuzzle,stamp_db: Session = Depends(get_stamp_db)):
    config = stamp_db.query(Puzzle_info_model).filter(Puzzle_info_model.puzzle_index == data.puzzle_index and Puzzle_info_model.puzzle_num == data.puzzle_num).first()
    config.district = data.district
    config.title = data.title
    config.content = data.content
    config.address = data.address
    stamp_db.commit()
    return {"message": "선택한 퍼즐이 업데이트되었습니다."}

@router.post("/clear_puzzle")
def clear_puzzle(data : ClearPuzzle, credentials: HTTPAuthorizationCredentials = Security(security),
                 stamp_db: Session = Depends(get_stamp_db),
                 user_db: Session = Depends(get_userdb)):
    token = credentials.credentials
    
    # JWT 토큰 디코딩 및 검증
    try:
        payload = decode_jwt(token)
    except Exception as e:
        raise HTTPException(status_code=403, detail="유효하지 않은 토큰입니다.")
    
    user_id = payload.get("sub")
    if not user_id:
        raise HTTPException(status_code=403, detail="유효하지 않은 토큰 페이로드입니다.")
    user = user_db.query(User_model).filter(User_model.user_id == user_id).first()
    data = UserPuzzle_model(puzzle_num = user.current_puzzle,
                            puzzle_index = data.puzzle_index,
                            user_id = user_id,
                            received_at = datetime.now())
    stamp_db.add(data)
    stamp_db.commit()
    stamp_db.refresh(data)
    return HTTPException(status_code=200, detail="정상적으로 퍼즐완료처리가 되었습니다.")

@router.get("/show_my_puzzle")
def show_my_puzzle(credentials: HTTPAuthorizationCredentials = Security(security),
                   stamp_db: Session = Depends(get_stamp_db)):
    token = credentials.credentials
    
    # JWT 토큰 디코딩 및 검증
    try:
        payload = decode_jwt(token)
    except Exception as e:
        raise HTTPException(status_code=403, detail="유효하지 않은 토큰입니다.")
    
    user_id = payload.get("sub")
    if not user_id:
        raise HTTPException(status_code=403, detail="유효하지 않은 토큰 페이로드입니다.")
    datas = stamp_db.query(UserPuzzle_model).filter(UserPuzzle_model.user_id == user_id).all()
    return [{"puzzle_num" : data.puzzle_num, "puzzle_index" : data.puzzle_index, "received at" : data.received_at} for data in datas]