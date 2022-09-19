# Gli Indici (C# v8.0)

* All'interno del namespace **System** si trova una struct di nome **Index** che rappresenta il concetto d'indice.

* È stato introdotto un nuovo operatore, **^** (index from end operator) che rappresenta l'indice a partire della
  fine.

La struct Index serve come supporto per la gestion degli indici e come supporto a questo nuovo operatore.

```
public class Program
{
    static void Main(string[] args)
    {
        string[] myArray = { "primo", "secondo", "terzo", "quarto" };

        // two Index instances
        Index first = 0;
        Index last = ^1;    // using the index from end operator, for the last array position

        string anStr = myArray[first];
        Console.WriteLine(anStr);

        anStr = myArray[last];
        Console.WriteLine(anStr);

        // reducing the code using the index from end operator directly

        string anotherStr = myArray[^1];
        Console.WriteLine(anotherStr);

        anotherStr = myArray[^3];
        Console.WriteLine(anotherStr);
    }
}
```

# I Range (C# v8.x)

I **Range** ci consentono di accedere ad una slice all'interno di un array, con un nuovo operatore.

Come nel caso degli indici:

* Esiste una struct **Range** nel namespace System (**struct System.Range**) che rappresenta il concetto di Range.

* È stato introdotto un nuovo operatore, **..** (range operator). Questo operatore viene usato tra parentesi
  quadre con i due elementi (inizio e fine) del range (ex.: **[a..b]**).
  Il valore usato come fine del range **non è inclusivo**.

```
public class Program
{
    static void Main(string[] args)
    {
        string[] myArray = { "primo", "secondo", "terzo", "quarto" };

        string[] anStrRange = myArray[..2];

        foreach (string item in anStrRange)
        {
            Console.WriteLine(item);
        }

        Console.WriteLine("-----------------------------");

        string[] anotherStrRange = myArray[1..];

        foreach (string item in anotherStrRange)
        {
            Console.WriteLine(item);
        }

        Console.WriteLine("-----------------------------");

        string[] anotherStringRange = myArray[1..3];

        foreach (string item in anotherStringRange)
        {
            Console.WriteLine(item);
        }
    }
}
```