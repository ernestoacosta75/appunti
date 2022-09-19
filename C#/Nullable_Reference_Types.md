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


In C# 8 e' stato introdotto un concetto specolare riguardo ai Reference Types per renderle **Not-Nullable**. Il motivo di questa modifica nel linguaggio e' dovuta principalmente alla volonta' di introdurre nei nostri programmi un meccanismo per limitare le **NullReferenceException**.

Per introdurre questo livello di controllo all'interno dei nostri programmi, si deve abiliarlo in modo esplicito.

Una forma drastica di fare questo e' andare nel file di configurazione del progetto .NET (**.csproj** file) ed inserire la riga **<Nullable>enable</Nullable>** all'interno del **PropertyGroup**.

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

Se non vogliamo andare a generalizzare del tutto questo controllo, si puo' introdurre in modo piu' fine attraverso un **pragma**, una indicazione che e' rivolta esplicitamente al compilatore in un punto qualunque all'interno del nostro programma.

Questo particolare pragma si chiama **nullable**, il cui principale valore ammesso e' **enable**.

Tutto cio' si tradurra nel fatto che da quella riga di codice in poi, il controllo sui Nullable Reference Types deve essere attivato.

Il controllo sui Nullable Reference Types si puo' disattivare andando ad introdurre un secndo valore per il pragma **nullable** col valore **disable**, che disabilitera' il controllo a partire della riga di codice dove sia stato inserito il pragma.

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