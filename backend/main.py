from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from database import user_engine,stamp_engine,user_Base,stamp_Base,region_Base,region_engine
app = FastAPI()

origins = ["*"]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
user_Base.metadata.create_all(bind=user_engine)
stamp_Base.metadata.create_all(bind=stamp_engine)
region_Base.metadata.create_all(bind=region_engine)

@app.get("/")
async def root():
    return {"message": "DIVE2024"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)