# Kodi module for puppet

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with kodi](#setup)
    * [What kodi affects](#what-kodi-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with kodi](#beginning-with-kodi)
4. [Limitations](#limitations)

## Overview

The kodi-module installs the application kodi and creates the user-config

## Module Description

The kodi-module installs the application by downloading the given link and runs the installer in silent mode.
This happens only if the installed version is older (or not present) than the version that should be installed

The userconfig-resource creates a personalized configuration for the given user.
If the user is not present, the resource can create the user for you (please change the default password 'chang3_me' as soon as possible).

## Setup

### What kodi affects

The kodi-module downloads the installation-file to the temp-directory of the user running the puppet-agent.

The resource userconfig creates or changes the advancedsettings.xml in the userdata-directory of the given user.

### Setup Requirements **OPTIONAL**

The kodi-module uses the puppet-download_file module

### Beginning with kodi

for a simple kodi-installation use:

```puppet
    class { "kodi" :
    }
```

To install a specific version of kodi on Windows:

```puppet
    class { "kodi" :
      package_version => '17.3',
      download_link => 'http://mirrors.kodi.tv/releases/win32/kodi-17.3-Krypton.exe',
    }
```

To configure the user Bob to use a mysql kodi-database-connection:

```puppet
    kodi::resource::userconfig { 'bob':
      videodatabase_type => 'mysql',
      videodatabase_host => '192.168.1.1',
      musicdatabase_type => 'mysql',
      musicdatabase_host => '192.168.1.1',
    }
```

To configure the user Bob to use a mysql kodi-database-connection and the user is not present on the system:

```puppet
    kodi::resource::userconfig { 'bob':
      create_missing_user => true,
      videodatabase_type => 'mysql',
      videodatabase_host => '192.168.1.1',
      musicdatabase_type => 'mysql',
      musicdatabase_host => '192.168.1.1',
    }
```

## Limitations

At the Moment, only windows 7, windows 10 and fedora 25 are supported.
