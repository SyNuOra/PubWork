-- liquibase formatted sql
-- changeset SYAPEX:1771865126600 stripComments:false  logicalFilePath:base-release/syapex/ref_constraints/ggops_credent_credential_do_fk.sql
-- sqlcl_snapshot src/database/syapex/ref_constraints/ggops_credent_credential_do_fk.sql:null:be557891e4ab33080217a315973ce656f8d809ce:create

alter table syapex.ggops_credentials
    add constraint ggops_credent_credential_do_fk
        foreign key ( credential_domain_id )
            references syapex.ggops_credential_domains ( domain_id )
                on delete cascade
        enable;

