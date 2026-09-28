# EXTINCTION HOLLOW

**Genre:** 2D Top-Down Prehistoric Survival / Evolution
**Perspektive:** 3/4 Top-Down
**Engine:** Godot 4.x (GDScript)
**Art Direction:** Atmospheric HD Pixel Art
**Steuerung:** Primär Maus
**Arbeitstitel:** **Extinction Hollow**

> **Hunt. Grow. Return. Survive the end.**

> **Plan-Update „Visual Direction & Engine“ (§149):** Engine, Perspektive, Art Direction, Weltaufbau, Beleuchtung und Rendering wurden überarbeitet. Bei Widersprüchen gilt §149 vor den älteren Abschnitten.

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

> **Aktualisiert durch §149:** Die visuelle Richtung ist festgelegt (Atmospheric HD Pixel Art, 3/4 Top-Down). Art wird nicht mehr später entwickelt, sondern früh über den Visual Vertical Slice validiert (§149.33–§149.40).

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

> **Umgesetzt in §153:** Dschungel, Regen, Dinosaurier, Angriffe, Vulkan, Erdbeben und Meteor (T094–T099).

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

| ID   | Bereich       | Task                                  | Priorität | Abhängigkeit | Status   |
| ---- | ------------- | ------------------------------------- | --------- | ------------ | -------- |
| T001 | Projekt       | Grundprojekt erstellen                | Hoch      | –            | Erledigt |
| T002 | Player        | Spielerobjekt erstellen               | Hoch      | T001         | Erledigt |
| T003 | Input         | Mausklick erkennen                    | Hoch      | T002         | Erledigt |
| T004 | Movement      | Click-to-Move implementieren          | Hoch      | T003         | Erledigt |
| T005 | Movement      | Neue Klickposition ersetzt altes Ziel | Hoch      | T004         | Erledigt |
| T006 | Movement      | Spieler stoppt am Ziel                | Hoch      | T004         | Erledigt |
| T007 | Movement      | Weiche Drehung zur Bewegungsrichtung  | Mittel    | T004         | Erledigt |
| T008 | Kamera        | Kamera folgt Spieler                  | Hoch      | T002         | Erledigt |
| T009 | Kamera        | Weiches Kamerafolgen                  | Mittel    | T008         | Erledigt |
| T010 | Kamera        | Maus-Zoom                             | Niedrig   | T008         | Erledigt |
| T011 | Welt          | Kleine Testmap erstellen              | Hoch      | T001         | Erledigt |
| T012 | Welt          | Kollisionsbereiche                    | Hoch      | T011         | Erledigt |
| T013 | Beute         | Kleines Beutetier erstellen           | Hoch      | T011         | Erledigt |
| T014 | KI            | Wander-Verhalten                      | Hoch      | T013         | Erledigt |
| T015 | KI            | Flucht vor Spieler                    | Hoch      | T014         | Erledigt |
| T016 | Interaktion   | Beute per Klick auswählen             | Hoch      | T013         | Erledigt |
| T017 | Jagd          | Beute automatisch verfolgen           | Hoch      | T016         | Erledigt |
| T018 | Fressen       | Beute fressen                         | Hoch      | T017         | Erledigt |
| T019 | XP            | XP-Wert pro Tier                      | Hoch      | T018         | Erledigt |
| T020 | XP            | Carried XP implementieren             | Hoch      | T019         | Erledigt |
| T021 | Höhle         | Höhlenobjekt erstellen                | Hoch      | T011         | Erledigt |
| T022 | Höhle         | Höhleneingang erkennen                | Hoch      | T021         | Erledigt |
| T023 | Höhle         | Höhle per Klick ansteuern             | Mittel    | T021         | Erledigt |
| T024 | XP            | Carried XP in Banked XP umwandeln     | Hoch      | T022, T020   | Erledigt |
| T025 | Save          | Speichern in Höhle                    | Mittel    | T024         | Erledigt |
| T026 | Gegner        | Großen Raubdino erstellen             | Hoch      | T011         | Erledigt |
| T027 | KI            | Raubdino erkennt Spieler              | Hoch      | T026         | Erledigt |
| T028 | KI            | Raubdino verfolgt Spieler             | Hoch      | T027         | Erledigt |
| T029 | Kampf         | Raubdino verursacht Schaden           | Hoch      | T028         | Erledigt |
| T030 | Player        | Spielertod                            | Hoch      | T029         | Erledigt |
| T031 | XP            | Carried XP bei Tod verlieren          | Hoch      | T030         | Erledigt |
| T032 | Nahrungskette | Größenklassen erstellen               | Hoch      | T013, T026   | Erledigt |
| T033 | Nahrungskette | Essbarkeit nach Größe prüfen          | Hoch      | T032         | Erledigt |
| T034 | KI            | NPC jagt NPC                          | Mittel    | T032         | Erledigt |
| T035 | KI            | Flee-State für NPCs                   | Mittel    | T034         | Erledigt |
| T036 | Wasser        | Wassergebiet erstellen                | Mittel    | T011         | Erledigt |
| T037 | Fisch         | Fisch-NPC erstellen                   | Mittel    | T036         | Erledigt |
| T038 | Fisch         | Fischbewegung                         | Mittel    | T037         | Erledigt |
| T039 | Fisch         | Fisch flieht vor Spieler              | Mittel    | T038         | Erledigt |
| T040 | Fisch         | Fisch fangen und fressen              | Mittel    | T039         | Erledigt |
| T041 | Player        | Hunger-System                         | Mittel    | T018         | Erledigt |
| T042 | Player        | Stamina-System                        | Mittel    | T004         | Erledigt |
| T043 | Player        | Sprint-System                         | Niedrig   | T042         | Erledigt |
| T044 | Upgrades      | Upgrade-System Grundstruktur          | Hoch      | T024         | Erledigt |
| T045 | Upgrades      | Health Upgrade                        | Mittel    | T044         | Erledigt |
| T046 | Upgrades      | Speed Upgrade                         | Mittel    | T044         | Erledigt |
| T047 | Upgrades      | Bite Upgrade                          | Mittel    | T044         | Erledigt |
| T048 | Upgrades      | Size Upgrade                          | Hoch      | T044, T032   | Erledigt |
| T049 | Höhle         | Cave-Level-System                     | Hoch      | T024         | Erledigt |
| T050 | Höhle         | Cave Strength                         | Hoch      | T049         | Erledigt |
| T051 | Höhle         | Cave Depth                            | Mittel    | T049         | Erledigt |
| T052 | Höhle         | Heat Resistance                       | Mittel    | T049         | Erledigt |
| T053 | Höhle         | Earthquake Resistance                 | Mittel    | T049         | Erledigt |
| T054 | Höhle         | Cold Resistance                       | Niedrig   | T049         | Erledigt |
| T055 | UI            | Health-Anzeige                        | Hoch      | T002         | Erledigt |
| T056 | UI            | Stamina-Anzeige                       | Mittel    | T042         | Erledigt |
| T057 | UI            | Hunger-Anzeige                        | Mittel    | T041         | Erledigt |
| T058 | UI            | Carried-XP-Anzeige                    | Hoch      | T020         | Erledigt |
| T059 | UI            | Banked-XP-Anzeige                     | Hoch      | T024         | Erledigt |
| T060 | UI            | Cave-Level-Anzeige                    | Mittel    | T049         | Erledigt |
| T061 | Wetter        | Weather-System Grundstruktur          | Hoch      | T011         | Erledigt |
| T062 | Wetter        | Clear State                           | Mittel    | T061         | Erledigt |
| T063 | Wetter        | Regen                                 | Hoch      | T061         | Erledigt |
| T064 | Wetter        | Starkregen                            | Niedrig   | T063         | Erledigt |
| T065 | Wetter        | Schnee                                | Mittel    | T061         | Erledigt |
| T066 | Wetter        | Asche                                 | Mittel    | T061         | Erledigt |
| T067 | Kälte         | Temperatur-System                     | Niedrig   | T065         | Erledigt |
| T068 | Katastrophe   | Disaster-System Grundstruktur         | Hoch      | T011         | Erledigt |
| T069 | Erdbeben      | Erdbeben-Event                        | Hoch      | T068         | Erledigt |
| T070 | Erdbeben      | Kamera-Shake                          | Mittel    | T069         | Erledigt |
| T071 | Erdbeben      | Schaden durch Erdbeben                | Mittel    | T069         | Erledigt |
| T072 | Erdbeben      | NPC-Flucht                            | Mittel    | T069, T035   | Erledigt |
| T073 | Vulkan        | Vulkanregion                          | Mittel    | T011         | Erledigt |
| T074 | Vulkan        | Vulkanwarnung                         | Mittel    | T073         | Erledigt |
| T075 | Vulkan        | Eruption                              | Mittel    | T074         | Erledigt |
| T076 | Feuer         | Feuerzonen                            | Mittel    | T075         | Erledigt |
| T077 | Feuer         | Feuerschaden                          | Mittel    | T076         | Erledigt |
| T078 | Feuer         | NPC-Reaktion auf Feuer                | Niedrig   | T076, T035   | Erledigt |
| T079 | Biome         | Dschungel-Biom                        | Hoch      | T011         | Erledigt |
| T080 | Biome         | Fluss-Biom                            | Mittel    | T036         | Erledigt |
| T081 | Biome         | Sumpf-Biom                            | Niedrig   | T036         | Erledigt |
| T082 | Biome         | Ebene                                 | Niedrig   | T011         | Erledigt |
| T083 | Biome         | Vulkan-Biom                           | Mittel    | T073         | Erledigt |
| T084 | Biome         | Schnee-Biom                           | Mittel    | T065         | Erledigt |
| T085 | Progression   | Weltphasen-System                     | Hoch      | T061, T068   | Erledigt |
| T086 | Progression   | Gefahren mit Zeit erhöhen             | Mittel    | T085         | Erledigt |
| T087 | Meteor        | Meteor-Vorzeichen                     | Hoch      | T085         | Erledigt |
| T088 | Meteor        | Meteor sichtbar machen                | Mittel    | T087         | Erledigt |
| T089 | Meteor        | Finale Warnphase                      | Hoch      | T087         | Erledigt |
| T090 | Meteor        | Meteoreinschlag                       | Hoch      | T089         | Erledigt |
| T091 | Meteor        | Höhlenprüfung                         | Hoch      | T090, T049   | Erledigt |
| T092 | Meteor        | Erfolgsende                           | Hoch      | T091         | Erledigt |
| T093 | Meteor        | Game-Over-Ende                        | Hoch      | T091         | Erledigt |
| T094 | Audio         | Dschungel-Ambiente                    | Niedrig   | T079         | Erledigt |
| T095 | Audio         | Regen-Sound                           | Niedrig   | T063         | Erledigt |
| T096 | Audio         | Tier-Sounds                           | Niedrig   | T013         | Erledigt |
| T097 | Audio         | Erdbeben-Sound                        | Niedrig   | T069         | Erledigt |
| T098 | Audio         | Vulkan-Sound                          | Niedrig   | T075         | Erledigt |
| T099 | Audio         | Meteor-Sound                          | Niedrig   | T090         | Erledigt |
| T100 | Polish        | Cursor-Zustände                       | Niedrig   | T016         | Offen    |
| T101 | Polish        | XP-Partikel bei Höhle                 | Niedrig   | T024         | Offen    |
| T102 | Polish        | Höhlenvisual verändert sich           | Mittel    | T049         | Erledigt |
| T103 | Polish        | Dino wächst sichtbar                  | Mittel    | T048         | Erledigt |
| T104 | Performance   | Spawn-Limits                          | Mittel    | T034         | Erledigt |
| T105 | Performance   | NPC-Despawn                           | Mittel    | T104         | Offen    |
| T106 | Performance   | vereinfachte Fern-KI                  | Niedrig   | T104         | Offen    |
| T107 | Balancing     | XP-Werte balancieren                  | Mittel    | T044         | Offen    |
| T108 | Balancing     | Tiergeschwindigkeiten balancieren     | Mittel    | T034         | Offen    |
| T109 | Balancing     | Höhlenkosten balancieren              | Mittel    | T049         | Offen    |
| T110 | Balancing     | Meteor-Anforderungen balancieren      | Mittel    | T091         | Offen    |

