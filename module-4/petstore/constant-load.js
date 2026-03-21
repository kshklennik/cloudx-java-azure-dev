import http from 'k6/http';
import { sleep } from 'k6';

export default function () {
    http.get('https://sh-api-pet-store-service-dgf0dtg5cybdcxfr.eastus2-01.azurewebsites.net/petstorepetservice/v2/pet/all');
    sleep(1);
}