# Event sourcing (https://github.com/dashsaurabh/event-sourcing-axon-spring-boot)
Every change to the state of the application should be captured. In other words, every action performed on an application entity should be persisted. Then, we can query those events. We can also use the list of events to reconstruct the current state of the object.

# Deciding the Events
Event Sourcing is driven by events.
It is a decision you need to take in conjunction with your domain experts. Basically, a good event structure will go a long way in helping you use Event Sourcing effectively.
One common process through which events are identified is **Event Storming**. 
The keyword here is **domain event**.
These domain events can be usually mapped to aggregates. In other words, aggregates can be thought of as entities. Domain events basically change the state of the aggregate in some way. These events can be then be modeled as real events in your application using Event Sourcing pattern.

# Why Event Sourcing?
Event Sourcing is one of the best ways to atomically update state and publish an event. As we saw, the traditional way is to persist the current state of the aggregate. However, in Event Sourcing the aggregate is stored as a sequence of events. Basically, for every state change a new event is created and added to the event store. Such an operation is inherently atomic.
Using Event Sourcing, you get extremely accurate audit logging for free. In other words, your event store also doubles up as an audit log. Basically, this reduces the risk of audit logging being an afterthought.
Another major advantage is the ability to run temporal queries. Event Store maintains a complete history of the aggregate. This makes it extremely easy to reconstruct the historical state of the object. In other words, the event store acts like a time machine of sorts. In case of any production issues, you can reconstruct the state of the object at the time of issue to investigate.

# Implementing Event Sourcing
We will be using Spring Boot for our normal application logic. Then, we will use Axon Framework for managing the heavy-lifting around Event Sourcing. Also, any event sourcing application needs to have an event store. Basically, event store is a normal database where events are stored. The beauty of Axon is that it works seamlessly with Spring Data JPA. As a result, we can practically use any database that works with JPA and Hibernate.

# More about Axon Framework
It is a lightweight framework that helps in building microservices. In other words, it helps solve some of the technical challenges around building microservices.
It integrates very well with Spring Boot and the general Spring world. This makes it quite easy to quickly build an application using Event Sourcing without worrying about the bells and whistles of managing an event store.

# The POM Dependencies
* **Spring Boot Starter Web** – This brings in support for web application capabilities and Spring Dispatcher Servlet. It also brings in Tomcat dependencies to run your application.
* **Spring Boot Starter Data JPA** – This brings in support for JPA and Hibernate. Basically, we need these two dependencies to connect to a database.
* **H2 Database** – This is for bringing in H2 in-memory database support.
* **Spring Boot Starter Actuator** – This enables Spring Boot actuator endpoints. Basically, these endpoints allow us to ask questions to our application. Also, you can get other run-time statistics.
* **Axon Spring Boot Starter** – This is a very important dependency for our example. It basically brings in support for Axon Framework along with all the annotations.
* **Springfox Swagger2 and Springfox Swagger UI** – We will be using Swagger for documenting our API end-points. Also, Swagger will provide a neat user interface for to test our APIs. These dependencies will help us enable Swagger for our Spring Boot application.

# Configuring the application
With Axon Spring Boot Starter, you don’t need a ton of configuration. Basically, the starter packages does most of the heavy-lifting in terms of creating the necessary beans.
However, the only bare minimum configuration required would be setting up the H2 database. In other words, we need to enable the console view. In order to do so, add the below statements in the application.properties file.
```
#H2 settings
spring.h2.console.enabled=true
spring.h2.console.path=/h2-console
```

# Creating the Event Sourced Entity
We will model our Accounting example in this sample app. Therefore, we will create an Account entity. Basically, this entity will act as our use-case to demonstrate Event Sourcing.
```
@Aggregate
public class AccountAggregate {

    @AggregateIdentifier
    private String id;

    private double accountBalance;

    private String currency;

    private String status;
}
```
Important things to note here are the two annotations.

