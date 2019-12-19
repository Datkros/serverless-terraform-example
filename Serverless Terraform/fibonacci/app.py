from math import sqrt
import json

def handler(event, context):
    n = json.loads(event['body'])['number']
    if n < 0:
        message = 'Invalid Number'
    elif n == 1:
        result = n
    else:
        result = int(((1+sqrt(5))**n-(1-sqrt(5))**n)/(2**n*sqrt(5)))
    message = f"Result: {result}"
    return {
        "isBase64Encoded": False,
        "statusCode": 200,
        "headers": {},
        "body": json.dumps({"result": message})
    }