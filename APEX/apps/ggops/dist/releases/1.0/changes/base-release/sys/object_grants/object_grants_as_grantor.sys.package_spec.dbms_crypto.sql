-- liquibase formatted sql
-- changeset SYS:1771865128757 stripComments:false  logicalFilePath:base-release/sys/object_grants/object_grants_as_grantor.sys.package_spec.dbms_crypto.sql
-- sqlcl_snapshot src/database/sys/object_grants/object_grants_as_grantor.sys.package_spec.dbms_crypto.sql:null:a90ee0ec3a36012d4a65fdc625707ce53cd3b041:create

grant execute on sys.dbms_crypto to syapex;

