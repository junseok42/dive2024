from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from dotenv import load_dotenv
import os

# .env 파일 로드
load_dotenv()

# 환경 변수 설정
DB_HOST = os.environ.get("DB_HOST")
DB_PASSWORD = os.environ.get("DB_PASSWORD")
USER_DB_NAME = os.environ.get("USER_DB_NAME")
STAMP_DB_NAME = os.environ.get("STAMP_DB_NAME")
REGION_DB_NAME = os.environ.get("REGION_DB_NAME")
DB_PORT = int(os.environ.get("DB_PORT", 3306))  

# 데이터베이스 URL 생성
SQLALCHEMY_DATABASE_URL_USER = f"mysql+mysqlconnector://root:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{USER_DB_NAME}"
SQLALCHEMY_DATABASE_URL_STAMP = f"mysql+mysqlconnector://root:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{STAMP_DB_NAME}"
SQLALCHEMY_DATABASE_URL_REGION = f"mysql+mysqlconnector://root:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{REGION_DB_NAME}"

# 엔진 생성
user_engine = create_engine(SQLALCHEMY_DATABASE_URL_USER)
stamp_engine = create_engine(SQLALCHEMY_DATABASE_URL_STAMP)
region_engine = create_engine(SQLALCHEMY_DATABASE_URL_REGION)

# 세션 생성기
user_SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=user_engine)
stamp_SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=stamp_engine)
region_SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=region_engine)

# Base 클래스 생성
user_Base = declarative_base()
stamp_Base = declarative_base()
region_Base = declarative_base()

# 데이터베이스 세션 가져오기 함수
def get_user_db():
    db = user_SessionLocal()
    try:
        yield db
    finally:
        db.close()

def get_stamp_db():
    db = stamp_SessionLocal()
    try:
        yield db
    finally:
        db.close()

def get_region_db():
    db = region_SessionLocal()
    try:
        yield db
    finally:
        db.close()
