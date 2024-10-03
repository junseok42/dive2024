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

# 지역구 테이블 정의
class District(region_Base):
    __tablename__ = "districts"
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(50), nullable=False) 

# Stamp 테이블 정의
class Stamp(stamp_Base):
    __tablename__ = "stamps"
    id = Column(Integer, primary_key=True, index=True)
    stamp_name = Column(String(100), nullable=False)  
    title = Column(String(255), nullable=False)  
    description = Column(Text, nullable=True)  
    latitude = Column(Float, nullable=False)  
    longitude = Column(Float, nullable=False)  
    district_id = Column(Integer, nullable=False)  
    created_at = Column(DateTime, default=datetime.utcnow)

# 유저 스탬프 기록 테이블 정의
class UserStamp(stamp_Base):
    __tablename__ = "user_stamps"
    received_at = Column(DateTime, default=datetime.utcnow)
    stamp_id = Column(Integer, primary_key=True)
    user_id = Column(Integer, primary_key=True)