---

# 63. Empfohlene Meilensteine

> **Aktualisiert durch §149.40 und §149.42:** Vor Milestone 1 wird **Milestone 0 – Visual Identity** eingefügt. Neue Reihenfolge: Grundbewegung → Visual Vertical Slice → Gameplay Core → weitere Art-Produktion → Weltaufbau.
>
> **Stand:** Milestone 0 bis 9 und 8b sind erledigt, Milestone 10 ist in Arbeit (siehe §152).

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

> **Aktualisiert durch §149.4–§149.7:** Die Perspektive ist jetzt **3/4 Top-Down**, zwischen klassischem Top-Down und starker Isometrie, ohne starres Isometric-Grid und mit sichtbaren Höhenunterschieden.

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

> **Aktualisiert durch §149.38:** 640 × 360 ist nur noch ein Ausgangspunkt. Die endgültige interne Renderauflösung entscheidet der Visual Vertical Slice.

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

> **Aktualisiert durch §149.38:** 32 × 32 ist nur noch ein Ausgangspunkt. Die endgültige Tile-Größe entscheidet der Visual Vertical Slice (UPDATE029).

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

> **Aktualisiert durch §149.10:** Beleuchtung ist kein optionaler Effekt mehr, sondern zentraler Bestandteil des Artstyles.

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

> **Aktualisiert durch §149.34:** Der erste visuelle Prototyp ist jetzt der Visual Vertical Slice im neuen Stil. Placeholder-Grafik reicht dafür nicht mehr.

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

> **Aktualisiert durch §149.41 (UPDATE030):** Diese Tasks werden an die neue visuelle Richtung angepasst.

