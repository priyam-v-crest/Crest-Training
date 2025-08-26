from typing import Annotated
from sqlalchemy.orm import Session
from fastapi import FastAPI, Depends, HTTPException, Path
from starlette import status
from pydantic import BaseModel, Field
from database import engine, SessionLocal
import models

app = FastAPI()

# Create all tables
models.Base.metadata.create_all(bind=engine)

# Dependency for DB session
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# Annotated type alias for DB dependency
db_dependency = Annotated[Session, Depends(get_db)]

# Pydantic model for request body
class TodoRequest(BaseModel):
    title: str = Field(min_length=3)
    desciption: str = Field(min_length=3, max_length=255)  # Keeping 'desciption'
    priority: int = Field(gt=0, lt=6)
    complete: bool

# Get all todos
@app.get("/")
async def read_all(db: db_dependency):
    return db.query(models.Todos).all()

# Get a single todo by ID
@app.get("/todo/{todo_id}", status_code=status.HTTP_200_OK)
async def read_todo(db: db_dependency, todo_id: int = Path(..., gt=0)):
    todo_model = db.query(models.Todos).filter(models.Todos.id == todo_id).first()
    if todo_model is not None:
        return todo_model
    raise HTTPException(status_code=404, detail="Todo Not Found.")

# Create a new todo
@app.post("/todo", status_code=status.HTTP_201_CREATED)
async def create_todo(db: db_dependency, todo_request: TodoRequest):
    todo_model = models.Todos(**todo_request.dict())
    db.add(todo_model)
    db.commit()
    db.refresh(todo_model)
    return todo_model

# Update an existing todo
@app.put("/todo/{todo_id}", status_code=status.HTTP_200_OK)
async def update_todo(
    db: db_dependency,
    todo_request: TodoRequest,
    todo_id: int = Path(gt=0)
):
    todo_model = db.query(models.Todos).filter(models.Todos.id == todo_id).first()
    if todo_model is None:
        raise HTTPException(status_code=404, detail="Todo not found.")

    # Update fields
    todo_model.title = todo_request.title
    todo_model.desciption = todo_request.desciption
    todo_model.priority = todo_request.priority
    todo_model.complete = todo_request.complete

    db.commit()
    db.refresh(todo_model)
    return todo_model



@app.delete("/todo/{todo_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_todo(todo_id: int = Path(gt=0), db: Session = Depends(get_db)):
    # Find the todo
    todo_model = db.query(models.Todos).filter(models.Todos.id == todo_id).first()
    if todo_model is None:
        raise HTTPException(status_code=404, detail="Todo not found.")

    # Delete the todo
    db.delete(todo_model)
    db.commit()
    return