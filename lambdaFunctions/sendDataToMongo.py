from pymongo import MongoClient

# Get MongoDB Atlas connection details from environment variables

def lambda_handler(event, context):
    identifier = event['identifier']
    new_val = event['new_val']
    # Connect to MongoDB Atlas
    cluster = MongoClient("mongodb+srv://marschub:Mamapapa4321@cluster0.mckkmip.mongodb.net/?retryWrites=true&w=majority")
    db = cluster["treehacks_2024"]
    collection = db["iot_data"]
    
    filter = {"identifier": identifier}
    update = {"$set": {"data": new_val}}
    # Query MongoDB Atlas with the provided ID
    result = collection.find_one_and_update(filter, update, return_document=True)

    # Close the MongoDB Atlas connection
    cluster.close()