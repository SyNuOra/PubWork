-- liquibase formatted sql
-- changeset SYAPEX:1771865125740 stripComments:false  logicalFilePath:base-release/syapex/indexes/ggops_deployments_i1.sql
-- sqlcl_snapshot src/database/syapex/indexes/ggops_deployments_i1.sql:null:02ac41fed342e3f19abb0213d44921bc2b1d98ef:create

create index syapex.ggops_deployments_i1 on
    syapex.ggops_deployments (
        host_id
    );

