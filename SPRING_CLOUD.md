# STEPS TO FOLLOW FOR CLOUD DEVELOPMENT
1. Configure graceful shutdown and grace period for the application.
2. Configure the Cloud Native Buildpacks integration and package the application as a container.
3. Update your Docker Compose file to run the microservice as a container.
4. Bootstrap a deployment pipeline for Config Service by implementing the workflow for the commit stage using GitHub Actions.
5. Write the Deployment and Service manifests for deploying the microservice to a Kubernetes cluster.
6. Update the commit stage of the deployment pipeline for the microservice to validate the Kubernetes manifests.
7. Configure Tilt to automate the Config Service deployment to your local Kubernetes cluster bootstrapped with 
   minikube.
   Tilt (tilt.dev) aims at providing a good developer experience when working on Kubernetes. It’s an open-source tool that offers features to build, deploy, and manage containerized workloads in your local environment. We’ll use some of its basic features to automate a development workflow for a specific application, but Tilt can also help you orchestrate the deployment of multiple applications and services in a centralized way.
   The goal is to design a workflow that will automate the following steps for you:
   * packaging a Spring Boot application as a container image using Cloud Native Buildpacks;
   * uploading the image to a Kubernetes cluster (in our case, the one created with minikube);
   * applying all the Kubernetes objects declared in the YAML manifests;
   * enabling the port-forward functionality to access applications from your local computer;
   * giving you easy access to the logs from the applications running on the cluster.

    Before configuring Tilt, make sure you have a database instance up and running in your local Kubernetes
    cluster.
    Open a Terminal window, navigate to the kubernetes/platform/development folder in your polar-deployment repository, and run the following command to deploy PostgreSQL.
    ```
    kubectl apply -f services
    ```
    Let’s now see how to configure Tilt to establish that automated development workflow.
    Tilt can be configured via a Tiltfile, an extensible configuration file written in Starlark (a simplified Python dialect). Go to your Catalog Service project (catalog-service) and create a file named Tiltfile (no extension) in the root folder. The file will contain three main configurations:
    * how to build a container image (Cloud Native Buildpacks);
    * how to deploy the application (Kubernetes YAML manifests);
    * how to access the application (port forwarding).
    ### Tilt configuration for Catalog Service (Tiltfile)
    ```
      custom_build(
      ref = 'catalog-service',
      command = './gradlew bootBuildImage --imageName $EXPECTED_REF',
      deps = ['build.gradle', 'src']
      )
      k8s_yaml(['k8s/deployment.yml', 'k8s/service.yml'])
      k8s_resource('catalog-service', port_forwards=['9001'])
    ```

    Open a Terminal window, navigate to the root folder of your Catalog Service project, and run the
    following command to start Tilt.
    ```
      tilt up
    ```

# Deployment pipeline: Build and test
Continuous delivery is a holistic approach for quickly, reliably, and safely delivering software. The primary pattern for adopting such an approach is the deployment pipeline, which goes from code commit to releasable software. It should be automated as much as possible and represent the only path to production.
We can identify a few key stages in a deployment pipeline:
* **Commit stage**. After a developer commits new code to the mainline, this stage goes through build, unit tests, integration tests, static code analysis, and packaging. At the endof this stage, an executable application artifact is published to an artifact repository. That is a release candidate. For example, it can be a JAR artifact published to a Maven repository or a container image published to a container registry. This stage supports the continuous ntegration practice. It’s supposed to be fast, possibly under five minutes, to provide developers with fast feedback about their changes and allow them to move on to the next task.
* **Acceptance stage**. The publication of a new release candidate to the artifact repository triggers this stage, which consists of deploying the application to production-like environments and running additional tests to increase the confidence about its releasability. The tests running in the acceptance stage are usually slow, but we should
strive to keep the whole deployment pipeline execution under one hour. Examples of tests included in this stage are functional acceptance tests and non-functional acceptance tests, such as performance tests, security tests, and compliance tests. If necessary, this stage can also include manual tasks like exploratory and usability tests. At the end of this stage, the release candidate is ready to be deployed to production at any time. If we are still not confident about it, this stage is missing some tests.
* **Production stage**. After a release candidate has gone through the commit and acceptance stages, we are confident enough to deploy it to production. This stage is triggered manually or automatically, depending on whether it’s been decided to adopt a continuous deployment practice. The new release candidate is deployed to a production environment
using the same deployment scripts employed (and tested) in the acceptance stage. Optionally, some final automated tests can be run to verify the deployment was successful.

The vulnerability scanner we’ll use in the Polar Bookshop project is grype (github.com/anchore/grype), a powerful open-source tool increasingly used in the cloud native world. For example, it’s part of the security supply chain solution provided by the VMware Tanzu Application Platform.

Open a Terminal window and navigate to the root folder of your micro service project. Then, use grype to scan your Java codebase for vulnerabilities. The tool will download a list of known vulnerabilities (a vulnerability database)
and scan your project against them. The scanning happens locally on your machine, which means none of your files or artifacts is sent to an external service. That makes it a good fit for more regulated environments or air-gapped scenarios.
```
grype .
```

