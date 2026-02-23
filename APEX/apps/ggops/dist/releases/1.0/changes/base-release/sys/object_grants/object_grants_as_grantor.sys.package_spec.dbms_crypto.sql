-- liquibase formatted sql
-- changeset SYS:1771862258823 stripComments:false  logicalFilePath:base-release/sys/object_grants/object_grants_as_grantor.sys.package_spec.dbms_crypto.sql
-- sqlcl_snapshot src/database/sys/object_grants/object_grants_as_grantor.sys.package_spec.dbms_crypto.sql:null:b6343a79fe9681d35b7eecc34e2ab8832fa1faf4:create

grant execute on dbms_crypto to syapex;

