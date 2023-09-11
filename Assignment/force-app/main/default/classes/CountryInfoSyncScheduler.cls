// Creating a scheduled job to run weekly
public class CountryInfoSyncScheduler implements Schedulable ,Database.AllowsCallouts{
    public void execute(SchedulableContext context) {
      	Database.executeBatch(new CountryInfoSyncBatch(), 200);
    }
}