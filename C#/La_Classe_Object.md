# La Classe System.Object

É la radice di tutti i tipi presenti in C#, sia quelli predefiniti che quelli custom.

La classe **System.Object** puó essere rappresentata anche attraverso la keyword **object**.

```
public class AClass : object
{
    public virtual void MyMethod()
    {
        Console.WriteLine("AClass:MyMethod");
    }
}

public class BClass : AClass
{
    public override void MyMethod()
    {
        Console.WriteLine("BClass:MyMethod");
    }
}

public class CClass : BClass
{
    public override void MyMethod()
    {
        Console.WriteLine("CClass:MyMethod");
    }
}
```

# Il Metodo ToString()

**public virtual string? ToString()**

Questo metodo ha giá un comportamento predefinito che viene ereditato.

```
using System;

class Book
{
    public string TitLE { get; set; }
    public string Author { get; set; }
}

...

Book myBook1 = new Book { "L'Isola Misteriosa", "Jules Verne" };
Console.WriteLine(myBook1); // Book
```