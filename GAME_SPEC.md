# EXTINCTION HOLLOW

**Genre:** 2D Top-Down Prehistoric Survival / Evolution
**Perspektive:** Top-Down
**Steuerung:** Primär Maus
**Arbeitstitel:** **Extinction Hollow**

> **Hunt. Grow. Return. Survive the end.**

---

# 1. Spielidee

**Extinction Hollow** ist ein 2D-Top-Down-Survival-Spiel in einer prähistorischen Welt.

Der Spieler kontrolliert einen kleinen Dinosaurier, der zu Beginn weit unten in der Nahrungskette steht.

Er muss:

* kleinere Tiere jagen,
* Fische fangen,
* Nahrung sammeln,
* größeren Raubtieren ausweichen,
* Naturkatastrophen überleben,
* wachsen,
* seine Fähigkeiten verbessern,
* zu seiner Höhle zurückkehren,
* gesammelte XP dort sichern,
* die Höhle verstärken,
* und sich auf einen unvermeidbaren Meteoriteneinschlag vorbereiten.

Das langfristige Ziel besteht darin, die Höhle so weit auszubauen, dass sie dem finalen Meteoriteneinschlag und dessen Folgen standhalten kann.

---

# 2. Kernfantasie

Der Spieler beginnt als kleines, schnelles und verwundbares Tier.

Zu Beginn ist fast alles gefährlich.

Mit zunehmendem Fortschritt verändert sich das Verhältnis zur Welt:

```text
Beute
↓
Jäger
↓
stärkerer Jäger
↓
dominantes Raubtier
```

Gleichzeitig wird jedoch auch die Welt selbst gefährlicher.

```text
friedlicher Dschungel
↓
Regen und Stürme
↓
Erdbeben
↓
Vulkanausbrüche
↓
Brände
↓
extreme Wetterlagen
↓
Meteor
```

Der Spieler wächst also nicht nur gegen andere Tiere an.

Er kämpft gegen das bevorstehende Ende seiner Welt.

---

# 3. Haupt-Gameplay-Loop

```text
Höhle verlassen
↓
Welt erkunden
↓
Beute suchen
↓
jagen
↓
fressen
↓
XP / Biomasse sammeln
↓
Risiko abwägen
↓
weitere Beute jagen ODER zurückkehren
↓
Höhle erreichen
↓
XP sichern
↓
Dino oder Höhle verbessern
↓
gefährlichere Gebiete erkunden
↓
stärkere Beute jagen
↓
Höhle auf Meteor vorbereiten
```

Die wichtigste Entscheidung lautet regelmäßig:

> **Jage ich noch eine Beute oder bringe ich meine XP zurück zur Höhle?**

---

# 4. Steuerung

Das Spiel wird primär mit der Maus gespielt.

Eine komplizierte Tastatursteuerung soll vermieden werden.

## 4.1 Bewegung

**Linksklick auf den Boden**

```text
Mausklick
↓
Zielposition bestimmen
↓
Dino dreht sich in Richtung Ziel
↓
Dino läuft zum Ziel
↓
Dino stoppt
```

Ein neuer Klick ersetzt sofort das vorherige Ziel.

---

## 4.2 Gedrückte Maustaste

Optional kann später unterstützt werden:

```text
Linke Maustaste gedrückt halten
↓
Zielposition wird regelmäßig aktualisiert
↓
Dino folgt der Maus
```

---

## 4.3 Interaktion

Linksklick soll kontextabhängig funktionieren.

### Klick auf Boden

```text
Zum Ziel laufen
```

### Klick auf Beute

```text
Beute als Ziel auswählen
↓
automatisch verfolgen
↓
bei ausreichender Nähe angreifen / fressen
```

### Klick auf Höhle

```text
zur Höhle laufen
↓
bei Ankunft Höhle betreten
```

### Klick auf Interaktionsobjekt

```text
Objekt auswählen
↓
zum Objekt laufen
↓
Interaktion ausführen
```

---

## 4.4 Mausrad

Optional:

```text
Mausrad hoch
→ hereinzoomen

Mausrad runter
→ herauszoomen
```

Der Zoom besitzt feste minimale und maximale Grenzen.

---

# 5. Steuerungsphilosophie

Das Spiel soll möglichst bequem mit einer Hand spielbar sein.

Die Schwierigkeit entsteht nicht durch komplizierte Eingaben.

Sie entsteht durch:

* Navigation,
* Jagd,
* Flucht,
* Risiko,
* Nahrungskette,
* Positionierung,
* Naturkatastrophen,
* Ressourcenmanagement,
* und die Entscheidung, wann man zur Höhle zurückkehrt.

---

# 6. Spieler

Der Spieler kontrolliert einen kleinen Dinosaurier.

Er beginnt schwach und schnell.

Mit zunehmendem Fortschritt kann er:

* größer werden,
* mehr Leben erhalten,
* schneller werden,
* stärker zubeißen,
* größere Tiere fressen,
* länger sprinten,
* Gefahren besser überleben.

---

# 7. Spielerwerte

Mindestens folgende Werte sind vorgesehen:

```text
Health
Max Health

Stamina
Max Stamina

Movement Speed
Sprint Speed

Strength
Bite Strength

Size Level

Hunger

Carried XP
Banked XP

Cold Resistance
Heat Resistance
```

---

# 8. Größenklassen

Alle Tiere besitzen eine Größenklasse.

Beispiel:

| Größenklasse | Bedeutung  |
| ------------ | ---------- |
| Size 1       | sehr klein |
| Size 2       | klein      |
| Size 3       | mittel     |
| Size 4       | groß       |
| Size 5       | gigantisch |

Der Spieler beginnt auf einer niedrigen Größenklasse.

---

# 9. Nahrungssystem

Nicht jede Beute kann sofort gefressen werden.

Die essbare Beute hängt ab von:

* Größe,
* Stärke,
* eventuell Lebenspunkten,
* Spielerfortschritt.

Beispiel:

### Frühes Spiel

Essbar:

* Insekten,
* kleine Echsen,
* kleine Fische,
* sehr kleine Dinosaurier,
* kleine Säugetiere.

### Mittleres Spiel

Zusätzlich essbar:

* größere Fische,
* kleine Dinosaurier,
* mittelgroße Tiere.

### Spätes Spiel

Zusätzlich essbar:

* größere Dinosaurier,
* stärkere Tiere,
* bisherige Räuber.

---

# 10. XP-System

Gefressene Tiere geben XP beziehungsweise Biomasse.

Beispiel:

| Beute             |  XP |
| ----------------- | --: |
| kleiner Fisch     |   2 |
| Insekt            |   2 |
| kleine Echse      |   4 |
| kleines Säugetier |   6 |
| kleiner Dino      |  10 |
| mittlere Beute    |  25 |
| große Beute       | 50+ |

Die Werte dienen nur als Ausgangspunkt für späteres Balancing.

---

# 11. Carried XP und Banked XP

XP wird nach dem Fressen nicht sofort dauerhaft gespeichert.

Es gibt zwei Arten von XP:

```text
Carried XP
Banked XP
```

## Carried XP

XP, die der Spieler außerhalb der Höhle gesammelt hat.

Sie ist gefährdet.

## Banked XP

XP, die bereits zur Höhle gebracht wurde.

Sie ist dauerhaft gesichert.

---

# 12. Risiko beim Tod

Stirbt der Spieler außerhalb der Höhle:

```text
Carried XP geht teilweise oder vollständig verloren.
```

Banked XP bleibt erhalten.

Dadurch entsteht eine permanente Risikoentscheidung:

```text
Noch eine Jagd?

oder

zurück zur Höhle?
```

---

# 13. Die Höhle

Die Höhle ist das zentrale Element des Spiels.

Sie dient als:

* Heimat,
* Spawnpunkt,
* Savepoint,
* XP-Bank,
* Upgrade-Ort,
* Schutzraum,
* Endgame-Ziel.

---

# 14. XP zur Höhle bringen

Betritt der Spieler seine Höhle:

```text
Carried XP
↓
Banked XP
```

Beispiel:

```text
Carried XP: 45
↓
Höhle betreten
↓
Carried XP: 0
Banked XP: +45
```

Die Abgabe soll später visuell dargestellt werden.

Beispielsweise durch:

* Partikel,
* Höhlenleuchten,
* Wachstum,
* neue Felsstrukturen,
* akustisches Feedback.

---

# 15. Höhlenfortschritt

Die Höhle wächst gemeinsam mit dem Spieler.

## Cave Level 1

* kleiner Eingang,
* kaum Schutz,
* kleiner Innenraum.

## Cave Level 2

* größerer Innenraum,
* stabilere Wände,
* erste Schutzfunktionen.

## Cave Level 3

* tieferer Bereich,
* Vorratskammer,
* bessere Stabilität.

## Cave Level 4

* massiver Schutzraum,
* hoher Hitze- und Erdbebenschutz.

## Cave Level 5

* tiefe Schutzkammer,
* maximale Stabilität,
* Meteor-resistent.

---

# 16. Höhlenwerte

Die Höhle besitzt mehrere Werte.

```text
Cave Strength
Cave Depth
Heat Resistance
Earthquake Resistance
Cold Resistance
Meteor Resistance
Food Storage
```

Das Finale soll nicht nur von einem einzelnen Wert abhängen.

---

# 17. Höhlen-Upgrades

Mögliche Upgrades:

* stärkere Wände,
* tieferer Schutzraum,
* Hitzeschutz,
* Erdbebenschutz,
* Kälteschutz,
* Lagerraum,
* Regeneration,
* zusätzlicher Eingangsschutz,
* Vorratskammern.

---

# 18. Spieler-Upgrades

Banked XP kann auch für den Dinosaurier ausgegeben werden.

Mögliche Upgrades:

* mehr Lebenspunkte,
* mehr Ausdauer,
* höhere Laufgeschwindigkeit,
* bessere Sprintgeschwindigkeit,
* stärkerer Biss,
* bessere Regeneration,
* höhere Größenklasse,
* bessere Wahrnehmung,
* Hitzeresistenz,
* Kälteresistenz.

---

# 19. Fortschrittsentscheidung

Der Spieler muss XP zwischen zwei Zielen verteilen:

