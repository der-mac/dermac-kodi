# define: kodi::resource::userconfig
#
# This definition creates for the given user a
# specified configuration in its user-directory
#
# Parameters:
#   [*ensure*]               - Activates, or deactivates the configuration for the given user
#     (present|absent)
#   [*create_missing_user*]  - Creates the missing user, if it not present
#   [*videodatabase_type*]   - Kodi video-database-type
#     (mysql|...), Default: ''
#   [*videodatabase_host*]   - Kodi video-database-server
#     Default: ''
#   [*videodatabase_port*]   - Kodi video-database-port
#     Default: 3306
#   [*videodatabase_user*]   - Kodi video-database-user
#     Default: 'kodi'
#   [*videodatabase_pass*]   - Kodi video-database-password
#     Default: ''
#   [*videodatabase_name*]   - Kodi video-database-name
#     Default: 'kodi_video'
#   [*musicdatabase_type*]   - Kodi video-database-type
#     (mysql|...), Default: ''
#   [*musicdatabase_host*]   - Kodi music-database-server
#     Default: ''
#   [*musicdatabase_port*]   - Kodi music-database-port
#     Default: 3306
#   [*musicdatabase_user*]   - Kodi music-database-user
#     Default: 'kodi'
#   [*musicdatabase_pass*]   - Kodi music-database-password
#     Default: ''
#   [*musicdatabase_name*]   - Kodi music-database-name
#     Default: 'kodi_music'
#   [*importwatchedstate*]   - Import previous exported playtimes and playcounters
#     Default: true
#   [*importresumepoint*]    - Import previous exported resume-points
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
  $ensure              = present,
  $create_missing_user = false,
  $videodatabase_type  = '',
  $videodatabase_host  = '',
  $videodatabase_port  = 3306,
  $videodatabase_user  = 'kodi',
  $videodatabase_pass  = 'kodi',
  $videodatabase_name  = 'kodi_video',
  $musicdatabase_type  = '',
  $musicdatabase_host  = '',
  $musicdatabase_port  = 3306,
  $musicdatabase_user  = 'kodi',
  $musicdatabase_pass  = 'kodi',
  $musicdatabase_name  = 'kodi_music',
  $importwatchedstate  = true,
  $importresumepoint   = true,
) {

  ## Check for various error conditions
  if ! ($name in $::kodi_local_users) {
    if ($create_missing_user == true) {
      user { "kodi_${name}":
        ensure     => present,
        name       => $name,
        managehome => true,
        groups     => ['S-1-5-32-545'],
        password   => 'kodi',
      }
    }
    else {
      fail("User ${name} not present on this host and \$create_missing_user is set to 'false'.")
    }
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
