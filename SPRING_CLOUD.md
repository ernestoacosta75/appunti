## Event-driven applications and functions
Cloud native applications should be loosely coupled.
Event-driven architectures describe distributed systems that interact by producing and consuming
events. The interaction is asynchronous, solving the problem of temporal coupling.

## Event-driven architectures
When an event occurs, interested
parties can be notified. Event notification is usually done through messages, which are a data
representation of an event.

In an event-driven architecture, we identify event producers and event consumers. A producer is
a component detecting the event and sending a notification. A consumer is a component getting
notified when a specific event occurs. Producers and consumers don’t know each other and work
independently. A producer sends an event notification by publishing a message to a channel
operated by an event broker responsible for collecting and routing messages to consumers. A
consumer is notified by the broker when an event occurs and can act upon it.
Producers and consumers have minimal coupling when using a broker that takes the processing
and distribution of events on itself. In particular, they are temporally decoupled because the
interaction is asynchronous. Consumers can fetch and process messages at any time without affecting the producers whatsoever.

## Kafka With Java, Spring, and Docker — Asynchronous Communication Between Microservices
https://github.com/pedroluiznogueira/medium-microservices-kafka

The idea is to create a Producer Microservice that receives Food Orders to be created and pass them along to the Consumer Microservice through Kafka to be persisted in database.

