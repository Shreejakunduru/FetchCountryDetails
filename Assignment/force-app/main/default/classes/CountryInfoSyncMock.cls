@isTest
global class CountryInfoSyncMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('[{"name": "Afghanistan","alpha2Code": "AF","alpha3Code": "AFG","capital": "Kabul","region": "Asia", "regionalBlocs" : [{"acronym": "Test"}]},{"name": "India","alpha2Code": "AF","alpha3Code": "AFG","capital": "Kabul","region": "Asia", "regionalBlocs" : [{"acronym": "Test"}]}]');
        response.setStatusCode(200);
        return response; 
    }
}