from fastapi import APIRouter, HTTPException, Depends, Response,Security
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials

from sqlalchemy.orm import Session
from database import get_region_db
from models import subway_info as Subway_Model, subway_Locker_info as Locker_Model, FoodPlace as Food_model, District as District_Model

from region.region_schema import District
import csv


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