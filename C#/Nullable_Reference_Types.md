# Not-Nullable Reference Types (C# v8.x)

* Value Types: **Not Nullable**

* Reference Types: **Nullable**

Si puo' intervenire sui Value Types rendendoli nullable se si aggiunge un **?** dopo il tipo.

```
public class Program
{
    static void Main(string[] args)
    {
        int x = null;                   // ERROR!!
        int? y = null;                  // OK!!
        Program aProgram = null;        // OK!!
    }
}
```

**Cannot convert null to 'int' because it is a non-nullable type**


In C# 8 é stato introdotto un concetto specolare riguardo ai Reference Types per renderle **Not-Nullable**. Il motivo di questa modifica nel linguaggio é dovuta principalmente alla volontá di introdurre nei nostri programmi un meccanismo per limitare le **NullReferenceException**.

Per introdurre questo livello di controllo all'interno dei nostri programmi, si deve abiliarlo in modo esplicito.

Una forma drastica di fare questo é andare nel file di configurazione del progetto .NET (**.csproj** file) ed inserire la riga **<Nullable>enable</Nullable>** all'interno del **PropertyGroup**.

```
<Project Sdk="Microsoft.NET.Sdk">
    <PropertyGroup>
        <OutputType>Exe</OutputType>
        <TargetFramework>netcoreapp3.1</TargetFramework>
        <Nullable>enable</Nullable>
    </PropertyGroup>
</Project>
```

Una volta fatto questo, si attivano una serie di controlli da parte del compilatore.

```
public class Program
{
    static void Main(string[] args)
    {
        // Now, we will receive two arning messages (CS8600 and CS8604) regarding the conversion of a Null literal
        // and possible Null as reference argument
        string s = null;    /// CS8600
        Greeting(s);
    }

    static void Gretting(string name)   // CS8604
    {
        Console.WriteLine($"Hello, {name}");
    }
}
```

Se non vogliamo andare a generalizzare del tutto questo controllo, si puó introdurre in modo piú fine attraverso un **pragma**, una indicazione che é rivolta esplicitamente al compilatore in un punto qualunque all'interno del nostro programma.

Questo particolare pragma si chiama **nullable**, il cui principale valore ammesso é **enable**.

Tutto ció si tradurra nel fatto che da quella riga di codice in poi, il controllo sui Nullable Reference Types deve essere attivato.

Il controllo sui Nullable Reference Types si puó disattivare andando ad introdurre un secndo valore per il pragma **nullable** col valore **disable**, che disabiliterá il controllo a partire della riga di codice dove sia stato inserito il pragma.

```
public class Program
{
    static void Main(string[] args)
    {
        #nullable enable
        string s = null;

        #nullable disable
        Greeting(s);
    }

    static void Gretting(string name)
    {
        Console.WriteLine($"Hello, {name}");
    }
}
```

# Nullable Reference Types

Deve essere fatto in modo esplicito. Ci sono un paio di modi per aggirare questo limite:

* Applicare il suffisso **?** ad un reference type specifico per indicare che proprio in questo caso, deve 
  essere trattato come un Nullable Type contravvenendo al controllo generale che sia stato introdotto.
  ```
  string? s = null; // OK  
  ```

  Bisogna anche introdurre un controllo nel metodo o metodi che riceveranno come parametro questo nullable reference type:
  ```
    if (name != null)
    {
        Console.WriteLine($"Hello, {name}");
    }
  ```

* Si puó dire al compilatore che il reference type ricevuto come parametro é un Nullable Reference Type 
  usando anche il suffisso **?** come al solito:
  ```
    static void Gretting(string? name) { ... }
  ```

  In alternativa, si puó usare l'operatore **null-forgiving** (**!**) che dovrá essere aggiunto al nullable reference type che viene passato come parametro:
  ```
    Greeting(s!);
    ...
    static void Gretting(string name) { ... }
  ```

  Detto questo, **all'interno del metodo dovremmo garantire la gestione del parametro null**.

```
public class Program
{
    static void Main(string[] args)
    {
        #nullable enable
        string s = null;

        Greeting(s!);
    }

    static void Gretting(string name)
    {
        if (name != null)
        {
            Console.WriteLine($"Hello, {name}");
        }        
    }
}
```