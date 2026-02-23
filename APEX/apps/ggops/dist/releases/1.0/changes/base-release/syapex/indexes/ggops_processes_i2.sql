-- liquibase formatted sql
-- changeset SYAPEX:1771865125948 stripComments:false  logicalFilePath:base-release/syapex/indexes/ggops_processes_i2.sql
-- sqlcl_snapshot src/database/syapex/indexes/ggops_processes_i2.sql:null:f4c3f3e2a6c6329b0877216e82126319796b83e2:create

create index syapex.ggops_processes_i2 on
    syapex.ggops_processes (
        deployment_id
    );

