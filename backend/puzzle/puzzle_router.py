from fastapi import APIRouter, HTTPException, Depends, Response,Security
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials

from sqlalchemy.orm import Session
from database import get_stamp_db
from models import District as District_Model, subway_info as Subway_Model, subway_Locker_info as Locker_Model, Puzzle as Puzzle_model, PuzzleInfo as Puzzle_info_model, UserPuzzle as UserPuzzle_model

from region.region_schema import District
from puzzle.ppuzzle_schema import Puzzle


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