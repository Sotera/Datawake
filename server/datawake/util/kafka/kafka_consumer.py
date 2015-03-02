from kafka.client import KafkaClient
from kafka.consumer import SimpleConsumer


class KafkaConsumer:

    group = "python-lookahead-consumer"

    def __init__(self,conn_pool,topic,group):
        self.conn_pool = conn_pool
        self.topic = topic
        self.group = group
        self.kafka = KafkaClient(self.conn_pool)
        self.consumer = SimpleConsumer(self.kafka,self.group,self.topic,max_buffer_size=None)
        self.consumer.seek(0,2) # move to the tail of the queue

    def next(self):
        offsetAndMessage = self.consumer.get_messages(timeout=None)[0]
        message = offsetAndMessage.message.value
        return message