| ID | Bereich | Task | Priorität | Abhängigkeit | Status |
|---|---|---|---|---|---|
| ART001 | Style | Pixel-Art-Styleguide definieren | Hoch | – | Erledigt |
| ART002 | Tech | Basisauflösung festlegen | Hoch | ART001 | Erledigt |
| ART003 | Tech | Nearest-Neighbor aktivieren | Hoch | ART002 | Erledigt |
| ART004 | Tech | Pixel-Snapping testen | Hoch | ART002 | Erledigt |
| ART005 | Tiles | 32x32 Tile-Standard festlegen | Hoch | ART001 | Erledigt |
| ART006 | Player | Placeholder-Dino erstellen | Hoch | ART001 | Erledigt |
| ART007 | Player | finalen Player-Sprite entwerfen | Hoch | ART006 | Erledigt |
| ART008 | Player | Idle-Animation | Hoch | ART007 | Erledigt |
| ART009 | Player | Walk-Animation | Hoch | ART007 | Erledigt |
| ART010 | Player | Run-Animation | Mittel | ART009 | Teilweise |
| ART011 | Player | Eat-Animation | Mittel | ART007 | Erledigt |
| ART012 | Player | Hurt-Animation | Mittel | ART007 | Teilweise |
| ART013 | Player | Death-Animation | Mittel | ART007 | Teilweise |
| ART014 | Animals | kleines Beutetier | Hoch | ART001 | Erledigt |
| ART015 | Animals | Beutetier-Animationen | Hoch | ART014 | Erledigt |
| ART016 | Animals | großer Raubdino | Hoch | ART001 | Erledigt |
| ART017 | Animals | Raubdino-Animationen | Hoch | ART016 | Erledigt |
| ART018 | Fish | Fisch-Sprite | Mittel | ART001 | Erledigt |
| ART019 | Fish | Fisch-Animation | Mittel | ART018 | Erledigt |
| ART020 | Cave | Höhleneingang Level 1 | Hoch | ART001 | Erledigt |
| ART021 | Cave | Höhlen-Level-Varianten | Mittel | ART020 | Erledigt |
| ART022 | Jungle | Dschungel-Bodentiles | Hoch | ART005 | Erledigt |
| ART023 | Jungle | Pflanzen-Set | Hoch | ART022 | Erledigt |
| ART024 | Jungle | Baum-Set | Mittel | ART022 | Erledigt |
| ART025 | Water | Wasser-Tiles | Hoch | ART005 | Erledigt |
| ART026 | Water | Wasseranimation | Mittel | ART025 | Erledigt |
| ART027 | Rocks | Felsen-Set | Mittel | ART005 | Erledigt |
| ART028 | Weather | Regen-Effekt | Hoch | ART001 | Erledigt |
| ART029 | Weather | Schnee-Effekt | Mittel | ART001 | Erledigt |
| ART030 | Weather | Asche-Effekt | Mittel | ART001 | Erledigt |
| ART031 | Volcano | Lava-Tiles | Mittel | ART005 | Erledigt |
| ART032 | Volcano | Feueranimation | Mittel | ART001 | Erledigt |
| ART033 | Volcano | Rauch und Funken | Niedrig | ART032 | Erledigt |
| ART034 | Disaster | Erdbeben-Partikel | Mittel | ART001 | Erledigt |
| ART035 | Meteor | Meteor-Frühphase | Mittel | ART001 | Erledigt |
| ART036 | Meteor | Meteor-Endphase | Hoch | ART035 | Erledigt |
| ART037 | Meteor | Einschlagssequenz | Hoch | ART036 | Erledigt |
| ART038 | UI | Pixel-UI-Styleguide | Mittel | ART001 | Erledigt |
| ART039 | UI | HUD | Hoch | ART038 | Erledigt |
| ART040 | UI | Cursor-Set | Mittel | ART038 | Offen |
| ART041 | FX | XP-Partikel | Mittel | ART001 | Offen |
| ART042 | FX | Laufstaub | Niedrig | ART001 | Erledigt |
| ART043 | FX | Wasserspritzer | Niedrig | ART025 | Teilweise |
| ART044 | FX | Blut-Effekt | Niedrig | ART001 | Erledigt |
| ART045 | Polish | Umgebungsanimationen | Niedrig | ART023 | Erledigt |

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

---

# 149. Plan-Update – Visual Direction & Engine

### Ziel dieses Updates

Die bestehende Planung für **Extinction Hollow** soll an eine neue visuelle Zielrichtung angepasst werden.

Die Kernmechaniken des Spiels bleiben unverändert:

- kleiner Dinosaurier als Spieler
- Click-to-Move per Maus
- Nahrungskette
- Jagd und Flucht
- Carried XP / Banked XP
- Rückkehr zur eigenen Höhle
- Dino- und Höhlen-Upgrades
- dynamisches Ökosystem
- Regen
- Schnee
- Erdbeben
- Vulkanaktivität
- Feuer
- Meteorit als finales Ereignis
- spätere Multiplayer-Option mit mehreren Spielern und Höhlen

Geändert werden hauptsächlich:

1. Engine
2. Perspektive
3. Art Direction
4. Weltaufbau
5. Beleuchtung
6. Rendering
7. Art- und Environment-Tasks

---

## 149.1 Engine ändern

Die bisher geplante Hauptengine **Defold** wird durch **Godot 4.x** ersetzt.

Programmiersprache:

```text
GDScript
```

Godot wird gewählt, weil das Spiel starken Fokus auf folgende 2D-Systeme bekommt:

- hochwertige 2D-Beleuchtung
- Schatten
- Tilemaps
- mehrere Environment-Layer
- Partikelsysteme
- Shader
- Wettereffekte
- Post-Processing
- atmosphärische Szenen
- dynamische Farb- und Lichtstimmungen

Die Engine-Entscheidung darf die Gameplay-Architektur nicht unnötig verändern.

Das Spiel bleibt weiterhin ein 2D-Spiel.

---

## 149.2 Neue visuelle Zielrichtung

Die bisherige einfache Top-Down-Pixel-Art wird durch eine hochwertigere visuelle Richtung ersetzt.

Neue Zielrichtung:

> **Atmospheric HD Pixel Art in a 3/4 top-down perspective with strong lighting, environmental depth and detailed prehistoric environments.**

Das Spiel soll weiterhin eindeutig wie Pixel Art aussehen.

Es soll jedoch NICHT wie klassische grobe Retro-Pixelgrafik wirken.

Gewünscht sind:

- hohe Detaildichte
- moderne Pixel Art
- aufwendige Lichtstimmung
- klare Formen
- starke Farbkomposition
- atmosphärische Partikeleffekte
- mehrere Tiefenebenen
- hochwertige Umgebungen

---

## 149.3 Referenzbild als Mood Target

Das vorhandene Referenzbild dient als **visuelles Mood Target**.

Es soll NICHT direkt kopiert werden.

Übernommen werden sollen insbesondere folgende Eigenschaften:

