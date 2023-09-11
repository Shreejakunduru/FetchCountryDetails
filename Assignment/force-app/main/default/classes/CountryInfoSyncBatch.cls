global class CountryInfoSyncBatch implements Database.Batchable<SObject>, Database.Stateful, Database.AllowsCallouts {
    
    global Map<String,CountryWrapper> countryWrapperMaps = new Map<String,CountryWrapper>();
	global Set<String> countrySet = new Set<String>();
    
    global List<Country__c> start(Database.BatchableContext bc) {
        String key = Country_Key_Details__c.getValues('key')?.Key__c;
        HTTP http = new HTTP();
        HTTPRequest req = new HTTPRequest();
        req.setEndpoint('http://api.countrylayer.com/v2/all?access_key='+key);
        req.setMethod('GET');
        HTTPResponse res = http.send(req);
        if(res.getStatusCode() == 200){
            	CountryWrapper wrap = new CountryWrapper();
            	countryWrapperMaps = wrap.getCountryDetails(res.getBody());
        }else{
            System.debug('ERROR' + res.getBody());
        }
        return Database.query('SELECT Alpha2Code__c, Alpha3Code__c, Capital_City__c, Region__c, Acronym__c, Name, Id FROM Country__c');
    }

   
    global void execute(Database.BatchableContext bc, List<Country__c> scope) {
        for (Country__c data : scope) {
            if(countryWrapperMaps.containsKey(data.name)){
                CountryWrapper wrap = countryWrapperMaps.get(data.name);
                data.Alpha2Code__c = wrap.alpha2Code;
                data.Alpha3Code__c = wrap.alpha3Code;
                data.Capital_City__c = wrap.capital;
                data.Region__c = wrap.region;
                if(wrap.regionalBlocs != NULL){
                    	data.Acronym__c = wrap.regionalBlocs[0]?.acronym;
                    
                }
                countrySet.add(data.name);
            }
        }
        
        UPDATE scope;
    }

    global void finish(Database.BatchableContext bc) {
        List<Country__c> insertCountries = new List<Country__c>();
        for (String key : countryWrapperMaps.keySet()) {
            CountryWrapper data = countryWrapperMaps.get(key);
            if(!countrySet.contains(data.name)){
                    Country__c con = new Country__c(Name = data.name, Alpha2Code__c = data.alpha2Code, Alpha3Code__c = data.alpha3Code, Capital_City__c = data.capital, Region__c = data.region);
                if(data.regionalBlocs != NULL){
                    con.Acronym__c = data.regionalBlocs[0].acronym; 
                    
                }
                insertCountries.add(con);
                
            }
            
        }
        
        INSERT insertCountries;
    }
    
	public class CountryWrapper {
        Map<String,CountryWrapper> countryWrapperMaps = new Map<String,CountryWrapper>();
		public String name;	//Afghanistan
		public String alpha2Code;	//AF
		public String alpha3Code;	//AFG
		public String capital;	//Kabul
		public String region;	//Asia
		public String subregion;	//Southern Asia
		public Integer population;	//27657145
		public String demonym;	//Afghan
		public Integer area;	//652230
		public cls_regionalBlocs[] regionalBlocs;
        
        public  Map<String,CountryWrapper> getCountryDetails(String json){    
            system.debug(json);
        for(CountryWrapper wrap : (List<CountryWrapper>) System.JSON.deserialize(json, List<CountryWrapper>.class)){
			countryWrapperMaps.put(wrap.name, wrap);                
        }
            return countryWrapperMaps;
	}
        
	}
	
	class cls_regionalBlocs {
		public String acronym;	//SAARC
		public String name;	//South Asian Association for Regional Cooperation
	}
	
}