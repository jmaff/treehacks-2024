import requests
from secret_info import mongo_username, mongo_password, particle_token
from pymongo import MongoClient

# Get MongoDB Atlas connection details from environment variables

def lambda_handler(event, context):
    id = event['id']
    # Connect to MongoDB Atlas
    cluster = MongoClient(f"mongodb+srv://{mongo_username}:{mongo_password}@cluster0.mckkmip.mongodb.net/?retryWrites=true&w=majority")
    db = cluster["treehacks_2024"]
    collection = db["iot_data"]
    functionName = event['functionName']
    
    # Query MongoDB Atlas with the provided ID
    result = collection.find_one({'_id':id})
    device_id = result['identifier']

    # Close the MongoDB Atlas connection
    cluster.close()

    # set up particle rest api call
    token = particle_token

    # API endpoint URL
    url = f'https://api.particle.io/v1/devices/{device_id}/{functionName}'

    # Set up headers with authorization token
    payload = {'arg':'', 'access_token': token}

    # Make a POST request to an API endpoint
    response = requests.post(url, data=payload)

    print(response)