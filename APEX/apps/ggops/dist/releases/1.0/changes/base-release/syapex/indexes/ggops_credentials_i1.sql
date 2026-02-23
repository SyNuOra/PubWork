-- liquibase formatted sql
-- changeset SYAPEX:1771865125704 stripComments:false  logicalFilePath:base-release/syapex/indexes/ggops_credentials_i1.sql
-- sqlcl_snapshot src/database/syapex/indexes/ggops_credentials_i1.sql:null:ee56d7b17567807ee8e6d27c3eb71f40d4cb8f4c:create

create index syapex.ggops_credentials_i1 on
    syapex.ggops_credentials (
        credential_domain_id
    );

