import requests
import json
from pymongo import MongoClient
from secret_info import mongo_username, mongo_password, particle_token

# Get MongoDB Atlas connection details from environment variables

def lambda_handler(event, context):
    body = json.loads(event['body'])
    tagID = body['tagID']
    # Connect to MongoDB Atlas
    cluster = MongoClient(f"mongodb+srv://{mongo_username}:{mongo_password}@cluster0.mckkmip.mongodb.net/?retryWrites=true&w=majority")
    db = cluster["treehacks_2024"]
    collection = db["iot_data"]
    functionName = body['functionName']
    
    # Query MongoDB Atlas with the provided ID
    result = collection.find_one({'tagID':tagID})
    device_id = result['particleID']

    # Close the MongoDB Atlas connection
    cluster.close()

    # API endpoint URL
    url = f'https://api.particle.io/v1/devices/{device_id}/{functionName}'

    # Set up headers with authorization token
    payload = {'arg':'', 'access_token': particle_token}

    # Make a POST request to an API endpoint
    response = requests.post(url, data=payload)

    return json.dumps("")

# if __name__ == "__main__":
#     event = {'id': '0', 'functionName': 'LED'}
#     lambda_handler(event, 0)