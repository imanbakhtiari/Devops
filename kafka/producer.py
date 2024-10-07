from kafka import KafkaProducer
import json
import time

# Initialize the producer
producer = KafkaProducer(
    bootstrap_servers='localhost:9092',  # Use 'kafka:9092' if inside a Docker container
    value_serializer=lambda v: json.dumps(v).encode('utf-8')  # Serialize JSON
)

topic = 'test_topic'

# Produce messages
for i in range(10):
    message = {'number': i}
    producer.send(topic, value=message)
    print(f'Sent: {message}')
    time.sleep(1)  # Wait for a second before sending the next message

producer.flush()
producer.close()

