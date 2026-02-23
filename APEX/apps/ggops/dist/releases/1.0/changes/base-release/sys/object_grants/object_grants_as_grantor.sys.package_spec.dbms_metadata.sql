-- liquibase formatted sql
-- changeset SYS:1771862258899 stripComments:false  logicalFilePath:base-release/sys/object_grants/object_grants_as_grantor.sys.package_spec.dbms_metadata.sql
-- sqlcl_snapshot src/database/sys/object_grants/object_grants_as_grantor.sys.package_spec.dbms_metadata.sql:null:cc1fa852c8c9adf050e1dbfebba1722ea1f3ec0e:create

grant execute on dbms_metadata to syapex;

