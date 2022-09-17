# Introduzione alle Lambda Expressions

Le **lambda expressions** permettono di aumentare la flessibilità all'ora di utilizzare i **delegates**.

La piattaforma .NET ci mette a disposizione due delegate pre-confezionati: **Actions** e **Func**:

```
public delegate void Action<T>([0...16 args]);

public delegate Tres Func<T, Tres>([0...16 args]);
```

Una **lambda expression** è una sorta di **metodo anonimo**: un metodo composto di parametri, di un valore di ritorno, ecc; **ma non di un nome**.

In presenza di una lambda expression, il compilatore è in grado di convertirla automaticamente nella corrispondente **istanza di un delegate**, di usarla quindi, in abbinamento ad un certo delegate.

Esistono due forme di lambda expression:

La prima forma si chiama **expression lambda** ed è una sorta di metodo anonimo con dei parametri in ingresso ed in cui il body è composto da **un unica expressione** che viene  valutata e ritorna un valore di un certo tipo.

**(parameters) => expression**

La seconda forma si chiama **statement lambda** ed è leggermente più complessa della expression lambda, perchè non è presente una sola espressione ma un insieme di statements racchiuse all'interno di un blocco di codice:

**(parameters) => { <statements> }**

# Utilizziamo le Lambda Expressions

```
class Program
{
    static void Main(string[] args)
    {
        Func<String> greeting = () => "Hello";
        Console.WriteLine(greeting());
    }
}
```

# Expression-bodied Members

In C# si può unsare una sintassi analoga a quella delle lambda expressions anche quando ci poniamo in relazione ai membri di un tipo che possono essere implementati come espressioni.

Il nome generico che viene attribuito ai membri che godono di questo privileggio è **expression-bodied members**. Cioè, membri che hanno un codice costituito da una espressione.