- hochwertige moderne Pixel Art
- starke Licht-/Schatten-Kontraste
- warme lokale Lichtquellen
- kaltes Umgebungslicht
- starke Tiefenwirkung
- detaillierte Vegetation
- Klippen und Höhenunterschiede
- atmosphärischer Hintergrund
- kleine Glow-Effekte
- Environmental Storytelling
- klar komponierte Szenen

Nicht übernommen werden müssen:

- Fantasy-Thematik
- schwebende Inseln
- Architektur des Referenzbildes
- konkrete Objekte
- konkrete Farbpalette

Die visuelle Sprache soll stattdessen auf eine prähistorische Welt übertragen werden.

---

## 149.4 Perspektive ändern

Die bisherige streng senkrechte Top-Down-Perspektive wird geändert.

Neue Perspektive:

### 3/4 Top-Down

Die Kamera blickt leicht schräg auf die Welt.

Die Perspektive soll zwischen:

```text
klassischem Top-Down
```

und

```text
starker Isometrie
```

liegen.

Die Welt soll dadurch räumlicher und hochwertiger wirken.

Wichtig:

Die Perspektive darf das Gameplay nicht unnötig komplizieren.

Click-to-Move und Navigation müssen weiterhin klar funktionieren.

---

## 149.5 Keine starre klassische Isometrie

Das Spiel muss kein mathematisch korrektes Isometric-Grid verwenden.

Bevorzugt wird eine flexible 3/4-Darstellung.

Dadurch bleiben möglich:

- organische Wege
- runde Seen
- natürliche Flüsse
- unregelmäßige Klippen
- Dschungelpfade
- Höhlen
- Vulkanlandschaften

Die Welt soll natürlich und nicht wie ein quadratisches Strategie-Grid aussehen.

---

## 149.6 Räumliche Tiefe

Die Welt soll aus mehreren sichtbaren Tiefenebenen bestehen.

Beispiel:

```text
Himmel / Atmosphäre
↓
entfernte Landschaft
↓
hohe Baumkronen
↓
Klippen / erhöhte Ebenen
↓
Dinosaurier
↓
Büsche / Farne
↓
Bodendetails
↓
Terrain
↓
Wasser / tieferliegende Bereiche
```

Die Welt soll dadurch wie ein kleines Diorama wirken.

---

## 149.7 Höhenunterschiede

Maps dürfen nicht ausschließlich flach sein.

Geplant werden:

- Klippen
- Plateaus
- Schluchten
- erhöhte Dschungelbereiche
- Flusstäler
- Höhleneingänge
- Felsvorsprünge
- natürliche Rampen
- Brücken
- Wasserfälle

Höhenunterschiede sind primär visuell und leveldesignerisch.

Es ist nicht notwendig, daraus ein komplexes echtes 3D-System zu machen.

---

## 149.8 Dschungel-Art-Direction

Der Dschungel ist weiterhin das Startbiom.

Er soll jetzt deutlich dichter und hochwertiger wirken.

Verwenden:

- große Farne
- Palmfarne
- prähistorische Pflanzen
- dichtes Gras
- große Blätter
- Moose
- Pilze
- Baumstämme
- Wurzeln
- Felsen
- kleine Wasserläufe
- Wasserfälle
- Lichtungen

Die Welt darf dicht wirken.

Der Spieler muss trotzdem eindeutig lesbar bleiben.

---

## 149.9 Environment Layering

Vegetation soll über mehrere Ebenen aufgebaut werden.

Beispiel:

```text
Background Vegetation
↓
Ground Vegetation
↓
Gameplay Layer
↓
Foreground Vegetation
↓
Tree Canopy
↓
Weather / Atmosphere
```

Vordergrundobjekte können den Spieler kurzzeitig teilweise verdecken.

Wenn notwendig, sollen diese Objekte:

- transparenter werden
- ausgeblendet werden
- oder visuell zurücktreten

sobald sich der Spieler dahinter befindet.

---

## 149.10 Licht als zentraler Bestandteil des Artstyles

Beleuchtung ist kein optionaler späterer Effekt.

Sie gehört zur grundlegenden visuellen Identität des Spiels.

Verwendet werden sollen:

- Umgebungslicht
- lokale Lichtquellen
- Schatten
- Glow
- farbiges Licht
- Wetterlicht
- Vulkanlicht
- Höhlenlicht
- Meteorlicht

---

## 149.11 Farbkontrast

Eine wichtige visuelle Regel lautet:

### Kühle Umgebung + warme lokale Lichtquellen

Beispiel:

```text
Dschungelnacht
=
Blau / Cyan / dunkles Grün

Feuer
=
Orange / Gelb

Lava
=
Orange / Rot

Höhle
=
warmes, geschütztes Licht
```

Dadurch entstehen starke visuelle Kontraste.

---

## 149.12 Tag und Nacht

Ein vollständiger Tag-Nacht-Zyklus bleibt zunächst optional.

Die Rendering-Architektur soll ihn jedoch später ermöglichen.

Mögliche Lichtstimmungen:

```text
Morgen
Tag
Abend
Nacht
Sturm
Aschesturm
Meteor-Endgame
```

---

## 149.13 Wasser

Wasser soll deutlich hochwertiger dargestellt werden.

Verwenden:

- animierte Wasseroberflächen
- Reflexionen
- Lichtschimmer
- Wellen
- Strömung
- Spritzer
- Fische unter der Oberfläche
- unterschiedliche Wassertiefen

Mögliche Umgebungen:

- Bäche
- Flüsse
- Seen
- Sümpfe
- Wasserfälle

---

## 149.14 Wasserfälle

Wasserfälle dürfen ein wichtiges visuelles Element werden.

Sie können:

- Landschaften strukturieren
- Höhenunterschiede sichtbar machen
- besondere Jagdgebiete markieren
- Landmarken bilden

Sie eignen sich außerdem gut für:

- Partikel
- Nebel
- Schaum
- Lichtreflexionen

---

## 149.15 Regen

Regen soll nicht nur aus einzelnen Linien bestehen.

Er besteht aus mehreren visuellen Komponenten:

```text
Regenpartikel
+
Wasserspritzer
+
nasser Boden
+
veränderte Beleuchtung
+
bewegtes Wasser
+
leichter atmosphärischer Nebel
```

Optional später:

- Pfützen
- Spiegelungen
- stärkerer Wasserfluss

---

## 149.16 Schnee

Schnee erhält ebenfalls mehrere Ebenen:

- Schneefall
- Schnee auf Terrain
- Schnee auf Felsen
- Schnee auf Vegetation
- Fußspuren
- veränderte Beleuchtung

Die Schneeregion soll deutlich kälter wirken als andere Biome.

---

## 149.17 Feuer

Feuer erhält:

- animierte Pixel-Flammen
- Glow
- Funken
- Rauch
- lokales Licht
- leichte Beleuchtung umliegender Objekte

Feuer soll die Umgebung sichtbar beeinflussen.

---

## 149.18 Vulkan

Die Vulkanregion soll eine der visuell spektakulärsten Regionen sein.

