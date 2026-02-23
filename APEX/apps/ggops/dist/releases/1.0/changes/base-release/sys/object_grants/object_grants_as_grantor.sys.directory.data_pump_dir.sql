-- liquibase formatted sql
-- changeset SYS:1771865128726 stripComments:false  logicalFilePath:base-release/sys/object_grants/object_grants_as_grantor.sys.directory.data_pump_dir.sql
-- sqlcl_snapshot src/database/sys/object_grants/object_grants_as_grantor.sys.directory.data_pump_dir.sql:null:ac3aaa30d7659e0ac6d8fe8330be6b7ae1c37d8c:create

grant read on directory sys.data_pump_dir to syapex;

grant write on directory sys.data_pump_dir to syapex;

