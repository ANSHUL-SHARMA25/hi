
FROM node

COPY package-lock.json package-lock.json 
COPY main.js main.js
COPY package.json package.js 


RUN npm install




ENTRYPOINT [ "node","main.js" ]





# Use google api to get the location (lon.lat.) of a landmark of our choice If the api is giving you a list then only display the first location


#!/bin/bash

# enter the landmark name
read -p "Enter the landmark name: " LANDMARK_NAME

API_KEY="AIzaSyALakwmdLoDmKgmMjrGCdqew6lKuI-gE4I"

# Encode the landmark name for URL
ENCODED_NAME=$(echo "$LANDMARK_NAME" | sed 's/ /+/g')

# Construct the API URL
API_URL="https://maps.googleapis.com/maps/api/geocode/json?address=$ENCODED_NAME&key=$API_KEY"

# Fetch data from the API
response=$(curl -s "$API_URL")

# Extract latitude, longitude, formatted address, and place ID using jq
latitude=$(echo "$response" | jq -r '.results[0].geometry.location.lat')
longitude=$(echo "$response" | jq -r '.results[0].geometry.location.lng')
formatted_address=$(echo "$response" | jq -r '.results[0].formatted_address')


# Print the results
echo "Latitude: $latitude"
echo "Longitude: $longitude"
echo "formatted_address: $formatted_address"



// Create a builder for configuring the application.
var builder = WebApplication.CreateBuilder(args);
// Add services to the container.
builder.Services.AddControllers();
// Build the application.
var app = builder.Build();
// Configure the HTTP request pipeline to use authorization
app.UseAuthorization();
// Map controller endpoints.
app.MapControllers();
// Run the application, listening on port 5500 on all network interfaces.
app.Run("http://localhost:5500");

using Microsoft.AspNetCore.Mvc;
 namespace HealthCheckApi.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class HealthController : ControllerBase
    {
        private static int _healthCheckCount = 0;
        private static readonly object _lock = new object();
        [HttpGet]
        public IActionResult Get()
        {
            lock (_lock)
            {
                _healthCheckCount++;
                if (_healthCheckCount % 20 == 0)
                {
                    return Ok("Nok");
                }
                return Ok("ok");
            }
        }
    }
}


#!/bin/bash

# Email details
MY_EMAIL="Anshul.Sharma@avl.com"
ANOTHER_EMAIL="Sameer.Jain@avl.com"
SUBJECT="Health Check Alert: Application returned Nok"
BODY="The application returned Nok status. Please check the application."
emailSend=false
SMTPSERVER="10.12.100.11"

# Infinite loop to check the health endpoint
while true;
do
    # Make the request to the health endpoint
    RESPONSE=$(curl -s http://localhost:5500/health)

    # Check if the response is "Nok"
    if [ "$RESPONSE" == "Nok" ] && [ "$emailSend" == false ]; then
        # Send the email
        echo "$BODY" | mail -s "$SUBJECT" "$ANOTHER_EMAIL" "$MY_EMAIL"
        emailSend=true
    elif [ "$RESPONSE" != "Nok" ]; then
        emailSend=false
    fi

    # Sleep for a specified interval before checking again (e.g., 10 seconds)
    sleep 10
done