```text
Dino stärker machen

oder

Höhle sicherer machen
```

Diese Entscheidung bildet einen wichtigen Teil des Spiels.

Ein sehr starker Dino ohne gute Höhle kann das Ende nicht überleben.

Eine starke Höhle mit einem zu schwachen Dino erschwert wiederum die Nahrungssuche.

---

# 20. Ökosystem

Die Welt soll nicht statisch wirken.

NPC-Tiere existieren unabhängig vom Spieler.

Sie:

* suchen Nahrung,
* fliehen,
* jagen,
* ruhen,
* wandern,
* reagieren auf Wetter,
* reagieren auf Katastrophen,
* reagieren auf andere Tiere.

---

# 21. Tier-KI

Grundlegende Zustände:

```text
IDLE
WANDER
SEARCH_FOOD
CHASE
FLEE
EAT
REST
DEAD
```

---

# 22. Nahrungskette

Tiere besitzen Beziehungen zueinander.

Beispiel:

```text
Insekten
↓
kleine Echsen
↓
kleine Dinosaurier
↓
mittlere Räuber
↓
große Räuber
```

NPCs dürfen andere NPCs jagen.

Der Spieler kann dadurch Jagden beobachten, Beute stehlen oder gefährliche Situationen vermeiden.

---

# 23. Große Raubtiere

Große Dinosaurier sind:

* sehr stark,
* gefährlich,
* schwer zu töten,
* langsam.

Das grundlegende Balancing:

```text
klein
=
schnell
aber schwach

groß
=
langsam
aber stark
```

Dadurch kann der kleine Spieler großen Räubern entkommen.

---

# 24. Wahrnehmung

Tiere besitzen keine perfekte Kenntnis über die Welt.

Mögliche Werte:

```text
Vision Radius
Hearing Radius
Attack Radius
Fear Radius
```

Beispiel:

```text
Raubtier sieht Spieler
↓
Spieler klein genug
↓
CHASE
```

Oder:

```text
kleines Tier sieht großen Räuber
↓
FLEE
```

---

# 25. Wasser

Die Welt enthält:

* Flüsse,
* Seen,
* Teiche,
* Sumpfgebiete.

Wasser dient als:

* Nahrungsquelle,
* natürliche Grenze,
* Gefahrenzone,
* später eventuell Fortbewegungsbarriere.

---

# 26. Fische

Fische sind eine wichtige frühe Nahrungsquelle.

Grundverhalten:

```text
zufällig schwimmen
↓
Spieler nähert sich
↓
Fisch flieht
↓
Spieler erreicht Fangposition
↓
Fisch wird gefressen
```

---

# 27. Biome

Geplante Weltregionen:

| Biom         | Charakter                                |
| ------------ | ---------------------------------------- |
| Dschungel    | Startgebiet, viele kleine Tiere          |
| Flussgebiet  | viele Fische, Wasserwege                 |
| Sumpf        | eingeschränkte Bewegung, spezielle Tiere |
| Ebene        | wenig Deckung, Herden                    |
| Vulkanregion | Feuer, Lava, gefährliche Beute           |
| Gebirge      | Felsen, enge Wege                        |
| Schneeregion | Kälte, Schnee, seltene Tiere             |

---

# 28. Dschungel

Das Startgebiet.

Eigenschaften:

* viel Vegetation,
* kleine Tiere,
* kleine Flüsse,
* relativ geringe Gefahr,
* wenige große Räuber.

---

# 29. Vulkanregion

Gefährliches Gebiet.

Enthält:

* Vulkane,
* Lava,
* Feuer,
* Asche,
* heiße Bereiche,
* stärkere Beute,
* seltene Tiere.

---

# 30. Wetter

Die Welt besitzt ein dynamisches Wettersystem.

Mögliche Zustände:

```text
CLEAR
RAIN
HEAVY_RAIN
STORM
SNOW
ASH
```

Wetter soll nicht ständig wechseln.

Längere stabile Wetterphasen sind erwünscht.

---

# 31. Regen

Regen beeinflusst:

* Sicht,
* Atmosphäre,
* Geräusche,
* Tierverhalten.

Später kann Regen zusätzlich:

* Feuer löschen,
* Flüsse anschwellen lassen,
* mehr Fische erzeugen,
* Sumpfbereiche vergrößern.

---

# 32. Starkregen

Starkregen ist eine seltenere Wetterlage.

Mögliche Auswirkungen:

* geringere Sicht,
* langsamere Bewegung,
* steigende Wasserstände,
* stärkere Strömungen,
* mehr Fische.

---

# 33. Schnee

Schnee tritt in bestimmten Regionen oder Wetterphasen auf.

Er beeinflusst:

* Sicht,
* Bewegung,
* Temperatur,
* Tierarten.

Optional:

* sichtbare Fußspuren,
* tiefen Schnee,
* Schneestürme.

---

# 34. Kälte

In kalten Regionen kann ein Temperaturwert relevant werden.

Zu starke Kälte kann:

* Ausdauerregeneration reduzieren,
* Bewegung verlangsamen,
* später Lebenspunkte kosten.

---

# 35. Katastrophen

Katastrophen sind von normalem Wetter getrennt.

Mögliche Katastrophen:

```text
EARTHQUAKE
VOLCANIC_ERUPTION
WILDFIRE
METEOR
```

---

# 36. Erdbeben

Erdbeben treten zufällig oder storybedingt auf.

Vorzeichen:

* kleine Bodenbewegungen,
* Geräusche,
* nervöse Tiere.

Während des Erdbebens:

* Kamera wackelt,
* Steine fallen,
* Tiere fliehen,
* Wege können blockiert werden,
* Spieler kann Schaden nehmen.

---

# 37. Vulkaneruptionen

Eine Eruption wird angekündigt.

Vorzeichen:

* stärkere Rauchentwicklung,
* Bodenbeben,
* glühender Vulkan,
* Tiere fliehen.

Während der Eruption:

* Feuer entsteht,
* Lava fließt,
* Steine fallen,
* Asche breitet sich aus.

---

# 38. Feuer

Feuer kann durch Vulkane oder spätere Ereignisse entstehen.

Feuer:

* verursacht Schaden,
* blockiert Wege,
* beeinflusst Tiere.

Später kann Feuer Vegetation erfassen.

---

# 39. Natur reagiert auf Katastrophen

Tiere reagieren ebenfalls auf Ereignisse.

Beispiel:

```text
Vulkan wird aktiv
↓
Tiere werden unruhig
↓
Herden fliehen
↓
Raubtiere ändern Routen
↓
Chaos entsteht
```

Dadurch entstehen dynamische Situationen.

---

# 40. Weltfortschritt

Die Spielwelt wird im Laufe einer Runde immer gefährlicher.

## Phase 1 – Frühe Welt

* ruhige Umgebung,
* kleine Tiere,
* wenig Katastrophen.

## Phase 2 – Instabilität

* größere Räuber,
* stärkeres Wetter,
* erste Erdbeben.

## Phase 3 – Katastrophen

* Vulkanausbrüche,
* Brände,
* stärkere Erdbeben.

## Phase 4 – Vorzeichen

* ungewöhnlicher Himmel,
* zunehmende Vulkanaktivität,
* häufigere Naturereignisse,
* Tiere verhalten sich nervös.

## Phase 5 – Meteor

* Meteor deutlich sichtbar,
* Welt gerät ins Chaos,
* finale Rückkehr zur Höhle.

---

# 41. Meteor

Der Meteor bildet das Endgame.

Er darf nicht plötzlich und ohne Vorbereitung erscheinen.

Der Spieler soll früh erkennen, dass langfristig etwas geschieht.

---

# 42. Meteor-Vorzeichen

Mögliche Hinweise:

* ungewöhnlicher Stern,
* heller Punkt am Himmel,
* Meteor wird größer,
* mehr Erdbeben,
* stärkere Vulkanaktivität,
* rote Himmelstöne,
* nervöse Tiere,
* Ascheregen,
* extreme Wetterereignisse.

---

# 43. Finale Phase

Kurz vor dem Einschlag muss der Spieler entscheiden:

```text
noch einmal jagen

oder

alles zur Höhle bringen
```

Die letzten Minuten sollen besonders gefährlich werden.

Mögliche Ereignisse:

* viele fliehende Tiere,
* Raubtiere verlieren normales Verhalten,
* Erdbeben,
* Vulkanausbrüche,
* Feuer,
* Ascheregen,
* Meteoritenschauer.

---

# 44. Meteor-Einschlag

Der Spieler muss sich rechtzeitig in seiner Höhle befinden.

Außerhalb:

```text
Tiere fliehen
↓
Erdbeben
↓
Vulkane
↓
Feuer
↓
Meteor sichtbar
↓
Einschlag
```

Dann wird überprüft, ob die Höhle stark genug ist.

---

# 45. Höhlenprüfung

Die Überlebenschance hängt von mehreren Werten ab.

Beispiel:

```text
Cave Strength
Cave Depth
Heat Resistance
Earthquake Resistance
Food Storage
Meteor Resistance
```

Der Einschlag verursacht mehrere Belastungen.

```text
Meteor Impact
↓
Druckwelle
↓
Erdbeben
↓
Hitze
↓
Feuer
↓
Asche
↓
Kältephase
```

Die Höhle muss insgesamt ausreichend vorbereitet sein.

---

# 46. Erfolg

Wenn die Höhle den Einschlag übersteht:

```text
SURVIVED
```

Danach:

* Bildschirm wird dunkel,
* Zeit vergeht,
* Geräusche klingen ab,
* der Dino verlässt langsam die Höhle,
* die Welt hat sich vollständig verändert.

---

# 47. Scheitern

Ist die Höhle nicht ausreichend ausgebaut:

```text
CAVE COLLAPSES
```

oder:

```text
EXTINCTION
```

Danach:

```text
GAME OVER
```

---

# 48. Optionales Post-Meteor-Endgame

Später denkbar:

**Post-Meteor Survival Mode**

Nach erfolgreichem Überleben:

* zerstörte Welt,
* kaum Vegetation,
* wenig Nahrung,
* Kälte,
* neue Überlebensbedingungen.

Nicht Teil des ersten Releases.

---