Elemente:

- dunkler Basalt
- Lava
- Glut
- Rauch
- Asche
- Feuer
- orange Beleuchtung
- dunkler Himmel
- glühende Risse

Die Lava dient gleichzeitig als Lichtquelle.

---

## 149.19 Erdbeben

Erdbeben werden vermittelt durch:

- Camera Shake
- Staub
- herunterfallende Steine
- kleine Felsbrocken
- Bodenrisse
- Pflanzenbewegung
- Umweltgeräusche

Starke Effekte dürfen die Spielbarkeit nicht vollständig verdecken.

---

## 149.20 Höhle

Die eigene Höhle ist visuell einer der wichtigsten Orte des Spiels.

Sie muss:

- sofort erkennbar sein
- Geborgenheit vermitteln
- visuell wachsen
- sich klar von normalen Felsen unterscheiden

Die Höhle kann warme Beleuchtung besitzen.

Dadurch entsteht ein bewusster Gegensatz zwischen:

```text
gefährliche kalte Außenwelt
```

und

```text
warme sichere Höhle
```

---

## 149.21 Höhlenentwicklung sichtbar machen

Höhlen-Upgrades müssen visuell sichtbar werden.

Beispiel:

### Level 1

- kleiner natürlicher Eingang
- wenig Beleuchtung
- einfache Felskammer

### Level 2

- größerer Innenraum
- Vorratsbereich
- erste erkennbare Anpassungen

### Level 3

- mehrere Kammern
- stabilere Felsstrukturen
- mehr Details

### Level 4

- deutlich tiefere Höhle
- verstärkte Strukturen
- Schutz vor Hitze und Erdbeben

### Level 5

- massiver Schutzraum
- starke Wände
- tiefer Untergrund
- visuell klar für das Meteor-Endgame vorbereitet

---

## 149.22 Dinosaurier-Artstyle

Dinosaurier werden in hochwertiger Pixel Art dargestellt.

Sie sollen nicht:

- zu niedlich
- zu cartoonhaft
- hyperrealistisch

sein.

Ziel:

```text
stilisiert
+
glaubwürdig
+
gut lesbar
+
charaktervoll
```

---

## 149.23 Größenwirkung der Dinosaurier

Größe wird nicht nur durch Sprite-Skalierung dargestellt.

Große Dinosaurier benötigen:

- größere Sprites
- schwerere Animationen
- langsamere Bewegungen
- größere Schatten
- kräftigere Schritte
- mehr Umgebungsreaktionen

Kleine Dinosaurier benötigen:

- schnelle Animationen
- kleine Schritte
- schnelle Richtungswechsel
- leichte Körperbewegungen

---

## 149.24 Player Visibility

Der Spieler muss immer gut erkennbar bleiben.

Dazu können eingesetzt werden:

- eindeutige Silhouette
- leicht höhere Farbsättigung
- kontrollierter Kontrast
- dezenter Schatten
- subtile Outline
- Hover-/Selection-Effekt

Keine dauerhafte grelle Umrandung verwenden.

---

## 149.25 Animationsstil

Animationen sollen hochwertiger als klassische Minimal-Pixelanimationen wirken.

Spieleranimationen:

```text
Idle
Walk
Run
Eat
Attack
Hurt
Death
Sleep
Drink
Roar
```

NPCs benötigen zunächst weniger Animationen.

Der Spieler und wichtige große Dinosaurier erhalten den größten Animationsumfang.

---

## 149.26 Partikel

Partikelsysteme sind ein wichtiger Bestandteil der visuellen Qualität.

Geplante Effekte:

- Staub
- Blätter
- Regen
- Wasserspritzer
- Schnee
- Asche
- Feuerfunken
- Lavafunken
- Rauch
- XP-Partikel
- Blut
- Meteorit-Partikel
- Einschlagsstaub

Partikel dürfen das Gameplay nicht überdecken.

---

## 149.27 Atmosphäre

Zusätzliche atmosphärische Elemente:

- Nebel
- Hintergrundwolken
- leichter Dunst
- schwebende Pollen
- kleine Lichtpartikel
- Staub
- Asche

Diese Elemente sollen Tiefe erzeugen.

---

## 149.28 Farbentwicklung im Spielverlauf

Der Weltfortschritt soll auch visuell erzählt werden.

### Frühes Spiel

```text
Grün
Blau
Türkis
warmes Sonnenlicht
```

Atmosphäre:

> lebendig und wunderschön

---

### Mittleres Spiel

```text
dunkleres Grün
mehr Grau
stärkerer Regen
mehr Schatten
```

Atmosphäre:

> Welt wird instabil

---

### Spätes Spiel

```text
Orange
Rot
Aschegrau
dunkles Blau
```

Atmosphäre:

> Katastrophe nähert sich

---

### Finale

```text
roter Himmel
glühender Meteor
Feuer
Asche
Rauch
lange Schatten
```

Atmosphäre:

> Aussterben steht unmittelbar bevor

---

## 149.29 Meteor als visuelles Storytelling

Der Meteor soll bereits lange vor dem Finale Teil der Welt werden.

Entwicklungsstufen:

```text
kleiner Lichtpunkt
↓
auffälliger Stern
↓
sichtbarer Himmelskörper
↓
großer glühender Meteor
↓
dominantes Objekt am Himmel
↓
Einschlag
```

Dadurch wird der Fortschritt visuell erzählt, ohne ständig Text anzeigen zu müssen.

---

## 149.30 Meteorlicht

Der Meteor darf im späteren Spiel selbst zur Lichtquelle werden.

Mögliche Auswirkungen:

- orange/rotes Umgebungslicht
- längere Schatten
- verfärbter Himmel
- sichtbare Reflexionen im Wasser
- ungewöhnliche Beleuchtung der Vegetation

---

## 149.31 UI-Artstyle

Die UI wird ebenfalls als moderne Pixel Art umgesetzt.

Gewünscht:

- klare Pixel-Icons
- hochwertige Rahmen
- reduzierte Elemente
- halbtransparente Hintergründe
- passende Bitmap-/Pixel-Schrift

Nicht gewünscht:

- klassische 8-Bit-Menüs
- extrem grobe UI
- futuristische Sci-Fi-Oberflächen

---

## 149.32 Grafikqualität vor Asset-Menge

Die Anzahl der Assets soll anfangs bewusst begrenzt werden.

Bevorzugt:

```text
wenige hochwertige Assets
```

statt:

```text
viele mittelmäßige Assets
```

Ein kleiner wunderschöner Dschungelbereich ist wertvoller als fünf unfertige Biome.

---

## 149.33 Neuer Entwicklungsgrundsatz

Bevor große Gameplay-Systeme weiter ausgebaut werden, muss ein visueller Vertical Slice erstellt werden.

Dieser dient als Qualitätsreferenz für das gesamte Spiel.

---

## 149.34 Visual Vertical Slice

Eine kleine Testszene erstellen.

Die Szene enthält mindestens:

