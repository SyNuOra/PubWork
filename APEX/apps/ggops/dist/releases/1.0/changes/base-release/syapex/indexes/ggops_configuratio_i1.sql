-- liquibase formatted sql
-- changeset SYAPEX:1771865125632 stripComments:false  logicalFilePath:base-release/syapex/indexes/ggops_configuratio_i1.sql
-- sqlcl_snapshot src/database/syapex/indexes/ggops_configuratio_i1.sql:null:7851d0d761a1548351ee3837de45613bd549522e:create

create index syapex.ggops_configuratio_i1 on
    syapex.ggops_configuration_files (
        process_id
    );

