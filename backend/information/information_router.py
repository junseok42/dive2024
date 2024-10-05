from fastapi import APIRouter, File, UploadFile,Depends
from fastapi.responses import FileResponse
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
import os
from sqlalchemy.orm import Session
from database import get_region_db

from models import District as District_Model

security = HTTPBearer()


router = APIRouter(
    prefix="/information",
)
# 이미지 저장 경로
IMAGE_DIR = '/home/kimtaewoo2242/dive2024/backend/img'

@router.post("/upload/")
async def upload_image(file: UploadFile = File(...)):
    file_location = f"{IMAGE_DIR}/{file.filename}"
    with open(file_location, "wb+") as file_object:
        file_object.write(file.file.read())
    return {"info": f"File '{file.filename}' saved at '{file_location}'"}

@router.get("/images/{image_name}")
async def get_image(image_name: str):
    image_name = image_name+".png"
    image_path = os.path.join(IMAGE_DIR, image_name)
    if os.path.exists(image_path):
        return FileResponse(image_path)
    return {"error": "Image not found"}

@router.get("/{district_name}")
async def get_district_information(district : str,region_db: Session = Depends(get_region_db)):
    data = region_db.query(District_Model).filter(District_Model.district == district).first()
    return data.district, data.content