- einen Spieler-Dinosaurier
- Click-to-Move
- hochwertige Pixelgrafik
- Dschungelboden
- mehrere Pflanzenarten
- Felsen
- Wasser
- mindestens einen Höhenunterschied
- Höhleneingang
- Lichtquelle
- Schatten
- Partikeleffekt
- atmosphärischen Hintergrund

Optional:

- kleiner Wasserfall
- Regen
- Feuer
- Nebel

---

## 149.35 Ziel des Vertical Slice

Der Vertical Slice muss beantworten:

> Kann Extinction Hollow in diesem Stil tatsächlich so aussehen, wie wir es uns vorstellen?

Erst wenn die Antwort eindeutig positiv ist, wird die große Weltproduktion fortgesetzt.

---

## 149.36 Art Quality Bar

Der Vertical Slice wird zukünftig als Qualitätsmaßstab verwendet.

Neue:

- Biome
- Tiere
- Höhlen
- Effekte
- Landschaften

sollen sich visuell an diesem Standard orientieren.

---

## 149.37 Keine vollständige Welt vor dem Art-Test

Vor Abschluss des Visual Vertical Slice NICHT:

- alle Biome bauen
- dutzende Dinosaurier erstellen
- riesige Maps anlegen
- komplette Wetterbibliothek produzieren
- umfangreiche Endgame-Grafik erstellen

Zuerst muss der Kernstil funktionieren.

---

## 149.38 Aktualisierte technische Grafikziele

Zu evaluieren sind:

- interne Renderauflösung
- Pixelgröße
- Sprite-Auflösung
- Tile-Auflösung
- Kamera-Zoom
- 3/4-Perspektive
- Pixel-Snapping
- Texture Filtering
- Lichtauflösung
- Schattenqualität

Die bisher festgelegten Werte wie:

```text
640 × 360
32 × 32 Tiles
```

sind ab jetzt **Ausgangspunkte und keine festen Vorgaben**.

Der Visual Vertical Slice entscheidet über die endgültigen Werte.

---

## 149.39 Pixel-Art-Ziel

Die Pixel dürfen kleiner und feiner sein als bei klassischer Retro-Pixel-Art.

Ziel ist:

```text
sichtbare Pixel
+
hohe Detaildichte
+
moderne Beleuchtung
+
hochwertige Animation
```

Nicht:

```text
riesige Retro-Pixel
```

---

## 149.40 Neue Priorität

Die Priorität der frühen Entwicklung wird geändert.

Bisher:

```text
Gameplay-Systeme
↓
Art später
```

Neu:

```text
Grundbewegung
↓
Visual Vertical Slice
↓
Gameplay Core
↓
weitere Art-Produktion
↓
Weltaufbau
```

Gameplay bleibt entscheidend.

Die visuelle Identität muss jedoch früh validiert werden.

---

## 149.41 Neue Update-Tasks

| ID | Bereich | Task | Priorität | Status |
|---|---|---|---|---|
| UPDATE001 | Engine | Projekt auf Godot 4.x umstellen | Kritisch | Erledigt |
| UPDATE002 | Engine | GDScript als Hauptsprache festlegen | Kritisch | Erledigt |
| UPDATE003 | Rendering | 3/4-Top-Down-Perspektive testen | Kritisch | Erledigt |
| UPDATE004 | Rendering | interne Renderauflösung evaluieren | Hoch | Erledigt |
| UPDATE005 | Rendering | Pixel-Perfect-Darstellung konfigurieren | Hoch | Erledigt |
| UPDATE006 | Rendering | 2D-Light-Test erstellen | Kritisch | Erledigt |
| UPDATE007 | Rendering | 2D-Schatten testen | Hoch | Erledigt |
| UPDATE008 | Rendering | Glow-/Highlight-Test | Mittel | Erledigt |
| UPDATE009 | Art | neuen HD-Pixel-Art-Styleguide erstellen | Kritisch | Erledigt |
| UPDATE010 | Art | Spieler-Dino im neuen Stil erstellen | Kritisch | Erledigt |
| UPDATE011 | Environment | Dschungel-Bodenset erstellen | Hoch | Erledigt |
| UPDATE012 | Environment | Farne und Pflanzen erstellen | Hoch | Erledigt |
| UPDATE013 | Environment | Felsen und Klippen erstellen | Hoch | Erledigt |
| UPDATE014 | Environment | Höhenebenen testen | Hoch | Erledigt |
| UPDATE015 | Environment | Höhleneingang erstellen | Hoch | Erledigt |
| UPDATE016 | Water | hochwertiges Wasser testen | Hoch | Erledigt |
| UPDATE017 | Water | Wasserfall-Prototyp erstellen | Mittel | Erledigt |
| UPDATE018 | FX | atmosphärische Partikel erstellen | Hoch | Erledigt |
| UPDATE019 | FX | Regen-Prototyp erstellen | Mittel | Erledigt |
| UPDATE020 | FX | Feuer-/Glow-Prototyp erstellen | Mittel | Erledigt |
| UPDATE021 | Atmosphere | Nebel/Dunst testen | Mittel | Erledigt |
| UPDATE022 | Lighting | warm/kalt Farbkontrast testen | Hoch | Erledigt |
| UPDATE023 | Camera | Kamera für neue Perspektive abstimmen | Hoch | Erledigt |
| UPDATE024 | Gameplay | Click-to-Move in neuer Perspektive testen | Kritisch | Erledigt |
| UPDATE025 | Gameplay | Navigation auf Höhenebenen testen | Hoch | Erledigt |
| UPDATE026 | Polish | Player Visibility im dichten Dschungel testen | Hoch | Erledigt |
| UPDATE027 | Vertical Slice | komplette Testszene zusammensetzen | Kritisch | Erledigt |
| UPDATE028 | Vertical Slice | Qualitätsbewertung durchführen | Kritisch | Erledigt |
| UPDATE029 | Planning | endgültige Sprite-/Tilegrößen festlegen | Hoch | Erledigt |
| UPDATE030 | Planning | bestehende Art-Tasks entsprechend aktualisieren | Hoch | Erledigt |

---

## 149.42 Neuer erster Meilenstein

### Milestone 0 – Visual Identity

Dieser Meilenstein wird vor den bisherigen größeren Gameplay-Meilensteinen eingefügt.

#### Enthält

- Engine-Wechsel auf Godot
- Click-to-Move-Prototyp
- Spieler-Dino
- Dschungel-Testumgebung
- Wasser
- Klippen
- Höhle
- Beleuchtung
- Schatten
- Partikel
- Kamera
- Pixel-Art-Rendering

#### Definition of Done

Der Meilenstein ist abgeschlossen, wenn eine kleine spielbare Szene existiert, die:

1. eindeutig wie **Extinction Hollow** aussieht,
2. visuell hochwertig genug für die angestrebte Richtung ist,
3. die 3/4-Perspektive überzeugend darstellt,
4. Click-to-Move weiterhin angenehm spielbar macht,
5. Licht und Schatten sinnvoll einsetzt,
6. die gewünschte HD-Pixel-Art-Ästhetik erreicht,
7. als Qualitätsreferenz für zukünftige Assets verwendet werden kann.

