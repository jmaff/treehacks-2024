import json
import requests
from pymongo import MongoClient
from secret_info import mongo_username, mongo_password, particle_token

# Get MongoDB Atlas connection details from environment variables

def lambda_handler(event, context):
    body = json.loads(event['body'])

    # Connect to MongoDB Atlas
    cluster = MongoClient(f"mongodb+srv://{mongo_username}:{mongo_password}@cluster0.mckkmip.mongodb.net/?retryWrites=true&w=majority")
    db = cluster["treehacks_2024"]
    collection = db["iot_data"]
    
    filter = {"particleID": body['coreid']}
    new_val = float(body['data'])
    update = {"$set": {"mostRecentState": new_val}}
    # Query MongoDB Atlas with the provided ID

    result = collection.find_one_and_update(filter, update, return_document=True)
    if result is not None:
        del result["_id"]
 
    # Close the MongoDB Atlas connection
    cluster.close()

    return {
        'statusCode': 200,
        'body': json.dumps(result)  # Return the query result
    }
