import http from 'k6/http';
import { sleep } from 'k6';

export let options = {
    stages: [
        { duration: '1m', target: 500 },    // Ramp-up to 10 users over 1 minute
        { duration: '1m', target: 2500 },    // Spike to 50 users in 1 minute
        { duration: '5m', target: 2500 },    // Stay at 50 users for 5 minutes
    ],
};

export default function () {
    http.get('https://sh-api-pet-store-service-dgf0dtg5cybdcxfr.eastus2-01.azurewebsites.net/petstorepetservice/v2/pet/all');
    sleep(1);
}
