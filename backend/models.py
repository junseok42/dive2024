from sqlalchemy import Column, Integer, String, Float, DateTime, ForeignKey, Text
from database import user_Base, stamp_Base, region_Base
from datetime import datetime

# User 모델 정의
class User(user_Base):
    __tablename__ = "user_info"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(String(255), unique=True, nullable=False, index=True)  
    password = Column(String(255), nullable=False)
    user_name = Column(String(30), nullable=False)
    current_puzzle = Column(Integer)

# 지역구 테이블 정의
class District(region_Base):
    __tablename__ = "districts"
    id = Column(Integer, primary_key=True, index=True)
    district = Column(String(50), nullable=False, index=True)
    content = Column(String(250), nullable=False)
     

# Stamp 테이블 정의
class Puzzle(stamp_Base):
    __tablename__ = "puzzles"
    id = Column(Integer, primary_key=True, index=True)
    puzzle_num = Column(Integer,index=True)
    puzzle_cnt = Column(Integer)

# 유저 스탬프 기록 테이블 정의
class UserPuzzle(stamp_Base):
    __tablename__ = "user_puzzle"
    id = Column(Integer, primary_key=True, index=True)
    received_at = Column(DateTime, default=datetime.utcnow)
    puzzle_num = Column(Integer)
    user_id = Column(String(30), index=True)
    puzzle_index = Column(Integer)

class PuzzleInfo(stamp_Base):
    __tablename__ = "puzzle_info"
    id = Column(Integer, primary_key=True, index=True)
    puzzle_num = Column(Integer, index=True)
    puzzle_index = Column(Integer)
    district = Column(String(30), index= True)
    title = Column(String(255))
    content = Column(String(255))
    address = Column(String(500))


class subway_info(region_Base):
    __tablename__ = "station"
    id = Column(Integer, primary_key=True, index=True)
    line = Column(String(10))
    station_name = Column(String(20), index= True)
    Meeting_Point = Column(Integer)
    Locker = Column(Integer)
    Photo_Booth = Column(Integer)
    ACDI = Column(Integer)#무인민원발급기
    Infant_Nursing_Room = Column(Integer)
    Wheelchair_Lift = Column(Integer)
    TPVI = Column(Integer)#시각장애인유도로
    URP = Column(Integer)#도시경찰대
    district = Column(String(10),index=True)

class subway_Locker_info(region_Base):
    __tablename__ = "Locker"
    id = Column(Integer, primary_key=True, index=True)
    station_name = Column(String(20), index= True)
    Detailed_Location = Column(String(100))
    Small = Column(Integer)
    Medium = Column(Integer)
    Large = Column(Integer)
    Extra_Large = Column(Integer)
    Usage_fee = Column(String(100))

class house_info(region_Base):
    __tablename__ = "house"
    id = Column(Integer, primary_key=True, index=True)
    type = Column(String(15), index=True)
    name = Column(String(100), index=True)
    cnt = Column(Integer)
    address = Column(String(500))
    region = Column(String(20),index=True)

class FoodPlace(region_Base):
    __tablename__ = "food"
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(30), index=True)
    District = Column(String(20),index=True)
