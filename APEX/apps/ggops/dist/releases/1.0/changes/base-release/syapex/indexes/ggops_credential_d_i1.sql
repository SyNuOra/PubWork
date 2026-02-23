-- liquibase formatted sql
-- changeset SYAPEX:1771865125665 stripComments:false  logicalFilePath:base-release/syapex/indexes/ggops_credential_d_i1.sql
-- sqlcl_snapshot src/database/syapex/indexes/ggops_credential_d_i1.sql:null:8b7685e4ffdb99b4dc51d0e1ed1b08d7a6a123b0:create

create index syapex.ggops_credential_d_i1 on
    syapex.ggops_credential_domains (
        deployment_id
    );