# 49. Kamera

Die Kamera folgt dem Spieler weich.

Optional verändert sie den Zoom abhängig von der Größe des Dinosauriers.

```text
kleiner Dino
→ näher

größerer Dino
→ weiter herausgezoomt
```

---

# 50. Benutzeroberfläche

Minimaler HUD:

* Health,
* Stamina,
* Hunger,
* Carried XP,
* Banked XP,
* Dino Size.

Später zusätzlich:

* Temperatur,
* Cave Level,
* Wetter,
* Katastrophenwarnung,
* Meteor-Status.

---

# 51. Mauszeiger

Der Cursor kann später kontextabhängig reagieren.

| Ziel               | Cursor         |
| ------------------ | -------------- |
| Boden              | Bewegung       |
| essbare Beute      | Angriff / Biss |
| zu große Beute     | Gefahr         |
| Höhle              | Home           |
| Upgrade            | Upgrade        |
| Interaktionsobjekt | Interaktion    |

---

# 52. Atmosphäre

Die Atmosphäre verändert sich über den Spielverlauf.

```text
friedlich
↓
angespannt
↓
gefährlich
↓
chaotisch
↓
apokalyptisch
```

Der Anfang soll bewusst ruhig wirken.

Dadurch fühlt sich das Ende umso extremer an.

---

# 53. Artstyle

Für frühe Versionen:

* einfache Shapes,
* Placeholder-Grafiken,
* einfache Sprites,
* einfache Animationen.

Priorität:

```text
Gameplay
>
Systeme
>
Balancing
>
Grafik
```

Später kann ein eigener Stil entwickelt werden.

Mögliche Richtung:

* stilisierte Pixelgrafik,
* handgezeichnete 2D-Grafik,
* farbenfrohe prähistorische Welt,
* zunehmend dunklere Farbpalette Richtung Endgame.

---

# 54. Sound

Geplante Soundkategorien:

* Dschungel,
* Regen,
* Wasser,
* Wind,
* Schnee,
* Dinosaurier,
* Schritte,
* Angriffe,
* Fressen,
* Feuer,
* Lava,
* Vulkan,
* Erdbeben,
* Meteor,
* Höhle.

Sound soll stark zur Atmosphäre beitragen.

---

# 55. Speichersystem

Gespeichert werden:

* Spieler-Upgrades,
* Banked XP,
* Höhlenlevel,
* Höhlen-Upgrades,
* Weltfortschritt,
* Meteorfortschritt,
* Einstellungen.

Bevorzugtes Prinzip:

> Speichern hauptsächlich innerhalb der Höhle.

Dadurch bleibt die Höhle auch spielmechanisch der sichere Ort.

---

# 56. Technische Architektur

Das Spiel soll modular aufgebaut sein.

Große Systeme werden getrennt.

Beispiel:

```text
Player
├── Movement
├── Health
├── Hunger
├── XP
├── Interaction
└── Upgrades
```

NPC:

```text
Animal
├── Movement
├── AI
├── Health
├── Species
├── Perception
└── Loot
```

Welt:

```text
World
├── Weather
├── Disasters
├── Spawning
├── Biomes
└── Progression
```

---

# 57. Datengetriebene Tierarten

Tierarten sollen möglichst über Daten definiert werden.

Beispiel:

```text
Name
Size
Speed
Health
XP Value
Diet
Predator
Prey Sizes
Vision Radius
Fear Radius
Biome
```

Dadurch können neue Tiere einfacher hinzugefügt werden.

---

# 58. Datengetriebene Katastrophen

Auch Katastrophen sollen möglichst datenbasiert aufgebaut sein.

Beispielwerte:

```text
Type
Duration
Intensity
Warning Time
Damage
Affected Radius
```

---

# 59. Performance

Später können viele Tiere gleichzeitig existieren.

Daher langfristig berücksichtigen:

* Spawn-Limits,
* Despawn in großer Entfernung,
* vereinfachte KI außerhalb des Sichtbereichs,
* Object Pooling,
* reduzierte Updates weit entfernter NPCs.

Optimierung soll jedoch erst erfolgen, wenn sie notwendig wird.

---

# 60. MVP

Die erste wirklich spielbare Version benötigt:

* Top-Down-Spieler,
* Maussteuerung,
* Kamera,
* kleine Karte,
* Höhle,
* kleine Beute,
* großen Räuber,
* Fisch,
* Fressen,
* Carried XP,
* Banked XP,
* ein Spieler-Upgrade,
* ein Höhlen-Upgrade,
* Regen,
* einfaches Erdbeben,
* vereinfachtes Meteor-Finale.

---

# 61. Nicht Teil des MVP

Zunächst nicht notwendig:

* Multiplayer,
* riesige Open World,
* Dutzende Dinoarten,
* Crafting,
* komplexes Inventar,
* Dialogsystem,
* Story-NPCs,
* prozedurale Welt,
* realistische Physik,
* komplexes Skillsystem,
* vollständige Simulation jedes Tieres.

---

# 62. Entwicklungs-Tasks

