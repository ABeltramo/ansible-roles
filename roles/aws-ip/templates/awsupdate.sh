#!/usr/bin/env bash

ZONEID='{{ hosted_zone }}'                             # Hosted Zone ID e.g. BJBK35SKMM9OE
RECORDSET='{{ external_domain_name }}'                 # The CNAME you want to update e.g. hello.example.com
TTL=300                                                # The Time-To-Live of this recordset
TYPE='A'                                               # Change to AAAA if using an IPv6 address
COMMENT="Auto updating @ `date`"
IP=`curl -ss https://ipinfo.io/ip`                     # Get the external IP address
LOGPATH='/var/log'

usage () {
  echo "update-route53.sh - Update IP address listed in Amazon Route 53"
  echo "eg: update-route53.sh -z BJBK35SKMM9OE -r hello.example.com -t CNAME"
  echo "  -h              Displays this message"
  echo "  -z ZONE_ID      Required; Zone ID assigned by AWS"
  echo "  -r DNS_NAME     Required; Record set name"
  echo "  -l TTL          Optional; Defaults to 300"
  echo "  -t TYPE         Optional; Defaults to A"
  echo "  -i IP_ADDRESS   Optional; Defaults to result from icanhazip.com"
  echo "  -c COMMENT      Optional; Defaults to 'Auto updating @ `date`'"
  echo "  -p LOG_PATH     Optional; Defaults to /var/log"
}

while getopts "z:r:t:c:l:i:p:h" opt; do
  case $opt in
    z) ZONEID="$OPTARG" ;;
    r) RECORDSET="$OPTARG" ;;
    l) TTL="$OPTARG" ;;
    t) TYPE="$OPTARG" ;;
    i) IP="$OPTARG" ;;
    c) COMMENT="$OPTARG" ;;
    p) LOGPATH="$OPTARG" ;;
    h) usage ;;
    \?) echo "Invalid option: -"$OPTARG"" >&2
        usage
        exit 1 ;;
    :) echo "Option -"$OPTARG" requires an argument." >&2
       usage
       exit 1 ;;
  esac
done

function valid_ip()
{
    local  ip=$1
    local  stat=1

    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        OIFS=$IFS
        IFS='.'
        ip=($ip)
        IFS=$OIFS
        [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 \
            && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
        stat=$?
    fi
    return $stat
}

# Get current dir (stolen from http://stackoverflow.com/a/246128/920350)
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LOGFILE="$LOGPATH/update-route53.log"
IPFILE="$LOGPATH/update-route53.ip"

if ! valid_ip $IP; then
    echo "Invalid IP address: $IP" >> "$LOGFILE"
    exit 1
fi

# Check if the IP has changed
if [ ! -f "$IPFILE" ]
    then
    touch "$IPFILE"
fi

if grep -Fxq "$IP" "$IPFILE"; then
    # code if found
    echo "IP is still $IP. Exiting" >> "$LOGFILE"
    exit 0
else
    echo "IP has changed to $IP" >> "$LOGFILE"
    # Fill a temp file with valid JSON
    TMPFILE=$(mktemp /tmp/temporary-file.XXXXXXXX)
    cat > ${TMPFILE} << EOF
    {
      "Comment":"$COMMENT",
      "Changes":[
        {
          "Action":"UPSERT",
          "ResourceRecordSet":{
            "ResourceRecords":[
              {
                "Value":"$IP"
              }
            ],
            "Name":"$RECORDSET",
            "Type":"$TYPE",
            "TTL":$TTL
          }
        }
      ]
    }
EOF

    # Update the Hosted Zone record
    aws route53 change-resource-record-sets \
        --hosted-zone-id $ZONEID \
        --change-batch file://"$TMPFILE" >> "$LOGFILE"
    echo "" >> "$LOGFILE"

    # Clean up
    rm $TMPFILE
fi

# All Done - cache the IP address for next time
echo "$IP" > "$IPFILE"