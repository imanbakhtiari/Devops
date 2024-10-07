import pika
import uuid

# Define RabbitMQ connection parameters with credentials
credentials = pika.PlainCredentials('user', 'password')  # Replace with your RabbitMQ username and password
connection_params = pika.ConnectionParameters('localhost', 5672, '/', credentials)

# Establish connection to RabbitMQ server
connection = pika.BlockingConnection(connection_params)
channel = connection.channel()

# Declare a response queue for acknowledgments
result = channel.queue_declare(queue='', exclusive=True)
callback_queue = result.method.queue

# Define a callback to handle response
def on_response(ch, method, properties, body):
    print(f" [x] Acknowledgment received: {body.decode()}")

# Subscribe the callback to the response queue
channel.basic_consume(queue=callback_queue, on_message_callback=on_response, auto_ack=True)

# Send a message to the consumer
message = 'Hello, World!'
channel.basic_publish(
    exchange='',
    routing_key='task_queue',
    body=message,
    properties=pika.BasicProperties(reply_to=callback_queue)  # Specify the callback queue
)

print(f" [x] Sent '{message}'")

# Start consuming to listen for the acknowledgment
channel.start_consuming()

