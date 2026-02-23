-- liquibase formatted sql
-- changeset SYS:1771862258973 stripComments:false  logicalFilePath:base-release/sys/object_grants/object_grants_as_grantor.sys.view.dba_objects.sql
-- sqlcl_snapshot src/database/sys/object_grants/object_grants_as_grantor.sys.view.dba_objects.sql:null:3f9cbb92adc6f4516cabec4ddcd4c233984bad0b:create

grant select on dba_objects to syapex;

