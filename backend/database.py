from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from dotenv import load_dotenv
import os
load_dotenv()

DB_HOST = os.environ.get("DB_HOST")
DB_PASSWORD = os.environ.get("DB_PASSWORD")
USER_DB_NAME = os.environ.get("USER_DB_NAME")
STAMP_DB_NAME = os.environ.get("STAMP_DB_NAME")
REGION_DB_NAME = os.environ.get("REGION_DB_NAME")
DB_PORT = os.environ.get("DB_PORT", 3306)

SQLALCHEMY_DATABASE_URL_USER = f"mysql+mysqlconnector://root:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{USER_DB_NAME}"
SQLALCHEMY_DATABASE_URL_STAMP = f"mysql+mysqlconnector://root:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{STAMP_DB_NAME}"
SQLALCHEMY_DATABASE_URL_REGION = f"mysql+mysqlconnector://root:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{REGION_DB_NAME}"
stamp_engine = create_engine(SQLALCHEMY_DATABASE_URL_STAMP)
region_engine = create_engine(SQLALCHEMY_DATABASE_URL_REGION)
user_engine = create_engine(SQLALCHEMY_DATABASE_URL_USER)

user_SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=user_engine)
stamp_SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=stamp_engine)
region_SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=region_engine)

user_Base = declarative_base()
stamp_Base = declarative_base()
region_Base = declarative_base()

def get_userdb():
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
