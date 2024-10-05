from fastapi import APIRouter, HTTPException, Depends, Response,Security
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials

from sqlalchemy.orm import Session
from database import get_region_db,get_userdb,get_stamp_db
from models import subway_info as Subway_Model, subway_Locker_info as Locker_Model, FoodPlace as Food_model, District as District_Model,\
PuzzleAttraction as Puzzle_At_Model, Attraction as At_Model,User as User_model, lodgment as  Lodgment_model

from region.region_schema import District,attraction
import csv
from puzzle.ppuzzle_schema import ClearPuzzle
from user.user_func import decode_jwt
from puzzle.puzzle_router import process_puzzle_clearance
security = HTTPBearer()


router = APIRouter(
    prefix="/region",
)

@router.post("/add")
def add_district(district: District,region_db: Session = Depends(get_region_db)):
    district_create = District_Model(district = district.name,
                                     content = district.content
            )
    region_db.add(district_create)
    region_db.commit()
    region_db.refresh(district_create)
    return district_create

@router.get("/list")
def see_district_list(region_db: Session = Depends(get_region_db)):
    districts = region_db.query(District_Model).all()  
    return [{"id": district.id, "name": district.district} for district in districts]

@router.delete("/delete/{district_id}")
def delete_district(district_id: int, region_db: Session = Depends(get_region_db)):
    district = region_db.query(District_Model).filter(District_Model.id == district_id).first()
    
    if district is None:
        raise HTTPException(status_code=404, detail="해당 지역구 없음")
    
    region_db.delete(district)
    region_db.commit()
    
    return {"detail": "삭제완료"}


@router.get("/subway/list")
def show_list_subway(district : str,region_db: Session = Depends(get_region_db)):
    station_data = region_db.query(Subway_Model).filter(Subway_Model.district == district).all()
    return  [{"id": station.id, "name": station.station_name} for station in station_data]

@router.get("/subway/info")
def show_info_station(station_id : int,region_db: Session = Depends(get_region_db)):
    station_data = region_db.query(Subway_Model).filter(Subway_Model.id == station_id).all()
    return [
    {
        "id": station.id,
        "name": station.station_name,
        "line": station.line,
        "Meeting_Point": station.Meeting_Point,
        "Locker": station.Locker,
        "Photo_Booth": station.Photo_Booth,
        "ACDI": station.ACDI,  # 무인 민원 발급기
        "Infant_Nursing_Room": station.Infant_Nursing_Room,
        "Wheelchair_Lift": station.Wheelchair_Lift,
        "TPVI": station.TPVI,  # 시각 장애인 유도
        "URP": station.URP,  # 도시경찰대
        "district": station.district
    }
    for station in station_data]

@router.get("/subway/locker")
def show_locker_info(station_name : str,region_db: Session = Depends(get_region_db)):
    locker_data = region_db.query(Locker_Model).filter(Locker_Model.station_name == station_name).all()
    return [
    {
        "id": locker.id,
        "station_name": locker.station_name,
        "Detailed_Location": locker.Detailed_Location,  # 보관함의 상세 위치
        "Small": locker.Small,  # 소형 보관함 개수
        "Medium": locker.Medium,  # 중형 보관함 개수
        "Large": locker.Large,  # 대형 보관함 개수
        "Extra_Large": locker.Extra_Large,  # 초대형 보관함 개수
        "Usage_fee": locker.Usage_fee  # 보관함 사용료
    }
    for locker in locker_data]

@router.get("/food/list")
def show_list_subway(district : str,region_db: Session = Depends(get_region_db)):
    food_data = region_db.query(Food_model).filter(Food_model.District == district).all()
    return  [{"id": food.id, "name": food.name} for food in food_data]



@router.post("/Puzzle_Attraction")
def add_puzzle_attraction(data : attraction,region_db: Session = Depends(get_region_db)):
    create_at = Puzzle_At_Model(name = data.name,
                                district = data.district,
                                content = data.content,
                                address = data.address,
                                puzzle_num = data.puzzle_num,
                                puzzle_index = data.puzzle_index)
    region_db.add(create_at)
    region_db.commit()
    region_db.refresh(create_at)
    return HTTPException(status_code=200 , detail="정상적으로 퍼즐장소가 추가되었습니다.")

@router.post("/Attraction")
def add_attraction(data : attraction,region_db: Session = Depends(get_region_db)):
    create_at = At_Model(name = data.name,
                                district = data.district,
                                content = data.content,
                                address = data.address)
    region_db.add(create_at)
    region_db.commit()
    region_db.refresh(create_at)
    return HTTPException(status_code=200 , detail="정상적으로 장소가 추가되었습니다.")

@router.get("/attract/{disctrict_name}")
def show_attract(disctrict_name : str,region_db: Session = Depends(get_region_db),credentials: HTTPAuthorizationCredentials = Security(security),
                 user_db: Session = Depends(get_userdb)):
    token = credentials.credentials
    
    try:
        payload = decode_jwt(token)
    except Exception as e:
        raise HTTPException(status_code=403, detail="유효하지 않은 토큰입니다.")
    
    user_id = payload.get("sub")
    if not user_id:
        raise HTTPException(status_code=403, detail="유효하지 않은 토큰 페이로드입니다.")
    puzzle_info = user_db.query(User_model).filter(User_model.user_id == user_id).one_or_none()
    puzzle_AT = region_db.query(Puzzle_At_Model).filter(Puzzle_At_Model.district == disctrict_name and Puzzle_At_Model.puzzle_num == puzzle_info.current_puzzle).all()
    AT = region_db.query(At_Model).filter(At_Model.district == disctrict_name).all()
    
    return [{"name" : at.name , "type" : True} for at in puzzle_AT] + [{"name" : at.name , "type" : False} for at in AT]

@router.post("/clear_puzzle")
def clear_puzzle_api(data: ClearPuzzle, 
                     credentials: HTTPAuthorizationCredentials = Depends(security), 
                     stamp_db: Session = Depends(get_stamp_db), 
                     user_db: Session = Depends(get_userdb)):
    # JWT 토큰 디코딩 및 사용자 검증
    user = validate_user_and_get_data(credentials, user_db)
    
    # 퍼즐 처리 함수 호출
    process_puzzle_clearance(data, user, stamp_db)
    return {"message": "정상적으로 퍼즐 완료 처리가 되었습니다."}

def validate_user_and_get_data(credentials: HTTPAuthorizationCredentials, user_db: Session):
    token = credentials.credentials
    try:
        payload = decode_jwt(token)
    except Exception as e:
        raise HTTPException(status_code=403, detail="유효하지 않은 토큰입니다.")
    
    user_id = payload.get("sub")
    if not user_id:
        raise HTTPException(status_code=403, detail="유효하지 않은 토큰 페이로드입니다.")
    
    user = user_db.query(User_model).filter(User_model.user_id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="사용자를 찾을 수 없습니다.")
    
    return user


@router.get("/show_lodgment/{district_name}")
def show_lodgment(district: str, region_db: Session = Depends(get_region_db)):
    datas = region_db.query(Lodgment_model).filter(Lodgment_model.district == district).all()
    return [{"name": data.name, "district" : data.district, "latitude" : data.latitude, "longitude" : data.longitude, "parking" : data.parking,\
             "locker" : data.locker, "wheel" : data.wheel, "road" : data.road} for data in datas]