| ID   | Bereich       | Task                                  | Priorität | Abhängigkeit | Status |
| ---- | ------------- | ------------------------------------- | --------- | ------------ | ------ |
| T001 | Projekt       | Grundprojekt erstellen                | Hoch      | –            | Offen  |
| T002 | Player        | Spielerobjekt erstellen               | Hoch      | T001         | Offen  |
| T003 | Input         | Mausklick erkennen                    | Hoch      | T002         | Offen  |
| T004 | Movement      | Click-to-Move implementieren          | Hoch      | T003         | Offen  |
| T005 | Movement      | Neue Klickposition ersetzt altes Ziel | Hoch      | T004         | Offen  |
| T006 | Movement      | Spieler stoppt am Ziel                | Hoch      | T004         | Offen  |
| T007 | Movement      | Weiche Drehung zur Bewegungsrichtung  | Mittel    | T004         | Offen  |
| T008 | Kamera        | Kamera folgt Spieler                  | Hoch      | T002         | Offen  |
| T009 | Kamera        | Weiches Kamerafolgen                  | Mittel    | T008         | Offen  |
| T010 | Kamera        | Maus-Zoom                             | Niedrig   | T008         | Offen  |
| T011 | Welt          | Kleine Testmap erstellen              | Hoch      | T001         | Offen  |
| T012 | Welt          | Kollisionsbereiche                    | Hoch      | T011         | Offen  |
| T013 | Beute         | Kleines Beutetier erstellen           | Hoch      | T011         | Offen  |
| T014 | KI            | Wander-Verhalten                      | Hoch      | T013         | Offen  |
| T015 | KI            | Flucht vor Spieler                    | Hoch      | T014         | Offen  |
| T016 | Interaktion   | Beute per Klick auswählen             | Hoch      | T013         | Offen  |
| T017 | Jagd          | Beute automatisch verfolgen           | Hoch      | T016         | Offen  |
| T018 | Fressen       | Beute fressen                         | Hoch      | T017         | Offen  |
| T019 | XP            | XP-Wert pro Tier                      | Hoch      | T018         | Offen  |
| T020 | XP            | Carried XP implementieren             | Hoch      | T019         | Offen  |
| T021 | Höhle         | Höhlenobjekt erstellen                | Hoch      | T011         | Offen  |
| T022 | Höhle         | Höhleneingang erkennen                | Hoch      | T021         | Offen  |
| T023 | Höhle         | Höhle per Klick ansteuern             | Mittel    | T021         | Offen  |
| T024 | XP            | Carried XP in Banked XP umwandeln     | Hoch      | T022, T020   | Offen  |
| T025 | Save          | Speichern in Höhle                    | Mittel    | T024         | Offen  |
| T026 | Gegner        | Großen Raubdino erstellen             | Hoch      | T011         | Offen  |
| T027 | KI            | Raubdino erkennt Spieler              | Hoch      | T026         | Offen  |
| T028 | KI            | Raubdino verfolgt Spieler             | Hoch      | T027         | Offen  |
| T029 | Kampf         | Raubdino verursacht Schaden           | Hoch      | T028         | Offen  |
| T030 | Player        | Spielertod                            | Hoch      | T029         | Offen  |
| T031 | XP            | Carried XP bei Tod verlieren          | Hoch      | T030         | Offen  |
| T032 | Nahrungskette | Größenklassen erstellen               | Hoch      | T013, T026   | Offen  |
| T033 | Nahrungskette | Essbarkeit nach Größe prüfen          | Hoch      | T032         | Offen  |
| T034 | KI            | NPC jagt NPC                          | Mittel    | T032         | Offen  |
| T035 | KI            | Flee-State für NPCs                   | Mittel    | T034         | Offen  |
| T036 | Wasser        | Wassergebiet erstellen                | Mittel    | T011         | Offen  |
| T037 | Fisch         | Fisch-NPC erstellen                   | Mittel    | T036         | Offen  |
| T038 | Fisch         | Fischbewegung                         | Mittel    | T037         | Offen  |
| T039 | Fisch         | Fisch flieht vor Spieler              | Mittel    | T038         | Offen  |
| T040 | Fisch         | Fisch fangen und fressen              | Mittel    | T039         | Offen  |
| T041 | Player        | Hunger-System                         | Mittel    | T018         | Offen  |
| T042 | Player        | Stamina-System                        | Mittel    | T004         | Offen  |
| T043 | Player        | Sprint-System                         | Niedrig   | T042         | Offen  |
| T044 | Upgrades      | Upgrade-System Grundstruktur          | Hoch      | T024         | Offen  |
| T045 | Upgrades      | Health Upgrade                        | Mittel    | T044         | Offen  |
| T046 | Upgrades      | Speed Upgrade                         | Mittel    | T044         | Offen  |
| T047 | Upgrades      | Bite Upgrade                          | Mittel    | T044         | Offen  |
| T048 | Upgrades      | Size Upgrade                          | Hoch      | T044, T032   | Offen  |
| T049 | Höhle         | Cave-Level-System                     | Hoch      | T024         | Offen  |
| T050 | Höhle         | Cave Strength                         | Hoch      | T049         | Offen  |
| T051 | Höhle         | Cave Depth                            | Mittel    | T049         | Offen  |
| T052 | Höhle         | Heat Resistance                       | Mittel    | T049         | Offen  |
| T053 | Höhle         | Earthquake Resistance                 | Mittel    | T049         | Offen  |
| T054 | Höhle         | Cold Resistance                       | Niedrig   | T049         | Offen  |
| T055 | UI            | Health-Anzeige                        | Hoch      | T002         | Offen  |
| T056 | UI            | Stamina-Anzeige                       | Mittel    | T042         | Offen  |
| T057 | UI            | Hunger-Anzeige                        | Mittel    | T041         | Offen  |
| T058 | UI            | Carried-XP-Anzeige                    | Hoch      | T020         | Offen  |
| T059 | UI            | Banked-XP-Anzeige                     | Hoch      | T024         | Offen  |
| T060 | UI            | Cave-Level-Anzeige                    | Mittel    | T049         | Offen  |
| T061 | Wetter        | Weather-System Grundstruktur          | Hoch      | T011         | Offen  |
| T062 | Wetter        | Clear State                           | Mittel    | T061         | Offen  |
| T063 | Wetter        | Regen                                 | Hoch      | T061         | Offen  |
| T064 | Wetter        | Starkregen                            | Niedrig   | T063         | Offen  |
| T065 | Wetter        | Schnee                                | Mittel    | T061         | Offen  |
| T066 | Wetter        | Asche                                 | Mittel    | T061         | Offen  |
| T067 | Kälte         | Temperatur-System                     | Niedrig   | T065         | Offen  |
| T068 | Katastrophe   | Disaster-System Grundstruktur         | Hoch      | T011         | Offen  |
| T069 | Erdbeben      | Erdbeben-Event                        | Hoch      | T068         | Offen  |
| T070 | Erdbeben      | Kamera-Shake                          | Mittel    | T069         | Offen  |
| T071 | Erdbeben      | Schaden durch Erdbeben                | Mittel    | T069         | Offen  |
| T072 | Erdbeben      | NPC-Flucht                            | Mittel    | T069, T035   | Offen  |
| T073 | Vulkan        | Vulkanregion                          | Mittel    | T011         | Offen  |
| T074 | Vulkan        | Vulkanwarnung                         | Mittel    | T073         | Offen  |
| T075 | Vulkan        | Eruption                              | Mittel    | T074         | Offen  |
| T076 | Feuer         | Feuerzonen                            | Mittel    | T075         | Offen  |
| T077 | Feuer         | Feuerschaden                          | Mittel    | T076         | Offen  |
| T078 | Feuer         | NPC-Reaktion auf Feuer                | Niedrig   | T076, T035   | Offen  |
| T079 | Biome         | Dschungel-Biom                        | Hoch      | T011         | Offen  |
| T080 | Biome         | Fluss-Biom                            | Mittel    | T036         | Offen  |
| T081 | Biome         | Sumpf-Biom                            | Niedrig   | T036         | Offen  |
| T082 | Biome         | Ebene                                 | Niedrig   | T011         | Offen  |
| T083 | Biome         | Vulkan-Biom                           | Mittel    | T073         | Offen  |
| T084 | Biome         | Schnee-Biom                           | Mittel    | T065         | Offen  |
| T085 | Progression   | Weltphasen-System                     | Hoch      | T061, T068   | Offen  |
| T086 | Progression   | Gefahren mit Zeit erhöhen             | Mittel    | T085         | Offen  |
| T087 | Meteor        | Meteor-Vorzeichen                     | Hoch      | T085         | Offen  |
| T088 | Meteor        | Meteor sichtbar machen                | Mittel    | T087         | Offen  |
| T089 | Meteor        | Finale Warnphase                      | Hoch      | T087         | Offen  |
| T090 | Meteor        | Meteoreinschlag                       | Hoch      | T089         | Offen  |
| T091 | Meteor        | Höhlenprüfung                         | Hoch      | T090, T049   | Offen  |
| T092 | Meteor        | Erfolgsende                           | Hoch      | T091         | Offen  |
| T093 | Meteor        | Game-Over-Ende                        | Hoch      | T091         | Offen  |
| T094 | Audio         | Dschungel-Ambiente                    | Niedrig   | T079         | Offen  |
| T095 | Audio         | Regen-Sound                           | Niedrig   | T063         | Offen  |
| T096 | Audio         | Tier-Sounds                           | Niedrig   | T013         | Offen  |
| T097 | Audio         | Erdbeben-Sound                        | Niedrig   | T069         | Offen  |
| T098 | Audio         | Vulkan-Sound                          | Niedrig   | T075         | Offen  |
| T099 | Audio         | Meteor-Sound                          | Niedrig   | T090         | Offen  |
| T100 | Polish        | Cursor-Zustände                       | Niedrig   | T016         | Offen  |
| T101 | Polish        | XP-Partikel bei Höhle                 | Niedrig   | T024         | Offen  |
| T102 | Polish        | Höhlenvisual verändert sich           | Mittel    | T049         | Offen  |
| T103 | Polish        | Dino wächst sichtbar                  | Mittel    | T048         | Offen  |
| T104 | Performance   | Spawn-Limits                          | Mittel    | T034         | Offen  |
| T105 | Performance   | NPC-Despawn                           | Mittel    | T104         | Offen  |
| T106 | Performance   | vereinfachte Fern-KI                  | Niedrig   | T104         | Offen  |
| T107 | Balancing     | XP-Werte balancieren                  | Mittel    | T044         | Offen  |
| T108 | Balancing     | Tiergeschwindigkeiten balancieren     | Mittel    | T034         | Offen  |
| T109 | Balancing     | Höhlenkosten balancieren              | Mittel    | T049         | Offen  |
| T110 | Balancing     | Meteor-Anforderungen balancieren      | Mittel    | T091         | Offen  |

---

# 63. Empfohlene Meilensteine

## Milestone 1 – Movement Prototype

Enthält:

* T001 bis T012

Ziel:

> Der Dino kann per Mausklick durch eine einfache Welt laufen.

---

## Milestone 2 – Hunt Prototype

Enthält:

* T013 bis T020

Ziel:

> Der Spieler kann kleine Beute verfolgen, fressen und XP erhalten.

---

## Milestone 3 – Cave Loop

Enthält:

* T021 bis T025

Ziel:

> Der komplette Loop aus Jagen → XP sammeln → Höhle erreichen → XP sichern funktioniert.

---

## Milestone 4 – Predator

Enthält:

* T026 bis T031

Ziel:

> Der Spieler kann gejagt werden und beim Tod XP verlieren.

---

## Milestone 5 – Ecosystem

Enthält:

* T032 bis T040

Ziel:

> Es entsteht eine erste funktionierende Nahrungskette.

---

## Milestone 6 – Progression

Enthält:

* T041 bis T060

Ziel:

> Spieler und Höhle können verbessert werden.

---

## Milestone 7 – Weather & Disaster

Enthält:

* T061 bis T078

Ziel:

> Regen, Schnee, Erdbeben, Vulkan und Feuer beeinflussen die Welt.

---

## Milestone 8 – Biomes

Enthält:

* T079 bis T084

Ziel:

> Die Welt besitzt mehrere klar unterscheidbare Regionen.

---

## Milestone 9 – Extinction

Enthält:

* T085 bis T093

Ziel:

> Der Meteor baut sich während des Spiels auf und bildet ein vollständiges Finale.

---

## Milestone 10 – Polish

Enthält:

* T094 bis T110

Ziel:

> Audio, Animationen, Feedback, Performance und Balancing verbessern das fertige Spiel.

---

# 64. Wichtigste Designregeln

## Regel 1

Der Spieler soll regelmäßig zwischen Risiko und Sicherheit entscheiden.

```text
noch eine Beute

oder

zur Höhle zurück
```

---

## Regel 2

Große Tiere sind stärker, kleine Tiere sind schneller.

Dadurch bleiben Flucht und Positionierung wichtig.

---

## Regel 3

Die Höhle ist genauso wichtig wie der Dinosaurier.

Das Spiel soll nicht nur daraus bestehen, den Spielercharakter stärker zu machen.

---

## Regel 4

Naturkatastrophen betreffen die gesamte Welt.

Nicht nur der Spieler reagiert darauf.

Auch Tiere, Herden und Räuber verändern ihr Verhalten.

---

## Regel 5

Der Meteor ist kein überraschender Endgegner.

Das gesamte Spiel arbeitet auf ihn hin.

---

# 65. Kurzbeschreibung

> **Extinction Hollow** ist ein prähistorisches Top-Down-Survival-Spiel, in dem ein kleiner Dinosaurier durch Jagen und Fressen wächst, gesammelte XP jedoch zunächst sicher zu seiner Höhle zurückbringen muss. Während die Welt zunehmend von Regen, Schnee, Erdbeben, Vulkanausbrüchen und Feuer erschüttert wird, muss der Spieler entscheiden, ob er seine eigene Stärke oder die Sicherheit seiner Höhle verbessert. Am Ende erscheint ein gigantischer Meteor – und nur eine ausreichend ausgebaute Höhle kann das Aussterben überstehen.

---

# 66. Elevator Pitch

> **Start small. Hunt. Grow. Return home. Build a shelter strong enough to survive extinction.**

# 67. Zukünftiger Multiplayer

Multiplayer ist **nicht Teil des MVP**, soll aber bei grundlegenden Architekturentscheidungen berücksichtigt werden.

Ziel ist, dass später mehrere Spieler gleichzeitig in derselben Welt existieren können.

Jeder Spieler kontrolliert einen eigenen Dinosaurier und besitzt eine eigene Höhle.

---

# 68. Multiplayer-Grundidee

Mehrere Dinosaurier leben gleichzeitig in derselben prähistorischen Welt.

Jeder Spieler:

* beginnt klein,
* jagt Tiere,
* sammelt Biomasse,
* baut seinen Dinosaurier aus,
* besitzt eine eigene Höhle,
* sichert dort XP,
* verteidigt sein Gebiet,
* konkurriert um Nahrung,
* kann andere Spieler jagen,
* und bereitet seine Höhle auf den Meteor vor.

Dadurch entsteht zusätzlich zum PvE-Spiel eine PvP-Ebene.

