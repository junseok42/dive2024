from fastapi import APIRouter, File, UploadFile
from fastapi.responses import FileResponse
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
import os


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
    image_path = os.path.join(IMAGE_DIR, image_name)
    if os.path.exists(image_path):
        return FileResponse(image_path)
    return {"error": "Image not found"}

