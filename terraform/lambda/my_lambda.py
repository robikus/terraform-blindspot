import boto3
import json
import traceback
import tempfile
import datetime
import logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)
s3_client = boto3.client('s3')

BUCKET_NAME_BASE = 'my-taget-bucket'

def get_env_from_url(handler_event):
    if handler_event['queryStringParameters']['env'] not in ['dev','prod']:
        raise ('Unknown enviroment variable')
    return handler_event['queryStringParameters']['env']

def get_bucket_name(env):
    return BUCKET_NAME_BASE + '-' + env

def delete_files_in_s3_bucket(bucket_name):
    '''
    Deletes all files in the specified bucket.
    This is a really simple version that would need to get upgraded in real project
    '''
    paginator = s3_client.get_paginator("list_objects_v2")
    for page in paginator.paginate(Bucket=bucket_name):
        contents = page.get('Contents', [])
        if len(contents) > 0:
            for content in contents:
                file = content['Key']
                s3_client.delete_object(
                    Bucket=bucket_name,
                    Key=file,
                )

def create_test_file_content(handler_event):
    '''
    Creates content of the target bucket index.html file based on the enviroment
    '''
    env = get_env_from_url(handler_event)
    dt = datetime.datetime.now()
    text = "<html xmlns=\"http://www.w3.org/1999/xhtml\"><head><title>Welcome</title></head><body><p>This is an index.html file in the %s bucket. This file was generated at: %s .</p></body></html>" % (env.upper(), dt)
    return text

def save_file_on_s3(file_payload, bucket_name):
    '''
    Creates tempfile, puts the text in and saves it to the specified S3 bucket (publicly available)
    '''
    s3_prefix = 'index.html'
    with tempfile.TemporaryFile() as temp_file:
        # encoding text data to binary format
        temp_file.write(file_payload.encode('utf-8'))
        temp_file.seek(0) 
        s3_client.put_object(
                Body=temp_file,
                Bucket=bucket_name,
                Key=s3_prefix,
                ContentType='text/html',
                # we wanna make the file public
                ACL='public-read')

def lambda_handler(event, context):
    '''
    Main Lambda workflow
    '''
    try:
        logger.info('## starting lambda')
        env = get_env_from_url(event)
        bucket_name = get_bucket_name(env)
        delete_files_in_s3_bucket(bucket_name)
        file_payload = create_test_file_content(event)
        save_file_on_s3(file_payload, bucket_name)
        response_body = 'This is the %s API. Checkout https://my-taget-bucket-%s.s3.eu-central-1.amazonaws.com/index.html' % (env.upper(), env)
        return {
            "statusCode": 200,
            "body"      : json.dumps(response_body)
        }
    except Exception as ex:
        return {
            "statusCode": 400,
            "body"      : traceback.format_exc()
        } 