## Implementing the commit stage with GitHub Actions

# Testing a RESTful application with Spring
We write **unit tests** to verify the behavior of single application components in isolation, while **integration tests** to assert the overall functioning of different parts of an application interacting with each other.
In Spring, unit tests aren’t required to load the Spring application context and don’t rely on any Spring library. On the other hand, integration tests need a Spring application context to run.

## Integration tests with @SpringBootTest
A Spring Boot integration test can be initialized with a mock web environment or a running server.
Recent versions of Spring Framework and Spring Boot have extended the features for testing web applications. You can now use the **WebTestClient** class to test REST APIs both on mock environments and running servers.


## Testing REST controllers with @WebMvcTest
@WebMvcTest loads a Spring application context in a mock web environment (no running server), configures the Spring MVC infrastructure, and includes only the beans used by the MVC layer, like @RestController and @RestControllerAdvice. It’s a good idea to limit the context to the beans used by the specific controller under test. We can do so by providing the controller class as an argument to the @WebMvcTest annotation.

## Testing the JSON serialization with @JsonTest
Using the @JsonTest annotation, you can test JSON serialization and deserialization against an application context, including only configuration and beans needed for the purpose. The JacksonTester utility class lets you perform parsing operations using the Jackson library.

## Testing data persistence with Spring and Testcontainers


# Local Kubernetes development with Skaffold and Octant
These tools are used to set up a local Kubernetes development workflow to automate steps like building images and applying manifests to a Kubernetes cluster. It’s part of what is defined as the inner loop of working with a Kubernetes platform. Using Skaffold, you can focus on the business logic of your applications rather than on all those infrastructural concerns, and Octant is used to visualize and manage the Kubernetes objects through a convenient GUI.

# Defining a development workflow on Kubernetes with Skaffold
Skaffold is a tool developed by Google that "handles the workflow for building, pushing and deploying your application, allowing you to focus on what matters most: writing code". You can find instructions on how to install it on the official website: skaffold.dev. The goal is to design a workflow that will automate the following steps for you:

* packaging a Spring Boot application as a container image using Cloud Native Buildpacks;
* uploading the image to a Kubernetes cluster created with kind;
* creating all the Kubernetes objects described in the YAML manifests;
* enabling the port-forward functionality to access applications from your local computer;
* collecting the logs from the application and showing them in your console.

# Configuring Skaffold for building and deploying
You can initialize Skaffold in a new project using the skaffold init command and choosing a strategy for building the application. Navigate to the project root folder, and run the following command:
```
$ skaffold init --XXenableBuildpacksInit
```

The resulting configuration will be saved in a skaffold.yaml file created in your project root folder. If it doesn’t show up in your IDE, try refreshing the project. So far, we’ve been using the .yml extension for YAML files. To be consistent, go ahead and rename the Skaffold configuration file to skaffold.yml. The build part describes how you want to package the application. The deploy part specifies what you want to deploy.

# Deploying applications to K8 with Skaffold
The first option for running Skaffold is the development mode, which builds and deploys the objects you configured in skaffold.yml, and then starts watching the project source code. When something changes, it rolls out the updated objects in your local Kubernetes cluster automatically. In the project root folder:
```
$ skaffold dev --port-forward
```

The --port-forward flag will set up automatic port forwarding to your local machine. Information on which port is forwarded is printed out at the end of the task. Unless it’s not available, Skaffold will use the port you defined for the Service object. When you’re done working with the application, you can terminate the Skaffold process (Ctrl+C), and all the Kubernetes objects will get deleted automatically. Another option for running Skaffold is using the command. skaffold run. It works like the development mode, but it doesn’t provide live-reload nor clean up when it terminates. It’s typically used in a CI/CD pipeline.

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

Kafka uses a **binary protocol over TCP**. The protocol defines all APIs as request response message pairs. All messages are size delimited and are made up of the following primitive types.
The server guarantees that on a single TCP connection, requests will be processed in the order they are sent and responses will return in that order as well.
The benefits of this are:
* **Greater parallelism**. A Kafka client will typically open up TCP connections to multiple brokers in 
  the cluster and send or fetch data in parallel across multiple partitions of the same topic.
* **Better network utilization** as HTTP headers can add a lot of size to otherwise small messages while 
  Kafka’s wire protocol is a compact binary protocol.  
* **Kafka clients handle load balancing, failover, and cluster expansion or contraction automatically** 
  while REST clients typically require a third party load balancer to achieve the same functionality.
* **Kafka client can send their own authentication credentials for access control and bandwidth throttling (quotas)** while all REST clients look to the kafka cluster as one Kafka client and therefore have common ACL privileges.
* **Kafka client libraries buffer and batch messages together into smaller numbers** of Kafka produce or 
  fetch requests while HTTP can only batch data if the programmer thought to publish them as a single batch.
* **The native Kafka protocol supports more than just what the producer/consumer api exposes**. There is 
  also an Admin API for creating topics, and modifying topic configurations. These functions are not (yet) exposed through the most popular REST Proxy implementations.

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