```text
Natur
+
NPC-Dinosaurier
+
Katastrophen
+
andere Spieler
```

---

# 69. Mehrere Höhlen

Jeder Spieler besitzt eine eigene Höhle.

Beispiel:

```text
Spieler A
→ Höhle A

Spieler B
→ Höhle B

Spieler C
→ Höhle C

Spieler D
→ Höhle D
```

Die Höhlen befinden sich an unterschiedlichen Positionen auf der Karte.

Dadurch entstehen natürliche Territorien.

---

# 70. Territorien

Das Gebiet rund um eine Höhle kann als Heimatgebiet eines Spielers gelten.

Mögliche Auswirkungen:

* leichter Heilbonus,
* schnellere Regeneration,
* Sicht auf nahe Gefahren,
* besserer Schutz,
* schnellerer Höhlenzugang.

Territorien sollen nicht automatisch große Teile der Karte blockieren.

Die Welt bleibt grundsätzlich für alle Spieler zugänglich.

---

# 71. Konkurrenz um Nahrung

Nahrung ist nicht für jeden Spieler separat vorhanden.

Wenn ein Spieler eine Beute frisst, ist sie für andere Spieler zunächst weg.

Dadurch entsteht Konkurrenz um:

* Tierherden,
* Fische,
* seltene Beute,
* sichere Jagdgebiete,
* Wasserstellen.

Beispiel:

```text
große Tierherde erscheint
↓
mehrere Spieler entdecken sie
↓
Wettlauf um Nahrung
```

---

# 72. Spieler gegen Spieler

Dinosaurier können später gegeneinander kämpfen.

Ob ein anderer Spieler sinnvoll angegriffen werden kann, hängt unter anderem ab von:

* Größenklasse,
* Stärke,
* Gesundheit,
* Geschwindigkeit,
* Position.

Ein kleiner Dino sollte einem deutlich größeren Spieler normalerweise entkommen können.

Ein großer Dino ist stärker, aber langsamer.

Damit bleibt dieselbe Designregel erhalten:

```text
klein
=
schnell

groß
=
stark
```

---

# 73. Spieler als Beute

Andere Spieler können Teil der Nahrungskette werden.

Beispiel:

```text
Spieler A
Size 4

Spieler B
Size 2
```

Spieler A kann Spieler B theoretisch jagen.

Der kleinere Spieler besitzt dafür einen deutlichen Geschwindigkeitsvorteil.

---

# 74. PvP-Belohnungen

Das Besiegen eines anderen Spielers darf nicht zu extrem belohnt werden.

Mögliche Belohnungen:

* Teil der getragenen Biomasse,
* Nahrung,
* temporärer Bonus.

Nicht vorgesehen:

```text
komplette Zerstörung des gesamten Spielerfortschritts
```

PvP soll spannend sein, aber Frust begrenzen.

---

# 75. Carried XP im Multiplayer

Carried XP bleibt auch im Multiplayer riskant.

Wird ein Spieler besiegt:

```text
Teil der Carried XP
↓
geht verloren
```

Optional kann ein Teil davon als Biomasse zurückbleiben.

Andere Spieler könnten diese aufnehmen.

Dadurch entstehen riskante Situationen:

```text
Spieler mit viel Biomasse
↓
wird attraktives Ziel
```

---

# 76. Höhlenangriffe

Andere Spieler sollen nicht einfach jederzeit komplette Höhlen zerstören können.

Eine vollständig zerstörbare Basis würde zu starkem Frust führen.

Besser:

Andere Spieler können später bestimmte äußere Strukturen angreifen.

Beispiele:

* Nahrungslager,
* Höhleneingang,
* äußere Schutzstrukturen,
* temporäre Verteidigungen.

Der permanente Kernfortschritt einer Höhle bleibt geschützt.

---

# 77. Höhlenverteidigung

Später mögliche Höhlen-Upgrades:

* stabilerer Eingang,
* enger Eingang für große Dinosaurier,
* bessere Tarnung,
* defensive Felsstrukturen,
* mehrere Zugänge,
* Fluchtweg,
* Nahrungslager.

Ein besonders interessanter Mechanismus:

> Große Dinosaurier können bestimmte kleine Höhleneingänge gar nicht betreten.

Dadurch behalten kleine Dinosaurier eigene taktische Vorteile.

---

# 78. Höhlengröße

Die Entwicklung der Höhle kann mit dem Dinosaurier zusammenhängen.

Beispiel:

```text
kleiner Dino
→ kleiner Höhleneingang

großer Dino
→ größerer Eingang notwendig
```

Ein größerer Eingang bietet:

```text
mehr Komfort
aber
weniger Schutz vor großen Gegnern
```

Damit entsteht ein weiterer Trade-off.

---

# 79. Höhlen entdecken

Andere Höhlen müssen nicht automatisch auf der Karte sichtbar sein.

Ein Spieler muss sie zunächst entdecken.

Mögliche Systeme:

```text
Geruch
Spuren
Fußabdrücke
Geräusche
sichtbarer Eingang
```

Damit wird Erkundung wichtiger.

---

# 80. Spuren

Multiplayer könnte ein Tracking-System erhalten.

Spieler hinterlassen zeitweise:

* Fußspuren,
* Geruchsspuren,
* Blutspuren,
* Fressspuren.

Regen kann Spuren schneller verschwinden lassen.

Schnee dagegen macht Fußspuren besonders deutlich.

Dadurch beeinflusst Wetter auch PvP.

---

# 81. Wetter und Multiplayer

Wetter verändert strategische Situationen.

## Regen

* reduziert Sicht,
* entfernt Spuren,
* dämpft Geräusche.

## Schnee

* erzeugt sichtbare Fußspuren,
* verlangsamt bestimmte Dinosaurier.

## Sturm

* erschwert Wahrnehmung.

## Asche

* reduziert Sicht stark.

Dadurch können Spieler Wetter gezielt für Jagd oder Flucht nutzen.

---

# 82. Katastrophen und Spieler

Katastrophen betreffen alle Spieler gleichzeitig.

Beispiel:

```text
Vulkan bricht aus
↓
Tierherden fliehen
↓
Spieler fliehen ebenfalls
↓
Nahrung konzentriert sich an neuen Orten
↓
Spieler treffen aufeinander
```

Katastrophen erzeugen dadurch natürliche Konfliktzonen.

---

# 83. Temporäre Kooperation

Andere Spieler müssen nicht immer Feinde sein.

Bei großen Katastrophen kann temporäre Zusammenarbeit sinnvoll werden.

Beispiel:

```text
großer Raubdino
↓
mehrere Spieler greifen gemeinsam an
```

oder:

```text
riesige Herde
↓
mehrere Spieler jagen gemeinsam
```

Das Spiel benötigt dafür nicht zwingend feste Teams.

Kooperation kann spontan entstehen.

---

# 84. Gruppen

Optional kann später ein Gruppensystem entstehen.

Spieler können kleine Rudel bilden.

Mögliche Gruppengröße:

```text
2–4 Spieler
```

Rudel können:

* gemeinsam jagen,
* Territorien verteidigen,
* große Beute angreifen,
* Gefahren früher erkennen.

---

# 85. Gemeinsame Höhlen

Eine spätere Alternative zu individuellen Höhlen:

```text
Rudel
↓
gemeinsame Höhle
```

Mehrere Spieler könnten gemeinsam XP beziehungsweise Ressourcen investieren.

Dadurch wird die Höhle größer und widerstandsfähiger.

Dies sollte ein optionaler Spielmodus sein.

---

# 86. Einzelhöhle vs. Rudelhöhle

## Einzelhöhle

Vorteile:

* vollständige Kontrolle,
* leichter zu verstecken,
* kleiner Eingang.

Nachteile:

* langsamerer Ausbau,
* weniger Verteidigung.

## Rudelhöhle

Vorteile:

* schnellerer Ausbau,
* mehrere Verteidiger,
* größere Vorräte.

Nachteile:

* leichter zu entdecken,
* größerer Eingang,
* mehr Konkurrenz innerhalb der Gruppe.

---

# 87. Meteor im Multiplayer

Der Meteor trifft die gesamte Welt gleichzeitig.

Jeder Spieler beziehungsweise jedes Rudel muss seine eigene Höhle vorbereiten.

Kurz vor dem Einschlag entsteht dadurch ein finales Rennen:

```text
letzte Nahrung sammeln
↓
letzte XP sichern
↓
Höhlen-Upgrades abschließen
↓
zur eigenen Höhle zurückkehren
↓
Meteor
```

---

# 88. Konflikte kurz vor dem Meteor

Die Endphase kann besonders spannend werden.

Mehrere Spieler suchen gleichzeitig nach den letzten verfügbaren Ressourcen.

Dadurch entstehen:

* Kämpfe um Nahrung,
* Kämpfe um sichere Routen,
* riskante Jagden,
* unerwartete Kooperationen.

Die Höhle eines Spielers soll dennoch nicht kurz vor Spielende vollständig zerstört werden können.

---

# 89. Multiplayer-Ende

Nach dem Meteoriteneinschlag wird für jeden Spieler beziehungsweise jedes Rudel separat geprüft:

```text
Hat die Höhle überlebt?
```

Mögliche Ergebnisse:

```text
Spieler A
→ überlebt

Spieler B
→ Höhle kollabiert

Spieler C + D
→ gemeinsame Höhle überlebt
```

Dadurch können innerhalb einer Session unterschiedliche Enden entstehen.

---

# 90. Multiplayer-Spielmodi

Später mögliche Modi:

## Survival

Normales Spiel mit mehreren Spielern.

PvP möglich.

---

## Cooperative Survival

Spieler arbeiten gemeinsam.

Kein direktes PvP.

Gemeinsame oder getrennte Höhlen.

---

## Territory Survival

Stärkerer Fokus auf:

* Territorien,
* Höhlen,
* PvP,
* Ressourcen.

---

## Private Session

Für Freundesgruppen.

Beispielsweise:

```text
2–8 Spieler
```

---

# 91. Architektur für spätere Multiplayer-Fähigkeit

Auch wenn Multiplayer zunächst nicht implementiert wird, sollten zentrale Systeme nicht ausschließlich davon ausgehen, dass es genau einen Spieler gibt.

