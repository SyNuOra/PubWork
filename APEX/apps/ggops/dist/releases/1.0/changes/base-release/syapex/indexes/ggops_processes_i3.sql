-- liquibase formatted sql
-- changeset SYAPEX:1771865125978 stripComments:false  logicalFilePath:base-release/syapex/indexes/ggops_processes_i3.sql
-- sqlcl_snapshot src/database/syapex/indexes/ggops_processes_i3.sql:null:0691fbeda3d6be03e725e3dafcfb719e0727cab2:create

create index syapex.ggops_processes_i3 on
    syapex.ggops_processes (
        encryption_profile
    );

