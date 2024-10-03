from sqlalchemy import Column, Integer, String, Float, DateTime, ForeignKey,Text
from sqlalchemy.orm import relationship
from database import user_Base, stamp_Base
from datetime import datetime

# User 모델 정의
class User(user_Base):
    __tablename__ = "user_info"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(String(255), unique=True, nullable=False, index=True)  
    password = Column(String(255), nullable=False)
    user_name = Column(String(30), nullable=False)

    stamps = relationship("UserStamp", back_populates="user")

#지역구 테이블 정의
class District(user_Base):
    __tablename__ = "districts"
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(50), nullable=False) 

    stamps = relationship("Stamp", back_populates="district")


# Stamp 테이블 정의
class Stamp(stamp_Base):
    __tablename__ = "stamps"
    id = Column(Integer, primary_key=True, index=True)
    stamp_name = Column(String(100), nullable=False)  
    title = Column(String(255), nullable=False)  
    description = Column(Text, nullable=True)  
    latitude = Column(Float, nullable=False)  
    longitude = Column(Float, nullable=False)  
    district_id = Column(Integer, ForeignKey('districts.id'), nullable=False)  
    created_at = Column(DateTime, default=datetime.utcnow)

    district = relationship("District", back_populates="stamps")
    user_stamps = relationship("UserStamp", back_populates="stamp")


# 유저 스탬프 기록 테이블 정의
class UserStamp(stamp_Base):
    __tablename__ = "user_stamps"
    received_at = Column(DateTime, default=datetime.utcnow)
    stamp_id = Column(Integer, ForeignKey('stamps.id'), primary_key=True)
    user_id = Column(Integer, ForeignKey('user_info.id'), primary_key=True)

    user = relationship("User", back_populates="stamps")
    stamp = relationship("Stamp", back_populates="user_stamps")
