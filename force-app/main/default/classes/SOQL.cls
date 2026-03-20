/**
 * The SOQL class serves as a primer into the Salesforce Object Query Language in Apex.
 * It covers fundamental aspects such as SELECT statements, WHERE clauses, Relationship queries, and LIMIT keyword.
 *
 * This class introduces developers to the concept of retrieving data from Salesforce using SOQL. It provides
 * a step-by-step guide on how to construct SOQL queries, filter results using WHERE clause, retrieve related
 * records, and manage data volume using the LIMIT keyword.
 *
 * Topics covered in this class include:
 * - Understanding the structure of a SOQL query.
 * - Crafting basic SELECT statements in SOQL.
 * - Applying filters using the WHERE clause in SOQL.
 * - Fetching related records using Relationship queries.
 * - Controlling the amount of data retrieved using the LIMIT keyword.
 *
 * Users of this class can expect to gain a solid understanding of SOQL in Apex and
 * be prepared to handle data retrieval tasks in Salesforce development.
 *
 * @author Your Name
 */

public with sharing class SOQL {
	/**
	 * Question 1
	 * Update/Uncomment the template code to create a method
	 * Returns all leads from Salesforce Org
	 * @return List of all leads with Id, LastName, Company, Phone, Email
	 * Update the corresponding test class and   method to cover this method
	 */
	public static List<Lead> getAllLeads() {
		if(!CrudFLSValidator.canAccess('Lead', new set<String>{'Id','LastName','Company','Phone','Email'}, CrudFLSValidator.OperationType.READ)){
			return new List<Lead>();
		}	
		return  [SELECT Id, LastName, Company, Phone, Email FROM Lead WITH USER_MODE];
	}

	/**
	 * Question 2
	 * Update/Uncomment the template code to create a method
	 * Returns all contacts with first name of John.
	 * @return A list of Contact records.
	 * Update the corresponding test class and testGetContactsByFirstName method to cover this method
	 */
	public static List<Contact> getContactsByFirstName() {
		if(!CrudFLSValidator.canAccess('Contact', new set<String>{'Id', 'FirstName', 'LastName'}, CrudFLSValidator.OperationType.READ)){
			return new List<Contact>();
		}	
		return [SELECT Id, FirstName, LastName, Name FROM Contact WHERE FirstName = 'John' WITH USER_MODE];	
	}

	/**
	 * Question 3
	 * Update/Uncomment the template code to create a method
	 * Returns the Contact Id for all contacts with last name of Smith or Jones
	 * @return A list of Contact Ids.
	 * Update the corresponding test class and testGetContactIdsByLastName method to cover this method
	 */
	public static List<Id> getSmithOrJonesContacts() {
		if(!CrudFLSValidator.canAccess('Contact', new set<String>{'Id',  'LastName'}, CrudFLSValidator.OperationType.READ)){
			return new List<Id>();
		}
		List<Id> contactIds = new List<Id>();

		for(Contact c : [SELECT Id FROM Contact WHERE LastName = 'Jones' OR LastName = 'Smith' WITH USER_MODE]){
			contactIds.add(c.Id);
		}	
		return contactIds;

	}

	/**
	 * Question 4
	 * Update/Uncomment the template code to create a method
	 * Returns List of closed won opportunities for a specific Account.
	 * Example: yourMethodName('001XXXXXXXXXXXX') should return the list of closed won opportunities for the Account with the Id
	 * @param accountId The ID of the Account.
	 * @return A list of Opportunities with important opportunities fields
	 * Update the corresponding test class and testGetClosedWonOpportunityCountByAccount method to cover this method
	 */
	
	public static List<Opportunity> getClosedWonOpportunities(Id accountId) {
		if(!CrudFLSValidator.canAccess('Opportunity', new set<String>{'Id', 'Name', 'StageName', 'AccountId', 'CloseDate'}, CrudFLSValidator.OperationType.READ)){
			return new List<Opportunity>();
		}	
		return [SELECT Id, Name, StageName, CloseDate, AccountId, Amount FROM Opportunity WHERE AccountId = :accountId AND StageName = 'Closed Won' WITH USER_MODE];		

	}

	/**
	 * Question 5
	 * Update/Uncomment the template code to create a method
	 * Returns the total count of Account records.
	 * @return The Integer count of Account records.
	 * Update the corresponding test class and testGetAccountCount method to cover this method
	 */
	//[public | private ] [static] data_type method_name (input parameters) {
	//  The body of the method
	//}
	public static Integer getTotalAccountCount(){
		if(!CrudFLSValidator.canAccess('Account', new set<String>{'Id'}, CrudFLSValidator.OperationType.READ)){
			return null;
		}
		Integer accCount = [SELECT Count() FROM Account WITH USER_MODE];
		return accCount;

	}

	/**
	 * Question 6
	 * Update/Uncomment the template code to create a method
	 * Return Key Value pair of Task Id and Task records for any tasks due date within the next 7 days.
	 * @return A map of Task Ids to Task records.
	 * Update the corresponding test class and testGetTasksDueNextWeek method to cover this method
	 */
	public static Map<Id, Task> getTaskWithDueDateNextSevenDays(){
		if(!CrudFLSValidator.canAccess('Task', new set<String>{'Id', 'Subject', 'ActivityDate'}, CrudFLSValidator.OperationType.READ)){
			return new Map<Id, Task>();
		}
		Map<Id, Task> taskMap = new Map<Id,Task>();
		for(Task t : [SELECT Id, Subject, ActivityDate FROM Task WHERE ActivityDate = NEXT_N_DAYS:7 WITH USER_MODE]){
			taskMap.put(t.Id, t);
		}
		return taskMap;
	}

	/**
	 * Question 7
	 * Update/Uncomment the template code to create a method
	 * Retrieves all Contacts that have a example.com domain in their Email.
	 * @return A list of Contact records.
	 * Update the corresponding test class and testGetContactsByEmailDomain method to cover this method
	 */
	public static List<Contact> getContactsByEmailDomain(){
		if(!CrudFLSValidator.canAccess('Contact', new set<String>{'Id','Email'}, CrudFLSValidator.OperationType.READ)){
			return new List<Contact>();
		}
		return [SELECT Id, Email, Name FROM CONTACT WHERE EMAIL LIKE '%example.com' WITH USER_MODE];
	}

	/**
	 * Question 8
	 * Retrieves all Opportunities that have a specific keyword in their Name.
	 * Example: getOpportunitiesByNameKeyword('keyword') should return all Opportunities that have 'keyword' in their Name.
	 * @param keyword The keyword to search for in the Opportunity Name.
	 * @return A list of Opportunity records.
	 */
	
	public static List<Opportunity> getOpportunitiesByNameKeyword(String keyword) {
		if(String.isBlank(keyword) || keyword == null){
			return new List<Opportunity>();
		}
		if(!CrudFLSValidator.canAccess('Opportunity', new set<String>{'Id','Name'}, CrudFLSValidator.OperationType.READ)){
			return new List<Opportunity>();
		}
		String escapedKeyworkd = '%' + String.escapeSingleQuotes(keyword) + '%';
		return [SELECT Id, Name FROM Opportunity WHERE Name LIKE :escapedKeyworkd WITH SYSTEM_MODE];
	}

	/**
	 * Question 9
	 * Retrieves all Cases that Case Origin is not Web or Email or Blank
	 * @return A list of Case records.
	 */
	public static List<Case> getFilterCaseOrigins() {
		return [SELECT Id, Origin FROM Case WHERE Origin NOT IN ('Web','Email') AND Origin != null with USER_MODE]; // Replace null with the variable you used to store the result
	}

	/**
	 * Question 10
	 * Update/Uncomment the template code to create a method
	 * Retrieves all Leads that have a specific Lead Source or contain a specific keyword in their Title.
	 * Example: yourMethodName('Web', 'Engineer') should return all Leads that have 'Web' in their Lead Source or 'Engineer' in their Title.
	 * @param leadSource The Lead Source to search for.
	 * @param keyword The keyword to search for in the Lead Title.
	 * @return A list of Lead records.
	 * Update the corresponding test class and testGetLeadsBySourceOrTitle method to cover this method
	 */
	public static List<Lead> getLeadsBySoruceOrKeyword(String leadSource, String keyword){
		String escapedKeyworkd = '%' + String.escapeSingleQuotes(keyword) + '%';
		List<Lead> leads = [SELECT Id, LeadSource, Title, LastName, Company, Email, Phone FROM Lead WHERE LeadSource = :leadSource OR Title LIKE :escapedKeyworkd WITH USER_MODE];
		return leads;
	}


	/**
	 * Question 11
	 * Returns the names of all Contacts associated with an Account.
	 * Example: getContactNamesByAccount('001XXXXXXXXXXXX') should return the list of Contact LastNames for the Account with the Id
	 * @param accountId The ID of the Account.
	 * @return A list of Contact LastName.
	 */
	public static List<String> getContactNamesByAccount(Id accountId) {
		// Create a list to hold the Contact LastNames
		List<String> contactNames = new List<String>();
		List<Contact> contactList = new List<Contact>();
		if(accountId == null ||!CrudFLSValidator.canAccess('Contact', new set<String>{'LastName'}, CrudFLSValidator.OperationType.READ)){
			return contactNames;
		}
		 for(Contact c : [SELECT Id, LastName FROM Contact WHERE AccountId = :accountId WITH USER_MODE]){
			 contactNames.add(c.LastName);
		 }
		// Return the list of Contact LastNames
		return contactNames;
	}

	/**
	 * Question 12
	 * Returns the total revenue for all Opportunities in a specific Stage or if the amount is greater than 10000.
	 * Example: getTotalRevenueByStage('Closed Won') should return the total revenue for the found opportunities
	 * @param stage The Stage value to filter Opportunities.
	 * @return The total revenue.
	 */
	public static Decimal getTotalRevenueByStage(String stage) {
		// Use AggregateQuery to get the total revenue
		AggregateResult[] results = [SELECT SUM(Amount) total FROM Opportunity WHERE StageName = :stage OR Amount > 10000 WITH SYSTEM_MODE];
		 Decimal totalRevenue = (Decimal) results[0].get('total');
		// Return the total revenue
		return totalRevenue;
	}

	/**
	 * Question 13
	 * Retrieves the first 10 Accounts ordered by Name.
	 * @return A list of the first 10 Accounts ordered by Name.
	 */
	public static List<Account> getFirstTenAccounts() {
		List<Account> accounts = [SELECT Id, Name FROM Account WITH SYSTEM_MODE ORDER BY Name LIMIT 10];
		return accounts;
	}

	/**
	 * Question 14
	 * Retrieves the Opportunities with an Amount greater than 100,000, ordered by CloseDate, and limited to 5 records.
	 * @return A list of Opportunities with an Amount greater than 100,000, ordered by CloseDate, and limited to 5 records.
	 */
	public static List<Opportunity> getHighValueOpportunities() {
		List<Opportunity> oppos = [SELECT  Id, Name, Amount, StageName, CloseDate FROM Opportunity WHERE Amount > 100000 WITH SYSTEM_MODE Order By CloseDate LIMIT 5];
		return oppos;
	}

	/**
	 * Question 15
	 * Retrieves the Contacts with the most recent Birthdate, ordered by Birthdate, and limited to 3 records.
	 * @return A list of Contacts
	 */
	public static List<Contact> getBirthdateContacts() {
		List<Contact> contacts = [SELECT Id, FirstName, LastName, Birthdate FROM Contact WITH SYSTEM_MODE ORDER BY Birthdate DESC LIMIT 3];
		return contacts;
	}

	/**
	 * Question 16
	 * Retrieves the Cases in the Open Status, ordered by CreatedDate, and limited to 10 records with an offset of 5.
	 * @return A list of Cases
	 */
	public static List<Case> getCasesWithStatus() {
		List<Case> openCases = [SELECT Id, CaseNumber, Status, CreatedDate FROM Case WHERE Status = 'Open' WITH SYSTEM_MODE ORDER BY CreatedDate ASC LIMIT 10 OFFSET 5];
		return openCases;
	}

	/**
	 * Question 17
	 * Returns Set of Case Ids for a specific Account.
	 * Example: getCaseIdsByAccount('001XXXXXXXXXXXX') should return the set of Case Ids for the Account with the Id
	 * @param accountId The ID of the Account.
	 * @return A set of Case Ids.
	 */
	public static Set<Id> getCaseIdsByAccount(Id accountId) {
		// Create a set to hold the Case Ids
		Set<Id> caseIds = new Set<Id>();
		// Query the Cases
		List<Case> cases = [SELECT Id FROM Case WHERE AccountId = :accountId WITH SYSTEM_MODE];
		// Loop through each Case and add the Id to the set
		for(Case c : cases){
			caseIds.add(c.Id);
		}
		// Return the set of Case Ids
		return caseIds;
	}

	/**
	 * Question 18
	 * Return Map of Account Ids to Account Names Not in a specific Country.
	 * Example: getAccountIdsToNamesNotInCountry('United States') should return the map of Account Ids to Account Names for Accounts that are not in the United States.
	 * @param country The country to filter Accounts.
	 * @return A map of Account Ids to Account Names.
	 */
	public static Map<Id, String> getAccountIdsToNamesNotInCountry(String country) {
		// Create a map to hold the Account Ids to Account Names
		Map<Id, String> accountIdsToNames = new Map<Id, String>();
		// Query the Accounts
		List<Account> accounts = [SELECT Id, Name, BillingCountry FROM Account WHERE BillingCountry != :country WITH SYSTEM_MODE];
		// Loop through each Account and add the Id and Name to the map
		for(Account a : accounts){
			accountIdsToNames.put(a.Id, a.Name);
		}
		return accountIdsToNames; // Replace null with the variable you used to store the result
	}

	/**
	 * Question 19
	 * Retrieves the Account Name for a given Contact.
	 * Example: getAccountNameForContact('003XXXXXXXXXXXX') should return the Account Name for the Contact with the Id
	 * @param contactId The Id of the Contact.
	 * @return The Account Name of the Contact.
	 */
	public static String getAccountNameForContact(String contactId) {
		List<Contact> contacstNames = [SELECT Id, Account.Name FROM Contact WHERE Id = :contactId WITH SYSTEM_MODE];
		return contacstNames[0].Account.Name;
	}

	/**
	 * Question 20
	 * Returns single Account that has related opportunities in the same query
	 * Example: getAccountAndOpportunitiesFromAccountId('001XXXXXXXXXXXX') should return the Account Name for the Account with the Id and all related Opportunities
	 * @param accountId The ID of the Account.
	 * @return An Account record with related Opportunities.
	 */
	public static Account getAccountAndOpportunitiesFromAccountId(Id accountId) {
		List<Account> accounts = [SELECT Id, Name, (SELECT Id, Name FROM Opportunities) FROM Account WHERE Id = :accountId WITH SYSTEM_MODE];
		return accounts[0]; // Replace null with the variable you used to store the result
	}

	/**
	 * Question 21
	 * Retrieves all contacts that have the Mailing State similar to the Account Billing State.
	 * Example: getAccountsWithContactsByState('001XXXXXXXXXXXX') should return a list of Contacts that have the same Mailing State as the Account with the Id
	 * @param Account Id
	 * @return List of contacts with the same Mailing State as the Account Billing State
	 */
	public static List<Contact> getAccountsWithContactsByState(Id accountId) {
		// Query the Account
		List<Account> accounts = [SELECT Id, Name, BillingState FROM Account WHERE Id = :accountId WITH SYSTEM_MODE];
		// Store the Account's BillingState
		String billingState = accounts[0].billingState;
		// Query the Contacts
		List<Contact> contacts = [SELECT Id, Name, Email, MailingState FROM Contact WHERE MailingState LIKE :('%'+ billingState + '%') WITH SYSTEM_MODE];
		return contacts; // Replace null with the variable you used to store the result
	}

	/**
	 * Question 22
	 * Extracts email domains from them leads, then finds Accounts with matching website domains
	 * If Lead Email = test@test.com return account with website = www.test.com
	 * Example: findAccountsByLeadEmailDomains([set of lead ids]) should return a list of Accounts with matching email domains
	 * @param A set of Lead Ids.
	 * @return A list of Accounts with matching email domains.
	 */
	public static List<Account> findAccountsByLeadEmailDomains(Set<Id> leadIds) {
		// Query the Leads
		List<Lead> leads = [SELECT Id, Email FROM Lead WHERE Id IN :leadIds WITH SYSTEM_MODE];
		// Create a set of email domains from the Leads
		Set<String> emailDomains = new Set<String>();
		// Loop through each Lead
		for(Lead l : leads){
			// Check if the email is not null
			if(l.Email != null){
				// Add the email domain to the set
				emailDomains.add(l.Email.substringAfter('@'));
			}
		}
		if (emailDomains.isEmpty()) {
        return new List<Account>();
		}

		//Dynamically build the SOQL query based on the email domains to pre-filter accounts.
		List<String> filters = new List<String>();
		for (String domain : emailDomains) {
			String safeDomain = String.escapeSingleQuotes(domain);
			filters.add('Website LIKE \'%' + safeDomain + '%\'');
		}

		String soql =
			'SELECT Id, Name, Website ' +
			'FROM Account ' +
			'WHERE Website != null AND (' + String.join(filters, ' OR ') + ') ' +
			'WITH SYSTEM_MODE';
		//Candidate quries using LIKE to prefilter based on email domains.
		List<Account> candidateAccounts = Database.query(soql);
    	List<Account> matchingAccounts = new List<Account>();

		for (Account acc : candidateAccounts) {
			//Setting website to lower case and remove any leading text to get only the deomain
			String website = acc.Website.toLowerCase()
				.replace('https://', '')
				.replace('http://', '')
				.replace('www.', '');
			// remove any trailing text after the domain: example.com/something
			if (website.contains('/')) {
				website = website.substringBefore('/');
			}
			//Adding domain to final list only if domain matches.
			if (emailDomains.contains(website)) {
				matchingAccounts.add(acc);
			}
		}
		return matchingAccounts;
	}

	/**
	 * Question 23
	 * Clones and Inserts Opportunity Line Items from an original Opportunity to a list of cloned Opportunities.
	 * Adds a randomized number between 1 to 3 to the quantity of each line item.
	 * Example: cloneLineItems('001XXXXXXXXXXXX', [list of opportunity ids]) should clone the line items from the Opportunity with the Id to each Opportunity in the list
	 * @param Original Opportunity Id
	 * @param List of cloned Opportunity Ids
	 */
	public static void cloneLineItems(Id origOppId, List<Id> cloneOppIds) {
		// Query the original Opportunity Line Items
		List<OpportunityLineItem> originalLineItems = [SELECT Id, Product2Id, Quantity, UnitPrice, PricebookEntryId FROM OpportunityLineItem WHERE OpportunityId = :origOppId WITH SYSTEM_MODE]; 
		// Create a list to hold the new line items
			List<OpportunityLineItem> cloneLineItems = new List<OpportunityLineItem>();
		// Generate a random number between 1 and 3
		Integer randomNumber = Math.round(Math.random() * 2) + 1;

		// Loop through each cloned Opportunity Id
		for(Id opp : cloneOppIds ){
			// Loop through each original line item
			for(OpportunityLineItem oli : originalLineItems){
				cloneLineItems.add(new OpportunityLineItem(
					OpportunityId = opp,
					Product2Id = oli.Product2Id,
					PricebookEntryId = oli.PricebookEntryId,
					Quantity = randomNumber,
					UnitPrice = oli.UnitPrice
				));

			}
		}
		// Insert the new line items
		insert cloneLineItems;
	}

	/**
	 * Question 24
	 * Retrieves the Opportunity Name, Account Name, and Owner Name for Opportunities that have a Stage of 'Closed Won'.
	 * @return A list of filtered Opportunity
	 */
	public static List<Opportunity> getOpportunityDetailsForClosedWon() {
		List<Opportunity> closedWonOpps = [SELECT Id, Name, AccountId, Account.Name, Owner.Name from Opportunity WHERE StageName = 'Closed Won' WITH SYSTEM_MODE];
		return closedWonOpps;
	}

	/**
	 * Question 25
	 * Sets the 'Primary_Contact__c' field for all Closed Won Opportunities to the Contact on the associated Account with the alphabetically first first name.
	 * Example: if there are two Contacts on the Account, "Billy" and "Abby," the 'Primary_Contact__c' will be set to "Abby."
	 */
	public static void setPrimaryContact() {
		//Use the getOpportunityDetailsForClosedWon() method to get the Opportunities
		List<Opportunity> closedWonOpps = getOpportunityDetailsForClosedWon();
		// Create a set of Account Ids from the Opportunities
		Set<Id> accountIds = new Set<Id>();
		for(Opportunity opp : closedWonOpps){
			accountIds.add(opp.AccountId);
		}
		// Query the Contacts
		List<Contact> contacts = [SELECT Id, AccountId, FirstName FROM Contact WHERE AccountId IN :accountIds WITH SYSTEM_MODE];
		// Loop through each Contact and add the Account Id and Contact to the map
		Map<Id, Contact> accountToContactMap = new Map<Id, Contact>();
		for(Contact c : contacts){
			if(!accountToContactMap.containsKey(c.AccountId)){
				accountToContactMap.put(c.AccountId, c);
			}else{
				if(c.FirstName < accountToContactMap.get(c.AccountId).FirstName){
					accountToContactMap.put(c.AccountId, c);
				}
			}
		}
		// Loop through each Opportunity
		for(Opportunity opp : closedWonOpps){
			// Update the Opportunity primary contact from accountToContactMap
			opp.Primary_Contact__c = accountToContactMap.get(opp.AccountId).Id;
		}
		// Update the Opportunities

		update closedWonOpps;
	}
}