Beispielsweise vermeiden:

```text
global_player
```

als Grundlage sämtlicher Gameplay-Systeme.

Besser:

```text
Entity
→ besitzt eigene ID

Player
→ ist eine Entity

Animal
→ ist eine Entity
```

---

# 92. Eindeutige Entities

Wichtige Spielobjekte sollten eindeutig identifizierbar sein.

Beispiele:

```text
Player ID
Animal ID
Cave ID
Entity ID
```

Das erleichtert später die Synchronisation.

---

# 93. Besitzsystem

Objekte sollten optional einen Besitzer besitzen können.

Beispiel:

```text
Cave
Owner ID = Player 3
```

oder:

```text
Cave
Owner ID = Pack 2
```

Damit können mehrere Höhlen und Gruppen später einfacher unterstützt werden.

---

# 94. Weltzustand

Gameplay-relevante Informationen sollten möglichst klar als Zustände existieren.

Beispiele:

```text
Health
Position
Target
XP
Cave Level
Weather State
Disaster State
```

Dadurch kann der Weltzustand später über ein Netzwerk synchronisiert werden.

---

# 95. Multiplayer nicht vorzeitig implementieren

Für die erste Version gilt weiterhin:

```text
Singleplayer zuerst.
```

Erst wenn folgende Systeme zuverlässig funktionieren:

* Bewegung,
* Jagd,
* Ökosystem,
* XP,
* Höhle,
* Upgrades,
* Wetter,
* Katastrophen,
* Meteor,

soll mit echter Netzwerkfunktionalität begonnen werden.

---

# 96. Erweiterte Multiplayer-Tasks

| ID    | Bereich     | Task                                 | Priorität | Abhängigkeit      | Status  |
| ----- | ----------- | ------------------------------------ | --------- | ----------------- | ------- |
| MP001 | Architektur | Mehrere Player-Entities unterstützen | Später    | Singleplayer Core | Geplant |
| MP002 | Architektur | Entity IDs einführen                 | Später    | MP001             | Geplant |
| MP003 | Architektur | Owner-System für Höhlen              | Später    | MP002             | Geplant |
| MP004 | Netzwerk    | Netzwerk-Grundsystem                 | Später    | Core Game         | Geplant |
| MP005 | Netzwerk    | Spielerposition synchronisieren      | Später    | MP004             | Geplant |
| MP006 | Netzwerk    | Spielerbewegung synchronisieren      | Später    | MP005             | Geplant |
| MP007 | Netzwerk    | Tierzustände synchronisieren         | Später    | MP004             | Geplant |
| MP008 | Netzwerk    | Wetter synchronisieren               | Später    | MP004             | Geplant |
| MP009 | Netzwerk    | Katastrophen synchronisieren         | Später    | MP004             | Geplant |
| MP010 | Höhle       | Mehrere Höhlen unterstützen          | Später    | MP003             | Geplant |
| MP011 | Höhle       | Persönliche Höhlen                   | Später    | MP010             | Geplant |
| MP012 | Höhle       | Rudelhöhlen                          | Optional  | MP010             | Geplant |
| MP013 | PvP         | Spieler angreifbar machen            | Später    | MP006             | Geplant |
| MP014 | PvP         | Größenregeln für PvP                 | Später    | MP013             | Geplant |
| MP015 | PvP         | Biomasse-Drop bei Niederlage         | Später    | MP013             | Geplant |
| MP016 | PvP         | Höhlenschutzregeln                   | Später    | MP010             | Geplant |
| MP017 | Tracking    | Spieler-Fußspuren                    | Optional  | MP006             | Geplant |
| MP018 | Tracking    | Schnee beeinflusst Spuren            | Optional  | MP017             | Geplant |
| MP019 | Tracking    | Regen entfernt Spuren                | Optional  | MP017             | Geplant |
| MP020 | Gruppen     | Rudel erstellen                      | Optional  | MP006             | Geplant |
| MP021 | Gruppen     | Spieler einladen                     | Optional  | MP020             | Geplant |
| MP022 | Gruppen     | Gemeinsame Höhle                     | Optional  | MP020, MP012      | Geplant |
| MP023 | Ressourcen  | Gemeinsame Tierpopulation            | Später    | MP007             | Geplant |
| MP024 | Meteor      | Meteor global synchronisieren        | Später    | MP009             | Geplant |
| MP025 | Meteor      | Höhlen separat auswerten             | Später    | MP024             | Geplant |
| MP026 | Session     | Private Multiplayer-Session          | Später    | MP004             | Geplant |
| MP027 | Session     | Spieler beitreten/verlassen          | Später    | MP026             | Geplant |
| MP028 | UI          | Andere Spieler darstellen            | Später    | MP006             | Geplant |
| MP029 | UI          | Rudelanzeige                         | Optional  | MP020             | Geplant |
| MP030 | Balancing   | PvP-Balancing                        | Später    | MP013             | Geplant |

---

# 97. Multiplayer-Designregel

Multiplayer soll das bestehende Spiel erweitern und nicht ersetzen.

Die zentrale Erfahrung bleibt:

```text
Jagen
↓
XP riskieren
↓
zur Höhle zurückkehren
↓
stärker werden
↓
auf den Meteor vorbereiten
```

Andere Spieler erzeugen lediglich eine zusätzliche Unsicherheit:

```text
Ist dort Beute?

Ist dort ein Raubtier?

Oder ist dort ein anderer Spieler?
```

# 98. Art Direction

Der visuelle Stil von **Extinction Hollow** soll als moderne, detailreiche **HD Pixel Art** umgesetzt werden.

Das Spiel soll klar erkennbar pixelig bleiben, aber deutlich hochwertiger und detailreicher wirken als klassische 8-Bit- oder 16-Bit-Retrospiele.

Ziel ist eine Mischung aus:

- klarer Lesbarkeit,
- schöner Atmosphäre,
- kräftigen Farben,
- detaillierten Umgebungen,
- ausdrucksstarken Dinosauriern,
- und starken Wetter- und Katastropheneffekten.

Die Pixelgrafik soll bewusst modern wirken und nicht wie eine technische Einschränkung.

---

# 99. Grundlegender Grafikstil

Der Stil lässt sich folgendermaßen zusammenfassen:

> **Modern high-resolution pixel art with strong silhouettes, lush prehistoric environments, readable gameplay, atmospheric weather and increasingly apocalyptic visual progression.**

Die Grafik soll:

- detailreich,
- farbenfroh,
- atmosphärisch,
- stilisiert,
- gut lesbar,
- und klar pixelig

sein.

Nicht angestrebt werden:

- fotorealistische Grafik,
- 3D-Look,
- extrem grobe Retro-Pixelgrafik,
- übermäßig cartoonhafte Chibi-Proportionen,
- stark verschwommene oder weichgezeichnete Pixel.

---

# 100. Perspektive

Das Spiel verwendet eine klare **Top-Down-Perspektive**.

Die Kamera blickt überwiegend von oben auf die Welt.

Ein leichter perspektivischer Winkel ist möglich, wenn dadurch Dinosaurier und Umgebung besser lesbar werden.

Wichtig ist, dass:

- Tiere klar voneinander unterscheidbar sind,
- Größenunterschiede sichtbar bleiben,
- Gefahren gut erkannt werden,
- Wege und Hindernisse eindeutig lesbar sind.

---

# 101. Basisauflösung

Die Darstellung soll auf einer festen internen Basisauflösung beruhen.

Empfohlene Ausgangsauflösung:

```text id="a4c9xd"
640 × 360
```

Alternativ:

```text id="q7m2fk"
480 × 270
```

Empfohlen wird:

```text id="z3fcjm"
640 × 360
```

Diese Auflösung bietet ausreichend Platz für:

- detailreiche Pixelgrafik,
- lesbare UI,
- größere Dinosaurier,
- Wettereffekte,
- große Landschaftsbereiche.

---

# 102. Skalierung

Pixelgrafik muss möglichst scharf dargestellt werden.

Bevorzugt wird Integer Scaling.

Beispiele:

```text id="gm37os"
640 × 360
→ 1280 × 720 = 2x

640 × 360
→ 1920 × 1080 = 3x

640 × 360
→ 2560 × 1440 = 4x
```

Nicht ganzzahlige Skalierung soll möglichst vermieden werden.

---

# 103. Texture Filtering

Für Pixelgrafik darf keine weiche Texturfilterung verwendet werden.

Verwenden:

```text id="wpn5l8"
Nearest Neighbor
```

Vermeiden:

```text id="q2z2kg"
Bilinear Filtering
Trilinear Filtering
Blur Filtering
```

Pixelkanten müssen scharf bleiben.

---

# 104. Pixel Snapping

Sprites und Kamera sollen so behandelt werden, dass Subpixel-Flimmern möglichst vermieden wird.

Besonders wichtig bei:

- langsamer Bewegung,
- weicher Kamera,
- Click-to-Move,
- kleinen NPCs,
- dünnen Umgebungsdetails.

Die Bewegung darf intern fließend berechnet werden, die Darstellung soll jedoch möglichst stabil bleiben.

---

# 105. Tile-Größe

Empfohlene Standardgröße:

```text id="6sjb9x"
32 × 32 Pixel
```

32x32 bietet:

- genug Detail,
- überschaubaren Produktionsaufwand,
- gute Modularität,
- klare Pixelstruktur.

Für größere Objekte können mehrere Tiles kombiniert werden.

---

# 106. Spieler-Sprite

Der Spieler-Dinosaurier soll detaillierter als kleine NPCs dargestellt werden.

Empfohlener Sprite-Bereich:

```text id="9he348"
48 × 48
bis
64 × 64 Pixel
```

Je nach Dinosauriergröße kann der sichtbare Sprite später größer werden.

Der Spieler muss auch bei dichter Vegetation sofort erkennbar bleiben.

---

# 107. Kleine Tiere

Kleine Tiere verwenden ungefähr:

```text id="5y6ryv"
16 × 16
bis
32 × 32 Pixel
```

Beispiele:

- Insekten,
- kleine Echsen,
- kleine Fische,
- kleine Säugetiere.

Die Silhouette ist wichtiger als sehr feine Details.

---

# 108. Mittlere Tiere

