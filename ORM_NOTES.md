# HIBERNATE

## Entities relationships best practices
The hibernate association classified into One-to-One, One-to-Many/Many-to-One and Many-to-Many.

- The direction of a relationship can be either bidirectional or unidirectional.
- A bidirectional relationship has both an owning side and an inverse side.
- A unidirectional relationship has only an owning side. The owning side of a relationship determines how the Persistence run time makes updates to the relationship in the database.


**Unidirectional Relationships**:
* Unidirectional is a relation where one side does not know about the relation.
* In a unidirectional relationship, only one entity has a relationship field or property that refers to the other. 
  For example, Line Item would have a relationship field that identifies Product, but Product would not have a relationship field or 
  property for Line Item. In other words, Line Item knows about Product, but Product doesn’t know which Line Item instances refer to it.

**Bidirectional Relationships**:
* Bidirectional relationship provides navigational access in both directions, so that you can access the other side without explicit queries.
* In a bidirectional relationship, each entity has a relationship field or property that refers to the other entity. 
  Through the relationship field or property, an entity class’s code can access its related object. If an entity has a related field, 
  the entity is said to “know” about its related object. 
  For example, if Order knows what Line Item instances it has and if Line Item knows what Order it belongs to, they have a bidirectional relationship.
  
Bidirectional relationships must follow these rules:

* The inverse side of a bidirectional relationship must refer to its owning side(Entity which contains the foreign key) by using the mappedBy element 
   of the @OneToOne, @OneToMany, or @ManyToMany annotation. The mappedBy element designates the property or field in the entity that is the owner of 
   the relationship.
* The many side of @ManyToOne bidirectional relationships must not define the mappedBy element. The many side is always the owning side of the 
  relationship.
* For @OneToOne bidirectional relationships, the owning side corresponds to the side that contains @JoinColumn i.e the corresponding foreign key.
* For @ManyToMany bidirectional relationships, either side may be the owning side.  

### CASE 1: (Mapping with foreign key association)
If we use only @OneToMany then there will be 3 tables. Such as company, branch and company_branch.
```
@Entity
public class Company {  
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Integer id;

    private String name;

    @OneToMany(targetEntity=Branch.class,cascade = CascadeType.ALL, 
              fetch = FetchType.LAZY, orphanRemoval = true)
    private List<Branch> branch = new ArrayList<>();

    //Accessors...
}

......

@Entity
public class Branch {
  
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Integer id;

    private string name;

    public Branch(String name) {
        this.name = name;
    }	

//Accessors...
}
```

Table company_branch will have two foreign key company_id and branch_id. The unidirectional associations are not very efficient when it comes to removing child entities.

On the other hand, a bidirectional @OneToMany association is much more efficient because the child entity controls the association.

CASE 2: (Mapping with foreign key association)
----------------------------------------------
If we use only @ManyToOne then there will be 2 tables. Such as company, branch.

@Entity
public class Company {
  
@Id
@GeneratedValue(strategy = GenerationType.AUTO)
private Integer companyId;

private String title;

   //Accessors...
   
}

....

@Entity
public class Branch {
  
@Id
@GeneratedValue(strategy = GenerationType.AUTO)
private Integer branchId;

private string name;

@ManyToOne(cascade = CascadeType.ALL)
Private Company company;

//Accessors..

}

CASE 5: (Mapping with foreign key association)
----------------------------------------------
If we use @ManyToOne with @JoinColumn then there will be 2 tables. Such as company,branch.

@Entity
public class Company {
  
@Id
@GeneratedValue(strategy = GenerationType.AUTO)
private Integer id;

private String name;
    
//Accessors...

}

....

@Entity
public class Branch {
  
@Id
@GeneratedValue(strategy = GenerationType.AUTO)
private Integer id;

private string name;

@ManyToOne(targetEntity = Company.class)
@JoinColumn(name = "companyId")
private Company company;

//Accessors...

}

The @JoinColumn annotation helps Hibernate to figure out that there is a company_id Foreign Key column in the branch table that defines 
this association.

Branch will have the foreign key company_id, so it’s the owner side.

The best way to map a @OneToMany association is to rely on the @ManyToOne side to propagate all entity state changes.

@Entity
public class Company {

@Id
@GeneratedValue(strategy = GenerationType.AUTO)
private Integer id;

private String name;

@OneToMany(targetEntity=Branch.class,cascade = CascadeType.ALL , fetch = FetchType.LAZY, mappedBy = "company")
private List<Branch> branches = new ArrayList<>();

public void addBranches(Branch branch){
   branches.add(branch);
   branch.setCompany(this);
}

public void removeBranches(Branch branch){
   branches.remove(branch);
   branch.setCompany(null);
}

//Accessors...
}

