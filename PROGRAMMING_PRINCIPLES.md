# Test-Driven Development (With Java)

## What Is Unit Testing?
A unit test consists of a program that exercises a small piece of the codebase in complete isolation. Most unit test cases contain assertions, which you can think of as verifications that a given piece of code works as you expect it to work under a given scenario.

By “complete isolation” we mean that unit tests don’t interact with elements that are external to the code, such as databases, the filesystem, or the network. Tests that adhere to this rule acquire some properties. For starters, they’re fast, since they don’t require reading or writing to the disk. But more importantly, they’re deterministic: If a given test is failing, you can run it any number of times and it will continue failing unless you change either the test or the production code being tested. The opposite is also true: A passing test will continue passing until a change to the code makes it otherwise.

## What Is the Use of Unit Testing?
An old programming teacher of mine used to say, “The computer does what you tell it to do; not what you think you’ve told it to do.” In other words, the mismatch between what our code really does and what we think it does is what causes bugs. Unit tests are mechanisms that developers can use to eliminate—or at least reduce—that mismatch.

As the number of unit tests in a codebase grows, you reach a point when they become a reliable safety net for developers, who can then change the code without the fear of breaking it. They know that if they introduce a defect, the tests will catch it.

## Are “Unit Testing” and “TDD” Synonymous?
Unit testing and TDD are related but different concepts. Unit testing refers to the type of software testing already discussed.

TDD, which stands for test-driven development, is a software development methodology. As the name suggests, TDD consists of using tests to drive the development of the application, leading to simple, iterative implementation with high test coverage from the beginning. When applying TDD, the development will follow a simple workflow:

* **You start by writing a unit test related to the feature you want to implement**. The test will 
  obviously fail, since the production code doesn’t exist yet. In fact, in compiled languages such as Java, you won’t even get to run the test, since the code won’t compile.
* **The second step is to make the test pass by writing the least possible amount of code**. You don’t 
  necessarily want to implement the correct solution, but just make the test pass. “Cheating” is OK in this step. For instance, you can just hardcode the expected value for a function’s return.
* **The next step is optional**. It consists of refactoring in order to get rid of duplication or other 
  problems introduced in the last step. Here, your responsibility is to change the code and keep the test passing.

# Behavior-Driven Development (With Java)
BDD (Behavioral Driven Development) is a software development approach that was developed from Test Driven Development (TDD).
BDD includes test case development on the basis of the behavior of software functionalities. All test cases are written in the form of simple English statements inside a feature file, which is human-generated. Acceptance test case statements are entirely focused on user actions.

BDD is written in simple English language statements, not in a typical programming language. BDD improves communication between technical and non-technical teams and stakeholders.
Let's understand through an example, how we can develop test cases on the basis of the behavior of a particular function.

**Example**:
In order to ensure the working of Login Functionality, we are developing acceptance test cases on the basis of BDD.

**Feature:** Login Function
To enter in the System  
User must be able to 
Access software when login is successful 
**Scenario**: Login
**Given** User has its Email  
**And** Password  
**When** User enters the correct Email and Password  
**Then** It should be logged in
**Scenario:** Unsuccessful Login
**When** User enters either wrong Email or Password  
**Then** It should be reverse back on the login page with an error message

## Need to Choose BDD
TDD works satisfactorily unless the business owners are familiar with the use of the unit testing. Also, their technical skills should strong enough, which is not always possible.
In these circumstances, BDD is advantageous because test cases are written in a common English language, which is easily understandable by all stakeholders.
The familiar, easily understandable language is the most significant advantage of using BDD because it plays a vital role in cooperation between technical and non-technical teams to perform a task with better efficiency.

## Characteristics of BDD

**Strong collaboration**
BDD provides a strong collaboration between involved parties. It is just because of easy test cases which are written in the English language. In cucumber testing, stockholders play a vital role in constructive discussions as only they know the expectations from the software.

**High Visibility**
Everyone gets strong visibility in the progress of the project due to the easy English language.
The software design follows the business value
BDD gives great importance to business value and needs. By setting priorities with the client, depending on the value provided by them, developers are able to give a better result because they have a strong understanding of how the customer thinks.

**The Ubiquitous Language**
As mentioned earlier, test cases are written in the ubiquitous language, which is understandable by all the members of the team, whether they are from a technical field or not. This helps to reduce misconceptions and misunderstanding between the members related to concepts. Ubiquitous language makes easy joining of new members into the working.

**Software development meets the user need.**
BDD focuses on the business's needs so that users can be satisfied, and of course, satisfied users imply a growing business. With BDD, tester focuses on the behavior which has more impact than the implementation.

**More confidence from the developers' side**
The teams using BDD are generally more confident because they do not break the code, and when it comes to their work, a better forecast is done.

**Lower Costs**
By improving the quality of the code, BDD basically reduces the cost of maintenance and minimizes the risks of the project.

## Feature File in Cucumber Testing
The feature file is the essential segment of cucumber tool, which is used to write acceptance steps for automation testing. Acceptance steps generally follow the application specification.
A feature file is usually a common file which stores feature, scenarios, and feature description to be tested.
The feature file is an entry point, to write the cucumber tests and used as a live document at the time of testing.
The extension of the feature file is **.feature**. Each functionality of the software must have a separate feature file.

Example:
In order to ensure the working of Login Functionality, we are implementing the cucumber test by creating a feature file. It will verify whether the Login Functionality is working properly or not.

**Feature:** Login 
**Scenario:** Login Functionality
**Given** user navigates to the website javatpoint.com
**And** there user logs in through Login Window by using Username as "USER" and Password as "PASSWORD"
**Then** login must be successful.