Mittlere Tiere verwenden ungefähr:

```text id="kw9rjt"
40 × 40
bis
64 × 64 Pixel
```

Sie sollen bereits deutlich mehr visuelle Details besitzen.

---

# 109. Große Dinosaurier

Große Dinosaurier können deutlich größere Sprites verwenden.

Beispiel:

```text id="u18iwk"
64 × 64
bis
128 × 128 Pixel
```

Sehr große Tiere dürfen bewusst große Teile des Bildschirms einnehmen.

Dadurch soll ihre Bedrohlichkeit sofort sichtbar werden.

---

# 110. Größenwirkung

Größenklassen müssen visuell deutlich erkennbar sein.

Ein großer Raubdinosaurier soll nicht nur statistisch stärker sein.

Er muss sichtbar:

- massiver,
- schwerer,
- langsamer,
- gefährlicher

wirken.

Ein kleiner Dinosaurier soll:

- kompakt,
- leicht,
- schnell,
- wendig

wirken.

---

# 111. Silhouetten

Jede Tierart benötigt eine möglichst eindeutige Silhouette.

Der Spieler soll Tiere auch ohne UI schnell erkennen können.

Unterschiede entstehen beispielsweise durch:

- Körperlänge,
- Schwanzform,
- Kopfgröße,
- Haltung,
- Rückenform,
- Beine,
- Hörner,
- Panzerung,
- Farbe.

Silhouette und Lesbarkeit haben Vorrang vor biologischer Detailgenauigkeit.

---

# 112. Farbgebung

Die Farben sollen anfangs lebendig und kräftig sein.

Bevorzugt:

- satte Grüntöne,
- warme Erdfarben,
- blaugrünes Wasser,
- farbige Dinosaurier,
- deutliche Kontraste.

Die Welt soll zu Beginn schön und lebendig wirken.

Dadurch entsteht später ein stärkerer Kontrast zur kommenden Katastrophe.

---

# 113. Visuelle Entwicklung der Welt

Die Farbpalette verändert sich mit dem Weltfortschritt.

## Frühes Spiel

- sattes Grün,
- warmes Sonnenlicht,
- klares Wasser,
- leuchtende Pflanzen,
- hohe Farbsättigung.

## Mittleres Spiel

- mehr Schatten,
- stärkere Kontraste,
- häufigerer Regen,
- dunklere Böden,
- mehr Nebel.

## Spätes Spiel

- Asche,
- verbrannte Vegetation,
- orange-rotes Licht,
- dunkler Himmel,
- sichtbarer Meteor,
- Feuer,
- Lava,
- Rauch.

## Finale

Die Welt soll beinahe apokalyptisch wirken.

```text id="l71coa"
Grün
↓
Dunkelgrün
↓
Grau
↓
Orange / Rot
↓
Asche / Feuer
↓
Meteor
```

---

# 114. Biome – Visuelle Identität

Jedes Biom muss auf den ersten Blick erkennbar sein.

## Dschungel

- sattes Grün,
- große Blätter,
- Farne,
- dichter Bodenbewuchs,
- kleine Wasserstellen,
- warme Lichtstimmung.

## Flussgebiet

- blaugrünes Wasser,
- helle Ufer,
- Steine,
- Pflanzen am Wasser,
- sichtbare Fische.

## Sumpf

- dunkles Wasser,
- Schlamm,
- tote Äste,
- Moos,
- Nebel.

## Ebene

- offene Flächen,
- Gräser,
- wenig Deckung,
- große Sichtweite.

## Vulkanregion

- dunkles Gestein,
- Rot- und Orangetöne,
- Lava,
- Rauch,
- Asche,
- verbrannte Pflanzen.

## Gebirge

- graue Felsen,
- starke Höhenunterschiede,
- enge Wege,
- karge Vegetation.

## Schneeregion

- Weiß,
- Blau,
- graue Felsen,
- vereiste Wasserflächen,
- kaltes Licht.

---

# 115. Vegetation

Vegetation soll reichhaltig wirken, darf das Gameplay aber nicht verdecken.

Verwenden:

- Farne,
- Büsche,
- große Blätter,
- prähistorische Pflanzen,
- Bäume,
- Pilze,
- Gräser,
- Wasserpflanzen.

Einige Pflanzen dürfen leicht animiert sein.

Beispiele:

```text id="7sqh4u"
Blätter bewegen sich
Gräser reagieren
Farne wippen
Bäume bewegen sich im Wind
```

---

# 116. Vegetations-Layer

Dichte Vegetation soll aus mehreren visuellen Ebenen bestehen.

Beispiel:

```text id="423xsi"
Boden
↓
kleine Pflanzen
↓
Dinosaurier
↓
hohe Pflanzen
↓
Baumkronen
```

Große Objekte können den Spieler teilweise verdecken.

Die Spielerposition muss trotzdem verständlich bleiben.

Optional können verdeckende Objekte transparent werden.

---

# 117. Wasser

Wasser soll sichtbar animiert sein.

Elemente:

- kleine Wellen,
- Reflexionen,
- Strömung,
- Wasserpflanzen,
- Fische unter der Oberfläche.

Flüsse sollen sich visuell deutlich von Seen und Sümpfen unterscheiden.

---

# 118. Bewegung im Wasser

Wenn Tiere durch flaches Wasser laufen:

- kleine Wellen,
- Spritzer,
- helle Wasserringe.

Diese Effekte sollen pixelig und klar lesbar bleiben.

---

# 119. Regen

Regen soll ein wichtiger visueller Effekt sein.

Darstellung:

- diagonale Pixel-Regenstreifen,
- kleine Spritzer auf Boden und Wasser,
- dunklere Bodenfarben,
- stärkere Wasseranimation.

Starker Regen darf die Sicht leicht reduzieren.

---

# 120. Schnee

Schnee wird über mehrere Ebenen dargestellt.

Beispiele:

- Schneeflocken im Vordergrund,
- kleinere Flocken im Hintergrund,
- schneebedeckte Landschaft,
- Schnee auf Objekten.

Optional später:

- Fußspuren,
- Schneeverdrängung,
- tiefer Schnee.

---

# 121. Asche

Aschepartikel ähneln Schnee, wirken aber:

- dunkler,
- langsamer,
- unregelmäßiger.

Während extremer Vulkanaktivität kann die Welt zunehmend von Asche bedeckt werden.

---

# 122. Feuer

Pixel-Feuer soll stark animiert sein.

Eigenschaften:

- klare Orange-/Gelbtöne,
- dunkler Rauch,
- flackerndes Licht,
- kleine Funken.

Feuerzonen müssen eindeutig als gefährlich erkennbar sein.

---

# 123. Lava

Lava soll visuell sehr auffällig sein.

Elemente:

- heller Kern,
- dunklere rote Ränder,
- langsame Bewegung,
- Glühen,
- kleine Partikel.

Lava soll einen starken Kontrast zur dunklen Vulkanlandschaft bilden.

---

# 124. Erdbeben

Erdbeben werden hauptsächlich über Bewegung und Effekte vermittelt.

Mögliche Darstellung:

- Kamera-Shake,
- kleine Staubwolken,
- fallende Steine,
- Bodenrisse,
- bewegte Vegetation.

Effekte sollen die Lesbarkeit nicht komplett zerstören.

---

# 125. Meteor

Der Meteor ist eines der wichtigsten visuellen Elemente des Spiels.

Er entwickelt sich über mehrere Phasen.

## Anfang

```text id="5cw7rv"
kleiner heller Punkt am Himmel
```

## Später

```text id="xjze1k"
deutlich sichtbarer Lichtpunkt
```

## Endgame

```text id="ot4ca4"
großer glühender Himmelskörper
```

Kurz vor dem Einschlag:

- Himmel verändert Farbe,
- Licht wird ungewöhnlich,
- Schatten werden stärker,
- Feuer und Vulkanaktivität nehmen zu.

---

# 126. Meteor-Einschlag

Der Einschlag soll der visuell stärkste Moment des Spiels sein.

Mögliche Elemente:

```text id="b8jwkc"
extremer Lichtblitz
↓
kurze Stille
↓
Druckwelle
↓
Kamera-Shake
↓
Feuer
↓
Staub
↓
Dunkelheit
```

Die Sequenz kann bewusst größer und dramatischer als das normale Gameplay inszeniert werden.

---

# 127. Höhle

Die Höhle ist der wichtigste Ort des Spiels und muss visuell sofort wiedererkennbar sein.

Sie soll sich von normalen Felsen deutlich unterscheiden.

Mögliche Merkmale:

- markanter Eingang,
- besondere Felsformation,
- Knochen oder Pflanzen,
- sichtbare Spuren des Spielers.

---

# 128. Höhlenentwicklung

Die Höhle verändert ihr Aussehen bei Upgrades.

## Frühe Höhle

- kleiner Eingang,
- natürliche Felsen,
- wenig Platz.

## Mittlere Höhle

- größerer Innenraum,
- stärkere Strukturen,
- Lagerbereiche.

## Späte Höhle

- tiefe Kammern,
- massive Felswände,
- deutlich sichtbare Verstärkung,
- großer Schutzraum.

Der Spieler soll den Fortschritt visuell erkennen können.

---

# 129. XP-Effekt

Carried XP beziehungsweise Biomasse darf visuell dezent am Spieler dargestellt werden.

Beim Betreten der Höhle:

```text id="m37hc6"
Dino
↓
Pixel-Partikel
↓
Höhle
```

Die Partikel können:

- kurz leuchten,
- in Höhlenwände wandern,
- Höhlen-Upgrades auslösen.

---

# 130. Animation der Dinosaurier

Animationen sollen flüssig wirken, aber weiterhin klar als Pixelanimation erkennbar bleiben.

Mindestens vorgesehen:

```text id="7j9e8u"
Idle
Walk
Run
Eat
Attack
Hurt
Death
```

Optional:

```text id="eokvvv"
Sleep
Drink
Roar
Sniff
Rest
```

---

# 131. Animationsumfang

Für normale Tiere reichen zunächst wenige Frames.

Beispiel:

```text id="h6t7py"
Walk:
4–8 Frames
```

Der Spieler-Dinosaurier darf mehr Animationsframes erhalten als gewöhnliche NPCs.

