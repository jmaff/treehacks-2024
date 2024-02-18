from pymongo import MongoClient

# Get MongoDB Atlas connection details from environment variables

def lambda_handler(event, context):
    id = event['id']
    # Connect to MongoDB Atlas
    cluster = MongoClient("mongodb+srv://marschub:Mamapapa4321@cluster0.mckkmip.mongodb.net/?retryWrites=true&w=majority")
    db = cluster["treehacks_2024"]
    collection = db["iot_data"]
    
    # Query MongoDB Atlas with the provided ID
    result = collection.find_one({'_id':id})

    # Close the MongoDB Atlas connection
    cluster.close()

    return {
        'statusCode': 200,
        'body': result  # Return the query result
    }

event = {'id': '0'}
print(lambda_handler(event, 0))
