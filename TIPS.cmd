# Maven commands

## Create a Java project
In a terminal (*uix or Mac) or command prompt (Windows), navigate to the folder you want to create the Java project. Type this command :
```
mvn archetype:generate 
	-DgroupId={project-packaging}
	-DartifactId={project-name}
	-DarchetypeArtifactId={maven-template} 
	-DinteractiveMode=false
```

# How to Prevent DEBUG Logging by Test Containers when Running Unit Tests in Java
1) Add a **logback-test.xml** file to your **src/test/resources** directory that looks like this:
```
<configuration>
    <appender name="STDOUT" class="ch.qos.logback.core.ConsoleAppender">
        <encoder>
            <pattern>%d{HH:mm:ss.SSS} [%thread] %-5level %logger - %msg%n</pattern>
        </encoder>
    </appender>

    <root level="info">
        <appender-ref ref="STDOUT"/>
    </root>

    <logger name="org.testcontainers" level="INFO"/>
    <logger name="com.github.dockerjava" level="WARN"/>
</configuration>
```