........

@Id
@GeneratedValue(strategy = GenerationType.AUTO)
private Integer id;

private string name;
@ManyToOne(targetEntity=Company.class, fetch = FetchType.LAZY)
@JoinColumn(name="companyId")//Optional
private Company company;

 @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Branch )) return false;
        return id != null && id.equals(((Branch) o).getId());
    }
    @Override
    public int hashCode() {
        return 31;
    }
//Accessors...
}

If we persist 2 Branch(s)

Hibernate generates just one SQL statement for each persisted Branch entity:

insert into company (name, id) values ("company1",1); 
insert into branch (company_id, name, id) values (1,"branch1",1); insert into branch (company_id, name, id) values (1,"branch2",2);
If we remove a Branch:

Company company = entityManager.find( Company.class, 1L );   Branch branch = company.getBranches().get(0);   company.removeBranches(branch);
There’s only one delete SQL statement that gets executed:

delete from Branch where id = 1
So, the bidirectional @OneToMany association is the best way to map a one-to-many database relationship when we really need the collection on the 
parent side of the association.

@JoinColumn Specifies a column for joining an entity association or element collection. The annotation @JoinColumn indicates that this entity 
is the owner of the relationship. That is the corresponding table has a column with a foreign key to the referenced table.


@OnetoOne best practices
-------------------------
The best way to map a @OneToOne relationship is to use @MapsId. This way, you don’t even need a bidirectional association since you can always 
fetch the PostDetails entity by using the Post entity identifier.

@Entity(name = "PostDetails")
@Table(name = "post_details")
public class PostDetails {
 
    @Id
    private Long id;
 
    @Column(name = "created_on")
    private Date createdOn;
 
    @Column(name = "created_by")
    private String createdBy;
 
    @OneToOne(fetch = FetchType.LAZY)
    @MapsId
    private Post post;
 
    public PostDetails() {}
 
    public PostDetails(String createdBy) {
        createdOn = new Date();
        this.createdBy = createdBy;
    }
 
    //Getters and setters omitted for brevity
}

This way, the id property serves as both Primary Key and Foreign Key. You’ll notice that the @Id column no longer uses a @GeneratedValue annotation 
since the identifier is populated with the identifier of the post association.

If you want to customize the Primary Key column name when using @MapsId, you need to use the @JoinColumn annotation.

The PostDetails entity can be persisted as follows:

doInJPA(entityManager -> {
    Post post = entityManager.find(Post.class, 1L);
    PostDetails details = new PostDetails("John Doe");
    details.setPost(post);
    entityManager.persist(details);
});

And we can even fetch the PostDetails using the Post entity identifier, so there is no need for a bidirectional association:

PostDetails details = entityManager.find(
    PostDetails.class,
    post.getId()
);

###################################################

JPA Hibernate first level cache
--------------------------------

The entity state is not synchronized every time an EntityManager method is called. In reality, the state changes are only synchronized when the 
flush EntityManager method is executed.

The advantage of using a write-behind strategy is that we can batch multiple entities when flushing the first-level cache.

The write-behind strategy is actually very common. The CPU has first, second, and third-level caches as well. And, when a registry is changed, 
its state is not synchronized with the main memory unless a flush is executed.

First, Hibernate checks whether the entity is already stored in the first-level cache, and if it is, the currently managed entity reference is returned.

If the JPA entity is not found in the first level-cache, Hibernate will check the second-level cache if this cache is enabled.

If the entity is not found in the first or second-level cache, then Hibernate will load it from the database using an SQL query.

The first-level cache provides application-level repeatable reads guarantee for entities because no matter how many times the entity is loaded from 
the Persistence Context, the same managed entity reference will be returned to the caller.

When the entity is loaded from the database, Hibernate takes the JDBC ResultSet and transforms it into a Java Object[] that’s known as the entity 
loaded state. The loaded state is stored in the first-level cache along with the managed entity.

The second-level cache stores the loaded state, so when loading an entity that was previously stored in the second-level cache, we can get the loaded 
state without having to execute the associated SQL query.

Ehcache
-------
<dependency>
    <groupId>org.hibernate</groupId>
    <artifactId>hibernate-ehcache</artifactId>
    <version>5.2.2.Final</version>
</dependency>