import logging
import random
import string


LOGGER = logging.getLogger()
LOGGER.setLevel(logging.INFO)


def handler(event, context):
    """
        event = {
            "name": "Surya"
        }
    """
    # names = ['surya', 'prakash', 'reddy', 'kosana']
    names = [''.join(random.choice(string.ascii_lowercase) for i in range(random.randint(2, 20)))
              for _ in range(random.randint(2, 20))]
    LOGGER.info(f'Event Object: {event}')
    LOGGER.info(f'Context Object: {context}')
    random_name = random.choice(names)
    event['name'] = random_name
    return event
