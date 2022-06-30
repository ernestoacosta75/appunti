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
