# Table: aws_organizations_delegated_administrators

This table shows data for Organizations Delegated Administrators.

https://docs.aws.amazon.com/organizations/latest/APIReference/API_DelegatedAdministrator.html

The composite primary key for this table is (**account_id**, **arn**).

## Columns

| Name          | Type          |
| ------------- | ------------- |
|_cq_source_name|String|
|_cq_sync_time|Timestamp|
|_cq_id|UUID|
|_cq_parent_id|UUID|
|account_id (PK)|String|
|arn (PK)|String|
|delegation_enabled_date|Timestamp|
|email|String|
|id|String|
|joined_method|String|
|joined_timestamp|Timestamp|
|name|String|
|status|String|