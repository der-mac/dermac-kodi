# define: kodi::resource::userconfig
#
# Diese Definition erzeugt fuer den gewuenschten user eine
# angepasste Konfiguration in seinem Home-Verzeichnis
#
# Parameters:
#   [*ensure*]               - Aktiviert, oder deaktiviert die Konfiguration fuer den angegebenen Benutzer
#     (present|absent)
#   [*videodatabase_type*]   - Kodi Video-Datenbank-Typ
#     (mysql|...), Default: ''
#   [*videodatabase_host*]   - Kodi Video-Datenbank-Server
#     Default: ''
#   [*videodatabase_port*]   - Kodi Video-Datenbank-Port
#     Default: 3306
#   [*videodatabase_user*]   - Kodi Video-Datenbank-User
#     Default: 'kodi'
#   [*videodatabase_pass*]   - Kodi Video-Datenbank-Passwort
#     Default: ''
#   [*videodatabase_name*]   - Kodi Video-Datenbank-Name
#     Default: 'kodi_video'
#   [*musicdatabase_type*]   - Kodi Music-Datenbank-Typ
#     (mysql|...), Default: ''
#   [*musicdatabase_host*]   - Kodi Music-Datenbank-Server
#     Default: ''
#   [*musicdatabase_port*]   - Kodi Music-Datenbank-Port
#     Default: 3306
#   [*musicdatabase_user*]   - Kodi Music-Datenbank-User
#     Default: 'kodi'
#   [*musicdatabase_pass*]   - Kodi Music-Datenbank-Passwort
#     Default: ''
#   [*musicdatabase_name*]   - Kodi Music-Datenbank-Name
#     Default: 'kodi_music'
#   [*importwatchedstate*]   - Importiere vorher exportierte Abspielzeiten und Abspielzaehler
#     Default: true
#   [*importresumepoint*]   - Importiere vorher exportierte Resume-Points
#     Default: true
#
#
# Actions:
#
# Requires:
#
# Sample Usage:
#  kodi::resource::userconfig { 'bob':
#    videodatabase_type => 'mysql',
#    videodatabase_host => '192.168.1.1',
#    musicdatabase_type => 'mysql',
#    musicdatabase_host => '192.168.1.1',
#  }
#

define kodi::resource::userconfig (
  $ensure             = present,
  $videodatabase_type = '',
  $videodatabase_host = '',
  $videodatabase_port = 3306,
  $videodatabase_user = 'kodi',
  $videodatabase_pass = 'kodi',
  $videodatabase_name = 'kodi_video',
  $musicdatabase_type = '',
  $musicdatabase_host = '',
  $musicdatabase_port = 3306,
  $musicdatabase_user = 'kodi',
  $musicdatabase_pass = 'kodi',
  $musicdatabase_name = 'kodi_music',
  $importwatchedstate = true,
  $importresumepoint  = true,
) {

  ## Check for various error conditions
  if ! ($name in $::kodi_local_users) {
    fail("User ${name} not present on this host.")
  }

  File {
    owner  => $name,
  }

  $ensure_file = $ensure ? {
    'absent' => absent,
    default  => file,
  }

  $ensure_dir = $ensure ? {
    'absent' => absent,
    default  => directory,
  }

  file { ["C:\\Users\\${name}\\AppData\\Roaming\\Kodi", "C:\\Users\\${name}\\AppData\\Roaming\\Kodi\\userdata"] :
    ensure => $ensure_dir,
  }

  file { "C:\\Users\\${name}\\AppData\\Roaming\\Kodi\\userdata\\advancedsettings.xml":
    ensure  => $ensure_file,
    content => template('kodi/advancedsettings.xml.erb'),
  }
}
