import http from 'k6/http';
import { sleep } from 'k6';

export let options = {
    stages: [
        { duration: '1m', target: 10 },   // Ramp-up to 10 users over 1 minute
        { duration: '5m', target: 10 },   // Stay at 10 users for 5 minutes
    ],
};

export default function () {
    http.get('https://petstore-petservice.livelydesert-8d8d978f.westus2.azurecontainerapps.io/petstorepetservice/v2/pet/all');
    sleep(1);
}
