-- liquibase formatted sql
-- changeset SYS:1771862258754 stripComments:false  logicalFilePath:base-release/sys/object_grants/object_grants_as_grantor.sys.directory.data_pump_dir.sql
-- sqlcl_snapshot src/database/sys/object_grants/object_grants_as_grantor.sys.directory.data_pump_dir.sql:null:983b875ca1e2002e60a40ae46ace4f6d4eca2cd8:create

grant read on directory data_pump_dir to syapex;

grant write on directory data_pump_dir to syapex;