---

## 149.43 Neue visuelle Leitidee

Die Welt von **Extinction Hollow** soll zunächst so schön wirken, dass der Spieler sie erhalten möchte.

Die kommende Zerstörung gewinnt dadurch an Bedeutung.

```text
Wunderschöne prähistorische Welt
↓
Spieler baut Beziehung zu seiner Umgebung auf
↓
Welt wird zunehmend instabil
↓
bekannte Gebiete verändern sich
↓
Feuer und Asche zerstören Teile der Landschaft
↓
Meteor dominiert den Himmel
↓
Flucht zur Höhle
↓
Extinction Event
```

Der Kontrast zwischen Schönheit und Zerstörung ist ein zentraler Bestandteil der visuellen Identität des Spiels.

---

## 149.44 Zusammenfassung der Planänderung

### Beibehalten

- Gameplay-Konzept
- Nahrungskette
- XP-System
- Höhle
- Meteor
- Naturkatastrophen
- Multiplayer-Vision
- Maussteuerung

### Ändern

```text
Defold
→ Godot 4.x

striktes Top-Down
→ 3/4 Top-Down

einfache Pixel Art
→ hochwertige HD Pixel Art

flache Maps
→ räumliche, geschichtete Landschaften

Art später
→ früher Visual Vertical Slice
```

### Neues Hauptziel

> **Extinction Hollow soll aussehen wie ein hochwertiges atmosphärisches Pixel-Art-Indiespiel und nicht wie ein einfacher Retro-Prototyp.**

---

# 150. Plan-Update – Dino-ARPG

Extinction Hollow wird ein **Hybrid aus Survival und Action-RPG** (Vorbild: Diablo, Torchlight).

### Beibehalten

- Spieler-Dino, Welt, Biome, Wetter, Katastrophen, Meteor-Ziel
- Höhle als sicherer Ort (wie eine Stadt): XP abgeben, speichern, Höhle und Größe aufwerten
- Hunger, Temperatur, getragene XP gehen beim Tod verloren
- Click-to-Move, 3/4-Top-Down-Pixel-Art

### Neu

- **Kampf mit Lebenspunkten:** Jede Tierart hat Lebenspunkte. Bisse verursachen Schaden, es gibt Schadenszahlen, Lebensbalken und kritische Treffer. Kleine Beute stirbt mit einem Biss, große Tiere brauchen viele. Der Dino darf jedes Tier angreifen; gebissene Raubtiere wehren sich unabhängig von der Größe.
- **Skills auf den Tasten 1–4:** Schwanzschlag (Flächenschaden), Brüllen (verscheucht alles in der Nähe), Ansturm (rammt Richtung Mauszeiger), Raserei (schnelle, heilende Bisse). Skills kosten Ausdauer und haben einen Cooldown.
- **Level und Skillbaum:** Jede XP zählt auch für das Charakter-Level (wird nie verloren). Jedes Level bringt +5 Leben und einen Talentpunkt. Drei Stufen im Skillbaum (ab Level 1, 3 und 6) mit Skills und passiven Talenten (Schaden, Rüstung, Crit, Ausdauer). Taste K.
- **Loot und Ausrüstung:** Getötete Tiere lassen Trophäen fallen – Zähne, Klauen, Haut, Bernstein – in vier Seltenheiten (Common, Magic, Rare, Legendary) mit zufälligen Werten. Je größer das Tier, desto öfter und besser. Aufheben durch Drüberlaufen, Inventar mit 4 Slots und 12 Taschenplätzen (Taste I). Unnötige Items lassen sich gegen XP zerlegen.

### Milestone 8b – ARPG-Kern

| ID | Bereich | Task | Status |
|---|---|---|---|
| ARPG001 | Kampf | Lebenspunkte für alle Tierarten | Erledigt |
| ARPG002 | Kampf | Schadenszahlen, Lebensbalken, kritische Treffer | Erledigt |
| ARPG003 | Kampf | Raubtiere wehren sich, verwundete Beute flieht | Erledigt |
| ARPG004 | Skills | vier Skills auf Tasten 1–4 mit Cooldown und Ausdauerkosten | Erledigt |
| ARPG005 | Progression | Charakter-Level aus XP, Talentpunkte | Erledigt |
| ARPG006 | Progression | Skillbaum mit drei Stufen | Erledigt |
| ARPG007 | Loot | Item-Drops mit Seltenheiten und zufälligen Werten | Erledigt |
| ARPG008 | Loot | Inventar, Ausrüstung, Zerlegen | Erledigt |
| ARPG009 | Speichern | Level, Talente und Items speichern | Erledigt |
| ARPG010 | Gegner | Elite-Tiere und Bosse pro Biom | Erledigt |
| ARPG011 | Welt | zufällig erzeugte Höhlen als Dungeons | Erledigt |
| ARPG012 | Karte | Automap mit Nebel: Minimap und große Karte (Taste M) | Erledigt |
| ARPG013 | Welt | zufällige Oberwelt bei jedem neuen Zeitalter | Erledigt |

### Zufällige Welt

- Die Oberwelt wird beim Start gebaut. Das erste Zeitalter spielt in der klassischen Welt, jedes weitere würfelt eine neue: Biom-Grenzen, Verlauf des Flusses und seine Furten, Klippe mit Höhle, Rampe, Teich mit Wasserfall und Bach, Wege, Vulkan, Skelett, Eisflächen und alle Pflanzen, Felsen, Dungeon-Eingänge und Lore-Orte.
- Der Boden wird von einem Shader aus diesen Werten gemalt (gleiche Paletten, Dithering und Details wie die übrige Pixel-Art), Kollisionen und Navigation entstehen passend dazu.
- Die Automap zeichnet ihr Bild aus derselben Welt; der Welt-Seed wird gespeichert, damit ein laufendes Zeitalter gleich bleibt.

### Dungeons

- Vier Eingänge (Dschungel, Sumpf, Vulkan, Schnee) mit eigenem Aussehen und Schwierigkeitsstufe.
- Jeder Besuch erzeugt ein neues Höhlensystem: Räume, verbundene Gänge mit Schleifen, Licht nur von leuchtenden Pilzen und dem Dino selbst.
- In jedem Raum Tiere, die den Dino unabhängig von der Größe angreifen; manchmal ein Elite-Tier (mehr Leben, härtere Bisse, besserer Loot).
- Im entferntesten Raum wartet der Boss (Cave Tyrant) mit großer Lebensleiste; besiegt öffnet er einen zweiten Ausgang und lässt mindestens drei seltene Items fallen.
- Ein Trophäenhort, eine eigene Dungeon-Karte, die sich beim Erkunden aufdeckt, und die letzte Lore-Stelle („star“).
- Wer unten stirbt, erwacht in der Höhle; was unten liegen bleibt, ist verloren.

### Story – der Meteor-Bogen

