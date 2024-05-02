import os
from dotenv import load_dotenv
 
aaa  = load_dotenv()
print(aaa)
print(f'Foo value from .env: {os.getenv("DN_ACTIVE_DIRECTORY")}')
print(f'Foo value from .env: {os.environ.get("DN_ACTIVE_DIRECTORY")}')
