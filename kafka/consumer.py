from kafka import KafkaConsumer
import json

# Initialize the consumer
consumer = KafkaConsumer(
    'test_topic',  # Topic to subscribe to
    bootstrap_servers='localhost:9092',  # Use 'kafka:9092' if inside a Docker container
    value_deserializer=lambda x: json.loads(x.decode('utf-8')),  # Deserialize JSON
    auto_offset_reset='earliest',  # Start reading at the earliest message
    enable_auto_commit=True,
    group_id='my-group'  # Consumer group ID
)

# Consume messages
for message in consumer:
    print(f'Received: {message.value}')
