#!/bin/bash
if [[ -v SEARCH_DEBUG_ENABLED ]]
then
  debug="$SEARCH_DEBUG_ENABLED"
else
  debug=0
fi

# Process Plugin Entries
if [ -f "${SEARCH_PLUGINS_FILE}" ]
then
  echo "Plugins found in file"
  SEARCH_PLUGINS=`cat ${SEARCH_PLUGINS_FILE}`
  IFS=','
  read -ra ARR <<< "${SEARCH_PLUGINS}"
  for plugin in "${ARR[@]}"; do
    if [ "$plugin" != "repository-s3" ]
    then
      echo "Installing $plugin"
      /usr/share/opensearch/bin/opensearch-plugin install --batch $plugin
    fi
  done
fi

# Process Keystore Entries
if [ -f "${SEARCH_KEYSTORE_FILE}" ]
then
  count=0
  echo "Keystore entries found in file"
  SEARCH_KEYSTORE=`cat ${SEARCH_KEYSTORE_FILE}`
  IFS='|'
  read -ra ARR <<< "${SEARCH_KEYSTORE}"
  for keystore_entry in "${ARR[@]}"; do
    count=$((count+1))
    if [ $count -eq 1 ]
    then
      /usr/share/opensearch/bin/opensearch-keystore create
    fi
    key=`echo $keystore_entry | cut -d"," -f1`
    value=`echo $keystore_entry | cut -d"," -f2`
    if [ $debug -eq 1 ]
    then
      echo "Adding key $key with value $value to keystore"
    fi
    echo $value | /usr/share/opensearch/bin/opensearch-keystore add --stdin $key
  done
fi