- Ein Zeitalter dauert 50 Minuten in fünf Phasen (Frühe Welt, Unruhe, Feuer, Vorzeichen, Letzte Tage), jede mit Kapiteltext; Katastrophen werden häufiger.
- Der Meteor wächst am Himmel vom Lichtpunkt zum glühenden Körper mit Schweif und färbt die Nacht rot.
- In den letzten drei Minuten fallen Meteoriten, Tiere fliehen, ein Countdown läuft.
- Einschlag: Lichtblitz, Stille, Staub. Nur in einer Höhle mit genug Schutz (Höhlenlevel doppelt, jeder Wert einfach, mindestens 12) überlebt der Dino.
- Danach beginnt ein neues Zeitalter: Level, Talente und Items bleiben; beim Aussterben gehen Höhle und gesparte XP verloren.
- Acht Lore-Stellen (Fossilien, Kratzspuren, Steinkreise) erzählen die Vorgeschichte.

---

# 151. Auflösung – HD-Pixel-Art (entscheidet UPDATE004, §149.38)

- Zielausgabe **2560 × 1440** (Vollbild, F11 wechselt ins Fenster); ganzzahlige Skalierung, auf 4K entsprechend 6-fach.
- Die Spielwelt und das UI-Layout bleiben in 640 × 360 Einheiten (Kamera-Ausschnitt, Positionen, Geschwindigkeiten unverändert).
- **Alle Sprites haben die doppelte Pixeldichte**: sie werden mit doppelter Auflösung erzeugt (glattere Konturen, feinere Schattierung, feineres Dithering, feinere Details) und mit halber Größe angezeigt. Auf 2560 × 1440 ist ein Texel damit 2 × 2 Bildschirmpixel statt 4 × 4.
- Boden, Dungeons, Nebel und Schneedecke werden ebenfalls mit doppelter Dichte gemalt; Partikel (Regen, Blätter, Schnee, Asche, Glut) sind feiner.
- Die Pixel-Schrift des UI bleibt bewusst gröber.

---

# 152. Stand der Umsetzung

## 152.1 Meilensteine

| Milestone | Inhalt | Status |
|---|---|---|
| 0 | Visual Identity (§149.42) | Erledigt |
| 1 | Movement Prototype | Erledigt |
| 2 | Hunt Prototype | Erledigt |
| 3 | Cave Loop | Erledigt |
| 4 | Predator | Erledigt |
| 5 | Ecosystem | Erledigt |
| 6 | Progression | Erledigt |
| 7 | Weather & Disaster | Erledigt |
| 8 | Biomes | Erledigt |
| 8b | ARPG-Kern (§150) | Erledigt |
| 9 | Extinction | Erledigt |
| 10 | Polish | In Arbeit: Audio erledigt (T094–T099); offen sind T100, T101 und T105–T110 |

Die Multiplayer-Tasks (§96, MP001–MP030) bleiben „Geplant“ und gehören nicht zum aktuellen Plan.

## 152.2 Über den ursprünglichen Plan hinaus

Diese Punkte standen anfangs unter „Nicht Teil des MVP“ (§61) oder gar nicht im Plan und sind inzwischen umgesetzt:

- **Action-RPG-Kern** (§150): Lebenspunkte, Skills auf 1–4, Charakter-Level, Skillbaum, Loot und Ausrüstung, Elite-Tiere und Bosse.
- **Prozedurale Welt** (§150): jedes neue Zeitalter würfelt eine neue Oberwelt.
- **Dungeons** (§150): vier Eingänge, jedes Mal ein neues Höhlensystem mit Boss.
- **Automap mit Nebel** (§150): Minimap und große Karte (Taste M), eigene Karte in Dungeons.
- **Story-Bogen mit Lore-Stellen** (§150): fünf Kapitel bis zum Meteoreinschlag, danach ein neues Zeitalter.
- **HD-Pixel-Art** für 2560 × 1440 (§151).
- **Neun Tierarten** statt einer Beute und eines Raubdinos (§152.3).
- **Prozedurale Klänge** (§153).

## 152.3 Tierarten

| Art | Größe | Rolle | Leben |
|---|---|---|---|
| Fisch | 1 | Beute in Teich und Fluss, wird vom Ufer aus geschnappt | 4 |
| Compy | 1 | Beute, zu dritt unterwegs | 6 |
| Eidechse | 1 | Beute im Dschungel | 8 |
| Diplo | 1 | Beute, paarweise | 14 |
| Snowrunner | 1 | flinke Beute im Schnee | 20 |
| Proto | 2 | Beute, Herden zu dritt | 55 |
| Ankylo | 2 | gepanzerte Beute, schlägt zurück (12 Schaden) | 110 |
| Raptor | 3 | Jäger im Rudel zu zweit (14 Schaden) | 60 |
| Allosaurus | 4 | großer Raubdino (34 Schaden); in Dungeons der Boss „Cave Tyrant“ | 240 |

Jedes Tier ist etwas größer oder kleiner und leicht anders gefärbt. In Dungeons greifen alle Tiere den Dino unabhängig von der Größe an.

---

# 153. Sound (T094–T099)

- Alle Klänge werden wie die Grafik prozedural erzeugt (Synthese aus Rauschen, Oszillatoren und Filtern, 22 kHz mono) und liegen in `assets/audio`.
- **Schleifen** wiederholen sich ohne hörbare Naht und blenden je nach Lage ein und aus:

| Klang | Wann |
|---|---|
| Dschungel: Blätter, Zikaden, Vögel, Frösche, ein fernes Rufen | im Dschungel voll, am Sumpf und Fluss leiser; Regen übertönt ihn; unter der Erde still |
| Regen | bei Regen, bei Starkregen lauter; unter der Erde still |
| Erdbeben: Grollen, mahlender Fels, Risse | leise während der Warnung, voll während des Bebens; ein Ausbruch ist fern vom Vulkan schwächer zu spüren |
| Vulkan: tiefes Grollen, blubbernde Lava, zischender Dampf | in der Nähe des Vulkans, lauter bei Warnung und Ausbruch |
| Meteor: tiefes, schwebendes Brummen und ein Rauschen hoch oben | schwillt ab etwa der Hälfte des Zeitalters an, unter der Erde gedämpft, verstummt mit dem Einschlag |

- **Einzelklänge** erklingen an ihrem Ort in der Welt, werden mit dem Abstand zur Bildmitte leiser und klingen jedes Mal etwas anders:
  - Biss des Dinos und der Raubtiere
  - Schmerzschrei verwundeter Tiere; größere Tiere schreien tiefer, Fische bleiben stumm
  - Brüllen, wenn ein Raubtier die Jagd auf den Dino beginnt oder gebissen wird; kleinere Jäger kreischen höher, jedes Tier höchstens alle 8 Sekunden
  - herabstürzende Felsen beim Erdbeben, einschlagende Lavabomben und Meteoriten
  - Ausbruch des Vulkans, weit hörbar
  - der Meteoreinschlag
- Noch offen aus §54: Schritte, Wasser, Wind, Schnee, Feuer, Fressen, Höhle und Musik.
