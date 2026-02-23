-- liquibase formatted sql
-- changeset SYAPEX:1771865125883 stripComments:false  logicalFilePath:base-release/syapex/indexes/ggops_paths_i3.sql
-- sqlcl_snapshot src/database/syapex/indexes/ggops_paths_i3.sql:null:a8c780f5a4a2727ba7f8476bbe1f931977a6d593:create

create index syapex.ggops_paths_i3 on
    syapex.ggops_paths (
        target
    );