* **@Aggregate** annotation tells Axon that this entity will be managed by Axon. Basically, this is similar to @Entity annotation available with JPA. However, we will be using the Axon recommended annotation.
* **@AggregateIdentifier** annotation is used for the identifying a particular instance of the Aggregate. In other words, this is similar to JPA’s @Id annotation.

# Modeling the Commands and Events
Axon works on the concept of **commands** and **events**. To elaborate, Commands are user-initiated actions that can change the state of your aggregate. However, Events are the actual changing of that state.
Now, considering our Account aggregate, there could be many commands and events possible. However, we will try and model some important ones.
The primary commands would be **Create Account Command**, **Credit Money Command** and **Debit Money Command**. Based on them, the corresponding events that can occur are **Account Created Event**, **Money Credited Event** and **Money Debited Event**. However, there could be a couple of more events. For instance, one of them is the **Account Activated Event**. Also, the **Account Held Event**.

First off, we will create a Base Command and a Base Event.
```
public class BaseCommand<T> {

    @TargetAggregateIdentifier
    public final T id;

    public BaseCommand(T id) {
        this.id = id;
    }
}

public class BaseEvent<T> {

    public final T id;

    public BaseEvent(T id) {
        this.id = id;
    }
}
```

The most important thing to note here is the **@TargetAggregateIdentifier** annotation. Basically, this is an Axon specific requirement to identify the aggregate instance. In other words, this annotation is required for Axon to determine the instance of the Aggregate that should handle the command. The annotation can be placed on either the field or the getter method. In this example, we chose to put it on the field.

## Create Account Command
```
public class CreateAccountCommand extends BaseCommand<String> {

    public final double accountBalance;

    public final String currency;

    public CreateAccountCommand(String id, double accountBalance, String currency) {
        super(id);
        this.accountBalance = accountBalance;
        this.currency = currency;
    }
}
```

## Credit Money Command
```
public class CreditMoneyCommand extends BaseCommand<String> {

    public final double creditAmount;

    public final String currency;

    public CreditMoneyCommand(String id, double creditAmount, String currency) {
        super(id);
        this.creditAmount = creditAmount;
        this.currency = currency;
    }
}
```

## Debit Money Command
```
public class DebitMoneyCommand extends BaseCommand<String> {

    public final double debitAmount;

    public final String currency;

    public DebitMoneyCommand(String id, double debitAmount, String currency) {
        super(id);
        this.debitAmount = debitAmount;
        this.currency = currency;
    }
}
```
Note that all the above commands extend the Base Command. Moreover, they supply the Generic type for the id field as String.

Next step is to implements the events.

## Account Created Event
```
public class AccountCreatedEvent extends BaseEvent<String> {

    public final double accountBalance;

    public final String currency;

    public AccountCreatedEvent(String id, double accountBalance, String currency) {
        super(id);
        this.accountBalance = accountBalance;
        this.currency = currency;
    }
}
```

## Money Credited Event
```
public class MoneyCreditedEvent extends BaseEvent<String> {

    public final double creditAmount;

    public final String currency;

    public MoneyCreditedEvent(String id, double creditAmount, String currency) {
        super(id);
        this.creditAmount = creditAmount;
        this.currency = currency;
    }
}
```

## Money Debited Event
```
public class MoneyDebitedEvent extends BaseEvent<String> {

    public final double debitAmount;

    public final String currency;

    public MoneyDebitedEvent(String id, double debitAmount, String currency) {
        super(id);
        this.debitAmount = debitAmount;
        this.currency = currency;
    }
}
```

## Account Activated Event
```
public class AccountActivatedEvent extends BaseEvent<String> {

    public final Status status;

    public AccountActivatedEvent(String id, Status status) {
        super(id);
        this.status = status;
    }
}
```

## Account Held Event
```
public class AccountHeldEvent extends BaseEvent<String> {

    public final Status status;

    public AccountHeldEvent(String id, Status status) {
        super(id);
        this.status = status;
    }
}
```

