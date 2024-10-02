from sqlalchemy import Column, Integer, String, ForeignKey, DECIMAL, TIMESTAMP, Text
from sqlalchemy.orm import relationship
from datetime import datetime
from database import Base  # 데이터베이스 초기화 시 사용하는 Base

# 유저 테이블
class User(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True, index=True)
    password = Column(Text, nullable=False)
    user_id = Column(String(30), nullable=False, unique=True)

    user_stamps = relationship("UserStamp", back_populates="user")

# 지역 테이블
class Region(Base):
    __tablename__ = "regions"
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(10), nullable=False)

    stamps = relationship("Stamp", back_populates="region")

# 스탬프 테이블
class Stamp(Base):
    __tablename__ = "stamps"
    id = Column(Integer, primary_key=True, index=True)
    stamp_name = Column(String(100), nullable=False)
    user_id = Column(Integer, ForeignKey("users.id"))
    latitude = Column(DECIMAL(10, 8), nullable=False)
    longitude = Column(DECIMAL(11, 8), nullable=False)
    created_at = Column(TIMESTAMP, default=datetime.utcnow)
    region_id = Column(Integer, ForeignKey("regions.id"))

    user = relationship("User", back_populates="stamps")
    region = relationship("Region", back_populates="stamps")
    user_stamps = relationship("UserStamp", back_populates="stamp")

# 유저 스탬프 기록 테이블
class UserStamp(Base):
    __tablename__ = "user_stamps"
    received_at = Column(TIMESTAMP, default=datetime.utcnow)
    stamp_id = Column(Integer, ForeignKey("stamps.id"), primary_key=True)
    user_id = Column(Integer, ForeignKey("users.id"), primary_key=True)

    user = relationship("User", back_populates="user_stamps")
    stamp = relationship("Stamp", back_populates="user_stamps")
