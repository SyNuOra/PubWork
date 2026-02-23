-- liquibase formatted sql
-- changeset SYAPEX:1771865125774 stripComments:false  logicalFilePath:base-release/syapex/indexes/ggops_encryption_p_i1.sql
-- sqlcl_snapshot src/database/syapex/indexes/ggops_encryption_p_i1.sql:null:6175ac5151c119b01a896250fbf68388a86d979d:create

create index syapex.ggops_encryption_p_i1 on
    syapex.ggops_encryption_profiles (
        deployment_id
    );