Große Räuber sollen durch bewusst schwere Bewegungen wirken.

---

# 132. Bewegungsgefühl

Animation und Geschwindigkeit müssen zusammenpassen.

Kleine Tiere:

- schnelle Schritte,
- kurze Animationen,
- schnelle Richtungswechsel.

Große Tiere:

- langsame Schritte,
- stärkere Körperbewegung,
- mehr Gewicht.

---

# 133. Richtungssprites

Abhängig vom Produktionsaufwand können Tiere mehrere Blickrichtungen besitzen.

Minimum:

```text id="h6qam3"
4 Richtungen
```

Bevorzugt:

```text id="ybyub3"
8 Richtungen
```

Für hochwertigere Hauptfiguren kann eine 8-Richtungs-Darstellung verwendet werden.

---

# 134. Schatten

Dinosaurier und größere Objekte sollen einfache Pixelschatten besitzen.

Schatten helfen bei:

- Tiefenwirkung,
- Positionserkennung,
- Größenwirkung.

Die Schatten dürfen stilisiert sein.

---

# 135. Partikeleffekte

Partikeleffekte sollen einen wichtigen Teil des visuellen Feedbacks bilden.

Beispiele:

- Staub beim Rennen,
- Blätter,
- Wasser,
- Schnee,
- Regen,
- Asche,
- Feuerfunken,
- Lava,
- XP,
- Blut,
- Einschlagsstaub.

Nicht zu viele Partikel gleichzeitig darstellen.

Lesbarkeit bleibt wichtiger als Effektmenge.

---

# 136. UI-Stil

Die Benutzeroberfläche soll zum Pixel-Art-Stil passen.

Verwenden:

- klare Pixelrahmen,
- reduzierte Flächen,
- gut lesbare Symbole,
- Pixel-Font oder passende Bitmap-Schrift.

Die UI soll moderner wirken als klassische Retro-Menüs.

---

# 137. HUD

Das HUD bleibt möglichst unaufdringlich.

Es soll nicht große Teile der Welt verdecken.

Mögliche Darstellung:

```text id="5gbdyj"
Health
Stamina
Hunger
Carried XP
```

als kleine, klare Pixelanzeigen.

---

# 138. Warnungen

Katastrophenwarnungen sollen atmosphärisch wirken.

Keine moderne Smartphone-Optik.

Beispielsweise:

```text id="s6l75d"
The ground begins to shake...
```

mit:

- dezenter Textanimation,
- Kameraeffekten,
- Geräuschen,
- Umweltreaktionen.

---

# 139. Cursor

Der Mauszeiger erhält einen eigenen Pixel-Art-Stil.

Mögliche Varianten:

```text id="bp4sp8"
Move
Hunt
Danger
Cave
Interact
```

Der Cursor muss klein genug bleiben, um die Sicht nicht zu behindern.

---

# 140. Farbfeedback bei Beute

Essbare Tiere sollen nicht dauerhaft mit grellen Umrandungen versehen werden.

Bevorzugt wird natürliches visuelles Feedback.

Optional:

- dezentes Highlight beim Hover,
- Cursoränderung,
- kleine Kontur,
- kurze Größenanzeige.

Die Welt soll nicht wie ein UI voller Marker aussehen.

---

# 141. Beleuchtung

Beleuchtung kann stilisiert genutzt werden.

Beispiele:

- warme Sonne,
- dunkler Regen,
- orange Vulkanlicht,
- kaltes Schneelicht,
- rotes Meteorlicht.

Licht soll die Atmosphäre verstärken, ohne die Pixelgrafik weichzuzeichnen.

---

# 142. Tageszeit

Ein vollständiger Tag-Nacht-Zyklus ist optional.

Wenn implementiert:

```text id="i1fu9g"
Morgen
Tag
Abend
Nacht
```

Nacht sollte andere Gefahren und visuelle Situationen erzeugen.

Dieses System ist kein MVP-Feature.

---

# 143. Pixel-Art-Konsistenz

Alle Grafiken müssen dieselbe Pixelsprache verwenden.

Zu vermeiden:

- unterschiedlich große Pixel innerhalb derselben Szene,
- weich skalierte Sprites,
- hochauflösende Effekte auf Pixelgrafik,
- unscharfe UI,
- unterschiedliche Perspektiven.

Alle Assets müssen optisch zusammenpassen.

---

# 144. Asset-Priorität

Grafiken werden in folgender Reihenfolge priorisiert:

```text id="mgllow"
Spieler
↓
Beute
↓
Raubtier
↓
Höhle
↓
Dschungel
↓
Wasser
↓
Wetter
↓
weitere Biome
↓
Katastrophen
↓
Polish
```

---

# 145. Art-MVP

Für den ersten visuellen Prototyp reichen:

- ein Spieler-Dino,
- ein kleines Beutetier,
- ein großer Raubdino,
- ein Fisch,
- Höhleneingang,
- Dschungelboden,
- einige Pflanzen,
- Wasser,
- einfache Felsen,
- Regen,
- einfache XP-Partikel.

Alle übrigen Grafiken können zunächst Placeholder sein.

---

# 146. Art-Tasks

| ID | Bereich | Task | Priorität | Abhängigkeit | Status |
|---|---|---|---|---|---|
| ART001 | Style | Pixel-Art-Styleguide definieren | Hoch | – | Offen |
| ART002 | Tech | Basisauflösung festlegen | Hoch | ART001 | Offen |
| ART003 | Tech | Nearest-Neighbor aktivieren | Hoch | ART002 | Offen |
| ART004 | Tech | Pixel-Snapping testen | Hoch | ART002 | Offen |
| ART005 | Tiles | 32x32 Tile-Standard festlegen | Hoch | ART001 | Offen |
| ART006 | Player | Placeholder-Dino erstellen | Hoch | ART001 | Offen |
| ART007 | Player | finalen Player-Sprite entwerfen | Hoch | ART006 | Offen |
| ART008 | Player | Idle-Animation | Hoch | ART007 | Offen |
| ART009 | Player | Walk-Animation | Hoch | ART007 | Offen |
| ART010 | Player | Run-Animation | Mittel | ART009 | Offen |
| ART011 | Player | Eat-Animation | Mittel | ART007 | Offen |
| ART012 | Player | Hurt-Animation | Mittel | ART007 | Offen |
| ART013 | Player | Death-Animation | Mittel | ART007 | Offen |
| ART014 | Animals | kleines Beutetier | Hoch | ART001 | Offen |
| ART015 | Animals | Beutetier-Animationen | Hoch | ART014 | Offen |
| ART016 | Animals | großer Raubdino | Hoch | ART001 | Offen |
| ART017 | Animals | Raubdino-Animationen | Hoch | ART016 | Offen |
| ART018 | Fish | Fisch-Sprite | Mittel | ART001 | Offen |
| ART019 | Fish | Fisch-Animation | Mittel | ART018 | Offen |
| ART020 | Cave | Höhleneingang Level 1 | Hoch | ART001 | Offen |
| ART021 | Cave | Höhlen-Level-Varianten | Mittel | ART020 | Offen |
| ART022 | Jungle | Dschungel-Bodentiles | Hoch | ART005 | Offen |
| ART023 | Jungle | Pflanzen-Set | Hoch | ART022 | Offen |
| ART024 | Jungle | Baum-Set | Mittel | ART022 | Offen |
| ART025 | Water | Wasser-Tiles | Hoch | ART005 | Offen |
| ART026 | Water | Wasseranimation | Mittel | ART025 | Offen |
| ART027 | Rocks | Felsen-Set | Mittel | ART005 | Offen |
| ART028 | Weather | Regen-Effekt | Hoch | ART001 | Offen |
| ART029 | Weather | Schnee-Effekt | Mittel | ART001 | Offen |
| ART030 | Weather | Asche-Effekt | Mittel | ART001 | Offen |
| ART031 | Volcano | Lava-Tiles | Mittel | ART005 | Offen |
| ART032 | Volcano | Feueranimation | Mittel | ART001 | Offen |
| ART033 | Volcano | Rauch und Funken | Niedrig | ART032 | Offen |
| ART034 | Disaster | Erdbeben-Partikel | Mittel | ART001 | Offen |
| ART035 | Meteor | Meteor-Frühphase | Mittel | ART001 | Offen |
| ART036 | Meteor | Meteor-Endphase | Hoch | ART035 | Offen |
| ART037 | Meteor | Einschlagssequenz | Hoch | ART036 | Offen |
| ART038 | UI | Pixel-UI-Styleguide | Mittel | ART001 | Offen |
| ART039 | UI | HUD | Hoch | ART038 | Offen |
| ART040 | UI | Cursor-Set | Mittel | ART038 | Offen |
| ART041 | FX | XP-Partikel | Mittel | ART001 | Offen |
| ART042 | FX | Laufstaub | Niedrig | ART001 | Offen |
| ART043 | FX | Wasserspritzer | Niedrig | ART025 | Offen |
| ART044 | FX | Blut-Effekt | Niedrig | ART001 | Offen |
| ART045 | Polish | Umgebungsanimationen | Niedrig | ART023 | Offen |

---

# 147. Visuelle Leitregel

Jedes grafische Element muss mindestens eines von drei Zielen erfüllen:

```text id="abmxtf"
Gameplay besser lesbar machen

oder

Atmosphäre verstärken

oder

die Welt lebendiger wirken lassen
```

Effekte, die nur spektakulär aussehen, aber das Gameplay schwerer lesbar machen, sollen vermieden werden.

---

# 148. Finale Art Vision

**Extinction Hollow** soll sich visuell anfühlen wie eine wunderschöne prähistorische Pixelwelt, die der Spieler zunächst entdecken und genießen möchte.

Im Verlauf des Spiels wird dieselbe Welt jedoch zunehmend instabil.

```text id="l2rxj8"
lebendiger Dschungel
↓
Regen
↓
Stürme
↓
Erdbeben
↓
Vulkane
↓
Feuer
↓
Asche
↓
roter Himmel
↓
Meteor
↓
Aussterben
```

Gerade weil die Welt zu Beginn farbenfroh und schön ist, soll ihre spätere Zerstörung emotional stärker wirken.
