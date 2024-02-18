import json
from pymongo import MongoClient
from secret_info import mongo_username, mongo_password

# Get MongoDB Atlas connection details from environment variables

def lambda_handler(event, context):
    body = json.loads(event['body'])

    tagID = body['tagID']
    # Connect to MongoDB Atlas
    cluster = MongoClient(f"mongodb+srv://{mongo_username}:{mongo_password}@cluster0.mckkmip.mongodb.net/?retryWrites=true&w=majority")
    db = cluster["treehacks_2024"]
    collection = db["iot_data"]
    
    # Query MongoDB Atlas with the provided ID
    result = collection.find_one({'tagID':tagID})
    if result is not None:
        del result["_id"]

    # Close the MongoDB Atlas connection
    cluster.close()

    return {
        'statusCode': 200,
        'body': json.dumps(result)  # Return the query result
    }

# event = {'id': '0'}
# print(lambda_handler(event, 0))
