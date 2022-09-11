# Introduzione

Le **eccezoni** sono il meccanismo principale che il linguaggio ci mette a disposizione per gestire correttamente tutta una serie di condizioni di errore che si possono venire a creare nei programmi.

# Come funzionano le Eccezioni

Le eccezioni in C# sono degli oggetti della classe **Exception** o delle sue sottoclassi.

**GENERAZIONE DELL'ECCEZIONE**

```
int aNumber = 0;

Console.Write("Type a number: ");
aNumber = Convert.ToInt32(Console.ReadLine());

Console.WriteLine($"You typed {aNumber}");
```

# Intercettare le Eccezioni

Le eccezioni vengono intercettate facendo uso del blocco **try/catch**:

```
int aNumber = 0;

Console.Write("Type a number: ");

try {
    aNumber = Convert.ToInt32(Console.ReadLine());
    Console.WriteLine($"You typed {aNumber}");
} catch (System.FormatException formatException) {
    Console.WriteLine($"You must type a valid number");
    aNumber = -1;
}
```

La parte **catch** può contenere delle eccezioni anidate. In questo caso, il tipo di eccezione più generale, sarebbe messa in fondo.

# Sollevare le eccezioni

Per generare una eccezione si utilizza la keyword **throw**, provocando l'interrizione immediata del metodo in cui viene lanciata l'eccezione e cominciando il bubbling-up di essa. È possibile anche fornire una stringa in input al costruttore dell'eccezione, e che sarà accessibile tramite la proprietà **Message**:

```
throw new Exception("Errore!");
...
Console.WriteLine(e.Message);
```

# La keyword 'finally'

Il blocco **finally** se viene aggiunto al blocco **try/catch**, verrà sempre eseguito, sia in casso di successo che in caso di un'avvenuta eccezione:

```
try {
    // ...
} catch (InvalidCastException e) {
    // ...
} finally {
    // ...
}
```