![alt text](https://miro.medium.com/max/1400/1*BsN81p7EOBf-1L2BVgTCbQ.png "Logo Title Text 1")


### Kafka in a nutshell
A Kafka cluster is highly scalable and fault-tolerant, meaning that if any of its servers fails, the other servers will take over their work to ensure continuous operations without any data loss.

An event records the fact that something happened, carrying a message, that can be pretty much anything, for example, a string, an array or a JSON object. When you read or write data to Kafka, you do this in the form of those events.

Producers are those that publish (write) events to Kafka, and consumers are those that subscribe (read and process) these events.

### Topics
Events are organized and durably stored in topics. A topic is similar to a folder, and these events are the files in that folder. Topics are multi-producer and multi-subscriber, meaning that we can have zero, one or many of them both.

**Events can be read as many times as needed, unlike traditional messaging systems, events are not deleted after consumption. Instead, you can define for how long Kafka should retain those events**.

### Partitions
Topics are partitioned, meaning that a topic is spread over a number of buckets. When a new event is published to a topic, it is actually appended to one of the topic’s partitions. Events with the same event key are written to the same partition. Kafka guarantees that any consumer of a given topic-partition will always read that partition’s events in the exact same order as they were written.
![alt text](https://miro.medium.com/max/1002/1*9nIXPX_2BbGRBXLENwhLOg.png "Logo Title Text 1")

To make your data fault-tolerant and high-available, every topic can be replicated, even across regions or data centers, so that there are always multiple brokers that have a copy of the data just in case things go wrong (they will).

### Producer Microservice setup
* Spring Web
* Spring Boot Actuator
* Lombok
* Spring for Apache Kafka

### Consumer Microservice setup
* Spring Web
* Spring Boot Actuator
* Lombok
* Spring for Apache Kafka
* H2 Database
* Spring Data JPA

### Docker Environment for Kafka
Create a docker-compose.yml file, containing the required configurations to run Kafka, Kafdrop, and Zookeeper in Docker containers.
```
version: "3.7"

networks:
  kafka-net:
    name: kafka-net
    driver: bridge

services:
  zookeeper:
    image: zookeeper:3.7.0
    container_name: zookeeper
    restart: "no"
    networks:
      - kafka-net
    ports:
      - "2181:2181"

  kafka:
    image: obsidiandynamics/kafka
    container_name: kafka
    restart: "no"
    networks:
      - kafka-net
    ports:
      - "9092:9092"
    environment:
      KAFKA_LISTENER_SECURITY_PROTOCOL_MAP: DOCKER_INTERNAL:PLAINTEXT,DOCKER_EXTERNAL:PLAINTEXT
      KAFKA_LISTENERS: DOCKER_INTERNAL://:29092,DOCKER_EXTERNAL://:9092
      KAFKA_ADVERTISED_LISTENERS: DOCKER_INTERNAL://kafka:29092,DOCKER_EXTERNAL://${DOCKER_HOST_IP:-127.0.0.1}:9092
      KAFKA_INTER_BROKER_LISTENER_NAME: DOCKER_INTERNAL
      KAFKA_ZOOKEEPER_CONNECT: "zookeeper:2181"
      KAFKA_BROKER_ID: 1
      KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR: 1
    depends_on:
      - zookeeper

  kafdrop:
    image: obsidiandynamics/kafdrop
    container_name: kafdrop
    restart: "no"
    networks:
      - kafka-net
    ports:
      - "9000:9000"
    environment:
      KAFKA_BROKERCONNECT: "kafka:29092"
    depends_on:
      - "kafka"
```

You can access Kafdrop, which is a web interface for managing Kafka, in http://localhost:9000.
![alt text](https://miro.medium.com/max/1400/1*DInNL3X58OmSamKsqtcwNg.png "Logo Title Text 1")

### Producer Microservice
Architecture:
![alt text](https://miro.medium.com/max/930/1*3zEEoVGnUTlZsC3nxSLuGQ.png "Logo Title Text 1")

Steps

* Create configuration beans
* Create a Food Order topic
* Create Food Order Controller, Service, and Producer
* Convert orders into messages in a string format to send to the broker

Environment variables and port to our API to run:
```
server:
  port: 8080

topic:
  name: t.food.order
```
**Config** — Responsible for creating the KafkaTemplate bean, which will be used to send the message, and creating the food order topic.
```
@Configuration
public class Config {

    private final KafkaProperties kafkaProperties;

    @Autowired
    public Config(KafkaProperties kafkaProperties) {
        this.kafkaProperties = kafkaProperties;
    }

    @Bean
    public ProducerFactory<String, String> producerFactory() {
        // get configs on application.properties/yml
        Map<String, Object> properties = kafkaProperties.buildProducerProperties();
        return new DefaultKafkaProducerFactory<>(properties);
    }

    @Bean
    public KafkaTemplate<String, String> kafkaTemplate() {
        return new KafkaTemplate<>(producerFactory());
    }

    @Bean
    public NewTopic topic() {
        return TopicBuilder
                .name("t.food.order")
                .partitions(1)
                .replicas(1)
                .build();
    }

}
```

Here’s the model class for FoodOrder:
```
@Data
@Value
public class FoodOrder {
    String item;
    Double amount;
}
```

**FoodOrderController** — Responsible for receiving a food order request, and passing it along to the service layer.
```
@Slf4j
@RestController
@RequestMapping("/order")
public class FoodOrderController {

    private final FoodOrderService foodOrderService;

    @Autowired
    public FoodOrderController(FoodOrderService foodOrderService) {
        this.foodOrderService = foodOrderService;
    }

    @PostMapping
    public String createFoodOrder(@RequestBody FoodOrder foodOrder) throws JsonProcessingException {
        log.info("create food order request received");
        return foodOrderService.createFoodOrder(foodOrder);
    }
}
```
**FoodOrderService** — Responsible for receiving the food order and passing it along to the producer.
```
@Slf4j
@Service
public class FoodOrderService {

    private final Producer producer;

    @Autowired
    public FoodOrderService(Producer producer) {
        this.producer = producer;
    }

    public String createFoodOrder(FoodOrder foodOrder) throws JsonProcessingException {
        return producer.sendMessage(foodOrder);
    }
}
```

**Producer** — Responsible for receiving the food order and publishing it as a message to Kafka.

In the **sendMessage()** method we convert the FoodOrder object into a string in JSON format, so it can be received as a string in the consumer microservice send the message, passing the topic in which to publish (referred as the environment variable **orderTopic**) and the order as a message.
```
@Slf4j
@Component
public class Producer {

    @Value("${topic.name}")
    private String orderTopic;

    private final ObjectMapper objectMapper;
    private final KafkaTemplate<String, String> kafkaTemplate;

    @Autowired
    public Producer(KafkaTemplate<String, String> kafkaTemplate, ObjectMapper objectMapper) {
        this.kafkaTemplate = kafkaTemplate;
        this.objectMapper = objectMapper;
    }

    public String sendMessage(FoodOrder foodOrder) throws JsonProcessingException {
        String orderAsMessage = objectMapper.writeValueAsString(foodOrder);
        kafkaTemplate.send(orderTopic, orderAsMessage);

        log.info("food order produced {}", orderAsMessage);

        return "message sent";
    }
}
```
When running the application, we should be able to see the topic created in Kafdrop. And when sending a food order, we should be able to see in the logs that the message was sent.
![alt text](https://miro.medium.com/max/1400/1*QEPdKbRKU_bLAw1ufdHaXg.png "Logo Title Text 1")

![alt text](https://miro.medium.com/max/1100/1*de-jms0X202691A9KB1ZYw.png "Logo Title Text 1")

If under the Topics section in Kafdrop we access the t.food.order topic created, we should be able to see the message.
![alt text](https://miro.medium.com/max/1164/1*lDolPXpvSoOmHoZd19Qjrg.png "Logo Title Text 1")

 ### Consumer Microservice
Architecture:
![alt text](https://miro.medium.com/max/826/1*UhpG6vIHrLGIuB1Gi9Q2OQ.png "Logo Title Text 1")

**Steps**
* Create a configuration for beans and group-id
* Create database access
* Create Food Order Consumer and Service
* Create a Food Access Repository

We will start configuring the port for our API to run, the topic to listen to, a group-id for our consumer, and the database configurations
```
server:
  port: 8081

topic:
  name: t.food.order

spring:
  kafka:
    consumer:
      group-id: "default"

  h2:
    console:
      enabled: true
      path: /h2-console
  datasource:
    url: jdbc:h2:mem:testdb
    username: sa
    password: password
```
**Config** — Responsible for configuring the ModelMapper bean which is a library used for mapping an object to another, when using the DTO pattern for example, that we will make use of here
```
@Configuration
public class Config {
    @Bean
    public ModelMapper modelMapper() {
        return new ModelMapper();
    }
}
```
The Model classes:
```
@Data
@Value
public class FoodOrderDto {
    String item;
    Double amount;
}

@Data
@Entity
@NoArgsConstructor
@AllArgsConstructor
public class FoodOrder {

    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String item;
    private Double amount;
}
```

**Consumer** — Responsible for listening to the food order topic and when any message is published to it, consume it. We will convert the listened messages to a FoodOrderDto object that doesn’t contain everything related to the entity that will be persisted, like the ID.
```
@Slf4j
@Component
public class Consumer {

    private static final String orderTopic = "${topic.name}";

    private final ObjectMapper objectMapper;
    private final FoodOrderService foodOrderService;

    @Autowired
    public Consumer(ObjectMapper objectMapper, FoodOrderService foodOrderService) {
        this.objectMapper = objectMapper;
        this.foodOrderService = foodOrderService;
    }

    @KafkaListener(topics = orderTopic)
    public void consumeMessage(String message) throws JsonProcessingException {
        log.info("message consumed {}", message);

        FoodOrderDto foodOrderDto = objectMapper.readValue(message, FoodOrderDto.class);
        foodOrderService.persistFoodOrder(foodOrderDto);
    }
}
```

**FoodOrderService** — Responsible for receiving the consumed order into a FoodOrder object to be and passing it along to the persistence layer to be persisted.
```
@Slf4j
@Service
public class FoodOrderService {

    private final FoodOrderRepository foodOrderRepository;
    private final ModelMapper modelMapper;

    @Autowired
    public FoodOrderService(FoodOrderRepository foodOrderRepository, ModelMapper modelMapper) {
        this.foodOrderRepository = foodOrderRepository;
        this.modelMapper = modelMapper;
    }

    public void persistFoodOrder(FoodOrderDto foodOrderDto) {
        FoodOrder foodOrder = modelMapper.map(foodOrderDto, FoodOrder.class);
        FoodOrder persistedFoodOrder = foodOrderRepository.save(foodOrder);

        log.info("food order persisted {}", persistedFoodOrder);
    }
}
```

The code for the **FoodOrderRepository** is:
```
@Repository
public interface FoodOrderRepository extends JpaRepository<FoodOrder, Long> {
}
```

Now only by running the Consumer Microservice, the already published messages will be consumed from the order topic
![alt text](https://miro.medium.com/max/1012/1*ZTAlMh-1fZIcHZ_5yjwlYw.png "Logo Title Text 1")

And an important detail to notice here is that if we go to Kafdrop and check the message that we just consumed, it will still be there. And that is something that wouldn’t happen with RabbitMQ, for example.
![alt text](https://miro.medium.com/max/1128/1*TE0aGuUjezMYdDrlaFASRA.png "Logo Title Text 1")

### Advanced features
We can send scheduled messages, by making use of Scheduling.

Enable it by adding the **@EnableScheduling** annotation in the configuration class in the Producer Microservice.
```
@EnableScheduling
@Configuration
public class Config {
    ...   
}
```

**Scheduler** is responsible for sending the messages at a certain rate, we will be sending them at a fixed rate of 1000 milliseconds.
```
@Slf4j
@Component
public class Scheduler {

    @Autowired
    private KafkaTemplate<String, String> kafkaTemplate;
    private Integer count = 0;

    @Scheduled(fixedRate = 1000)
    public void sendMessage() {
        count++;
        kafkaTemplate.send("t.scheduled", "message " + count);
        log.info("sent message count {}", count);
    }
}
```

The topic will be created automatically, but we could define the bean like we defined previously. The output would be:
![alt text](https://miro.medium.com/max/468/1*Ugw_bvMdDw3GpewKqvwQ3w.png "Logo Title Text 1")