# Command Handlers and Event Handlers
Basically, handlers are methods on the Aggregate that should be invoked for a particular command or an event.
Due to their relation to the Aggregate, it is recommended to define the handlers in the Aggregate class itself. Also, the command handlers often need to access the state of the Aggregate.
```
@Aggregate
public class AccountAggregate {

    @AggregateIdentifier
    private String id;

    private double accountBalance;

    private String currency;

    private String status;

    public AccountAggregate() {
    }

    @CommandHandler
    public AccountAggregate(CreateAccountCommand createAccountCommand){
        AggregateLifecycle.apply(new AccountCreatedEvent(createAccountCommand.id, createAccountCommand.accountBalance, createAccountCommand.currency));
    }

    @EventSourcingHandler
    protected void on(AccountCreatedEvent accountCreatedEvent){
        this.id = accountCreatedEvent.id;
        this.accountBalance = accountCreatedEvent.accountBalance;
        this.currency = accountCreatedEvent.currency;
        this.status = String.valueOf(Status.CREATED);

        AggregateLifecycle.apply(new AccountActivatedEvent(this.id, Status.ACTIVATED));
    }

    @EventSourcingHandler
    protected void on(AccountActivatedEvent accountActivatedEvent){
        this.status = String.valueOf(accountActivatedEvent.status);
    }

    @CommandHandler
    protected void on(CreditMoneyCommand creditMoneyCommand){
        AggregateLifecycle.apply(new MoneyCreditedEvent(creditMoneyCommand.id, creditMoneyCommand.creditAmount, creditMoneyCommand.currency));
    }

    @EventSourcingHandler
    protected void on(MoneyCreditedEvent moneyCreditedEvent){

        if (this.accountBalance < 0 & (this.accountBalance + moneyCreditedEvent.creditAmount) >= 0){
            AggregateLifecycle.apply(new AccountActivatedEvent(this.id, Status.ACTIVATED));
        }

        this.accountBalance += moneyCreditedEvent.creditAmount;
    }

    @CommandHandler
    protected void on(DebitMoneyCommand debitMoneyCommand){
        AggregateLifecycle.apply(new MoneyDebitedEvent(debitMoneyCommand.id, debitMoneyCommand.debitAmount, debitMoneyCommand.currency));
    }

    @EventSourcingHandler
    protected void on(MoneyDebitedEvent moneyDebitedEvent){

        if (this.accountBalance >= 0 & (this.accountBalance - moneyDebitedEvent.debitAmount) < 0){
            AggregateLifecycle.apply(new AccountHeldEvent(this.id, Status.HOLD));
        }

        this.accountBalance -= moneyDebitedEvent.debitAmount;

    }

    @EventSourcingHandler
    protected void on(AccountHeldEvent accountHeldEvent){
        this.status = String.valueOf(accountHeldEvent.status);
    }
}
```
We are handling the three commands in their own handler methods. These handler methods should be annotated with **@CommandHandler** annotation. We have three handler methods because there are three commands we want to handle.
The handler methods use **AggregateLifecyle.apply()** method to register events.
These events, in turn, are handled by methods annotated with **@EventSourcingHandler** annotation. Also, it is imperative that all state changes in an event sourced aggregate should be performed in these methods.
Another important point to keep in mind is that the Aggregate Identifier must be set in the first method annotated with **@EventSourcingHandler**. In other words, this will be the creation Event.
Other events are handled in other methods. All of such methods are annotated with **@EventSourcingHandler**.
Another important thing to point out here is the **no-args default constructor**. You need to declare such a constructor because Axon framework needs it. Basically, using this constructor, Axon creates an empty instance of the aggregate. Then, it applies the events. **If this constructor is not present, it will result in an exception**.

To test the application, we will expose certain REST interfaces from our application. These interfaces will allow us to create an account and also perform other operations. Basically, you can think of these REST interfaces as APIs.

