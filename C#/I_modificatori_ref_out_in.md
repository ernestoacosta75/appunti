# Value Type, Value Parameter (ParametriValueTypeEReference)

Differenza quando si parla di parametri valore e parametri reference.
Di norma, il passaggio di un parametro in un argumento in C# avviene **by value**.

# Reference Type, Value Parameter (ParametriValueTypeEReference)

Il reference type viene passato come un argomento ad un metodo, però il passaggio avviene comunque **by value**.

Il parametro del metodo invocato è un **value parameter**, e quello che succede è che il reference type passato al metodo viene duplicato nel parametro del metodo, e quindi, durante l'esecuzione del metodo ci saranno due references que puntano ad uno stesso oggetto.

Questo significa che quando dentro il metodo viene modificato il valore di uno degli attributi del reference passato come parametro, **verrà modificato lo stesso oggetto**.

Se invece, al reference passato come parametro al metodo, viene assegnata una nuova istanza del reference type, esso verrà associato ad una nuova istanza e l'ulteriore modifica degli attributi verrà assegnata a questa istanza, **e non a quella che è stata passata come parametro**.

# Reference Parameters: il Modificatore 'ref' (ModificatoreRef)

I **reference parameters** e' lo strumento che C# mette a disposizione per gestire i parametri tramite **riferimento**, non piu' tramite **valore**. Si tratta de la possibilita' di eseguire un passaggio di un argomento ad un parametro **by reference**.

Per farte questo, si utlizza il modificator **ref**. Esso altera la semantica del passaggio degli argomenti ad un metodo, provocando il passaggio **by reference**.

Il modificatore **ref** deve essere usato nella dichiarazione di un metodo, prima del tipo del parametro. La argomento che si potra' fornire al metodo adesso, deve essere per forza una variabile e questa variabile **deve avere gia' un valore assegnato**, prima di poterla passare come argomento al metodo.

Se il tipo del parametro e' un **reference type**, la variabile che rappresenta l'argomento puo' essere anche impostata ad **un oggetto**, ma anche a **null**, prima della chiamata al metodo.

Il modificatore **ref** deve essere utilizzato poi al momento dell'invocazione del metodo, prima del nome dell'argomento.

**DICHIARAZIONE**

```
void MyMethod(ref int x) {...}

int y = 5;
MyMethod(ref y);
```

**Value Parameter - Memory Allocation nello Stack**

Quando il passaggio di argomenti avviene **per valore**, viene allocata della memoria nello Stack per accogliere i valori dei rispettivi parametri, e questa memoria è separata rispetto al valore iniziale degli argomenti.

**Reference Parameter - No Memory Allocation nello Stack**

Quando el passaggio è **by reference**, non viene allocata dell'ulteriore memoria nello Stack perchè i parametri diventano loro stessi degli alias per i valori originali degli argomenti. Quindi, praticamente condividono la stessa memoria degli argomenti, ed è proprio per questo che ogni modifica che viene eseguita all'interno del metodo sui parametri, provoca una corrispondente modifica negli argomenti originali.

**Che cosa succede se nel passaggio di un reference type per reference, andiamo a cambiare l'oggetto puntato?**

Il nuovo oggetto viene creato all'interno del metodo e  viene sostituito a quello iniziale. Quindi è rimasto in vita, e la variabile che era stata passata come argomento, punta a questo nuovo oggetto.

# Output Parameters: il modificatore 'out' (ModificatoreOut)

Gli **output parameters** sono lo strumento che C# mette a disposizione per passare all'indietro dei dati, da un metodo verso il suo chiamante.

In questo modo, possiamo prevvedere degli ulteriori valori in uscita da un metodo (se questo ci serve), in aggiunta a quell'unico valore di ritorno canonico.

Questo se ottiene col modificatore **out**. Esso consente ad un metodo di produrre un valore in uscita, modificando un proprio parametro, essattamente come accade nel passaggio **by reference**.

L'argomento da passare ad un parametro out **deve essere una variabile**, che può anche non contenere un valore iniziale dato che questa variabile **sarà sicuramente inizzializata all'interno del metodo**.

Una differenza importante del modificatore **out** è quella de che all'interno del metodo, un parametro out **deve ASSOLUTAMENTE essere assegnato ad un valore esplicito** prima di poter essere letto. Altrimenti, il compilatore ci ferma.

**DICHIARAZIONE**

```
void MyMethod(out int x) {...}

int y;
MyMethod(out y);
```

# Il modificatore 'in' (versione 7.2 di C#) (ModificatoreIn)

Il modificatore **in** serve a rendere dei parametri **read only**. Serve per dichiarare un modo esplicito che il valore di un parametro non sarà sicuramente modificato all'interno del suo metodo.

**DICHIARAZIONE**

```
void MyMethod(in int x) {...}

int y = 5;
MyMethod(y);
```