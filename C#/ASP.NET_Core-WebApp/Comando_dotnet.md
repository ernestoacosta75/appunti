È lo strumento per gestire il progetto ed espone le sue funzioni come sottocomandi.
Ad esempio: dotnet qualcosa

* Per visualizzare i sottocomandi:
 ```
 dotnet --help
 ```

* La guida è disponibile per ogni sottocomando:
 ```
 dotnet new --help
 ```

# Panoramica dei sottocomandi disponibili

**dotnet new nometemplate**     Crea un nuovo progetto

**dotnet build**                Compila il progetto

**dotnet run**                  Esegue l'applicazione, compilandola se necessario

**dotnet test**                 Esegue gli unit test trovati nel progetto

**dotnet publish**              Pubblica l'applicazione in una directory locale

# Aggiungere funzionalità all'applicazione (Catalogo dei pacchetti NuGet)

Per capire se esiste un pacchetto d'aggiungere, visitare il sito **https://www.nuget.org/packages**.

## NuGet

* È un catalogo da cui ottenere pacchetti di funzionalità aggiuntive.
* Ogni pacchetto ha una specifica versione.
* ASP.NET Core è formato da una moltitudine di pacchetti NuGet.
* Volendo, potete realizzare un feed privato.

# Sottocomandi che riguardano la gestione delle dipendenze di un progetto

**dotnet add package nome**     Aggiunge il riferimento a un pacchetto NuGet

**dotnet restore**              Ripristina i pacchetti (implicito con build e run)

**dotnet remove package name**  Rimouve un pacchetto NuGet

**dotnet pack**                 Create il vostro pacchetto NuGet!

**dotnet add reference nome**   Aggiunge il riferimento a un progetto .NET Core