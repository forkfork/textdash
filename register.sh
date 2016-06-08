while true
do
        echo ""
	echo "Waiting for emails"
	sleep 1
	REDISMSG=`redis-cli --raw blpop emailqueue 0 | tail -n +2`
	EMAIL=$(echo "$REDISMSG" | head -n 1)
	CONTENTS=$(echo "$REDISMSG" | tail -n +2)
	echo "got registration for $EMAIL"
	curl -s --user "api:key-$MAILGUN_API_KEY" https://api.mailgun.net/v3/mg.textdash.xyz/messages -F from='textdash <timothydowns@gmail.com>' -F to=$EMAIL -F subject='textdash account created' \
 -F text="$CONTENTS"
	sleep 5
done

