import requests
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
    device_id = result['identifier']

    # Close the MongoDB Atlas connection
    cluster.close()

    # set up particle rest api call
    token = '720602948c4cd7251b47f208496c3d4f5eba6874'

    # API endpoint URL
    url = 'https://api.particle.io/v1/devices'

    # Set up headers with authorization token
    headers = {'Authorization': f'Bearer {token}'}

    data = {'command': 'toggle',
            'identifier': device_id}

    # Make a POST request to an API endpoint
    response = requests.post(url, json=data, headers=headers)

    

event = {'id': '0'}
print(lambda_handler(event, 0))
