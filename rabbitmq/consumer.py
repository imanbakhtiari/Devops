import pika
import time

# Define RabbitMQ connection parameters with credentials
credentials = pika.PlainCredentials('user', 'password')  # Replace with your RabbitMQ username and password
connection_params = pika.ConnectionParameters('localhost', 5672, '/', credentials)

# Establish connection to RabbitMQ server
connection = pika.BlockingConnection(connection_params)
channel = connection.channel()

# Declare the same durable queue
channel.queue_declare(queue='task_queue', durable=True)

# Callback function for processing the message
def callback(ch, method, properties, body):
    print(f" [x] Received {body.decode()}")
    # Simulate some processing time
    time.sleep(1)  # Simulating work
    print(f" [x] Done processing {body.decode()}")
    # Acknowledge message processing
    ch.basic_ack(delivery_tag=method.delivery_tag)

    # Ensure reply_to is a valid string before sending
    if properties.reply_to:
        acknowledgment = f"Processed '{body.decode()}'"
        ch.basic_publish(
            exchange='',
            routing_key=properties.reply_to,  # Send to the callback queue
            body=acknowledgment,
            properties=pika.BasicProperties(correlation_id=properties.correlation_id)  # Optional: set correlation ID
        )
    else:
        print(" [!] No reply_to specified in the properties.")

# Tell RabbitMQ not to dispatch more than one message at a time (Fair dispatch)
channel.basic_qos(prefetch_count=1)

# Subscribe the callback to the queue
channel.basic_consume(queue='task_queue', on_message_callback=callback)

print(' [*] Waiting for messages. To exit press CTRL+C')
# Start consuming
channel.start_consuming()

