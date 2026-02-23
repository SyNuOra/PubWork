-- liquibase formatted sql
-- changeset SYS:1771865128817 stripComments:false  logicalFilePath:base-release/sys/object_grants/object_grants_as_grantor.sys.view.dba_objects.sql
-- sqlcl_snapshot src/database/sys/object_grants/object_grants_as_grantor.sys.view.dba_objects.sql:null:24c7ca4f86ab237fc7beeb797cbe81082bded4a3:create

grant select on sys.dba_objects to syapex;

