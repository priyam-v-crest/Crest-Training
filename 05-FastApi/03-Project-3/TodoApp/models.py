from database import Base
from sqlalchemy import Column, Integer, String, Boolean

class Todos(Base):
    __tablename__ = "todos"

    id = Column(Integer, primary_key=True, index=True)
    title = Column(String(100), nullable=False)
    desciption = Column(String(255), nullable=False)  
    priority = Column(Integer, nullable=False)
    complete = Column(Boolean, default=False)
