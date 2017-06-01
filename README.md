# Kodi Modul fuer Puppet

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with kodi](#setup)
    * [What kodi affects](#what-kodi-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with kodi](#beginning-with-kodi)
4. [Usage - Configuration options and additional functionality](#usage)

## Overview

Das kodi Modul installiert die Anwendung Kodi und erstellt User-Konfigurationen

## Module Description

Die Kodi Klasse installiert die Anwendung, indem es die Installationsdatei herunter läd und installiert.
Dies geschieht nur, wenn die installierte Version aelter (oder nicht vorhanden) als die gewuenschte
Version ist.

Weiterhin wird die Resource userconfig definiert. Mit dieser kann eine Benutzerkonfiguration erstellt
und verwaltet werden.

Derzeit wird nur Windows 10 unterstuetzt, an weiteren Systemen wird gearbeitet.

## Setup

### What kodi affects

Kodi laed die Installationsdateien in das System-Temp- (bzw. User-Temp-) Verzeichnis herunter um es zu
installieren.

Die Definition userconfig erstellt bzw. aendert die advancedsettings.xml im userdata-Verzeichnis des entsprechenden
Benutzers.

### Setup Requirements **OPTIONAL**

kodi verwendet das puppet-download_file Modul

### Beginning with kodi

Um Kodi lediglich zu installieren, genuegt:

```puppet
    class { "kodi" :
    }
```

Um eine bestimmte Version zu installieren:

```puppet
    class { "kodi" :
      package_version => '17.3',
      download_link => 'http://mirrors.kodi.tv/releases/win32/kodi-17.3-Krypton.exe',
    }
```

Um fuer den User Bob eine MySQL Kodi-DB-Verbindung zur Verfuegung zu stellen:

```puppet
    kodi::resource::userconfig { 'bob':
      videodatabase_type => 'mysql',
      videodatabase_host => '192.168.1.1',
      musicdatabase_type => 'mysql',
      musicdatabase_host => '192.168.1.1',
    }
```

## Limitations

Im Moment nur mit Windows 10 kompatibel
