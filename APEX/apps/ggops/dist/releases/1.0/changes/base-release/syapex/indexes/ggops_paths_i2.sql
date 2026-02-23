-- liquibase formatted sql
-- changeset SYAPEX:1771865125841 stripComments:false  logicalFilePath:base-release/syapex/indexes/ggops_paths_i2.sql
-- sqlcl_snapshot src/database/syapex/indexes/ggops_paths_i2.sql:null:9728dcfe032b0414a20c891a74a316972cf5a7db:create

create index syapex.ggops_paths_i2 on
    syapex.ggops_paths (
        source
    );

