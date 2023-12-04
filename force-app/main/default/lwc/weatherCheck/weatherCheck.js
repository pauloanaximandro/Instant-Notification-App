import { LightningElement, wire, api } from 'lwc';
import getRecord from '@salesforce/apex/WeatherCheckController.refreshWeather';

export default class WeatherCheck extends LightningElement {
    @api recordId;
    record;

    @wire(getRecord, {recordId: '$recordId'})
    wiredAccount({ error, data }) {
        if (data) {
            this.record = data[0];
        } else if (error) {
            console.log('Something went wrong:', error);
        }
    }

    get city() {
        return this.record?.city;
    }

    get weatherDesc() {
        return this.record?.weatherDesc;
    }

    get temperature() {
        return this.record?.temperature;
    }

}