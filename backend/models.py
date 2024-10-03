from sqlalchemy import Column, Integer, String, Text, DateTime, ForeignKey, Boolean
from sqlalchemy.orm import relationship
from database import user_Base,region_Base,stamp_Base
from datetime import datetime


# User 모델 정의
class User(user_Base):
    __tablename__ = "user_info"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(String(255), unique=True, nullable=False, index=True)  
    password = Column(String(255), nullable=False)
    user_name = Column(String(30), nullable=False)
    

# 다른 모델 정의

class Stamp(stamp_Base):
    __tablename__ = "stamps"
    id = Column(Integer, primary_key=True, index=True)
    stamp_name = Column(String(100), nullable=False)
    user_id = Column(Integer, nullable=False)  # 외래 키 없음
    created_at = Column(DateTime, default=datetime.utcnow)
    region_id = Column(Integer, nullable=True)  # 외래 키 없음


# Region 테이블 정의
class Region(region_Base):
    __tablename__ = "regions"
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(50), nullable=False)


# 유저 스탬프 기록 테이블
class UserStamp(stamp_Base):
    __tablename__ = "user_stamps"
    received_at = Column(DateTime, default=datetime.utcnow)
    stamp_id = Column(Integer, primary_key=True)
    user_id = Column(Integer, primary_key=True)