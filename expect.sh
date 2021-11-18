#!/usr/bin/expect -f
set timeout -1
spawn /usr/share/opensearch/bin/opensearch-plugin -s install repository-s3
expect "Continue with installation?"
send "y\r"
expect eof