# The Service Layer
We will have two service interfaces. First is **AccountCommandService** to handle the Commands. Second is **AccountQueryService**. At this point, the query service will just help in fetching a list of events.
Basically we try to follow SOLID principles.
```
public interface AccountCommandService {

    public CompletableFuture<String> createAccount(AccountCreateDTO accountCreateDTO);
    public CompletableFuture<String> creditMoneyToAccount(String accountNumber, MoneyCreditDTO moneyCreditDTO);
    public CompletableFuture<String> debitMoneyFromAccount(String accountNumber, MoneyDebitDTO moneyDebitDTO);
}

public interface AccountQueryService {
    public List<Object> listEventsForAccount(String accountNumber);
}
```

Now, we implement these interfaces. 
```
@Service
public class AccountCommandServiceImpl implements AccountCommandService {

    private final CommandGateway commandGateway;

    public AccountCommandServiceImpl(CommandGateway commandGateway) {
        this.commandGateway = commandGateway;
    }

    @Override
    public CompletableFuture<String> createAccount(AccountCreateDTO accountCreateDTO) {
        return commandGateway.send(new CreateAccountCommand(UUID.randomUUID().toString(), accountCreateDTO.getStartingBalance(), accountCreateDTO.getCurrency()));
    }

    @Override
    public CompletableFuture<String> creditMoneyToAccount(String accountNumber, MoneyCreditDTO moneyCreditDTO) {
        return commandGateway.send(new CreditMoneyCommand(accountNumber, moneyCreditDTO.getCreditAmount(), moneyCreditDTO.getCurrency()));
    }

    @Override
    public CompletableFuture<String> debitMoneyFromAccount(String accountNumber, MoneyDebitDTO moneyDebitDTO) {
        return commandGateway.send(new DebitMoneyCommand(accountNumber, moneyDebitDTO.getDebitAmount(), moneyDebitDTO.getCurrency()));
    }
}
```
The main thing to note here is the **CommandGateway**. Basically, this is a convenience interface provided by Axon. In other words, **you can use this interface to dispatch commands**. When you wire up the **CommandGateway** as below, Axon will actually provide the **DefaultCommandGateway** implementation.
Then, using the **send** method on the CommandGateway we can send a command and wait for the response.

