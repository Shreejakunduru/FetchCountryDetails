@isTest
private class CountryInfoSyncBatchTest {
    @isTest
    static void testBatch() {
       insert new Country_Key_Details__c(Name = 'Key', Key__c = '1234');
        List<Country__c> countryList = new List<Country__c>();
        
        for(Integer i = 0 ; i<2 ; i++){
            countryList.add(new Country__c(Name = 'Afghanistan' , Alpha2Code__c = '1234', Alpha3Code__c = '4567', Capital_City__c = 'laurence', Region__c = 'Africa'));
        }
        
        INSERT countryList;
        // Start the batch job
        Test.startTest();
		Test.setMock(HttpCalloutMock.class, new CountryInfoSyncMock());  
        CountryInfoSyncBatch batch = new CountryInfoSyncBatch();
        Database.executeBatch(batch);
        Test.stopTest();

        // Verify that the batch job updated and Created the records correctly
        System.assertEquals([SELECT Alpha2Code__c, Alpha3Code__c, Capital_City__c, Region__c, Acronym__c, Name
                                             FROM Country__c].size(), 3);
        
    }
}