public inherited sharing class CrudFLSValidator {

    // Supported access types for object and field permission validation.
    public enum OperationType {
        READ, CREATE, UPDATE_RECORD, DELETE_RECORD, UPSERT_RECORD
    }

    /**
     * Validates object-level and field-level access for the given operation.
     * Throws a SecurityException if the object does not exist, a field does not exist,
     * or the running user does not have the required permission.
     *
     * @param objectApiName API name of the object, for example 'Account'
     * @param fieldApiNames Set of field API names to validate, for example 'Name', 'Industry'
     * @param operation Type of access to validate: READ, CREATE, UPDATE_RECORD, DELETE_RECORD, or UPSERT_RECORD
     */
    public static void assertAccess(
        String objectApiName,
        Set<String> fieldApiNames,
        OperationType operation
    ) {
        Schema.SObjectType objType = Schema.getGlobalDescribe().get(objectApiName);

        if (objType == null) {
            throw new SecurityException('Unknown object: ' + objectApiName);
        }

        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();

        if (!hasObjectAccess(objDescribe, operation)) {
            throw new SecurityException(
                'No ' + operation + ' access to object ' + objectApiName
            );
        }

        // Field-level validation is not needed for DELETE operations.
        // Also skip if no fields were provided.
        if (operation == OperationType.DELETE_RECORD || fieldApiNames == null || fieldApiNames.isEmpty()) {
            return;
        }

        Map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();

        for (String fieldApiName : fieldApiNames) {
            Schema.SObjectField fieldToken = fieldMap.get(fieldApiName);

            if (fieldToken == null) {
                throw new SecurityException(
                    'Unknown field: ' + objectApiName + '.' + fieldApiName
                );
            }

            Schema.DescribeFieldResult fieldDescribe = fieldToken.getDescribe();

            if (!hasFieldAccess(fieldDescribe, operation)) {
                throw new SecurityException(
                    'No ' + operation + ' access to field ' +
                    objectApiName + '.' + fieldApiName
                );
            }
        }
    }

    /**
     * Checks whether the user has the required object and field access.
     * Returns true if access is allowed, otherwise false.
     * Unlike assertAccess, this method does not throw an exception.
     *
     * @param objectApiName API name of the object
     * @param fieldApiNames Set of field API names to validate
     * @param operation Type of access to validate
     * @return True if access is allowed, false otherwise
     */
    public static Boolean canAccess(
        String objectApiName,
        Set<String> fieldApiNames,
        OperationType operation
    ) {
        try {
            assertAccess(objectApiName, fieldApiNames, operation);
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    /**
     * Evaluates object-level CRUD permission based on the requested operation.
     *
     * READ    = object is accessible
     * CREATE  = object is createable
     * UPDATE_RECORD  = object is updateable
     * DELETE_RECORD  = object is deletable
     * UPSERT_RECORD  = object must be both createable and updateable
     *
     * @param d Describe result for the object
     * @param operation Type of access to validate
     * @return True if the object permission is granted, false otherwise
     */
    private static Boolean hasObjectAccess(
        Schema.DescribeSObjectResult d,
        OperationType operation
    ) {
        switch on operation {
            when READ {
                return d.isAccessible();
            }
            when CREATE {
                return d.isCreateable();
            }
            when UPDATE_RECORD {
                return d.isUpdateable();
            }
            when DELETE_RECORD {
                return d.isDeletable();
            }
            when UPSERT_RECORD {
                return d.isCreateable() && d.isUpdateable();
            }
        }
        return false;
    }

    /**
     * Evaluates field-level access based on the requested operation.
     *
     * READ    = field is accessible
     * CREATE  = field is createable
     * UPDATE_RECORD  = field is updateable
     * DELETE_RECORD  = always true because field-level checks do not apply to delete
     * UPSERT_RECORD  = field must be both createable and updateable
     *
     * @param d Describe result for the field
     * @param operation Type of access to validate
     * @return True if the field permission is granted, false otherwise
     */
    private static Boolean hasFieldAccess(
        Schema.DescribeFieldResult d,
        OperationType operation
    ) {
        switch on operation {
            when READ {
                return d.isAccessible();
            }
            when CREATE {
                return d.isCreateable();
            }
            when UPDATE_RECORD {
                return d.isUpdateable();
            }
            when DELETE_RECORD {
                return true;
            }
            when UPSERT_RECORD {
                return d.isCreateable() && d.isUpdateable();
            }
        }
        return false;
    }
}