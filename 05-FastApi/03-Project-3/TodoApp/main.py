from fastapi import FastAPI
import models
from database import engine
from routers import auth, todos

app = FastAPI()

# Create all tables
models.Base.metadata.create_all(bind=engine)

# Include routers
app.include_router(auth.router)
app.include_router(todos.router)
