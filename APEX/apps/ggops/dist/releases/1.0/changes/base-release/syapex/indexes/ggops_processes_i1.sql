-- liquibase formatted sql
-- changeset SYAPEX:1771865125917 stripComments:false  logicalFilePath:base-release/syapex/indexes/ggops_processes_i1.sql
-- sqlcl_snapshot src/database/syapex/indexes/ggops_processes_i1.sql:null:810360eeb5b8691ae1559096fb84aaa0e831d99a:create

create index syapex.ggops_processes_i1 on
    syapex.ggops_processes (
        credential_id
    );

