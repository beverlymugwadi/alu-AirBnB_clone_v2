from sqlalchemy.orm import scoped_session, sessionmaker
from sqlalchemy import create_engine
from models.base_model import BaseModel, Base

class FileStorage:


    __engine = None
    __session = None

    def __init__(self):
        self.__engine = create_engine('sqlite:///my_database.db')
        Base.metadata.create_all(self.__engine)
        session_factory = sessionmaker(bind=self.__engine, 
                                       expire_on_commit=False)
        Session = scoped_session(session_factory)
        self.__session = Session()

    def all(self, cls=None):
        if cls:
            return self.__session.query(cls).all()
        return self.__session.query(BaseModel).all()

    def new(self, obj):
        self.__session.add(obj)

    def save(self):
        self.__session.commit()

    def delete(self, obj=None):
        if obj:
            self.__session.delete(obj)

    def reload(self):
        Base.metadata.create_all(self.__engine)

    def close(self):
        self.__session.close()
