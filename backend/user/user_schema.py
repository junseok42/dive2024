from pydantic import BaseModel
from typing import Optional


# 입력받는 양식
class User(BaseModel):
    user_id: str # 아이디
    password: str # 비밀번호
    user_name: str # 실제 이름 

    


class TokenRefreshRequest(BaseModel):
    refresh_token: str
    
class UserResponse(BaseModel):
    user_id: str
    user_name:str

class Login_user(BaseModel):
    user_id: str
    password: str

class modify_password(BaseModel):
    password: str
    new_password: str
 
class certification_email(BaseModel):
    user_id: str
    email: str

class check_certification_email(BaseModel):
    user_id: str
    email: str
    number: str