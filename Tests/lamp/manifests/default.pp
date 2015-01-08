Exec {
  path => ["/usr/bin", "/bin", "/usr/sbin", "/sbin", "/usr/local/bin", "/usr/local/sbin"]
}
stage { "pre": before => Stage["main"] }

$flowVersionTag = 'Flow-1.1.0-beta3'
$mysqlpw = "toor"
$flowdb_name = "flowdb"
$flowdb_passwd = "flowpasswd"
$flowdb_username = "flowuser"

include bootstrap
include other
include apache
include php
include mysql
include flow
include oauth
include demoapp
