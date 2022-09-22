# Cosa fa ASP.NET Core?

* È un framework per il Web.
* Si possono realizzare applicazioni di due tipi:
  - **Web App**: Applicazioni che forniscono delle informazioni in maniera dinamica, producono HTML ed in esse ci sono dei dati ottenuti da databases o servizi esterni come Web Services.I suoi principali utenti sono le persone.
  - **Web API**: È un'applicazioni i cui utenti sono **altre applicazioni**. Il suo scopo è quello di fornire dei dati in posseso dell'applicazione, afinchè altre possano consumarle, magari lavorarle e reinserirne delle proprie.

* È conforme al **GDPR**: si possono archiviare i dati degli utenti in maniera cifrata e perciò, confidenziale.
* È stremamente **modulare**: si possono scegliere i componenti da usare.
* È **gratuito** e **multipiattaforma**.
* È **open source**.

# Lo stack tecnologico x un'applicazione web sviluppata con ASP.NET Core

* **Applicazione** (user code)
  Si programma in **C#**, oppure in VB.NET o F#, ma questi hanno un supporto parziale.

* **ASP.NET Core** (application framework)
  Fornisce gli oggetti e i servizi specifici per realizzare una webapp.

* **.NET Core** (software framework)
  Contiene le librerie fondamentali, il runtime e il compilatore JIT.

* **Piattaforma ospitante**
  Il .NET Core contiene anche i binds specifici con la piattaforma ospitante. Quindi, può funzionare su Windows, MacOS e Linux (x86, x64 o ARM32).
