# Introduzione

Gli eventi permettono alle classe che noi progettiamo di notificare l'accadere di specifici eventi (ex.: il cambiamento di valore di una proprietà).

**IL MODELLO DEGLI EVENTI**

        /
EMITTER --------------- LISTENER
        \
# Definizione di un evento

Per definire un evento all'interno di una classe, si deve creare un **delegate** con la keyword **evemt** dopo la visibilità del metodo nella sua signature.
Il delegate sarà utilizzato come meccanismo di notifica degli eventi a tutti i suoi subscribers.

Sempre all'interno della classe emitter, si definisce un metodo che verrà invocato tutte le volte che l'evento verrà generato.
Per convenzione, i messaggi usati per scatenare la notifica seguono la nomenclatura **On<event_name>**.

Per invocare questo tipo di metodo, basterà modificare il codice della Property nella modalità scritura (**set**), aggiungendo la chiamata al metodo **On...()** e passando come parametro proprio il nuovo valore del messaggio appena modificato.

```
public class Emitter
{
    private string message;

    public string Message
    {
        get { return message; }
        set { message = value; OnNewMessage(message); }
    }

    // event definition
    public event Action<string> NewMessage;

    public void OnNewMessage(string msg)
    {
        if(NewMessage != null)
        {
            NewMessage(msg);
        }
    }
}
```
# Listener di un Evento

Vediamo come si definisce una classe che vuole sottoscrivere la notifica di un evento, cioè, che sia in grado di sottoscriversi come **ascoltatore** di un evento.

All'interno di questa classe si definisce un metodo (**message handler**) che verrà invocato sugli oggetti di questa classe, che sottoscriveranno a ricevere le notifiche degli eventi dagli oggetti della classe emitrice degli eventi.

**La signatura di questo metodo deve essere compatibile con la signature del metodo che sia stato usato per notificare l'evento**.

**IL MESSAGE HANDLER**

```
public class Listener
{
    public void MessageHandler(string message)
    {
        Console.WriteLine("The message {0} has been received", message);
    }
}
```

# Ricezione di un Evento

A continuazione, vedremmo tutti i passi necessari per sottoscrivere l'evento definito nella classe emitrice da parte di oggetti della classe listener.

**SOTTOSCRIZIONE E RICEZIONE DI UN EVENTO**

1. Creare un oggetto **emettitore di eventi**.
2. Creare due oggetti **listener**.
3. Eseguire la sottoscrizione dei due **listener** all'**emettitore**.
4. Modificare la Property "message".
5. Pubblicare l'evento dall'**emettitore**.
6. Ricevere l'evento nei due **listener**.

```

```