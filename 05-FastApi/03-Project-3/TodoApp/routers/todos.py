from typing import Annotated
from pydantic import BaseModel, Field
from sqlalchemy.orm import Session
from fastapi import APIRouter, Depends, HTTPException, Path
from starlette import status
import models
from database import SessionLocal

router = APIRouter()

# Dependency for DB session
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

db_dependency = Annotated[Session, Depends(get_db)]

# Pydantic model for request body
class TodoRequest(BaseModel):
    title: str = Field(min_length=3)
    description: str = Field(min_length=3, max_length=255)
    priority: int = Field(gt=0, lt=6)
    complete: bool

# Get all todos
@router.get("/")
async def read_all(db: db_dependency):
    return db.query(models.Todos).all()

# Get a single todo by ID
@router.get("/todo/{todo_id}", status_code=status.HTTP_200_OK)
async def read_todo(db: db_dependency, todo_id: int = Path(..., gt=0)):
    todo_model = db.query(models.Todos).filter(models.Todos.id == todo_id).first()
    if todo_model:
        return todo_model
    raise HTTPException(status_code=404, detail="Todo not found")

# Create a new todo
@router.post("/todo", status_code=status.HTTP_201_CREATED)
async def create_todo(db: db_dependency, todo_request: TodoRequest):
    todo_model = models.Todos(**todo_request.dict())
    db.add(todo_model)
    db.commit()
    db.refresh(todo_model)
    return todo_model

# Update an existing todo
@router.put("/todo/{todo_id}", status_code=status.HTTP_200_OK)
async def update_todo(db: db_dependency, todo_request: TodoRequest, todo_id: int = Path(gt=0)):
    todo_model = db.query(models.Todos).filter(models.Todos.id == todo_id).first()
    if todo_model is None:
        raise HTTPException(status_code=404, detail="Todo not found")

    todo_model.title = todo_request.title
    todo_model.description = todo_request.description
    todo_model.priority = todo_request.priority
    todo_model.complete = todo_request.complete

    db.commit()
    db.refresh(todo_model)
    return todo_model

# Delete a todo
@router.delete("/todo/{todo_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_todo(todo_id: int = Path(gt=0), db: Session = Depends(get_db)):
    todo_model = db.query(models.Todos).filter(models.Todos.id == todo_id).first()
    if todo_model is None:
        raise HTTPException(status_code=404, detail="Todo not found")

    db.delete(todo_model)
    db.commit()
    return
