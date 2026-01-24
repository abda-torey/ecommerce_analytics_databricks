import json
import random
import time
from datetime import datetime, timedelta
from azure.eventhub import EventHubProducerClient, EventData
import os
from faker import Faker

fake = Faker()

# Event types with realistic probabilities
EVENT_TYPES = {
    'page_view': 0.40,
    'product_view': 0.25,
    'add_to_cart': 0.15,
    'remove_from_cart': 0.05,
    'search': 0.10,
    'filter': 0.05
}

# Product categories
CATEGORIES = [
    'Electronics', 'Clothing', 'Books', 'Home & Garden',
    'Sports', 'Toys', 'Beauty', 'Food & Beverage'
]

# Pages users can visit
PAGES = [
    '/home', '/products', '/cart', '/checkout', '/account',
    '/search', '/category', '/product/{id}', '/deals', '/new-arrivals'
]

# Devices
DEVICES = ['desktop', 'mobile', 'tablet']
BROWSERS = ['Chrome', 'Firefox', 'Safari', 'Edge']
OS = ['Windows', 'MacOS', 'iOS', 'Android', 'Linux']


def weighted_random_choice(choices_dict):
    """Select a random choice based on weights"""
    choices = list(choices_dict.keys())
    weights = list(choices_dict.values())
    return random.choices(choices, weights=weights)[0]


def generate_clickstream_event():
    """Generate a single clickstream event"""
    event_type = weighted_random_choice(EVENT_TYPES)
    
    event = {
        'event_id': fake.uuid4(),
        'event_type': event_type,
        'timestamp': datetime.utcnow().isoformat(),
        'user_id': f'user_{random.randint(1, 10000)}',
        'session_id': fake.uuid4()[:8],
        'device': {
            'type': random.choice(DEVICES),
            'browser': random.choice(BROWSERS),
            'os': random.choice(OS),
            'ip_address': fake.ipv4()
        },
        'location': {
            'country': fake.country_code(),
            'city': fake.city(),
            'region': fake.state()
        }
    }
    
    # Add event-specific fields
    if event_type == 'page_view':
        event['page_url'] = random.choice(PAGES)
        event['referrer'] = random.choice(PAGES) if random.random() > 0.3 else None
        
    elif event_type == 'product_view':
        event['product_id'] = f'prod_{random.randint(1, 1000)}'
        event['product_name'] = fake.catch_phrase()
        event['product_category'] = random.choice(CATEGORIES)
        event['product_price'] = round(random.uniform(9.99, 999.99), 2)
        
    elif event_type == 'add_to_cart':
        event['product_id'] = f'prod_{random.randint(1, 1000)}'
        event['quantity'] = random.randint(1, 5)
        event['price'] = round(random.uniform(9.99, 999.99), 2)
        
    elif event_type == 'remove_from_cart':
        event['product_id'] = f'prod_{random.randint(1, 1000)}'
        
    elif event_type == 'search':
        event['search_query'] = fake.word()
        event['results_count'] = random.randint(0, 100)
        
    elif event_type == 'filter':
        event['filter_type'] = random.choice(['category', 'price', 'brand', 'rating'])
        event['filter_value'] = fake.word()
    
    return event


def send_to_eventhub(connection_string, eventhub_name, events, batch_size=100):
    """Send events to Azure Event Hub"""
    producer = EventHubProducerClient.from_connection_string(
        conn_str=connection_string,
        eventhub_name=eventhub_name
    )
    
    try:
        event_data_batch = producer.create_batch()
        
        for i, event in enumerate(events):
            event_data = EventData(json.dumps(event))
            
            try:
                event_data_batch.add(event_data)
            except ValueError:
                # Batch is full, send it and create a new one
                producer.send_batch(event_data_batch)
                event_data_batch = producer.create_batch()
                event_data_batch.add(event_data)
            
            if (i + 1) % batch_size == 0:
                producer.send_batch(event_data_batch)
                event_data_batch = producer.create_batch()
                print(f"Sent batch of {batch_size} events")
        
        # Send remaining events
        if len(event_data_batch) > 0:
            producer.send_batch(event_data_batch)
            print(f"Sent final batch of {len(event_data_batch)} events")
            
    finally:
        producer.close()
def main():
    """Main execution function"""
    # Load configuration from environment variables
    connection_string = os.getenv('EVENTHUB_CLICKSTREAM_CONNECTION_STRING')
    eventhub_name = 'clickstream'
    
    if not connection_string:
        print("Error: EVENTHUB_CLICKSTREAM_CONNECTION_STRING not set")
        print("Load credentials: source infrastructure/terraform/environments/dev.env or set manually")
        return
    
    # Number of events to generate
    num_events = int(os.getenv('CLICKSTREAM_EVENT_COUNT', 1000))
    
    # Generate events
    events = [generate_clickstream_event() for _ in range(num_events)]
    
    # Send to Event Hub
    send_to_eventhub(connection_string, eventhub_name, events, batch_size=100)
    print(f"Sent {num_events} clickstream events to Event Hub '{eventhub_name}'.")


if __name__ == "__main__":
    main()
