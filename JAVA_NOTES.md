# Java Design Patterns

## Creational Design Patterns
Creational design patterns provide solution to instantiate a object in the best possible way for specific situations.


1. **Singleton Pattern**
Singleton pattern restricts the instantiation of a class and ensures that only one instance of the class exists in the Java virtual machine. It seems to be a very simple design pattern but when it comes to implementation, it comes with a lot of implementation concerns. The implementation of the Singleton pattern has always been a controversial topic among developers. Check out Singleton Design Pattern to learn about different ways to implement Singleton pattern and pros and cons of each of the method. This is one of the most discussed java design patterns.

* GoF (Gangs of Four Design) Creational Pattern
* Only one instance of class
* Must have global access point to create the instance

To implement a Singleton pattern, we have different approaches but all of them have the following common concepts.

* **Private constructor** to restrict instantiation of the class from other classes.
```

package com.journaldev.singleton;

public class EagerInitializedSingleton {
    
    private static final EagerInitializedSingleton instance = new EagerInitializedSingleton();
    
    //private constructor to avoid client applications to use constructor
    private EagerInitializedSingleton(){}

    public static EagerInitializedSingleton getInstance(){
        return instance;
    }
}
```
* **Private static variable** of the same class that is the only instance of the class.

* **Public static method** that returns the instance of the class, this is the global access point for outer world to get the instance of the singleton class.
```

package com.journaldev.singleton;

public class StaticBlockSingleton {

    private static StaticBlockSingleton instance;
    
    private StaticBlockSingleton(){}
    
    //static block initialization for exception handling
    static{
        try{
            instance = new StaticBlockSingleton();
        }catch(Exception e){
            throw new RuntimeException("Exception occured in creating singleton instance");
        }
    }
    
    public static StaticBlockSingleton getInstance(){
        return instance;
    }
}

```

1. **Factory Pattern**
The factory design pattern is used when we have a superclass with multiple sub-classes and based on input, we need to return one of the sub-class. This pattern takes out the responsibility of the instantiation of a class from the client program to the factory class. We can apply a Singleton pattern on the Factory class or make the factory method static. Check out Factory Design Pattern for example program and factory pattern benefits. This is one of the most widely used java design patterns.

### Factory Design Pattern Super Class
Super class in factory design pattern can be an interface, abstract class or a normal java class. For our factory design pattern example, we have abstract super class with overridden toString() method for testing purpose.
```
package com.journaldev.design.model;

public abstract class Computer {
	
	public abstract String getRAM();
	public abstract String getHDD();
	public abstract String getCPU();
	
	@Override
	public String toString(){
		return "RAM= "+this.getRAM()+", HDD="+this.getHDD()+", CPU="+this.getCPU();
	}
}
```

### Factory Design Pattern Sub Classes
Let’s say we have two sub-classes PC and Server with below implementation.
```
package com.journaldev.design.model;

public class PC extends Computer {

	private String ram;
	private String hdd;
	private String cpu;
	
	public PC(String ram, String hdd, String cpu){
		this.ram=ram;
		this.hdd=hdd;
		this.cpu=cpu;
	}
	@Override
	public String getRAM() {
		return this.ram;
	}

	@Override
	public String getHDD() {
		return this.hdd;
	}

	@Override
	public String getCPU() {
		return this.cpu;
	}

}

package com.journaldev.design.model;

public class Server extends Computer {

	private String ram;
	private String hdd;
	private String cpu;
	
	public Server(String ram, String hdd, String cpu){
		this.ram=ram;
		this.hdd=hdd;
		this.cpu=cpu;
	}
	@Override
	public String getRAM() {
		return this.ram;
	}

	@Override
	public String getHDD() {
		return this.hdd;
	}

	@Override
	public String getCPU() {
		return this.cpu;
	}

}
```

### Factory Class
Now that we have super classes and sub-classes ready, we can write our factory class. Here is the basic implementation.
```
package com.journaldev.design.factory;

import com.journaldev.design.model.Computer;
import com.journaldev.design.model.PC;
import com.journaldev.design.model.Server;

public class ComputerFactory {

	public static Computer getComputer(String type, String ram, String hdd, String cpu){
		if("PC".equalsIgnoreCase(type)) return new PC(ram, hdd, cpu);
		else if("Server".equalsIgnoreCase(type)) return new Server(ram, hdd, cpu);
		
		return null;
	}
}
```

3. Abstract Factory Pattern
Abstract Factory pattern is similar to Factory pattern and it’s a factory of factories. If you are familiar with the factory design pattern in java, you will notice that we have a single Factory class that returns the different sub-classes based on the input provided and the factory class uses if-else or switch statements to achieve this.

In Abstract Factory pattern, we get rid of if-else block and have a factory class for each sub-class and then an Abstract Factory class that will return the sub-class based on the input factory class. Check out Abstract Factory Pattern to know how to implement this pattern with example program.

## Miscellaneous Design Patterns
There are a lot of design patterns that doesn’t come under GoF design patterns. Let’s look at some of these popular design patterns.


1. **DAO Design Pattern**
DAO design pattern is used to decouple the data persistence logic to a separate layer. DAO is a very popular pattern when we design systems to work with databases. The idea is to keep the service layer separate from the Data Access layer. This way we implement the separation of Logic in our application.

Checkout DAO Pattern for complete details and example program.


2. **Dependency Injection Pattern**
Dependency Injection allows us to remove the hard-coded dependencies and make our application loosely coupled, extendable, and maintainable. We can implement dependency injection in java to move the dependency resolution from compile-time to runtime. Spring framework is built on the principle of dependency injection.

Read more about Dependency Injection Pattern to understand how to implement it in our Java application.


3. **MVC Pattern**
MVC Pattern is one of the oldest architectural patterns for creating web applications. MVC stands for Model-View-Controller.

We have following components on which our design depends:

* The model which is transferred from one layer to the other.
* The View which is responsible to show the data present in the application.
* The controller is responsible to accept a request from a user, modify a model and send it to the view which is shown to the user.

# File handling with NIO
## Read files with Java 8 using Files.lines()
JDK8 offers the lines() method inside the Files class. It returns a Stream of String elements.
Let’s look at an example of how to read data into bytes and decode it using UTF-8 charset.
The following code reads the file using the new Files.lines():
```
@Test
public void givenFilePath_whenUsingFilesLines_thenFileData() {
    String expectedData = "Hello, world!";
         
    Path path = Paths.get(getClass().getClassLoader()
      .getResource("fileTest.txt").toURI());
         
    Stream<String> lines = Files.lines(path);
    String data = lines.collect(Collectors.joining("\n"));
    lines.close();
         
    Assert.assertEquals(expectedData, data.trim());
}
```

## Create directory
We can use the NIO **Files.createDirectory** to create a directory or **Files.createDirectories** to create a directory including all nonexistent parent directories.
```
try {

    Path path = Paths.get("/home/mkyong/a/b/c/");

    //java.nio.file.Files;
    Files.createDirectories(path);

    System.out.println("Directory is created!");

  } catch (IOException e) {

    System.err.println("Failed to create directory!" + e.getMessage());

  }
```