```
@Service
public class AccountQueryServiceImpl implements AccountQueryService {

    private final EventStore eventStore;

    public AccountQueryServiceImpl(EventStore eventStore) {
        this.eventStore = eventStore;
    }

    @Override
    public List<Object> listEventsForAccount(String accountNumber) {
        return eventStore.readEvents(accountNumber).asStream().map( s -> s.getPayload()).collect(Collectors.toList());
    }
}
```
Notice that we wire up something called **EventStore**. This is the Axon Event Store. Basically, EventStore provides a method to read events for a particular AggregateId. In other words, we call the **readEvents()** method with the AggregateId (or Account#) as input. Then, we collect the output stream and transform it to a list. Nothing too complex.

# The Data Transfer Objects
Even though our resource might be the entire account but different commands will require different payload. Therefore, DTO objects are required.
```
// AccountCreateDTO is used for creating a new account.
public class AccountCreateDTO {

    private double startingBalance;

    private String currency;

    public double getStartingBalance() {
        return startingBalance;
    }

    public void setStartingBalance(double startingBalance) {
        this.startingBalance = startingBalance;
    }

    public String getCurrency() {
        return currency;
    }

    public void setCurrency(String currency) {
        this.currency = currency;
    }
}
```

```
// MoneyCreditDTO for crediting money to an account.
public class MoneyCreditDTO {

    private double creditAmount;

    private String currency;

    public double getCreditAmount() {
        return creditAmount;
    }

    public void setCreditAmount(double creditAmount) {
        this.creditAmount = creditAmount;
    }

    public String getCurrency() {
        return currency;
    }

    public void setCurrency(String currency) {
        this.currency = currency;
    }
}
```

```
// MoneyDebitDTO for debiting money from an account.
public class MoneyDebitDTO {

    private double debitAmount;

    private String currency;

    public double getDebitAmount() {
        return debitAmount;
    }

    public void setDebitAmount(double debitAmount) {
        this.debitAmount = debitAmount;
    }

    public String getCurrency() {
        return currency;
    }

    public void setCurrency(String currency) {
        this.currency = currency;
    }
}
```
To enable Jackson to be able to serialize and deserialize the objects we have declared standard getter and setter methods.

# Defining the REST Controllers
In order to allow a consumer to interact with our application, we need to expose some interfaces. Spring Web MVC provides excellent support for the same. We define two controllers. The first one is to handle the commands.
```
@RestController
@RequestMapping(value = "/bank-accounts")
@Api(value = "Account Commands", description = "Account Commands Related Endpoints", tags = "Account Commands")
public class AccountCommandController {

    private final AccountCommandService accountCommandService;

    public AccountCommandController(AccountCommandService accountCommandService) {
        this.accountCommandService = accountCommandService;
    }

    @PostMapping
    public CompletableFuture<String> createAccount(@RequestBody AccountCreateDTO accountCreateDTO){
        return accountCommandService.createAccount(accountCreateDTO);
    }

    @PutMapping(value = "/credits/{accountNumber}")
    public CompletableFuture<String> creditMoneyToAccount(@PathVariable(value = "accountNumber") String accountNumber,
                                                          @RequestBody MoneyCreditDTO moneyCreditDTO){
        return accountCommandService.creditMoneyToAccount(accountNumber, moneyCreditDTO);
    }

    @PutMapping(value = "/debits/{accountNumber}")
    public CompletableFuture<String> debitMoneyFromAccount(@PathVariable(value = "accountNumber") String accountNumber,
                                                           @RequestBody MoneyDebitDTO moneyDebitDTO){
        return accountCommandService.debitMoneyFromAccount(accountNumber, moneyDebitDTO);
    }
}
```
We create another controller to expose one end-point. Basically, this endpoint will help us list the events on an aggregate.
```
@RestController
@RequestMapping(value = "/bank-accounts")
@Api(value = "Account Queries", description = "Account Query Events Endpoint", tags = "Account Queries")
public class AccountQueryController {

    private final AccountQueryService accountQueryService;

    public AccountQueryController(AccountQueryService accountQueryService) {
        this.accountQueryService = accountQueryService;
    }

    @GetMapping("/{accountNumber}/events")
    public List<Object> listEventsForAccount(@PathVariable(value = "accountNumber") String accountNumber){
        return accountQueryService.listEventsForAccount(accountNumber);
    }
}
```
These controllers mainly use the Services we created earlier. The payload received is passed to the service that in turn uses the **CommandGateway** to trigger the commands. Then,the response is mapped back to the output of the end-point.

As a last bit of help, we configure Swagger for our application. Basically, Swagger provides a nice user interface that can be used to test our REST end-points.
```
@Configuration
@EnableSwagger2
public class SwaggerConfig {

    @Bean
    public Docket apiDocket(){
        return new Docket(DocumentationType.SWAGGER_2)
                .select()
                .apis(RequestHandlerSelectors.basePackage("com.progressivecoder.es"))
                .paths(PathSelectors.any())
                .build()
                .apiInfo(getApiInfo());
    }

    private ApiInfo getApiInfo(){
        return new ApiInfo(
                "Event Sourcing using Axon and Spring Boot",
                "App to demonstrate Event Sourcing using Axon and Spring Boot",
                "1.0.0",
                "Terms of Service",
                new Contact("Saurabh Dashora", "progressivecoder.com", "coder.progressive@gmail.com"),
                "",
                "",
                Collections.emptyList());
    }

}
```

# Testing the Application
How does the data look in the event store? We can easily check it out in the h2-console. In order to check the h2-console, we have to visit http://localhost:8080/h2-console.
We login to testdb. Then, we can execute the below query in the console.
```
SELECT PAYLOAD_TYPE , AGGREGATE_IDENTIFIER, SEQUENCE_NUMBER , PAYLOAD   FROM DOMAIN_EVENT_ENTRY
```