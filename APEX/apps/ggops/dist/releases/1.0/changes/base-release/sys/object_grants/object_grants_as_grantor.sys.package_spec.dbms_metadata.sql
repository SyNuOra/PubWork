-- liquibase formatted sql
-- changeset SYS:1771865128786 stripComments:false  logicalFilePath:base-release/sys/object_grants/object_grants_as_grantor.sys.package_spec.dbms_metadata.sql
-- sqlcl_snapshot src/database/sys/object_grants/object_grants_as_grantor.sys.package_spec.dbms_metadata.sql:null:1048d391760a48c759c91c81fe795137a8ff7749:create

grant execute on sys.dbms_metadata to syapex;

