import http from 'k6/http';
import { sleep } from 'k6';

export default function () {
    http.get('https://petstore-petservice.livelydesert-8d8d978f.westus2.azurecontainerapps.io/petstorepetservice/v2/pet/all');
    sleep(1); // Adjust the sleep time as needed
}
