# fastapi
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

# db
from database import user_engine,user_Base,stamp_Base,stamp_engine,region_Base,region_engine

# user
from user.user_router import router as user_router
from puzzle.puzzle_router import router as puzzle_router
from region.region_router import router as region_router
from region.house_router import router as house_router

app = FastAPI()


@app.get("/")
async def init():
    return {"init"}

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

app.include_router(user_router, tags=["user"])
app.include_router(puzzle_router, tags=["puzzle"])
app.include_router(region_router, tags=["region"])
app.include_router(house_router, tags=["house"])
if __name__ == "__main__":
    import uvicorn

    
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)