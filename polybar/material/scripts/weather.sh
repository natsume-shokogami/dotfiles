#!/bin/bash

##Use your city's latitude and longitude instead
LATITUDE="10.82"
LONGITUDE="106.63"

##Cached data
cache_dir="$HOME/.cache/polybar/weather"
cache_weather_code=${cache_dir}/weather-code
cache_weather_degree=${cache_dir}/weather-degree
cache_weather_icon=${cache_dir}/weather-icon
cache_weather_text=${cache_dir}/weather-text

if [[ ! -d "$cache_dir" ]]; then
	mkdir -p ${cache_dir}
fi

#Get data
get_weather_data() {

	weather=$(curl -sf "https://api.open-meteo.com/v1/forecast?latitude="$LATITUDE"&longitude="$LONGITUDE"&current_weather=true")
	#echo ${weather}
	if [ ! -x "$weather" ]; then
		temperature=${weather%%,\"windspeed\":*}
		temperature=${temperature##*\"temperature\":}
		weather_code=${weather%%,\"time\":*}
		weather_code=${weather_code##*\"weathercode\":}
		##echo "$temperature"
		##echo "$weather_code"
		if [ "$weather_code" == "0" ]; then
			weather_icon="☀"
			weather_text="Clear sky"
		elif [ "$weather_code" == "1" ]; then
                        weather_icon="🌤"
                        weather_text="Mainly clear"
		elif [ "$weather_code" == "2" ]; then
                        weather_icon="🌤"
                        weather_text="Partly cloudy"
		elif [ "$weather_code" == "3" ]; then
                        weather_icon="☁"
                        weather_text="Overcast"
		elif [ "$weather_code" == "45" ]; then
                        weather_icon="🌫"
                        weather_text="Fog"
		elif [ "$weather_code" == "48" ]; then
                        weather_icon="🌫"
                        weather_text="Depositing rime fog"
		elif [ "$weather_code" == "45" ]; then
                        weather_icon="🌫"
                        weather_text="Fog"
		elif [[ "$weather_code" == "51" && "$weather_code" == "53" && "$weather_code" == "55" ]]; then
                        weather_icon="🌦"
                        weather_text="Drizzle"
		elif [[ "$weather_code" ==  "56" && "$weather_code" == "57" ]]; then
			weather_icon="🌨"
                        weather_text="Freezing drizzle"
		elif [[ "$weather_code" == "61" && "$weather_code" == "66" && "$weather_code" == "80" ]]; then
                        weather_icon="🌧"
                        weather_text="Slight rain"
		elif [[ "$weather_code" == "63" && "$weather_code" == "81" ]]; then
                        weather_icon="🌧"
                        weather_text="Moderate rain"
		elif [[ "$weather_code" == "65" && "$weather_code" == "67" && "$weather_code" == "82" ]]; then
                        weather_icon="🌧"
                        weather_text="Heavy rain"
		elif [[ "$weather_code" == "71" && "$weather_code" == "85" ]]; then
                        weather_icon="❄"
                        weather_text="Slight snow"
		elif [ "$weather_code" == "73" ]; then
                        weather_icon="❄"
                        weather_text="Moderate snow"
		elif [[ "$weather_code" == "75" && "$weather_code" == "86" ]]; then
                        weather_icon="❄"
                        weather_text="Heavy snow"
		else
			weather_icon="?"
                        weather_text="?"
		fi
		echo "$weather_icon" > ${cache_weather_icon}
		echo "${weather_text}" > ${cache_weather_text}
		echo "${temperature}oC" > ${cache_weather_degree}	
	else
		echo "?" > ${cache_weather_icon}
                echo "N/A" > ${cache_weather_text}
                echo "-" > ${cache_weather_degree}
	fi
}

## Execute
if [[ "$1" == "--getdata" ]]; then
	get_weather_data
elif [[ "$1" == "--icon" ]]; then
	cat ${cache_weather_icon}
elif [[ "$1" == "--temp" ]]; then
        cat ${cache_weather_degree} | head -n1
elif [[ "$1" == "--text" ]]; then
        echo "$(cat ${cache_weather_icon} | head -n1) $(cat ${cache_weather_text} | head -n1)"
elif [[ "$1" == "--widget" ]]; then
	get_weather_data
	echo "🌡 $(cat ${cache_weather_degree} | head -n1 )"
fi
