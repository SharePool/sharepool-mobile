# SharePool Mobile
&copy; Tobias Kaderle & Jan Wiebauer

## Beschreibung
Eine ausführliche Erleuterung der Idee finden sie im [Proposal](./PROPOSAL.md).

## Flutter
Für die Umsetzung de mobilen Anwendung wurde Googels [Flutter](https://flutter.dev) verwendet. Dies ermöglicht mit einer gemeinsamen Code-Basis Android, iOS und seit kurzem auch Web-Apps zu entwickeln. Die Andwenung wird mittels der Programmiersprache [Dart](https://dart.dev) entwickelt, und kompiliert dann in nativen Swift-, bzw. Java- Code.

Wir waren mit dem Framework sehr zufrieden, da es viele Standardkomponenten bietet, und die Entwicklung durch Features wie z.b. "Hot-Reload" (Code-Änderungen werden binnen einer Sekunde am Test-Gerät aktualisiert) sehr angenehm ist.

## Use-Cases
### Login / Registrieren
Damit sich der Benutzer einen Account erstellen kann, bzw. sich in seinen Account einloggen kann, wird beim Start der App die Möglochkeit dazu geboten. Die eingegebenen Daten werden sowohl validiert (valide Email, Passwort-Regex, ...), und wenn sie keinen Fehler mehr enthalten, kann ein Request an den Server abgesetzt werden. Auch dort werden die Daten erneut validiert, und wenn alles passt, wird der User-Token retourniert. Dieser Token wird dann für alle anderen Requests an den Server benötigt, um den User zu authentifizieren.

<img src="doc/login-register.gif" alt="login-register" width="250"/>

### Sicht des Fahrers
Ein Benutzer, der als Fahrer der Fahrgemeinschaft agiert, kann für seinen Account Touren anlegen und verwalten. Wenn er oben rechts auf das Zahnrad-Icon klickt, sieht er alle sein Fahrten. Durch einen Klick auf einen Eintrag die Bearbeitungs-Seite öffnen. Wenn er jedoch auf das Plus-Icon rechts unten klickt, kann er eine neue Fahrt anlegen.

Aus den erstellten Touren kann eine gewählt werden, deren Infos dann mittels des QR-Code angezeigt werden. Durch einen Klick auf das Lupen-Icon wird die Liste der Touren angezeitg, aus der die gewünschte ausgewählt werden kann.

<img src="doc/driver.gif" alt="driver" width="250"/>

### Sicht des Mitfahrers
Ein Mitfahrer kann durch einen Klick auf den "Scan QR-Code" Menü-Eintrag die Kamera öffnen, und einen Tour-QR-Code eines Fahrers scannen. Wenn Code erkann wurde, wird erst einmal ein Request an den Server abgesetzt, um die benötigten Informationen zu erhalten (welche Tour, Entfernung, Preis, Fahrer, ..), die dann in einem Dialog angezeigt werden. Der Mitfahrer kann die Infos überprüfen, und dann entweder bestätigen oder ablehnen. Wenn er auf "Ja" klickt wird die Fahrt auf dem Server bestätigt.

<img src="doc/passenger.gif" alt="passenger" width="250"/>

### Einsicht der Bilanz
Nachdem ein Benutzer mehrere Fahrten absolbiert hat, kann er sich auf der "Statistic"-Seite seine Bilanz ansehen. Ganz oben wird ihm seine Gesamt-Bilanz angezeigt, und darunter in einer Liste die Bilanzen gegenüber der einzelnen Benutzer. Wenn er einen User auswählt, werden auf einer neuen Seite die einzelnen Fahrten und Rückzahlungen aufgelistet. Durch einen Klick auf das Plus-Icon rechts unten können neue Rückzählungen erstellt werden.

<img src="doc/balance.gif" alt="balance" width="250"/>

### Einsicht der Analyse
Damit sich der Benutzer auch seine Analyse-Daten anzeigen lassen kann, muss er von den Bilanzen einfach nur nach links wischen, um den Tab zu wechseln. Dort sieht er Graphen, die ihm auf den Tag aufsummiert, die gefahrenen Kilometer, sowie die eingesparten Liter Treibstoff anzeigt (diese Daten werden vom Analytics-Microservice abgefragt). Die Daten können nach Datum eingeschränkt werden, und auch durch einen Klick auf de Namen in der Legende aus/eingeblendet werden.

<img src="doc/analytics.gif" alt="analytics" width="250"/>