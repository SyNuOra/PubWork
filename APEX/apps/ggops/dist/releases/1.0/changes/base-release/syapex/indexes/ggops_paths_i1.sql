-- liquibase formatted sql
-- changeset SYAPEX:1771865125810 stripComments:false  logicalFilePath:base-release/syapex/indexes/ggops_paths_i1.sql
-- sqlcl_snapshot src/database/syapex/indexes/ggops_paths_i1.sql:null:919c8156b9f19ff1d083bd17243271ecd93da45a:create

create index syapex.ggops_paths_i1 on
    syapex.ggops_paths (
        process_id
    );

