public with sharing class WeatherCheckController {

    public class WeatherAppException extends Exception {}

    @AuraEnabled
    public static Weather_Widget_Configuration__c getLastSyncDetails() {
        Weather_Widget_Configuration__c configRec = Weather_Widget_Configuration__c.getValues('Default');
        return configRec;
    }

    @AuraEnabled
    public static Weather_Widget_Configuration__c refreshWeather() {

        String recordId = ApexPages.currentPage().getParameters().get('id');
        Account acc = ([SELECT ShippingCity FROM Account WHERE Id = : recordId ]);
        String city = acc.ShippingCity;
        String apiKey = 'bae136e84869f4286f2110f76cf507c4';

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        String unit = 'metric';
        String endpoint = 'https://api.openweathermap.org/data/3.0/weather?';
        endpoint += 'q=' + city + '&appid=' + apiKey + '&units=' + unit;
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        HttpResponse res = http.send(request);
        String responseBody = res.getBody();

        if(res.getStatusCode() == 401) {
            throw new WeatherAppException('Invalid API Key');
        }
        if(res.getStatusCode() == 404) {
            throw new WeatherAppException('City not found.');
        }

        Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(responseBody);
        Weather_Widget_Configuration__c configRec = getLastSyncDetails();
        if(configRec == null) {
            configRec = new Weather_Widget_Configuration__c();
        }

        String cityName = String.valueOf(responseMap.get('name'));
        Map<String, Object> sysMap = (Map<String, Object>)responseMap.get('sys');
        String countryName = String.valueOf(sysMap.get('country'));
        Map<String, Object> mainMap = (Map<String, Object>)responseMap.get('main');
        Double temperature = Double.valueOf(mainMap.get('temp'));
        List<Object> weatherList = (List<Object>)responseMap.get('weather');
        Map<String, Object> weatherInfo = (Map<String, Object>)weatherList[0];
        String weatherDesc = String.valueOf(weatherInfo.get('description'));
        String weatherIcon = String.valueOf(weatherInfo.get('icon'));

        configRec.City__c = cityName;
        configRec.Temperature__c = temperature;
        configRec.Icon_Name__c = weatherIcon;
        configRec.Weather__c = weatherDesc;
        configRec.API_Key__c = apiKey;
        
        upsert configRec;
        System.debug(configRec);
        return configRec;

    }
    
}